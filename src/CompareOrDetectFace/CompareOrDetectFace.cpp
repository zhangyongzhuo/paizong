#pragma execution_character_set("utf-8")
#include "CompareOrDetectFace.h"

CompareOrDetectFace::CompareOrDetectFace(QObject *parent) : QObject(parent)
{
    qRegisterMetaType<EOPERATE_TYPE>("EOPERATE_TYPE");
    qRegisterMetaType<EFACE_RET>("EFACE_RET");
    //qDebug()<<"FaceCompareNet::FaceCompareNet";
    m_pCompareOrDetectFaceThread = new CompareOrDetectFaceThread(this);
}

CompareOrDetectFace::~CompareOrDetectFace()
{
    //qDebug()<<"~FaceCompareNet";
    //等待线程结束
    if(m_pCompareOrDetectFaceThread->isRunning())
    {
        while(m_pCompareOrDetectFaceThread->isRunning());
    }
    //释放线程资源
    if(m_pCompareOrDetectFaceThread!=NULL)
    {
        delete m_pCompareOrDetectFaceThread;
        m_pCompareOrDetectFaceThread = NULL;
        qDebug()<<"face 释放";
    }
}

QString CompareOrDetectFace::detectImage()
{
    QString right = m_detectImagPath.right(4); //取后面的格式类型
    QString left  = m_detectImagPath.left(m_detectImagPath.length()-4); //取前面的路径
    //qDebug()<<"---right:"<<right;
    //qDebug()<<"---left:"<<left;
    QString afterDetectPath = left+"_dete"+right;
    copyFileToPath(m_detectImagPath, afterDetectPath, true);

    if(InitFaceRecognition()!=0){
        qDebug() << "InitFaceRecognition error";
    }

    if(SetSnapFaceRange((float)1.5, (float)1.3)!=0){
        qDebug() << "SetSnapFaceRange error";
    }
    if(ImportFaceImgByPath(m_detectImagPath.toLatin1().data())!=0){
        qDebug() << "ImportFaceImgByPath error";
    }

    if(StartFaceRecog() != 1){
        qDebug() << "StartFaceRecog error";
    } else{
        QString face = QString::fromLocal8Bit(GetSnapImgPath());
        copyFileToPath(face, afterDetectPath, true);
    }
    ReleaseResource();

    return afterDetectPath;
}

CompareOrDetectFace::EFACE_RET CompareOrDetectFace::compareFace()
{
    qDebug()<<"开始比对 图1:"<<m_detectImagPath.toUtf8().data();
    qDebug()<<"开始比对 图2:"<<m_compareImagPath.toUtf8().data();
    //开始比对
    float compareResult = FaceSDK_CMP(m_detectImagPath.toUtf8().data(),m_compareImagPath.toUtf8().data());
    //long err = FaceSDK_GetError();
    //float compareResult =50;
    qDebug()<<"比对结果"<<compareResult;
    if(compareResult >= m_compareBoundaryValue)
    {
        //qDebug()<<"比对通过";
        return EFACE_RET_PASS;
    }
    else if(compareResult<m_compareBoundaryValue && compareResult>0)
    {
        //qDebug()<<"比对不通过";
        return EFACE_RET_NOPASS;
    }
    else if(compareResult==0)
    {
        //qDebug()<<"比对失败";
        return EFACE_RET_ERROR;
    }
    return EFACE_RET_ERROR;
}

//开始人脸比对或截取 参1：操作类型 参2：要截取的照片 参3：要与参2进行比对的照片 参4：比对结果边界值
void CompareOrDetectFace::startFaceCompareOrDetect(EOPERATE_TYPE type, QString detectImagPath,
                                                   QString compareImagPath, float compareBoundaryValue,
                                                   QString taskName)
{  
    detectImagPath  =  detectImagPath.replace("\\","/");
    compareImagPath =  compareImagPath.replace("\\","/");
    m_operateType     = type;
    m_detectImagPath  = detectImagPath;
    m_compareImagPath = compareImagPath;
    m_compareBoundaryValue = compareBoundaryValue;
    m_taskName = taskName;

    if(m_pCompareOrDetectFaceThread->isRunning())
    {
        while(m_pCompareOrDetectFaceThread->isRunning());
    }
    m_pCompareOrDetectFaceThread->startRun();
}

//void CompareOrDetectFace::startFaceCompareOrDetect(EOPERATE_TYPE type, QString detectImagPath,
//                                          QString compareImagPath, float compareBoundaryValue,
//                                          QJSValue callback)
//{
//    m_callback = callback;
//    startFaceCompareOrDetect(type,detectImagPath,compareImagPath,compareBoundaryValue);
//}

void CompareOrDetectFaceThread::run()
{ 
    CompareOrDetectFace *parent = (CompareOrDetectFace *)m_parent;
    QString detect;
    CompareOrDetectFace::EFACE_RET ret;
    switch(parent->m_operateType)
    {
    //自行截取后比对
    case CompareOrDetectFace::EOPERATE_TYPE_ALL:
        detect = parent->detectImage();
        ret = parent->compareFace();
        //ret = parent->compareFace();
        //ret=CompareOrDetectFace::EFACE_RET_PASS ;
        //emit parent->compareOrDetectFinished(ret, detect);
        break;
    //只比对
    case CompareOrDetectFace::EOPERATE_TYPE_COMPARE:
        ret = parent->compareFace();
        detect = parent->m_detectImagPath;
        break;
    //只截取
    case CompareOrDetectFace::EOPERATE_TYPE_DETECT:
        ret = CompareOrDetectFace::EFACE_RET_PASS;
        detect = parent->detectImage();
        break;
    }

    emit parent->compareOrDetectFinished(ret, detect, parent->m_taskName);

//    if(parent->m_callback.toString() != "undefined"){
//        QJSValue tempRet = parent->m_callback.engine()->newObject();
//        QJSValue tempDetectImagPath = parent->m_callback.engine()->newObject();
//        tempRet = ret;
//        tempDetectImagPath = detect;
//        QJSValueList valueList;
//        valueList.append(tempRet);
//        valueList.append(tempDetectImagPath);
//        parent->m_callback.call(valueList);
//    }

    qDebug()<<"比对线程结束";
}

//拷贝文件：
bool CompareOrDetectFace::copyFileToPath(QString sourceDir, QString toDir, bool coverFileIfExist)
{
    toDir.replace("\\","/");
    if (sourceDir == toDir){
        return true;
    }
    if (!QFile::exists(sourceDir)){
        return false;
    }
    QDir *createfile     = new QDir;
    bool exist = createfile->exists(toDir);
    if (exist){
        if(coverFileIfExist){
            createfile->remove(toDir);
        }
    }//end if

    if(!QFile::copy(sourceDir, toDir))
    {
        return false;
    }
    return true;
}

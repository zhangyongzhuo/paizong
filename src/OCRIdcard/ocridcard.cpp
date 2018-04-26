#include "ocridcard.h"

OCRIdcard::OCRIdcard()
{
    m_pOCRIdcardThread = new OCRIdcardThread(this);
    m_isInit = false;
}

OCRIdcard::~OCRIdcard()
{
    if(m_pOCRIdcardThread->isRunning())
    {
        qDebug()<<"OCR 线程正在运行";
        while(m_pOCRIdcardThread->isRunning());
    }
    if(m_isInit)
    {
        HyUnInitOcr();
    }
    if(m_pOCRIdcardThread!=NULL)
    {
        delete m_pOCRIdcardThread;
        m_pOCRIdcardThread = NULL;
        qDebug()<<"OCR 释放";
    }

}
//初始化
bool OCRIdcard::Init()
{
    //return HyInitOcr() == 0;
    QFile read_ocrpwd_file(":/images/src/IDOCR/IdOcr.dat");
    read_ocrpwd_file.open(QIODevice::ReadOnly | QIODevice::Text);
    QByteArray baOcrpwd = read_ocrpwd_file.readAll();
    char* pOcrpwd = baOcrpwd.data();
    read_ocrpwd_file.close();
    return HyInitOcrOEM(pOcrpwd) == 0;
}
//OCR识别
ENSCANSIDE OCRIdcard::OCRRecognizer( char* filePathName )
{
    ENSCANSIDE ScanRes = ENSCANSIDE_ScanNone;
    if ( filePathName == NULL )
    {
        return ScanRes;
    }
    if ( HyOcrImageFile(filePathName) == 0 )
    {
        std::string str(HyGetOcrSectionStr(SEC_NAME));
        ScanRes = str.empty() ? ENSCANSIDE_ScanBack:ENSCANSIDE_ScanFront;
    }
    return ScanRes;
}
//开始模糊检测
void OCRIdcard::StartBlurDetect(QString path)
{
    int blur_value = ImageBlurDetect((char*)path.toStdString().data());
    emit finishBlurDetect(path, blur_value);
}
//将识别的身份证信息存入本地
//返回值为二代身份证信息
QString OCRIdcard::SaveOcrIdcardInfo( ENSCANSIDE readSide )
{
    QJsonObject json_object;
    QJsonArray  json_arry;
    QJsonDocument json_doc;
    if ( readSide == ENSCANSIDE_ScanFront )
    {
        json_object.insert("name",QString::fromLocal8Bit(HyGetOcrSectionStr(SEC_NAME)));
        json_object.insert("sex",QString::fromLocal8Bit(HyGetOcrSectionStr(SEC_SEX)));
        json_object.insert("nation",QString::fromLocal8Bit(HyGetOcrSectionStr(SEC_FOLK)));
        json_object.insert("birth",QString::fromLocal8Bit(HyGetOcrSectionStr(SEC_BIRTHDAY)));
        json_object.insert("address",QString::fromLocal8Bit(HyGetOcrSectionStr(SEC_ADDRESS)));
        json_object.insert("idcard",QString::fromLocal8Bit(HyGetOcrSectionStr(SEC_NUM)));
        if ( HyGetOcrHeadImage( m_saveImgPath.toUtf8().data() ) == 0 )
         json_object.insert("photopath",m_saveImgPath);
    }
    else if ( readSide == ENSCANSIDE_ScanBack )
    {
        json_object.insert("depart",QString::fromLocal8Bit(HyGetOcrSectionStr(SEC_ISSUE)));
        json_object.insert("validdate",QString::fromLocal8Bit(HyGetOcrSectionStr(SEC_PERIOD)));
    }
    json_arry.append(QJsonValue(json_object));
    json_doc.setArray(json_arry);
    return QString(json_doc.toJson());
    //return TRUE;
}
bool OCRIdcard::read_ocrResult() const
{
    return ocrResult;
}

void OCRIdcard::write_ocrResult(const bool &flag)
{
    ocrResult=flag;
}

bool OCRIdcard::ReadPhotoOcrInfo(QString PhotoPath)
{
//    QString temp_path=PoliceIDFilePath+"/face.jpg";
//    QFile::remove(temp_path);

//    QByteArray arry_path = PhotoPath.toUtf8();
//    char *path = arry_path.data();
//    QByteArray arry_idpath = temp_path.toUtf8();
//    char *idpath = arry_idpath.data();

//    needsendgps=true;
//      if(GetIDPhotoInfo(path,idpath)){
//        this->write_ocrResult(true);
//        return true;
//    }
//    else{
//        this->write_ocrResult(false);
//        return false;
//    }
    return true;
}


//参1：身份证正面照片路径  参2：解析的身份证一寸照存放路径 默认存D盘 参数格式：D:\\OCRheadImg.bmp
//bool OCRIdcard::getIDPhotoInfo(char* photoPath, St_ReadIDInfo& readIDInfo, char* readIDPhotoPath)
bool OCRIdcard::GetIDPhotoInfo(char* photoPath, char* readIDPhotoPath)
{
    if (photoPath == NULL)
    {
        qDebug() << "ocr fail: photopath is null";
        return false;
    }
    /////////////////////////////////////2015-12-28 XIN 接到识别任务后迅速返回 启动线程继续做识别任务
    m_photoPath = photoPath;
    if (readIDPhotoPath == NULL)
    {
        m_saveImgPath = (char *)"D:\\OCRheadImg.bmp";
    }
    else
    {
        m_saveImgPath = readIDPhotoPath;
    }
    m_pOCRIdcardThread->StartRun();  //起线程

    return true;
}

///////////////////////////////////////////////////////////////////
void OCRIdcardThread::run()
{
    qDebug() << "OCR线程开始";
    OCRIdcard *parent = (OCRIdcard *)m_parent;

    if (!parent->Init())
    {
        //emit notify("ocr 初始化失败");
        qDebug()<<"ocr 初始化失败";
        return ;
    }
    parent->m_isInit = true;

    ENSCANSIDE side = parent->OCRRecognizer(parent->m_photoPath.toUtf8().data());
    if (side == ENSCANSIDE_ScanFront || side == ENSCANSIDE_ScanBack)
    {
         QString ocrIdInfo=parent->SaveOcrIdcardInfo(side);
         emit parent->ocrIdcardFinished(ocrIdInfo); //读到数据了
    }
    else
    {
        qDebug()<<"OCR faild";
        return ;
    }

    qDebug() << "OCR 识别线程结束";
}


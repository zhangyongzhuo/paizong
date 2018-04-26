#pragma execution_character_set("utf-8")
#include "OcrIdcardOrBlurDetect.h"


OcrIdcardOrBlurDetect::OcrIdcardOrBlurDetect()
{
    qRegisterMetaType<EOCR_RET>("EOCR_RET");
    m_pOcrIdcardOrBlurDetectThread = new OcrIdcardOrBlurDetectThread(this);
    if (!init())
    {
        qDebug()<<"========ocr 初始化失败";
        return ;
    }
    m_isInit = true;

    //m_pOcrIdcardOrBlurDetectThread = new OcrIdcardOrBlurDetectThread(this);
}

OcrIdcardOrBlurDetect::~OcrIdcardOrBlurDetect()
{
    if(m_isInit)
    {
        HyUnInitOcr();
    }

    if(m_pOcrIdcardOrBlurDetectThread->isRunning())
    {
        //qDebug()<<"OCR 线程正在运行";
        while(m_pOcrIdcardOrBlurDetectThread->isRunning());
    }

    if(m_pOcrIdcardOrBlurDetectThread!=NULL)
    {
        delete m_pOcrIdcardOrBlurDetectThread;
        m_pOcrIdcardOrBlurDetectThread = NULL;
        //qDebug()<<"OCR 释放";
    }
}
//初始化
bool OcrIdcardOrBlurDetect::init()
{
    QFile ocrFile(":/base/src/OcrIdcardOrBlurDetect/OcrInterface/IdOcr.dat");
    bool err = ocrFile.open(QIODevice::ReadOnly | QIODevice::Text);
    if(!err){
        qDebug()<<"open IdOcr.dat file fail.";
    }
    QByteArray baOcrpwd = ocrFile.readAll();
    ocrFile.close();
    return  HyInitOcrOEM(baOcrpwd.data()) == 0;
}

//OCR识别
QString OcrIdcardOrBlurDetect::ocrIdcard()
{
    ENSCANSIDE ScanRes = ENSCANSIDE_ScanNone;
    //qDebug() <<m_idcardPhotoPath;
    //qDebug() <<HyOcrImageFile(m_idcardPhotoPath.toUtf8().data());
    if ( HyOcrImageFile(m_idcardPhotoPath.toUtf8().data()) == 0 )
    {
        std::string str(HyGetOcrSectionStr(SEC_NAME));
        ScanRes = str.empty() ? ENSCANSIDE_ScanBack:ENSCANSIDE_ScanFront;
    }  

    //qDebug() <<ScanRes;
    return saveOcrIdcardInfo( ScanRes ).toUtf8().data();
}

//将识别的身份证信息存入本地 并返回值为二代身份证信息
QString OcrIdcardOrBlurDetect::saveOcrIdcardInfo( ENSCANSIDE readSide )
{
    QString ret;
    QJsonObject json_object;
    QJsonDocument json_doc;
    if ( readSide == ENSCANSIDE_ScanFront )
    {
        json_object.insert("name",QString::fromLocal8Bit(HyGetOcrSectionStr(SEC_NAME)));
        json_object.insert("sex",QString::fromLocal8Bit(HyGetOcrSectionStr(SEC_SEX)));
        json_object.insert("nation",QString::fromLocal8Bit(HyGetOcrSectionStr(SEC_FOLK)));
        json_object.insert("birth",QString::fromLocal8Bit(HyGetOcrSectionStr(SEC_BIRTHDAY)));
        json_object.insert("address",QString::fromLocal8Bit(HyGetOcrSectionStr(SEC_ADDRESS)));
        json_object.insert("idcard",QString::fromLocal8Bit(HyGetOcrSectionStr(SEC_NUM)));
        //qDebug() << m_readIdcardPhotoPath;
        //qDebug() <<HyGetOcrHeadImage( m_readIdcardPhotoPath.toUtf8().data()) ;
        if ( HyGetOcrHeadImage( m_readIdcardPhotoPath.toUtf8().data() ) == 0 )
         json_object.insert("photopath",m_readIdcardPhotoPath);
    }
    else if ( readSide == ENSCANSIDE_ScanBack )
    {
        json_object.insert("depart",QString::fromLocal8Bit(HyGetOcrSectionStr(SEC_ISSUE)));                                                                                                                                                                                                                                           //>_ISSUE)));
        json_object.insert("validdate",QString::fromLocal8Bit(HyGetOcrSectionStr(SEC_PERIOD)));
    }
    else
    {
        return "";
    }
    json_doc.setObject(json_object);
    ret = json_doc.toJson();
    return ret;
}

int OcrIdcardOrBlurDetect::blurDetect()
{
    return ImageBlurDetect(m_idcardPhotoPath.toUtf8().data());
}

//参1：操作类型 参2：要进行识别的二代证照片路径 参3：期望识别成功后一寸照片存放路径 参4：期望模糊值
void OcrIdcardOrBlurDetect::startOcrIdcardOrBlurDetect(EOPERATE_TYPE type, QString idcardPhotoPath, QString readIdcardPhotoPath, int blurValue)
{
    m_operateType = type;
    m_idcardPhotoPath = idcardPhotoPath;
    m_readIdcardPhotoPath = readIdcardPhotoPath;
    m_blurValue = blurValue;
    //qDebug() <<m_pOcrIdcardOrBlurDetectThread->isRunning();
    if(m_pOcrIdcardOrBlurDetectThread->isRunning())
    {
        while(m_pOcrIdcardOrBlurDetectThread->isRunning());
    }
    m_pOcrIdcardOrBlurDetectThread->startRun();

}

///////////////////////////////////////////////////////////////////
void OcrIdcardOrBlurDetectThread::run()
{
    //qDebug() << "OCR线程开始";
    OcrIdcardOrBlurDetect *parent = (OcrIdcardOrBlurDetect *)m_parent;
    int blurValue=0;
    QString jsonStr;

    switch(parent->m_operateType)
    {
    //自行验证清晰度后进行OCR识别
    case OcrIdcardOrBlurDetect::EOPERATE_TYPE_ALL:
        blurValue = parent->blurDetect();
        if( blurValue <= parent->m_blurValue)//清晰可进行识别
        {
            jsonStr = parent->ocrIdcard();
            if(jsonStr != "")//识别身份证成功
            {
                emit parent->ocrIdcardOrBlurDetectFinished(OcrIdcardOrBlurDetect::EFACE_RET_SUCCESS, blurValue, jsonStr);
            }
            else
            {
                emit parent->ocrIdcardOrBlurDetectFinished(OcrIdcardOrBlurDetect::EFACE_RET_ERROR, blurValue, jsonStr);
            }
        }
        else
        {
            emit parent->ocrIdcardOrBlurDetectFinished(OcrIdcardOrBlurDetect::EFACE_RET_BLUR, blurValue, "");
        }
        break;
    //只验证清晰度
    case OcrIdcardOrBlurDetect::EOPERATE_TYPE_BLUR:
        emit parent->ocrIdcardOrBlurDetectFinished(OcrIdcardOrBlurDetect::EFACE_RET_SUCCESS, parent->blurDetect(), "");
        break;
    //只进行OCR识别
    case OcrIdcardOrBlurDetect::EOPERATE_TYPE_OCR:
        jsonStr = parent->ocrIdcard();
        if(jsonStr != "")//识别身份证成功
        {
            emit parent->ocrIdcardOrBlurDetectFinished(OcrIdcardOrBlurDetect::EFACE_RET_SUCCESS, blurValue, jsonStr);
        }
        else
        {
            emit parent->ocrIdcardOrBlurDetectFinished(OcrIdcardOrBlurDetect::EFACE_RET_ERROR, blurValue, jsonStr);
        }
        break;
    }
    //qDebug() << "OCR 识别线程结束";
}


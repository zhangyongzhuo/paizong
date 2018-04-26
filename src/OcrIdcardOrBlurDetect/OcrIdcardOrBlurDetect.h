#ifndef OCRIDCARD_H
#define OCRIDCARD_H
#include "src/OcrIdcardOrBlurDetect/OcrInterface/OcrInterface.h"
#include "src/OcrIdcardOrBlurDetect/BlurDetect/BlurDetect.h"
#include <QThread>
#include <QDebug>
#include <QFile>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QMetaType>

//识别的身份证是正面还是反面还是都不是
enum ENSCANSIDE
{
   ENSCANSIDE_ScanNone				= 1,
   ENSCANSIDE_ScanFront			    = 2,
   ENSCANSIDE_ScanBack				= 3
};

class OcrIdcardOrBlurDetectThread : public QThread  /////////2015-12-28 XIN
{
        Q_OBJECT
public:
        OcrIdcardOrBlurDetectThread(QObject *parent = 0): QThread(parent)
        {
            m_parent = parent;
        }
        void startRun()
        {
            start(HighestPriority);
        }
protected:
    void run();
public:
    QObject *m_parent;
};


class OcrIdcardOrBlurDetect : public QObject
{
    Q_OBJECT
    Q_ENUMS(EOCR_RET)
    Q_ENUMS(EOPERATE_TYPE)
public:
    enum EOCR_RET{
        EFACE_RET_SUCCESS = 1, //成功
        EFACE_RET_ERROR,       //出错
        EFACE_RET_BLUR         //清晰度不达标
    };
    enum EOPERATE_TYPE{
        EOPERATE_TYPE_ALL = 1,  //模糊度检测+OCR识别
        EOPERATE_TYPE_OCR,      //OCR识别
        EOPERATE_TYPE_BLUR      //模糊度检测
    };
public:
    OcrIdcardOrBlurDetect();
    ~OcrIdcardOrBlurDetect();
signals:
    //参1 结果 参2 清晰度 参3身份证信息Json
    void ocrIdcardOrBlurDetectFinished(EOCR_RET ret, int blurValue, QString ocrIdInfo);
public:
    bool ocrResult;
    OcrIdcardOrBlurDetectThread *m_pOcrIdcardOrBlurDetectThread;
    bool                         m_isInit;
    QString                      m_readIdcardPhotoPath;
    QString                      m_idcardPhotoPath;
    EOPERATE_TYPE                m_operateType;
    int                          m_blurValue;
public:
    //参1：操作类型 参2：要进行识别的二代证照片路径 参3：期望识别成功后一寸照片存放路径 参4：期望模糊值
    Q_INVOKABLE void startOcrIdcardOrBlurDetect(EOPERATE_TYPE type, QString idcardPhotoPath, QString readIdcardPhotoPath, int blurValue);
public:
    int      blurDetect();
    QString  ocrIdcard();//OCR识别
    //参1：身份证正面照片路径  参2：解析的身份证一寸照存放路径 默认存D盘 参数格式：D:\\OCRheadImg.bmp
    bool getIDPhotoInfo(char* photoPath, char* readIDPhotoPath);
    //将识别的身份证信息存入本地
    //返回值为二代身份证信息
    QString         saveOcrIdcardInfo(ENSCANSIDE readSide);
private:
    bool			init();//初始化


};

#endif // OCRIDCARD_H

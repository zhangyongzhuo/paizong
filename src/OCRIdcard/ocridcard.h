#ifndef OCRIDCARD_H
#define OCRIDCARD_H
#include "OcrInterface.h"
#include <QThread>
#include "src/IDOCR/BlurDetect.h"
#include <QDebug>
#include <QFile>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
//#include "src/publicdata.h"

//识别的身份证是正面还是反面还是都不是
typedef enum
{
   ENSCANSIDE_ScanNone				= 1,
   ENSCANSIDE_ScanFront			    = 2,
   ENSCANSIDE_ScanBack				= 3
}ENSCANSIDE;

class OCRIdcardThread : public QThread  /////////2015-12-28 XIN
{
        Q_OBJECT
public:
        OCRIdcardThread(QObject *parent = 0): QThread(parent)
        {
            m_parent = parent;
        }
        void StartRun()
        {
            start(HighestPriority);
        }
protected:
    void run();
public:
    QObject *m_parent;
};


class OCRIdcard : public QObject
{
       Q_OBJECT
public:
    OCRIdcard();
    ~OCRIdcard();

signals:
    void finishBlurDetect(QString path, int value);//完成模糊检测
    void ocrIdcardFinished(QString ocrIdInfo);
public:
    bool ocrResult;
    OCRIdcardThread *m_pOCRIdcardThread;
    bool            m_isInit;
    QString         m_saveImgPath;
    QString         m_photoPath;
public:
    Q_INVOKABLE void StartBlurDetect(QString path);//开始模糊检测
    Q_INVOKABLE bool ReadPhotoOcrInfo(QString PhotoPath);
public:
    bool read_ocrResult() const;
    void write_ocrResult(const bool &flag);
    //参1：身份证正面照片路径  参2：解析的身份证一寸照存放路径 默认存D盘 参数格式：D:\\OCRheadImg.bmp
    bool GetIDPhotoInfo(char* photoPath, char* readIDPhotoPath);
    //将识别的身份证信息存入本地
    //返回值为二代身份证信息
    QString SaveOcrIdcardInfo(ENSCANSIDE readSide);
    bool			Init();//初始化
    ENSCANSIDE      OCRRecognizer(char* filePathName);//OCR识别

};

#endif // OCRIDCARD_H

#pragma execution_character_set("utf-8")
#ifndef OCRCAR_H
#define OCRCAR_H
#include "plateocr/PlateOcr.h"
#include <QString>
#include <QObject>
#include <QThread>

class OcrCarThread : public QThread
{
        Q_OBJECT
public:
        OcrCarThread(QObject *parent = 0): QThread(parent)
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


class OcrCar:public QObject
{
    Q_OBJECT
public:
    OcrCar();//初始化车牌OCR 传入车牌OCR的授权文件路径 初始化一次就可以
    ~OcrCar();

    OcrCarThread    *m_pOcrCarThread;
    bool            m_isInit;
    QString         m_carPhotoPath;

public:
    Q_INVOKABLE int getCarPhotoInfo(QString carPhotoPath);//获取车牌号码 传入车牌照片 返回值车牌号码

signals:
    void ocrCarnotify(QString msg);
    void ocrCarfinished(QString licenseNumber);

};

#endif // OCRCAR_H

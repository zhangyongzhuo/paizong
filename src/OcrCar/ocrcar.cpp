#pragma execution_character_set("utf-8")
#include "ocrcar.h"
#include <QFile>
#include <QDebug>

OcrCar::OcrCar()
{
    char szLicense[64] = "\0";

    QFile file(":/base/src/OcrCar/plateocr/PlateOcr.dat");
    file.open(QIODevice::ReadOnly);
    file.read(szLicense, 64);
    file.close();

    //初始化
    int	ok = HyInitPlateOCROEM( szLicense  );
    qDebug()<<"HyInitPlateOCROEM:"<<ok;
    if(ok != 0 ){
        m_isInit = false;
    }
    else{
        m_isInit = true;
        //设置优先省份
        ok = HySetProvinceOrder((char *)"黑京辽吉");
        qDebug()<<"HyInitPlateOCROEM:"<<ok;
    }

    m_pOcrCarThread = new OcrCarThread(this);
    //m_isInit = false;
}

OcrCar::~OcrCar()
{
    if(m_pOcrCarThread->isRunning())
    {
        qDebug()<<"车牌OCR 线程正在运行";
        while(m_pOcrCarThread->isRunning());
    }
    if(m_isInit)
    {
        HyUninitPlateOCR();
    }
    if(m_pOcrCarThread!=NULL)
    {
        delete m_pOcrCarThread;
        m_pOcrCarThread = NULL;
        qDebug()<<"车牌OCR 释放";
    }
}

//获取车牌号码 传入车牌照片 返回值车牌号码
int OcrCar::getCarPhotoInfo(QString carPhotoPath)
{
    if (carPhotoPath == NULL)
    {
        qDebug() << "车牌OCR识别失败 照片路径为空";
        return -1;
    }
    //接到识别任务后迅速返回 启动线程继续做识别任务
    m_carPhotoPath = carPhotoPath;

    if(m_pOcrCarThread->isRunning())
    {
        qDebug()<<"车牌OCR 线程正在运行";
        while(m_pOcrCarThread->isRunning());
    }
    else
    {
        m_pOcrCarThread->startRun();  //起线程
    }

    return 0;
}


///////////////////////////////////////////////////////////////////
void OcrCarThread::run()
{
    //qDebug() << "车牌OCR线程开始";
    OcrCar *parent = (OcrCar *)m_parent;
    if (!parent->m_isInit)
    {
        //emit notify("car ocr init err");
        qDebug()<<"car ocr init err";
        return ;
    }
    char * strCph = HyGetPlateNoStringFromFile( parent->m_carPhotoPath.toUtf8().data() );
    QString cph;
    cph = cph.fromLocal8Bit(strCph);
    if(cph != NULL){
        emit parent->ocrCarfinished(cph);
    }
    else{
        emit parent->ocrCarnotify("OCR 识别失败");
        return ;
    }

    qDebug() << "OCR 识别线程结束";
    return ;
}

#ifndef READIDCARD_H
#define READIDCARD_H

#include <QApplication>
#include <QCoreApplication>
#include <Windows.h>
#include <QObject>
#include <QThread>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QFile>


/*typedef enum
{
    EMREADIDRESULT_IDInitFaild = 1,
    EMREADIDRESULT_IDReadSuccess = 2,
    EMREADIDRESULT_IDReadContentErr = 3,

}EMREADIDRESULT;*/


class ReadIdcardThread : public QThread
{
        Q_OBJECT
public:
        ReadIdcardThread(QObject *parent = 0): QThread(parent)
        {
            m_parent = parent;
            m_ReadIdcardThreadRun = TRUE;
        }
        void startRun()
        {
            start(HighestPriority);
        }
protected:
    void run();
public:
    QObject *m_parent;

    BOOL     m_ReadIdcardThreadRun;
};

class ReadIdcard: public QObject
{
        Q_OBJECT
public:
    ReadIdcard();
    ~ReadIdcard();

signals:
    //void ReadIdcardError(QString errorInfo);//读取二代身份证报错
    void readIdcardFinished(QString idcardInformation); //二代证识别完成

public:
     Q_INVOKABLE int  startIdcardIdentification(QString photoPath);//启动二代证键盘识别
     Q_INVOKABLE void stopIdcardIdentification( void );//停止二代证键盘识别

public:
    //检测二代证键盘设备ID： USB\VID_0400&PID_C35A&REV_0063
    //USB\VID_0400&PID_C35A
    BOOL  detectKeyboardDevice( void );

    //将读取的身份证信息存入本地
    // wz.txt 数据信息
    // zp.bmp 身份证照片
    //返回值为二代身份证信息
    QString  saveIdcardInfo();

   // En_READIDRESULT  StartReadIdcardInfo();//启动读取身份证信息
    QString getDecodeNation(int code);//译码民族 参数code为编码，nation为民族  返回值为民族
    BOOL	loadDll( void );//加载dll
    BOOL	initDevice();//初始化设备
    BOOL	closeDevice();//关闭设备
    bool copyFileToPath(QString sourceDir, QString toDir, bool coverFileIfExist);

    /*public slots:
    void OnReadIdcardError(QString errorInfo);
    void OnReadIdcardFinished(QString idcardInformation);*/

    public:
    ReadIdcardThread        *m_pReadIdcardThread;
    QString m_photoPath;

};

#endif // READIDCARD_H

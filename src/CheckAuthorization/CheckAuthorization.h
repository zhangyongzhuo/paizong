
#ifndef CHECKAUTHORIZATION_H
#define CHECKAUTHORIZATION_H

#include <QObject>
#include <QCoreApplication>
#include <QString>
#include <QMutex>
#include <QFile>
#include <qDebug>
#include <QDateTime>
#include <QMap>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include "src/CheckAuthorization/Validate/PcInfo.h"
#include "src/CheckAuthorization/Validate/SafeDll.h"
#include "src/CheckAuthorization/OpenSSL/include/evp.h"
#include "src/CheckAuthorization/OpenSSL/include/pem.h"
#include "src/CheckAuthorization/OpenSSL/include/err.h"

/***********************************************************************
 * 注意：
 * 需要在pro中连接PcInfo.lib、SafeDll.lib、libcrypto.lib、libssl.lib，如：
 * LIBS += -L$$PWD\src\Validate -lPcInfo
 * LIBS += -L$$PWD\src\Validate -lSafeDll
 * LIBS += -L$$PWD\src\OpenSSL\lib -llibcrypto
 * LIBS += -L$$PWD\src\OpenSSL\lib -llibssl
 * 调用CheckAuthorization::GetInstance()->VerifyLicense();进行校验License
 * main函数中需要注册此类，如
 * qmlRegisterType<OperatePoliceNet>("com.hylink.fmcp.ctrl", 2, 0, "OperatePoliceNet");
 * *********************************************************************/

#define HLK_NAME        "license.hlk"
#define SIG_NAME        "license.sig"
#define HLK_KEY_SN      "HarddiskSN"
#define HLK_KEY_DATE    "Deadline"

enum EFEATURE
{
    EFEATURE_RELEASE,
    EFEATURE_DEBUG
};

class CheckAuthorization : public QObject
{
    Q_OBJECT

public:
    enum EAUTHERR
    {
        EAUTHERR_NOERROR,
        EAUTHERR_LOSELICENSE,   // 丢失license
        EAUTHERR_VERIFYSIGN,    // 校验签名文件失败
        EAUTHERR_SN,            // 序列号校验失败
        EAUTHERR_DEALLINE       // 最后期限校验失败
    };

private:
    CheckAuthorization();
    CheckAuthorization(const CheckAuthorization &);	// 只声明不实现
    CheckAuthorization &operator=(const CheckAuthorization &);	// 只声明不实现
    ~CheckAuthorization();

public:
    Q_INVOKABLE static CheckAuthorization *getInstance();

public:
    // 校验License
    QString verifyLicense();
    QString m_serialNumber;

private:
    QString         getSN();    //获取硬盘序列号
    bool            isExist(QString filename);  // 判断文件是否存在
    bool            verifySign();   // 校验签名文件
    QString         readHlkInfo(QString jsonKey);   // 获取hlk文件中的信息
    enum EFEATURE   readHlkFeature();   // 读取hlk文件中的Feature
    QDateTime       getCurrentDate();   //获取当前系统日期
    void            setX3SN(QString x3sn);  // 保存x3序列号

public:
    QString generateVerifyLicenseReply(const enum EAUTHERR &errType, const QString &Description, const enum EFEATURE &featureType);     // 生成回复json

private:
    static  CheckAuthorization *s_pInstance;
    static  QMutex s_Mutex;

private:
    QString m_AppPath;
    QString m_HlkPath;
    QString m_SigPath;
    QString m_X3SN;
    QString m_VerifyLicenseRet;
};

#endif // CHECKAUTHORIZATION_H

#ifndef OPERATECONFIGFILE_H
#define OPERATECONFIGFILE_H

#include <QObject>
#include <QCoreApplication>
#include <QString>
#include <QMutex>
#include <QSettings>
#include <QFile>
/***************************************************************************
 * 说明：
 * 此类读取/写入运行目录中的app.conf、camera.conf、proxy.conf、setting.conf、
 * UpgradeConfig.conf配置文件。
 * 首先调用OperateConfigFile()->GetInstance()->LoadConfigData()读取配置文件
 * 之后读取某一项时调用对应函数，如读取app.conf中[Welcome]中的text1,则
 * QString test1 = OperateConfigFile()->GetInstance()->GetWelcomeText1();
 * Set函数返回false则写入出错
***************************************************************************/

class OperateConfigFile:public QObject
{
    Q_OBJECT

public:
    OperateConfigFile();
    ~OperateConfigFile();

public:
// Camera
    Q_INVOKABLE int getCameraInitNum();
    Q_INVOKABLE bool setCameraInitNum(const int &num);
    Q_INVOKABLE int     getCameraBlur();
    Q_INVOKABLE bool    setCameraBlur(const int &blur);
// General
    Q_INVOKABLE QString getLocationName();
    Q_INVOKABLE bool    setLocationName(const QString &locationName);
    Q_INVOKABLE QString getLocationId();
    Q_INVOKABLE bool    setLocationId(const QString &locationId);
    Q_INVOKABLE QString getUnitName();
    Q_INVOKABLE bool    setUnitName(const QString &unitName);
    Q_INVOKABLE QString getTypeName();
    Q_INVOKABLE bool    setTypeName(const QString &typeName);
    Q_INVOKABLE QString getApproverIdcard();
    Q_INVOKABLE bool    setApproverIdcard(const QString &approverIdcard);
    Q_INVOKABLE QString getApproverLeader();
    Q_INVOKABLE bool    setApproverLeader(const QString &approverLeader);

    Q_INVOKABLE QString getOrgId();
    Q_INVOKABLE bool    setOrgId(const QString &orgId);
    Q_INVOKABLE QString getOrgName();
    Q_INVOKABLE bool    setOrgName(const QString &orgName);
    Q_INVOKABLE QString getOrgCode();
    Q_INVOKABLE bool    setOrgCode(const QString &orgCode);
    Q_INVOKABLE QString getOrgJb();
    Q_INVOKABLE bool    setOrgJb(const QString &orgJb);

// GoService
    Q_INVOKABLE QString getGoServiceIP();
    Q_INVOKABLE int     getGoServicePort();

// ShowText
    Q_INVOKABLE QString getShowTextMainPageTitle();
    Q_INVOKABLE QString getShowTextEnglishTitle();
    Q_INVOKABLE QString getShowTextCompanyName();
    Q_INVOKABLE QString getShowTextCityNumber();

// Remote
    Q_INVOKABLE QString getRemoteIP();
    Q_INVOKABLE void    setRemoteIP(const QString &IP);
    Q_INVOKABLE int     getRemotePort();
    Q_INVOKABLE void    setRemotePort(const int &port);

// Proxy
    Q_INVOKABLE int     getProxyHttpsEnable();
    Q_INVOKABLE void    setProxyHttpsEnable(const int &enable);
    Q_INVOKABLE QString getProxyHttpsIP();
    Q_INVOKABLE void    setProxyHttpsIP(const QString &IP);
    Q_INVOKABLE int     getProxyHttpsPort();
    Q_INVOKABLE void    setProxyHttpsPort(const int &port);
    Q_INVOKABLE QString getProxyUsreName();
    Q_INVOKABLE void    setProxyUserName(const QString &userName);
    Q_INVOKABLE QString getProxyPassword();
    Q_INVOKABLE void    setProxyPassword(const QString &password);

// GPS
    Q_INVOKABLE QString getGPSIP();
    Q_INVOKABLE int     getGPSPort();

// FaceCompare
    Q_INVOKABLE float getFaceCompareBoundaryValue();

private:
    void readAllConfig();

private:
    QSettings *m_pAppConfig;
    QSettings *m_pCameraConfig;

private:
// General
    QString m_LocationName;
    QString m_LocationId;
    QString m_UnitName;
    QString m_TypeName;
    QString m_ApproverIdcard;
    QString m_ApproverLeader;

    QString m_OrgId;
    QString m_OrgName;
    QString m_OrgCode;
    QString m_OrgJb;
// GoService
    QString m_GoServiceIP;
    int     m_GoServicePort;
// ShowText
    QString m_ShowTextMainPageTitle;
    QString m_ShowTextCompanyName;
    QString m_ShowTextEnglishTitle;
    QString m_ShowTextCityNumber;
// Camera
    int     m_CameraInitNum;
    int     m_CameraBlur;
// Remote
    QString m_RemoteIP;
    int     m_RemotePort;

// Proxy
    int     m_ProxyHttpsEnable;
    QString m_ProxyHttpsIP;
    int     m_ProxyHttpsPort;
    QString m_ProxyUserName;
    QString m_ProxyPassword;
// GPS
    QString m_GPSIP;
    int     m_GPSPort;
// FaceCompare
    float   m_FaceCompareBoundaryValue;
};

#endif // OPERATECONFIGFILE_H

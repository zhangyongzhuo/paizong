#pragma execution_character_set("utf-8")
#include "OperateConfigFile.h"
#include <qDebug>

OperateConfigFile::OperateConfigFile()
{
    m_pAppConfig        = NULL;
    m_pCameraConfig     = NULL;
    m_CameraInitNum = 0;
    m_RemotePort = 0;
    m_ProxyHttpsEnable = 0;
    m_ProxyHttpsPort = 0;
    m_GPSPort = 0;
    m_FaceCompareBoundaryValue = 0.0;

    readAllConfig();
}

OperateConfigFile::~OperateConfigFile()
{
    delete m_pAppConfig;                    m_pAppConfig = NULL;
    delete m_pCameraConfig;                 m_pCameraConfig = NULL;
}

// General
QString OperateConfigFile::getLocationName()
{
    return m_LocationName;
}

bool    OperateConfigFile::setLocationName(const QString &locationName)
{
    m_LocationName = locationName;
    m_pAppConfig->setValue("locationName", m_LocationName);
    return true;
}

QString OperateConfigFile::getLocationId()
{
    return m_LocationId;
}

bool    OperateConfigFile::setLocationId(const QString &locationId)
{
    m_LocationId = locationId;
    m_pAppConfig->setValue("locationId", m_LocationId);
    return true;
}

QString OperateConfigFile::getUnitName(){
     return m_UnitName;
}

bool    OperateConfigFile::setUnitName(const QString &unitName){
    m_UnitName = unitName;
    m_pAppConfig->setValue("unitName", m_UnitName);
    return true;
}

QString OperateConfigFile::getTypeName(){
   return m_TypeName;
}

bool    OperateConfigFile::setTypeName(const QString &typeName){
    m_TypeName = typeName;
    m_pAppConfig->setValue("typeName", m_TypeName);
    return true;
}

QString OperateConfigFile::getApproverIdcard(){
    return m_ApproverIdcard;
}

bool    OperateConfigFile::setApproverIdcard(const QString &approverIdcard){
    m_ApproverIdcard = approverIdcard;
    m_pAppConfig->setValue("approverIdcard", m_ApproverIdcard);
    return true;
}

QString OperateConfigFile::getApproverLeader(){
    return m_ApproverLeader;
}

bool    OperateConfigFile::setApproverLeader(const QString &approverLeader){
    m_ApproverLeader = approverLeader;
    m_pAppConfig->setValue("approverLeader", m_ApproverLeader);
    return true;
}

QString OperateConfigFile::getOrgId()
{
    return m_OrgId;
}

bool    OperateConfigFile::setOrgId(const QString &orgId)
{
    m_OrgId = orgId;
    m_pAppConfig->setValue("OrgInfo/orgId", m_OrgId);
    return true;
}

QString OperateConfigFile::getOrgName()
{
    return m_OrgName;
}

bool    OperateConfigFile::setOrgName(const QString &orgName)
{
    m_OrgName = orgName;
    m_pAppConfig->setValue("OrgInfo/orgName", m_OrgName);
    return true;
}

QString OperateConfigFile::getOrgCode()
{
    return m_OrgCode;
}

bool    OperateConfigFile::setOrgCode(const QString &orgCode)
{
    m_OrgCode = orgCode;
    m_pAppConfig->setValue("OrgInfo/orgCode", m_OrgCode);
    return true;
}

QString OperateConfigFile::getOrgJb(){
    return m_OrgJb;
}

bool    OperateConfigFile::setOrgJb(const QString &orgJb){
    m_OrgJb = orgJb;
    m_pAppConfig->setValue("OrgInfo/orgJb", m_OrgJb);
    return true;
}


// GoService
QString OperateConfigFile::getGoServiceIP()
{
    return m_GoServiceIP;
}

int OperateConfigFile::getGoServicePort()
{
    return m_GoServicePort;
}

// ShowText
QString OperateConfigFile::getShowTextMainPageTitle()
{
    return m_ShowTextMainPageTitle;
}

QString OperateConfigFile::getShowTextEnglishTitle(){
    return m_ShowTextEnglishTitle;
}

QString OperateConfigFile::getShowTextCityNumber(){
    return m_ShowTextCityNumber;
}

QString OperateConfigFile::getShowTextCompanyName()
{
    return m_ShowTextCompanyName;
}


// Camera
int OperateConfigFile::getCameraInitNum()
{
    return m_CameraInitNum;
}

bool OperateConfigFile::setCameraInitNum(const int &num)
{

    m_CameraInitNum = num;
    m_pCameraConfig->setValue("initCamera", m_CameraInitNum);

    return false;
}
int OperateConfigFile::getCameraBlur()
{
    return m_CameraBlur;
}

bool OperateConfigFile::setCameraBlur(const int &blur)
{
    return false;

    m_CameraBlur = blur;
    m_pAppConfig->setValue("Camera/blur", m_CameraBlur);
}

// Remote
QString OperateConfigFile::getRemoteIP()
{
    return m_RemoteIP;
}

void OperateConfigFile::setRemoteIP(const QString &IP)
{
    m_RemoteIP = IP;
    m_pAppConfig->beginGroup("Remote");
    m_pAppConfig->setValue("ip", IP);
    m_pAppConfig->endGroup();
}

int OperateConfigFile::getRemotePort()
{
    return m_RemotePort;
}

void OperateConfigFile::setRemotePort(const int &port)
{
    m_RemotePort = port;
    m_pAppConfig->beginGroup("Remote");
    m_pAppConfig->setValue("port", m_RemotePort);
    m_pAppConfig->endGroup();
}

// Proxy
int OperateConfigFile::getProxyHttpsEnable()
{
    return m_ProxyHttpsEnable;
}

void OperateConfigFile::setProxyHttpsEnable(const int &enable)
{
    m_ProxyHttpsEnable = enable;
    m_pAppConfig->beginGroup("Proxy");
    m_pAppConfig->setValue("enable", m_ProxyHttpsEnable);
    m_pAppConfig->endGroup();
}

QString OperateConfigFile::getProxyHttpsIP()
{
    return m_ProxyHttpsIP;
}

void OperateConfigFile::setProxyHttpsIP(const QString &IP)
{
    m_ProxyHttpsIP = IP;
    m_pAppConfig->beginGroup("Proxy");
    m_pAppConfig->setValue("ip", m_ProxyHttpsIP);
    m_pAppConfig->endGroup();
}

int OperateConfigFile::getProxyHttpsPort()
{
    return m_ProxyHttpsPort;
}

void OperateConfigFile::setProxyHttpsPort(const int &port)
{
    m_ProxyHttpsPort = port;
    m_pAppConfig->beginGroup("Proxy");
    m_pAppConfig->setValue("port", m_ProxyHttpsPort);
    m_pAppConfig->endGroup();
}

QString OperateConfigFile::getProxyUsreName()
{
    return m_ProxyUserName;
}

void OperateConfigFile::setProxyUserName(const QString &userName)
{
    m_ProxyUserName = userName;
    m_pAppConfig->beginGroup("Proxy");
    m_pAppConfig->setValue("username", m_ProxyUserName);
    m_pAppConfig->endGroup();
}

QString OperateConfigFile::getProxyPassword()
{
    return m_ProxyPassword;
}

void OperateConfigFile::setProxyPassword(const QString &password)
{
    m_ProxyPassword = password;
    m_pAppConfig->beginGroup("Proxy");
    m_pAppConfig->setValue("password", m_ProxyPassword);
    m_pAppConfig->endGroup();
}

// GPS
QString OperateConfigFile::getGPSIP()
{
    return m_GPSIP;
}

int OperateConfigFile::getGPSPort()
{
    return m_GPSPort;
}


// FaceCompare
float OperateConfigFile::getFaceCompareBoundaryValue()
{
    return m_FaceCompareBoundaryValue;
}

void OperateConfigFile::readAllConfig()
{
    QString path = QCoreApplication::applicationDirPath();
    QString appPath = path +"/../app-data/app.conf";
    //qDebug()<<appPath;

    m_pAppConfig = new QSettings(appPath, QSettings::IniFormat);
    m_pAppConfig->setIniCodec("GBK");
// General
    m_LocationName                  = m_pAppConfig->value("locationName").toString();
    m_LocationId                    = m_pAppConfig->value("locationId").toString();
    m_UnitName                      = m_pAppConfig->value("unitName").toString();
    m_TypeName                      = m_pAppConfig->value("typeName").toString();
    m_ApproverIdcard                = m_pAppConfig->value("approverIdcard").toString();
    m_ApproverLeader               = m_pAppConfig->value("approverLeader").toString();

    m_OrgId   = m_pAppConfig->value("OrgInfo/orgId").toString();
    m_OrgName = m_pAppConfig->value("OrgInfo/orgName").toString();
    m_OrgCode = m_pAppConfig->value("OrgInfo/orgCode").toString();
    m_OrgJb = m_pAppConfig->value("OrgInfo/orgJb").toString();

// GoService
    m_GoServiceIP                   = m_pAppConfig->value("GoService/ip").toString();
    m_GoServicePort                 = m_pAppConfig->value("GoService/port").toInt();

// ShowText
    m_ShowTextMainPageTitle         = m_pAppConfig->value("ShowText/mainPageTitle").toString();
    m_ShowTextCompanyName           = m_pAppConfig->value("ShowText/companyName").toString();
    m_ShowTextEnglishTitle         = m_pAppConfig->value("ShowText/englishTitle").toString();
    m_ShowTextCityNumber           = m_pAppConfig->value("ShowText/cityNumber").toString();
// Remote
    m_RemoteIP                      = m_pAppConfig->value("Remote/ip").toString();
    m_RemotePort                    = m_pAppConfig->value("Remote/port").toInt();

// Proxy
    m_ProxyHttpsEnable              = m_pAppConfig->value("Proxy/enable").toInt();
    m_ProxyHttpsIP                  = m_pAppConfig->value("Proxy/ip").toString();
    m_ProxyHttpsPort                = m_pAppConfig->value("Proxy/port").toInt();
    m_ProxyUserName                 = m_pAppConfig->value("Proxy/username").toString();
    m_ProxyPassword                 = m_pAppConfig->value("Proxy/password").toString();

// GPS
    m_GPSIP                         = m_pAppConfig->value("GPS/ip").toString();
    m_GPSPort                       = m_pAppConfig->value("GPS/port").toInt();

// FaceCompare
    m_FaceCompareBoundaryValue      = m_pAppConfig->value("FaceCompare/boundaryValue").toFloat();

// Camera
    QString cameraPath = path +"/../app-data/camera.conf";
    m_pCameraConfig = new QSettings(cameraPath);
    m_pCameraConfig->setIniCodec("GBK");
    m_CameraInitNum                 = m_pCameraConfig->value("initCamera").toInt();
    m_CameraBlur                    = m_pAppConfig->value("Camera/blur").toInt();
}


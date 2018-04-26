#pragma execution_character_set("utf-8")
#include "CheckAuthorization.h"

CheckAuthorization *CheckAuthorization::s_pInstance = NULL;
QMutex CheckAuthorization::s_Mutex;

CheckAuthorization::CheckAuthorization()
{
    qRegisterMetaType<EAUTHERR>("EAUTHERR");
    m_AppPath = QCoreApplication::applicationDirPath();
    m_HlkPath = m_AppPath+"/../app-data/"+HLK_NAME;
    m_SigPath = m_AppPath+"/../app-data/"+SIG_NAME;
}

CheckAuthorization::~CheckAuthorization()
{

}

CheckAuthorization *CheckAuthorization::getInstance()
{
    if (NULL == s_pInstance)
    {
        s_Mutex.lock();
        if (NULL == s_pInstance)
        {
            s_pInstance = new CheckAuthorization();
        }
        s_Mutex.unlock();
    }

    return s_pInstance;
}

QString CheckAuthorization::verifyLicense()
{
    // 获取硬盘序列号      serialNumber为空可以直接返回不进行下面操作
    m_serialNumber = getSN();

    // 缺失license文件
    if(!isExist(m_HlkPath) || !isExist(m_SigPath))
    {
        qDebug()<<"缺失license文件,无法继续验证";
        QString errText;
        if(m_serialNumber!="")
           errText = QString("应用缺失注册文件!\n请将序列号【%1】反馈给应用提供商，以获得解决方案.").arg(m_serialNumber);
        else
           errText = "应用缺失注册文件!\n请联系供应商，以获得解决方案.";
        return generateVerifyLicenseReply(EAUTHERR_LOSELICENSE, errText, (enum EFEATURE)-1);
    }
    // 开始验证//////////////////////////////////////
    // 校验签名文件
    if (false == verifySign())  // 检验签名失败
    {
        qDebug()<<"校验签名失败";
        return generateVerifyLicenseReply(EAUTHERR_VERIFYSIGN, "校验签名文件失败！\n请联系应用提供商，以获得解决方案.", (enum EFEATURE)-1);
    }
    // 核对明文信息
    QString hardDiskSN = readHlkInfo(HLK_KEY_SN);
    QString deadline = readHlkInfo(HLK_KEY_DATE);
    QDateTime deadlineTime = QDateTime::fromString(deadline, "yyyy-MM-dd");
    QDateTime currentTime = getCurrentDate();
    // 检验PC/X3序列号和最后期限
    if((m_serialNumber==hardDiskSN) && (currentTime<=deadlineTime))
    {
        return generateVerifyLicenseReply(EAUTHERR_NOERROR, "license已过期！\n请联系应用提供商，以获得解决方案.", readHlkFeature());
    }
    else
    {
        qDebug()<<"PC/X3序列号：【"<<m_serialNumber<<"】【"<<hardDiskSN<<"】，日期：【"<<currentTime<<"】【"<<deadlineTime<<"】";
        if (m_serialNumber!=hardDiskSN)
            return generateVerifyLicenseReply(EAUTHERR_SN, "验证license序列号失败！\n请联系应用提供商，以获得解决方案.", (enum EFEATURE)-1);
        if (currentTime>deadlineTime)
            return generateVerifyLicenseReply(EAUTHERR_DEALLINE, "license已过期！\n请联系应用提供商，以获得解决方案.", (enum EFEATURE)-1);
    }

    return "";
}
// 获取硬盘序列号
QString CheckAuthorization::getSN()
{
    QString strSerialNumber = "";
      int nCode = IsHylinkProduct();//获取机器的品牌信息
      if(nCode==0 || nCode==1) //海邻科系列平板
      {
          //开始读取x3序列号
          char* systemSerialNumber = GetHylinkDeviceId();//获取X3序列号
          strSerialNumber = systemSerialNumber;
          if(strSerialNumber=="ERROR")//获取X3序列号失败或非海邻科产品
              qDebug()<<"获取X3SN失败或非海邻科产品";
          else if(strSerialNumber!="")//获取X3序列号成功
          {
              qDebug()<<"获取到的x3序列号："<<strSerialNumber;
              setX3SN(strSerialNumber);//保存x3序列号
              QString snPath = m_AppPath+"/../app-data/SN.txt";
              if(!isExist(snPath))//SN.txt不存在
              {
                  //把x3序列号写入文件
                  QFile writeserialsn_file(snPath);
                  writeserialsn_file.open(QIODevice::WriteOnly);
                  if(writeserialsn_file.write("SN="+strSerialNumber.toUtf8())==-1)
                      qDebug()<<"写入x3序列号到SN.txt失败";
                  writeserialsn_file.close();
              }
          }
      }
      else if(nCode==-1)//其它公司产品，硬盘序列号方式校验license
      {
          //qDebug()<<"品牌信息：未知";
          //开始读取硬盘序列号
          char systemSerialNumber[32];
          int HdSnLen = CheckKey(systemSerialNumber);//获取硬盘序列号
          strSerialNumber = systemSerialNumber;
          strSerialNumber = strSerialNumber.left(HdSnLen);
          qDebug()<<"获取到的硬盘序列号："<<strSerialNumber;
          QString snPath = m_AppPath+"/../app-data/HDSN.txt";
          if(!isExist(snPath) && strSerialNumber!="")//HDSN.txt不存在，并获取到硬盘序列号
          {
              //把硬盘序列号写入文件
              QFile writeserialsn_file(snPath);
              writeserialsn_file.open(QIODevice::WriteOnly);
              if(writeserialsn_file.write("HDSN="+strSerialNumber.toUtf8())==-1)
                  qDebug()<<"写入硬盘序列号到HDSN.txt失败";
              writeserialsn_file.close();
          }
      }
      return strSerialNumber;

}
// 判断文件是否存在
bool CheckAuthorization::isExist(QString filename)
{
    QFile file(filename);
    return file.exists();
}
// 校验签名文件
bool CheckAuthorization::verifySign()
{
    EVP_MD_CTX *mctx = NULL;
    EVP_PKEY_CTX *pctx = NULL;
    EVP_PKEY *sigkey = NULL;

    mctx = EVP_MD_CTX_new();

    const EVP_MD *md = EVP_get_digestbyname("sha1");
    if(!md)
    {
        qDebug() << "unknown digest name";
    }
    // 读取公钥
    QFile readPubkeyFile(":/base/ui/PublicKey.pem");
    readPubkeyFile.open(QIODevice::ReadOnly | QIODevice::Text);
    QByteArray baPubkey = readPubkeyFile.readAll();
    char *pubkey = baPubkey.data(); //读取到的公钥文件
    readPubkeyFile.close();
    // 将公钥写入内存
    BIO *mem = BIO_new(BIO_s_mem());
    if(BIO_puts(mem, pubkey)==0)
        qDebug()<<"BIO_puts fail:"<<ERR_reason_error_string(ERR_get_error());
    BIO_set_close(mem, BIO_NOCLOSE);
    // 获得公钥
    sigkey = PEM_read_bio_PUBKEY(/*key_file*/mem, /*&sigkey*/NULL, NULL, NULL);
    BIO_free(mem);  // 释放
    if(sigkey==0)
        qDebug() << "PEM_read_bio_PUBKEY fail:" << ERR_reason_error_string(ERR_get_error());
    if(EVP_DigestVerifyInit(mctx, &pctx, EVP_sha1(), NULL, sigkey)==0)
        qDebug() << "EVP_DigestVerifyInit fail:" << ERR_reason_error_string(ERR_get_error());

    QFile hlkFile(m_HlkPath);
    hlkFile.open(QIODevice::ReadOnly | QIODevice::Text);
    QByteArray qData = hlkFile.readAll();
    hlkFile.close();
    if(EVP_DigestVerifyUpdate(mctx, qData.data(), qData.length())==0)
        qDebug() << "EVP_DigestVerifyUpdate fail:" << ERR_reason_error_string(ERR_get_error());
    QFile signFile(m_SigPath);
    signFile.open(QIODevice::ReadOnly);
    QByteArray signData = signFile.readAll();
    signFile.close();
    return EVP_DigestVerifyFinal(mctx, (unsigned char*)signData.data(), signData.length());
}

// 获取hlk文件中的信息
QString CheckAuthorization::readHlkInfo(QString jsonKey)
{
    // 读取license.hlk文件
    QFile readFile(m_HlkPath);
    if(!readFile.open(QIODevice::ReadOnly))
    {
        qDebug()<<m_HlkPath<<"文件打开失败！";
        return "";
    }
    QByteArray datagram = readFile.readAll();
    readFile.close();
    // 解析license.hlk文件json
    QJsonParseError jsonError;
    QJsonDocument parseDoucment = QJsonDocument::fromJson(datagram, &jsonError);
    if(jsonError.error == QJsonParseError::NoError)
    {
        if(parseDoucment.isObject())
        {
            QJsonObject obj = parseDoucment.object();
            if(obj.contains(jsonKey))
            {
                return obj[jsonKey].toString();
            }
        }
    }
    return "";
}
// 读取hlk文件中的Feature
enum EFEATURE CheckAuthorization::readHlkFeature()
{
    // 读取license.hlk文件
    QFile readFile(m_HlkPath);
    if(!readFile.open(QIODevice::ReadOnly))
    {
        qDebug()<<"license.hlk文件打开失败！";
        return (enum EFEATURE)-1;
    }
    QByteArray datagram = readFile.readAll();
    readFile.close();
    // 解析license.hlk文件json
    QJsonParseError jsonError;
    QJsonDocument parseDoucment = QJsonDocument::fromJson(datagram, &jsonError);
    if(jsonError.error == QJsonParseError::NoError)
    {
        if(parseDoucment.isObject())
        {
            QJsonObject obj = parseDoucment.object();
            if(obj.contains("Feature"))
            {
                QJsonArray jsonArrayFeature= obj[" "].toArray();
                if(jsonArrayFeature.contains("release"))
                    return EFEATURE_RELEASE;
                else
                    return EFEATURE_DEBUG;
            }
        }
    }

    return (enum EFEATURE)-1;
}

// 获取当前系统日期
QDateTime CheckAuthorization::getCurrentDate()
{
    QString strYear = QString::number(QDate::currentDate().year(), 10);
    QString strMonth = QString::number(QDate::currentDate().month(), 10);
    QString strDay = QString::number(QDate::currentDate().day(), 10);
    QString currentDate = strYear + "-" + strMonth + "-" + strDay;
    return QDateTime::fromString(currentDate, "yyyy-MM-dd");
}

void CheckAuthorization::setX3SN(QString x3SN)
{
    m_X3SN = x3SN;
}

// 生成回复json
QString CheckAuthorization::generateVerifyLicenseReply(const enum EAUTHERR &errType, const QString &Description, const enum EFEATURE &featureType)
{
    QJsonDocument   document;
    QJsonObject     json, jsonErr;

    json.insert("AuthorizedOk", errType==EAUTHERR_NOERROR?true:false);
    jsonErr.insert("code", (int)errType);
    jsonErr.insert("desc", Description);
    json.insert("Error", jsonErr);
    QString feature;
    switch (featureType)
    {
    case EFEATURE_DEBUG:
        feature = "debug";
        break;
    case EFEATURE_RELEASE:
        feature = "release";
        break;
    default:
        break;
    }
    json.insert("Feature", feature);
    document.setObject(json);
    return document.toJson();
}

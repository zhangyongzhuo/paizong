#pragma execution_character_set("utf-8")
#include "mobilecollection.h"
//#define MOBILECOLLECTION_QDEBUG
MobileCollection::MobileCollection()
{
    m_delayedTimer = new QTimer(this);
    m_HeartCount = 0;

    m_pHeartThread = new MobileCollectionHeartThread(this);
    m_pUSBThread = new MobileCollectionUSBThread(this);
    m_pTcpSocket = new QTcpSocket(this);

    connect(m_pHeartThread, &MobileCollectionHeartThread::sendHeart, this, &MobileCollection::onSendHeart);
    connect(m_pHeartThread, &MobileCollectionHeartThread::sendHeartTimeOut, this, &MobileCollection::onSendHeartTimeOut);
    connect(m_pUSBThread, &MobileCollectionUSBThread::sendCheckUSBState, this, &MobileCollection::onSendCheckUSBState);

    connect(m_pTcpSocket, &QTcpSocket::connected, this, &MobileCollection::onConnected);
    connect(m_pTcpSocket, &QTcpSocket::disconnected, this, &MobileCollection::onDisconnected);
    connect(m_pTcpSocket, &QTcpSocket::readyRead,this,&MobileCollection::onReadyRead);
    connect(m_pTcpSocket, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(onError(QAbstractSocket::SocketError)));

    connect(m_delayedTimer, &QTimer::timeout, this, &MobileCollection::onDelayedTimeout);
}
MobileCollection::~MobileCollection()
{
    m_pTcpSocket->close();
    qDebug()<<"~MobileCollection()";
}
//延时1s发送数据
void MobileCollection::onDelayedTimeout()
{
    //停止延时定时器
    m_delayedTimer->stop();

    //启动心跳线程
    SetHeartSwitch(true);
    m_pHeartThread->StartRun();

    //检测手机连接状态
    SetStartCollectionSuccessState(false);
    SetCheckUSBStateSwitch(true);
    SetSendCheckPhoneUSBState(true);
    m_pUSBThread->StartRun();
}
//与服务建立链路成功
void MobileCollection::onConnected()
{
#ifdef MOBILECOLLECTION_QDEBUG
    qDebug()<<"Connect Service Success.";
#endif
    emit mobileCollectionInfo(MSG_CONNECT_SERVICE, START_SUCCESS, "建立通信链路成功"); //发送信号
    m_delayedTimer->start(1000);//设置延时发送数据时间
}
//连接已断开的响应
void MobileCollection::onDisconnected()
{
#ifdef MOBILECOLLECTION_QDEBUG
    qDebug()<<"Service Disconnected.";
#endif
    SetCheckUSBStateSwitch(false);
    SetHeartSwitch(false);
}

//收到数据的响应
void MobileCollection::onReadyRead()
{
    m_HeartCount = 0;
    QByteArray recvData = m_pTcpSocket->readAll();
    const char* strRecv = recvData.data();
#ifdef MOBILECOLLECTION_QDEBUG
    qDebug()<<"recv data: "<<strRecv;
#endif
    DealData(strRecv, strlen(strRecv));//处理数据
}

//socket错误的响应
void MobileCollection::onError(QAbstractSocket::SocketError errType)
{
    emit mobileCollectionInfo(MSG_CONNECT_SERVICE, START_FAIL, m_pTcpSocket->errorString()); //发送信号
}

//响应检测USB状态
void MobileCollection::onSendCheckUSBState()
{
    if(GetSendCheckPhoneUSBState())//USB连接
        ConnectUSB();
    else
        DisconnectUSB();
}

//响应心跳
void MobileCollection::onSendHeart()
{
    QString tempStrHeart(STR_C_S_HEARTBEAT);
    QByteArray tempBaHeart = tempStrHeart.toUtf8();
    char* strHeartBeat = tempBaHeart.data();
    m_pTcpSocket->write(strHeartBeat);
    m_HeartCount++;
}

//响应心跳超时
void MobileCollection::onSendHeartTimeOut()
{
    //断开连接 重新连接
#ifdef MOBILECOLLECTION_QDEBUG
    qDebug()<<"与服务器之间的心跳超时！";
#endif
    m_HeartCount = 0;
    m_pTcpSocket->close();
    m_pHeartThread->quit();
#ifdef MOBILECOLLECTION_QDEBUG
    qDebug()<<"尝试重新连接服务...";
#endif
    emit mobileCollectionInfo(MSG_CONNECT_SERVICE, START_FAIL, "建立通信链路失败，尝试重新连接服务..."); //发送信号
    connectService();//连接服务
}

//连接服务
void MobileCollection::connectService()
{
    m_pTcpSocket->abort();
    m_pTcpSocket->connectToHost(IP, PORT);
    //    if (m_pTcpSocket->waitForConnected())
    //    {
    //        qDebug("Connected!");
    //    }
}

//开始采集
bool MobileCollection::startCollection(QJsonObject bodyObject)
{
    SetStartCollectionJsonBody(bodyObject);
    QJsonObject json;
    json.insert("body", QJsonValue(bodyObject));
    QJsonDocument document;
    document.setObject(json);
    QByteArray baTemp = document.toJson(QJsonDocument::Compact);
    char* strTemp = baTemp.data();
    QString strJson(strTemp);
    strJson = strJson.mid(1);//去掉 '{'
    QByteArray baJson = strJson.toUtf8();
    char *strBody = baJson.data();

    char szBeginToCheckPhoneMsg[2048];
    char szBeginToCheckPhoneJsonbody[1024];
    int content_length = 0;
    int res = 0;
    memset(szBeginToCheckPhoneMsg, 0, sizeof(szBeginToCheckPhoneMsg));
    memset(szBeginToCheckPhoneJsonbody, 0, sizeof(szBeginToCheckPhoneJsonbody));

    _snprintf_s(szBeginToCheckPhoneJsonbody, sizeof(szBeginToCheckPhoneJsonbody),
                "%s"
                "\r\n%s\r\n"
                , STR_COLLECTIONSTART_JONBODY_HEADER, strBody);
    content_length = strlen(szBeginToCheckPhoneJsonbody);
    _snprintf_s(szBeginToCheckPhoneMsg, sizeof(szBeginToCheckPhoneMsg),
                "%s"
                "%s"
                "%s%d\r\n"
                "\r\n"
                "%s",
                STR_COMMAND_REQUESTLINE, STR_REQUEST_NOCODETYPE_HEADER, STR_REQUEST_BODYLENGTH, content_length, szBeginToCheckPhoneJsonbody);
    std::string strBeginToCheckPhoneMsg(szBeginToCheckPhoneMsg);
    strBeginToCheckPhoneMsg.substr(0, strlen(szBeginToCheckPhoneMsg));
#ifdef MOBILECOLLECTION_QDEBUG
    qDebug()<<"发送开始采集手机【length="<<strlen(szBeginToCheckPhoneMsg)<<"】:\r\n"<<strBeginToCheckPhoneMsg.c_str();
#endif
    res = SendData(szBeginToCheckPhoneMsg, strlen(szBeginToCheckPhoneMsg));
    if (res == strlen(szBeginToCheckPhoneMsg))
        return SUCCESS;
    else
        return FAIL;
}

//发送停止采集手机消息到服务端
int MobileCollection::StopCollection(QString strDevID)
{
    char szStopToCheckPhoneMsg[1024];
    char szStopToCheckPhoneJsonbody[512];
    int content_length = 0;
    int res = 0;
    memset(szStopToCheckPhoneMsg, 0, sizeof(szStopToCheckPhoneMsg));
    memset(szStopToCheckPhoneJsonbody, 0, sizeof(szStopToCheckPhoneJsonbody));

    QString strBody("\"body\":\r\n{\r\n\"PK_DEVICE_ID\":\"");
    strBody += strDevID;
    strBody += "\"\r\n}\r\n}";

    QByteArray baTemp = strBody.toUtf8();
    char* strBodyJson = baTemp.data();
    _snprintf_s(szStopToCheckPhoneJsonbody, sizeof(szStopToCheckPhoneJsonbody),
                "%s%s"
                , STR_COLLECTIONSTOP_JONBODY_HEADER, strBodyJson);
    content_length = strlen(szStopToCheckPhoneJsonbody);
    _snprintf_s(szStopToCheckPhoneMsg, sizeof(szStopToCheckPhoneMsg),
                "%s"
                "%s"
                "%s%d\r\n"
                "\r\n"
                "%s",
                STR_COMMAND_REQUESTLINE, STR_REQUEST_NOCODETYPE_HEADER, STR_REQUEST_BODYLENGTH, content_length, szStopToCheckPhoneJsonbody);

    std::string strStopToCheckPhoneMsg(szStopToCheckPhoneMsg);
    strStopToCheckPhoneMsg.substr(0, strlen(szStopToCheckPhoneMsg));
#ifdef MOBILECOLLECTION_QDEBUG
    qDebug()<<"发送停止采集手机【length="<<strlen(szStopToCheckPhoneMsg)<<"】:\r\n"<<strStopToCheckPhoneMsg.c_str();
#endif
    res = SendData(szStopToCheckPhoneMsg, strlen(szStopToCheckPhoneMsg));
    if (res == strlen(szStopToCheckPhoneMsg))
    {
        return SUCCESS;
    }
    else
    {
        return FAIL;
    }
}

//发送连接手机数据线消息到服务端
bool MobileCollection::ConnectUSB()
{
    char szPushPhoneUsbDataLineMsg[1024];
    char szPushPhoneUsbDataLineJsonbody[512];
    int content_length = 0;
    int res = 0;
    memset(szPushPhoneUsbDataLineMsg, 0, sizeof(szPushPhoneUsbDataLineMsg));
    memset(szPushPhoneUsbDataLineJsonbody, 0, sizeof(szPushPhoneUsbDataLineJsonbody));

    _snprintf_s(szPushPhoneUsbDataLineJsonbody, sizeof(szPushPhoneUsbDataLineJsonbody),
                "%s%s"
                , STR_USBSTATE_JONBODY_HEADER, STR_USBSTATE_JONBODY_CONNECTION_BODY);
    content_length = STR_USBSTATE_JONBODY_HEADER_LENGTH + STR_USBSTATE_JONBODY_CONNECTION_BODY_LENGTH;
    _snprintf_s(szPushPhoneUsbDataLineMsg, sizeof(szPushPhoneUsbDataLineMsg),
                "%s"
                "%s"
                "%s%d\r\n"
                "\r\n"
                "%s",
                STR_COMMAND_REQUESTLINE, STR_REQUEST_NOCODETYPE_HEADER, STR_REQUEST_BODYLENGTH, content_length, szPushPhoneUsbDataLineJsonbody);

    std::string strPushPhoneUsbDataLineMsg(szPushPhoneUsbDataLineMsg);
    strPushPhoneUsbDataLineMsg.substr(0, strlen(szPushPhoneUsbDataLineMsg));
#ifdef MOBILECOLLECTION_QDEBUG
    qDebug()<<"发送连接USB请求：\r\nlength"<<strlen(szPushPhoneUsbDataLineMsg)<<"\r\nmsg:"<<strPushPhoneUsbDataLineMsg.data()<<"\r\n";
#endif
    SetSendCheckPhoneUSBState(true);//记录当前是检测USB连接
    res = SendData(szPushPhoneUsbDataLineMsg, strlen(szPushPhoneUsbDataLineMsg));
    if (res == strlen(szPushPhoneUsbDataLineMsg))
    {
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"发送连接USB请求成功，发送数据长度:"<<res;
#endif
        return SUCCESS;
    }
    return FAIL;
}

//发送断开手机数据线消息到服务端
bool MobileCollection::DisconnectUSB()
{
    char szPullPhoneUsbDataLineMsg[1024];
    char szPullPhoneUsbDataLineJsonbody[512];
    int content_length = 0;
    int res = 0;
    memset(szPullPhoneUsbDataLineMsg, 0, sizeof(szPullPhoneUsbDataLineMsg));
    memset(szPullPhoneUsbDataLineJsonbody, 0, sizeof(szPullPhoneUsbDataLineJsonbody));

    _snprintf_s(szPullPhoneUsbDataLineJsonbody, sizeof(szPullPhoneUsbDataLineJsonbody),
                "%s%s"
                , STR_USBSTATE_JONBODY_HEADER, STR_USBSTATE_JONBODY_UNCONNECTION_BODY);
    content_length = STR_USBSTATE_JONBODY_HEADER_LENGTH + STR_USBSTATE_JONBODY_UNCONNECTION_BODY_LENGTH;
    _snprintf_s(szPullPhoneUsbDataLineMsg, sizeof(szPullPhoneUsbDataLineMsg),
                "%s"
                "%s"
                "%s%d\r\n"
                "\r\n"
                "%s",
                STR_COMMAND_REQUESTLINE, STR_REQUEST_NOCODETYPE_HEADER, STR_REQUEST_BODYLENGTH, content_length, szPullPhoneUsbDataLineJsonbody);

    std::string strPullPhoneUsbDataLineMsg(szPullPhoneUsbDataLineMsg);
    strPullPhoneUsbDataLineMsg.substr(0, strlen(szPullPhoneUsbDataLineMsg));
#ifdef MOBILECOLLECTION_QDEBUG
    qDebug()<<"发送断开USB请求：\r\nlength"<<strlen(szPullPhoneUsbDataLineMsg)<<"\r\nmsg:"<<strPullPhoneUsbDataLineMsg.data()<<"\r\n";
#endif
    SetSendCheckPhoneUSBState(false);//记录当前是检测USB断开

    res = SendData(szPullPhoneUsbDataLineMsg, strlen(szPullPhoneUsbDataLineMsg));
    if (res == strlen(szPullPhoneUsbDataLineMsg))
    {
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"发送断开USB请求成功，发送数据长度:"<<res;
#endif
        return SUCCESS;
    }
    return FAIL;
}

//处理接收的数据包
void MobileCollection::DealData(const char *pszData, int nDataLen)
{
    char szDataBuffer[RECVBUFLEN];
    int nRequestLineLen = 0;
    int nRequestHeaderLineContentTypeLen = 0;
    int nRequestHeaderLineContentLengthLen = 0;
    int nRequestBodyLen = 0;
    int nRequestHeaderLineContentTypePos = 0;
    int nRequestHeaderLineContentLengthPos = 0;
    int nRequestBodyPos = 0;
    char szMessage[256];
    char szBodyMessage[1024];
    std::string strMessage;

    bool isCodeUTF8 = false;

    char *pHead = NULL;
    char *pEnd = NULL;

    if(nDataLen >= RECVBUFLEN)
    {
        //nDataLen = RECVBUFLEN;
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"接收到的数据长度过长, 长度："<<nDataLen;
#endif
    }
    memset(szDataBuffer, 0, sizeof(szDataBuffer));
    memcpy(szDataBuffer, pszData, nDataLen);
    szDataBuffer[nDataLen] = 0;
    pHead = szDataBuffer;
    pEnd = szDataBuffer + nDataLen;

    int indexFrame = 0;
    while (pHead != pEnd)
    {
        indexFrame++;
        //是否为心跳帧
        if(JudgeHeartBeatAckFrame(pHead))
        {
            m_HeartCount = 0;
            pHead = pHead + STR_S_C_HEARTBEAT_LENGTH;
#ifdef MOBILECOLLECTION_QDEBUG
            qDebug()<<"已经成功处理第【"<<indexFrame<<"】帧【心跳应答】数据帧";
#endif
            continue;
        }
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"**************************************开始处理第【"<<indexFrame<<"】数据帧****************************************************************************";
#endif
        nRequestLineLen = GetRequestLine(pHead);
        nRequestHeaderLineContentTypeLen = GetRequestHeadersContentType(pHead, nRequestHeaderLineContentTypePos);
        nRequestHeaderLineContentLengthLen = GetRequestHeadersContentLength(pHead, nRequestHeaderLineContentLengthPos);
        nRequestBodyLen = GetRequestBody(pHead, nRequestBodyPos);

        if(nRequestLineLen == 0 || nRequestHeaderLineContentTypeLen == 0 || nRequestHeaderLineContentLengthLen == 0 || nRequestBodyLen == 0)
        {
#ifdef MOBILECOLLECTION_QDEBUG
            qDebug()<<"Server Request or Response HTTP is exception"<<nRequestLineLen<<","<<nRequestHeaderLineContentTypeLen<<","<<nRequestHeaderLineContentLengthLen<<","<<nRequestBodyLen;
#endif
            return;
        }
        else
        {
#ifdef MOBILECOLLECTION_QDEBUG
            qDebug()<<"第【"<<indexFrame<<"】数据帧：RequestLineLen="<<nRequestLineLen<<",RequestHeaderLineContentTypeLen="<<nRequestHeaderLineContentTypeLen<<",RequestHeaderLineContentLengthLen="<<nRequestHeaderLineContentLengthLen<<",nRequestBodyLen="<<nRequestBodyLen;
            qDebug()<<"第【"<<indexFrame<<"】数据帧：RequestHeaderLineContentTypePos="<<nRequestHeaderLineContentTypePos<<",RequestHeaderLineContentLengthPos="<<nRequestHeaderLineContentLengthPos<<",nRequestBodyPos="<<nRequestBodyPos;
#endif
        }

        if(nRequestLineLen != 0)
        {
            memset(szMessage, 0, 256);
            strMessage.clear();
            memcpy(szMessage, pHead, nRequestLineLen);
            strMessage = szMessage;
            strMessage.substr(0, nRequestLineLen);
#ifdef MOBILECOLLECTION_QDEBUG
            qDebug()<<"第【"<<indexFrame<<"】数据帧：server RequestLine:\r\n"<<strMessage.data();
#endif
            if(nRequestLineLen == COMMAND_REQUESTLINE_LENGTH)
            {
#ifdef MOBILECOLLECTION_QDEBUG
                qDebug()<<"第【"<<indexFrame<<"】数据帧：Request Type message from server.";
#endif
            }
            else if (nRequestLineLen == ACKCOMMAND_REQUESTLINE_LENGTH)
            {
#ifdef MOBILECOLLECTION_QDEBUG
                qDebug()<<"第【"<<indexFrame<<"】数据帧： ACK Type message from server.";
#endif
            }
            else
            {
#ifdef MOBILECOLLECTION_QDEBUG
                qDebug()<<"第【"<<indexFrame<<"】数据帧：Unknown Type message from server.Request Line Length:"<<nRequestLineLen;
#endif
                return;
            }
        }
        if(nRequestHeaderLineContentTypeLen != 0)
        {
            memset(szMessage, 0, 256);
            strMessage.clear();
            memcpy(szMessage, pHead + nRequestHeaderLineContentTypePos, nRequestHeaderLineContentTypeLen);
            strMessage = szMessage;
            strMessage.substr(0, nRequestHeaderLineContentTypeLen);
#ifdef MOBILECOLLECTION_QDEBUG
            qDebug()<<"第【"<<indexFrame<<"】数据帧：server RequestContent-Type:"<<strMessage.data();
#endif
            if(nRequestHeaderLineContentTypeLen == REQUEST_NOCODETYPE_HEADER_LENGTH)//31
            {
#ifdef MOBILECOLLECTION_QDEBUG
                qDebug()<<"第【"<<indexFrame<<"】数据帧：RequestHeader ContentType from server none include UTF-8 code.";
#endif
            }
            else if(nRequestHeaderLineContentTypeLen == REQUEST_CONTENTTYPE_HEADER_LENGTH)//46
            {
#ifdef MOBILECOLLECTION_QDEBUG
                qDebug()<<"第【"<<indexFrame<<"】数据帧：RequestHeader ContentType from server include code UTF-8.";
#endif
                isCodeUTF8 = true;
            }
            else
            {
#ifdef MOBILECOLLECTION_QDEBUG
                qDebug()<<"第【"<<indexFrame<<"】数据帧：Unknown RequestHeader ContentType from server, Request Line Length: "<<nRequestHeaderLineContentTypeLen<<".isnot "<<REQUEST_NOCODETYPE_HEADER_LENGTH<<"or "<<REQUEST_CONTENTTYPE_HEADER_LENGTH;
#endif
                return;
            }
        }

        if(nRequestHeaderLineContentLengthLen != 0)
        {
            memset(szMessage, 0, 256);
            strMessage.clear();
            memcpy(szMessage, pHead + nRequestHeaderLineContentLengthPos, nRequestHeaderLineContentLengthLen);
            strMessage = szMessage;
            strMessage.substr(0, nRequestHeaderLineContentLengthLen);
#ifdef MOBILECOLLECTION_QDEBUG
            qDebug()<<"第【"<<indexFrame<<"】数据帧：server RequestContent-Length: "<<strMessage.data();
#endif
        }
        if(nRequestBodyLen != 0)//包体处理
        {
            memset(szBodyMessage, 0, 1024);
            strMessage.clear();
            memcpy(szBodyMessage, pHead + nRequestBodyPos, nRequestBodyLen);

            strMessage = szBodyMessage;
            strMessage.substr(0, nRequestBodyLen);
#ifdef MOBILECOLLECTION_QDEBUG
            qDebug()<<"第【"<<indexFrame<<"】数据帧：server RequestBody: \r\n"<<strMessage.data();
#endif
            DispatchMessageCmd(strMessage.data(), nRequestBodyLen);
        }
        pHead = pHead + nRequestHeaderLineContentLengthPos + nRequestHeaderLineContentLengthLen + nRequestBodyLen + 2;//body 与 header之间的\r\n

        int currentDealAckByte = nRequestHeaderLineContentLengthPos + nRequestHeaderLineContentLengthLen + nRequestBodyLen + 2;
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"到现在为止，已经处理这包帧数据的【"<<currentDealAckByte<<"】字节了，该数据帧为第【"<<indexFrame<<"】帧.";
        qDebug()<<"**************************************结束处理第【"<<indexFrame<<"】数据帧****************************************************************************";
#endif
        if(pHead == pEnd)
        {
#ifdef MOBILECOLLECTION_QDEBUG
            qDebug()<<"**************************************已经处理完这包数据帧了【Length="<<nDataLen<<"】.****************************************************************************";
#endif
            break;
        }
    }//end while (pHead != pEnd)
}

//分派消息指令
void MobileCollection::DispatchMessageCmd(const char *pszData, int nLen)
{
    if (pszData == NULL)
    {
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"DispatchMessageCmd():CheckerPhoneClient receive command frame is NULL";
#endif
        return;
    }
    int nVersion = 0;
    int nCommandFlag = 0;

    QJsonParseError json_error;
    const QByteArray baData(pszData);
    QJsonDocument doucment = QJsonDocument::fromJson(baData, &json_error);
    if(json_error.error == QJsonParseError::NoError)
    {
        if(doucment.isObject())
        {
            QJsonObject obj = doucment.object();
            QJsonValue value = obj.value(QString("header"));
            QJsonObject item = value.toObject();
            if(item.contains("version"))
            {
                value = item.take("version");
                nVersion = value.toInt();
            }
            if(item.contains("command"))
            {
                value = item.take("command");
                nCommandFlag = value.toInt();
            }
#ifdef MOBILECOLLECTION_QDEBUG
            qDebug()<<"DispatchMessageCmd():CheckerPhoneClient analysis command frame header【version:"<<nVersion<<"】【commandFlag:"<<nCommandFlag<<"】";
#endif
        }
        else
        {
#ifdef MOBILECOLLECTION_QDEBUG
            qDebug()<<"DispatchMessageCmd():CheckerPhoneClient receive JSON header frame is exception.";
#endif
            return;
        }
    }

    switch(nCommandFlag)
    {
    /*开始采集*/
    case STARTCOLLECTION_MSG:
    {
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"收到开始采集的应答";
#endif
        DispatchL_F_STARTCOLLECTION_ACK(pszData, nLen, nCommandFlag);
    }
        break;

        /*停止采集*/
    case STOPCOLLECTION_MSG:
    {
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"收到停止采集的应答";
#endif
        DispatchL_F_STOPCOLLECTION_MSG(pszData, nLen, nCommandFlag);
    }
        break;

        /*采集完成*/
    case FINISHCOLLECTION_MSG:
    {
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"收到采集完成的应答";
#endif
        DispatchL_F_COLLECTIONFINISH_MSG(pszData, nLen, nCommandFlag);
    }
        break;

        /*检测手机数据线的应答*/
    case USBSTATE_MSG:
    {
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"收到检测手机数据线的应答";
#endif
        DispatchL_F_DEVICEID_ACK(pszData, nLen, nCommandFlag);
    }
        break;
        /*检测手机指令无法解析*/
    case UNKNOW_MSG:
    {
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"收到了无法解析的指令";
#endif
    }
        break;
    default:
    {
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"PhoneChecker_CLIENT receive unknown message type：", nCommandFlag;
#endif
    }
        break;
    }
}

//判断是否为心跳回复帧
bool MobileCollection::JudgeHeartBeatAckFrame(const char *pszData)
{
    bool bRespType = false;
    if (memcmp(pszData, STR_S_C_HEARTBEAT, STR_S_C_HEARTBEAT_LENGTH) == 0)
    {
        bRespType = true;
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"收到心跳回复.";
#endif
    }
    return bRespType;
}

//获取请求head的长度
int MobileCollection::GetRequestLine(const char *pszData)
{
    bool bPostType = false;
    bool bRespType = false;
    int nRequestLineLen = 0;

    if(memcmp(pszData, "POST ", 5) == 0)//判断psaData的前5个字节是否是"POST "
    {
        bPostType = true;
    }
    else if(memcmp(pszData, "HTTP/", 5) == 0) //判断psaData的前5个字节是否是"HTTP/"
    {
        bRespType = true;
    }
    else
    {
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"错误的请求头："<<pszData;
#endif
    }

    if (bPostType)//POST
    {
        char* pRequestLineEnd = strstr((char*)pszData, "\r\n");
        if (!pRequestLineEnd)
        {
            return 0;
        }
        nRequestLineLen = pRequestLineEnd - pszData + strlen("\r\n");
        return nRequestLineLen;
    }
    else if (bRespType)//HTTP
    {
        char* pRequestLineEnd = strstr((char*)pszData, "\r\n");
        if (!pRequestLineEnd)
        {
            return 0;
        }
        nRequestLineLen = pRequestLineEnd - pszData + strlen("\r\n");
        return nRequestLineLen;
    }
    return nRequestLineLen;
}

//获取包含"Content-Type:"串的请求head长度
int MobileCollection::GetRequestHeadersContentType(const char *pszData, int& nContentTypePos)
{
    bool bPostType = false;
    bool bRespType = false;
    int nContentTypeLen = 0;
    if(memcmp(pszData, "POST ", 5) == 0)
    {
        bPostType = true;
    }
    else if(memcmp(pszData, "HTTP/", 5) == 0)
    {
        bRespType = true;
    }
    nContentTypePos = 0;
    if(bPostType || bRespType)
    {
        char* pcontentTypeLen = strstr((char*)pszData, "Content-Type:");
        nContentTypePos = pcontentTypeLen - pszData;
        if (pcontentTypeLen)
        {
            char* pcontentTypeEnd = strstr(pcontentTypeLen, "\r\n");
            if (pcontentTypeEnd)
            {
                nContentTypeLen = pcontentTypeEnd - pcontentTypeLen + strlen("\r\n");
                return nContentTypeLen;
            }
        }
    }
    else
    {
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"接收到未知的Content-Type【NOT HTTP AND NOT POST】："<<pszData;
#endif
    }
    return nContentTypeLen;
}

//获取包含"Content-Length:"串的请求head长度
int MobileCollection::GetRequestHeadersContentLength(const char *pszData, int& nContentLengthPos)
{
    bool bPostType = false;
    bool bRespType = false;
    int nContentLengthLen = 0;
    if (memcmp(pszData, "POST ", 5) == 0)
    {
        bPostType = true;
    }
    else if (memcmp(pszData, "HTTP/", 5) == 0)
    {
        bRespType = true;
    }
    nContentLengthPos = 0;
    if (bPostType || bRespType)
    {
        char* pcontentLengthLen = strstr((char*)pszData, "Content-Length:");
        nContentLengthPos = pcontentLengthLen - pszData;
        if (pcontentLengthLen)
        {
            char* pcontentLengthEnd = strstr(pcontentLengthLen, "\r\n");
            if (pcontentLengthEnd)
            {
                nContentLengthLen = pcontentLengthEnd - pcontentLengthLen + strlen("\r\n");
                return nContentLengthLen;
            }
        }
    }
    else
    {
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"接收到未知的Content-Length【NOT HTTP AND NOT POST】："<<pszData;
#endif
    }
    return nContentLengthLen;
}

//获取请求body长度
int MobileCollection::GetRequestBody(const char *pszData, int& nContentPos)
{
    bool bPostType = false;
    bool bRespType = false;
    int nContentLen;
    if (memcmp(pszData, "POST ", 5) == 0)
    {
        bPostType = true;
    }
    else if (memcmp(pszData, "HTTP/", 5) == 0)
    {
        bRespType = true;
    }
    //根据http头结束符判断
    char* pHeadEnd = strstr((char*)pszData, "\r\n\r\n");
    if (!pHeadEnd)
    {
        return 0;
    }
    nContentPos = 0;
    nContentLen = 0;
    //int nHeadLen = pHeadEnd + strlen("\r\n\r\n") - pszData;
    if (bPostType || bRespType)
    {
        char* pContentLen = strstr((char*)pszData, "Content-Length:");
        if (pContentLen)
        {
            pContentLen += strlen("Content-Length:");
            char* pContentLenEnd = strstr(pContentLen, "\r\n");
            if (pContentLenEnd)
            {
                char buf[256];
                memset(buf, 0, sizeof(buf));
                memcpy(buf, pContentLen, pContentLenEnd - pContentLen);
                nContentLen = atoi(buf);

                //内容的相对位置
                nContentPos = pHeadEnd - pszData + strlen("\r\n\r\n");
                return nContentLen;
            }
        }
    }
    else
    {
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"接收到未知的Request Body【NOT HTTP AND NOT POST】："<<pszData;
#endif
    }
    return nContentLen;
}

//分派检测手机连接状态消息
void MobileCollection::DispatchL_F_DEVICEID_ACK(const char *pszData, int nLen, int nCmdType)
{
    if(GetStartCollectionSuccessState())
        return;
    int nCode = 0;
    QString strDesc;
    QString strUUID;
    QJsonParseError json_error;
    const QByteArray baData(pszData);
    QJsonDocument doucment = QJsonDocument::fromJson(baData, &json_error);
    if(json_error.error == QJsonParseError::NoError)
    {
        if(doucment.isObject())
        {
            QJsonObject obj = doucment.object();
            QJsonValue value = obj.value(QString("response"));
            QJsonObject item = value.toObject();
            //指令
            if(item.contains("code"))
            {
                value = item.take("code");
                nCode = value.toInt();
            }
            //描述
            if(item.contains("desc"))
            {
                value = item.take("desc");
                strDesc = value.toString();
            }
            //包体
            value = obj.value(QString("body"));
            item = value.toObject();
            value = item.take("devices");
            if(value.isArray())
            {
                QJsonArray array = value.toArray();
                for(int i=0; i<array.size(); i++)
                {
                    QJsonObject obj = array.at(i).toObject();
                    if(obj.contains("uuid"))
                    {
                        strUUID = obj.take("uuid").toString();
                    }
                }
            }
#ifdef MOBILECOLLECTION_QDEBUG
            qDebug()<<"DispatchL_F_DEVICEID_ACK():CheckerPhoneClient analysis command frame header【nCode:"<<nCode<<"】【desc:"<<strDesc<<"】【uuid:"<<strUUID<<"】";
#endif
            bool bcheckphonestate = GetSendCheckPhoneUSBState();
            if (bcheckphonestate)//检测手机连接状态：连接
            {
                if (nCode == 0)//连接成功
                {
                    if (m_pUSBThread->isRunning())
                    {
                        SetCheckUSBStateSwitch(false);
                        m_pUSBThread->quit();//关闭检测USB状态线程
                    }
                    emit mobileCollectionInfo(MSG_ACK_PUSH_USB, PUSH_SUCCESS, strUUID); //发送信号
                    if (strUUID == "")
                    {
#ifdef MOBILECOLLECTION_QDEBUG
                        qDebug()<<"连接USB成功，但有异常UUID为空，desc:"<<strDesc;
#endif
                    }
                    else
                    {
#ifdef MOBILECOLLECTION_QDEBUG
                        qDebug()<<"连接USB成功，UUID："<<strUUID;
#endif
                    }
                }
                else if (nCode == 1)//设备错误
                {
                    emit mobileCollectionInfo(MSG_ACK_PUSH_USB, PUSH_FAIL_DEVICE_ERROR, strDesc); //发送信号
#ifdef MOBILECOLLECTION_QDEBUG
                    qDebug()<<"连接USB失败：【设备错误】No phone is pushed.Message: "<<strDesc;
                    qDebug()<<"连接USB失败：还没有手机连接的应答指令，启动线程继续检测...";
#endif
                    SetCheckUSBStateSwitch(true);
                    m_pUSBThread->StartRun();
                }
                else if (nCode == 3)//无法解析命令
                {
                    emit mobileCollectionInfo(MSG_ACK_PUSH_USB, PUSH_FAIL_UNDISCODE, strDesc); //发送信号
#ifdef MOBILECOLLECTION_QDEBUG
                    qDebug()<<"连接USB失败:【无法解析命令】还没有接收到手机连接的应答:"<<strDesc;
                    qDebug()<<"连接USB失败：还没有手机连接的应答指令，启动线程继续检测...";
#endif
                    SetCheckUSBStateSwitch(true);
                    m_pUSBThread->StartRun();
                }
                else if (nCode == 4)//手机长时间未识别，请用户再次插拔手机和重开手机相关权限
                {
                    emit mobileCollectionInfo(MSG_ACK_PUSH_USB, PUSH_FAIL_LONGTIME_UNRECOGNIZED, strDesc); //发送信号
#ifdef MOBILECOLLECTION_QDEBUG
                    qDebug()<<"连接USB失败：【手机长时间未识别，请用户再次插拔手机和重开手机相关权限】"<<strDesc;
                    qDebug()<<"连接USB失败：还没有手机连接的应答指令，启动线程继续检测...";
#endif
                    SetCheckUSBStateSwitch(true);
                    m_pUSBThread->StartRun();
                }
            }
            else //检测手机连接状态：断开
            {
                if(nCode == 1 || nCode == 3 || nCode == 4)//已经没有手机连接的应答
                {
                    SetCheckUSBStateSwitch(false);
                    m_pUSBThread->quit();//关闭检测USB状态线程
                    emit mobileCollectionInfo(MSG_ACK_PULL_USB, PULL_SUCCESS, "断开USB成功，采集完美结束"); //发送信号
#ifdef MOBILECOLLECTION_QDEBUG
                    qDebug()<<"断开USB成功: "<<strDesc<<",断开与服务器之间的通信链路.";
#endif
                    m_pHeartThread->quit();
                    m_pTcpSocket->close();
                }
                else if(nCode == 0)//还有手机应答
                {
                    emit mobileCollectionInfo(MSG_ACK_PULL_USB, PULL_FAIL, strDesc); //发送信号
#ifdef MOBILECOLLECTION_QDEBUG
                    qDebug()<<"断开USB失败："<<strDesc;
                    qDebug()<<"断开USB失败：仍然有手机处于连接状态，启动线程继续检测...";
#endif
                    SetCheckUSBStateSwitch(true);
                    m_pUSBThread->StartRun();
                }
            }
        }
        else
        {
#ifdef MOBILECOLLECTION_QDEBUG
            qDebug()<<"解析检测手机连接状态json体失败,DispatchL_F_DEVICEID_ACK";
#endif
        }
    }// end if(json_error.error == QJsonParseError::NoError)
}

//分派开始采集消息
void MobileCollection::DispatchL_F_STARTCOLLECTION_ACK(const char *pszData, int nLen, int nCmdType)
{
    int nCode = 0;
    QString strDesc, strDBPath, strUUID, strNewUUID;
    strDesc = strDBPath = strUUID = strNewUUID = "";
    QJsonParseError json_error;
    const QByteArray baData(pszData);
    QJsonDocument doucment = QJsonDocument::fromJson(baData, &json_error);
    if(json_error.error == QJsonParseError::NoError)
    {
        if(doucment.isObject())
        {
            QJsonObject obj = doucment.object();
            QJsonValue value;
            QJsonObject item;

            //response
            value = obj.value(QString("response"));
            item = value.toObject();
            //指令
            if(item.contains("code"))
            {
                value = item.take("code");
                nCode = value.toInt();
            }
            //描述
            if(item.contains("desc"))
            {
                value = item.take("desc");
                strDesc = value.toString();
            }

            //body
            value = obj.value(QString("body"));
            item = value.toObject();
            //数据库路径
            if(item.contains("db_path"))
            {
                value = item.take("db_path");
                strDBPath = value.toString();
            }
            //UUID
            if(item.contains("uuid"))
            {
                value = item.take("uuid");
                strUUID = value.toString();
            }
            //new UUID
            if(item.contains("new_uuid"))
            {
                value = item.take("new_uuid");
                strNewUUID = value.toString();
            }

            if(strNewUUID!="null")
                SetUUID(strNewUUID);//保存UUID
            else
                SetUUID(strUUID);//保存UUID

            //处理
            if (nCode == 0)
            {
                QString strBack;
                if(strNewUUID!="null")
                    strBack = strNewUUID+";"+strDBPath;
                else
                    strBack = strUUID+";"+strDBPath;

                emit mobileCollectionInfo(MSG_ACK_COLLECTION_START, MSG_START_CHECK_SUCCESS, strBack); //发送信号
#ifdef MOBILECOLLECTION_QDEBUG
                qDebug()<<"开始采集成功："<<strBack;
#endif
                SetStartCollectionSuccessState(true);
            }
            else if (nCode == 1)
            {
                emit mobileCollectionInfo(MSG_ACK_COLLECTION_START, MSG_START_CHECK_DEVICE_FAIL, strDesc); //发送信号
#ifdef MOBILECOLLECTION_QDEBUG
                qDebug()<<"开始采集失败：错误代码："<<nCode<<"错误描述："<<strDesc;
#endif
            }
            else if (nCode == 2)
            {
                emit mobileCollectionInfo(MSG_ACK_COLLECTION_START, MSG_START_CHECK_SERVICE_FAIL, strDesc); //发送信号
#ifdef MOBILECOLLECTION_QDEBUG
                qDebug()<<"开始采集失败：错误代码："<<nCode<<"错误描述："<<strDesc;
#endif
            }
            else if (nCode == 3)
            {
                emit mobileCollectionInfo(MSG_ACK_COLLECTION_START, MSG_START_CHECK_FAIL_UNDISCODE, strDesc); //发送信号
#ifdef MOBILECOLLECTION_QDEBUG
                qDebug()<<"开始采集失败，重发此命令：错误代码："<<nCode<<"错误描述："<<strDesc;
#endif
                startCollection(GetStartCollectionJsonBody());
            }
        }
    }
    else
    {
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"解析开始采集json体失败,DispatchL_F_STARTCOLLECTION_ACK";
#endif
    }
}

//分派手机采集完成消息
void MobileCollection::DispatchL_F_COLLECTIONFINISH_MSG(const char *pszData, int nLen, int nCmdType)
{
    int nCode = 0;
    QString strDesc = "";
    QJsonParseError json_error;
    const QByteArray baData(pszData);
    QJsonDocument doucment = QJsonDocument::fromJson(baData, &json_error);
    if(json_error.error == QJsonParseError::NoError)
    {
        if(doucment.isObject())
        {
            QJsonObject obj = doucment.object();
            QJsonValue value = obj.value(QString("response"));
            QJsonObject item = value.toObject();
            //指令
            if(item.contains("code"))
            {
                value = item.take("code");
                nCode = value.toInt();
            }
            //描述
            if(item.contains("desc"))
            {
                value = item.take("desc");
                strDesc = value.toString();
            }

            if (nCode == 0)//成功
            {
                emit mobileCollectionInfo(MSG_ACK_COLLECTION_FINISH, MSG_CHECK_FINISH_SUCCESS, strDesc); //发送信号
#ifdef MOBILECOLLECTION_QDEBUG
                qDebug()<<"采集完成【成功】:"<<strDesc<<", 发送停止采集指令...";
#endif
                StopCollection(GetUUID());//停止采集
            }
            else if(nCode == 2)//失败
            {
                emit mobileCollectionInfo(MSG_ACK_COLLECTION_FINISH, MSG_CHECK_FINISH_SUCCESS, strDesc); //发送信号
#ifdef MOBILECOLLECTION_QDEBUG
                qDebug()<<"采集完成【失败】:"<<strDesc;
#endif
            }
        }
    }
    else
    {
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"解析采集完成json包出错DispatchL_F_COLLECTIONFINISH_MSG";
#endif
    }
}

//分派停止采集手机消息
void MobileCollection::DispatchL_F_STOPCOLLECTION_MSG(const char *pszData, int nLen, int nCmdType)
{
    int nCode = 0;
    QString strDesc = "";
    QJsonParseError json_error;
    const QByteArray baData(pszData);
    QJsonDocument doucment = QJsonDocument::fromJson(baData, &json_error);
    if(json_error.error == QJsonParseError::NoError)
    {
        if(doucment.isObject())
        {
            QJsonObject obj = doucment.object();
            QJsonValue value = obj.value(QString("response"));
            QJsonObject item = value.toObject();
            //指令
            if(item.contains("code"))
            {
                value = item.take("code");
                nCode = value.toInt();
            }
            //描述
            if(item.contains("desc"))
            {
                value = item.take("desc");
                strDesc = value.toString();
            }

            //处理
            if (nCode == 0)
            {
                emit mobileCollectionInfo(MSG_ACK_COLLECTION_STOP, MSG_STOP_SUCCESS, strDesc); //发送信号
#ifdef MOBILECOLLECTION_QDEBUG
                qDebug()<<"停止采集成功："<<strDesc;
#endif
            }
            else if (nCode == 1)
            {
                emit mobileCollectionInfo(MSG_ACK_COLLECTION_STOP, MSG_STOP_DEVICE_FAIL, strDesc); //发送信号
#ifdef MOBILECOLLECTION_QDEBUG
                qDebug()<<"停止采集失败：错误代码："<<nCode<<",错误描述："<<strDesc;
#endif
            }
            else if (nCode == 2)
            {
                emit mobileCollectionInfo(MSG_ACK_COLLECTION_STOP, MSG_STOP_SERVICE_FAIL, strDesc); //发送信号
#ifdef MOBILECOLLECTION_QDEBUG
                qDebug()<<"停止采集失败：错误代码："<<nCode<<",错误描述："<<strDesc;
#endif
            }
            else if (nCode == 3)
            {
                emit mobileCollectionInfo(MSG_ACK_COLLECTION_STOP, MSG_STOP_FAIL_UNDISCODE, strDesc); //发送信号
#ifdef MOBILECOLLECTION_QDEBUG
                qDebug()<<"停止采集失败:命令无法解析,重发此命令：错误代码："<<nCode<<",错误描述："<<strDesc;
#endif
                StopCollection(GetUUID());
            }
#ifdef MOBILECOLLECTION_QDEBUG
            qDebug()<<"收到停止采集的回复，发送断开USB指令...";
#endif
            SetStartCollectionSuccessState(false);
            SetSendCheckPhoneUSBState(false);//记录当前是检测USB断开
            SetCheckUSBStateSwitch(true);
            m_pUSBThread->StartRun();
        }
    }
    else
    {
#ifdef MOBILECOLLECTION_QDEBUG
        qDebug()<<"解析停止采集json包出错DispatchL_F_STOPCOLLECTION_MSG";
#endif
    }
}

//设置是否已经发送检测手机USB状态指令
void MobileCollection::SetSendCheckPhoneUSBState(bool bSendCheckPhoneUSBState)
{
    m_bSendCheckPhoneUSBState = bSendCheckPhoneUSBState;
}
//设置检测USB状态开关
void MobileCollection::SetCheckUSBStateSwitch(bool bCheckUSBStateSwitch)
{
    m_bCheckUSBStateSwitch = bCheckUSBStateSwitch;
}
//设置检测USB状态开关
void MobileCollection::SetHeartSwitch(bool bHeartSwitch)
{
    m_bHeartSwitch = bHeartSwitch;
}
//设置开始采集所需要的数据项（json）
void MobileCollection::SetStartCollectionJsonBody(QJsonObject bodyObject)
{
    m_jsonStartCollectionJsonBody = bodyObject;
}
//设置UUID
void MobileCollection::SetUUID(QString strUUID)
{
    m_strUUID = strUUID;
}
//设置开始采集是否成功的状态
void MobileCollection::SetStartCollectionSuccessState(bool bStartCollectionSuccess)
{
    m_bStartCollectionSuccess = bStartCollectionSuccess;
}
//心跳
void MobileCollectionHeartThread::run()
{
    //有问题？？？！！！
    //    MobileCollection *parent = (MobileCollection *)m_parent;
    //    while(parent->GetHeartSwitch())
    //    {
    //        emit sendHeart();
    //        sleep(30);//间隔30s
    //        if(parent->m_HeartCount == 5 )//心跳超时
    //        {
    //            emit sendHeartTimeOut();
    //        }
    //    }
}

//USB
void MobileCollectionUSBThread::run()
{
    MobileCollection *parent = (MobileCollection *)m_parent;
    while(parent->GetCheckUSBStateSwitch())
    {
        emit sendCheckUSBState();
        sleep(1);
    }
}
//发送数据
int MobileCollection::SendData(const char *pszData, int nDataLen)
{
    return m_pTcpSocket->write(pszData);
}
//查找软件安装路径
QString MobileCollection::searchSoftwareExecutionPath(QString softwareName)
{
    QString key = "HKEY_LOCAL_MACHINE\\SOFTWARE\\";
    QSettings reg(key+softwareName, QSettings::NativeFormat);
    QString path = reg.value("Path").toString();
    return path;
}
//调用暴恐音视频检测工具
bool MobileCollection::startFearVideoCheckTool()
{
    QString videoName = "DC-8010 反恐利剑暴恐音视频图片电子书查缉工具";
    QString temp = searchSoftwareExecutionPath(videoName);
    QString videoPath = temp+"\\"+videoName+".exe";
    QProcess process;
    if(process.execute(videoPath, QStringList())==0)
    {
        return true;
    }
    else
    {
        return false;
    }
}
////手机采集等级 false 基础采集 true 全部采集
//bool MobileCollection::collectLevel()
//{
//    QSettings config(QCoreApplication::applicationDirPath()+"/app.conf", QSettings::IniFormat);
//    config.setIniCodec("GBK");
//    if(config.value("Collect/level").toInt()==1)
//    {
//        return true;
//    }
//    else
//    {
//        return false;
//    }
//}
//清理线程
void MobileCollection::destructor()
{
    SetCheckUSBStateSwitch(false);
    bool bRun = true;
    while(bRun){
        m_pUSBThread->quit();
        if(!m_pUSBThread->isRunning()){
            bRun = false;
            break;
        }
    }
    emit mobileCollectionInfo(MSG_ACK_THREAD_DESTRUCTOR, 1, "");
}

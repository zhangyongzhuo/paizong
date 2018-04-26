#pragma execution_character_set("utf-8")
#ifndef MOBILECOLLECTION_H
#define MOBILECOLLECTION_H
#include<QtNetwork/QTcpSocket>
#include <QObject>
#include <QThread>
#include <QTimer>
#include <QTime>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>

#include <QProcess>
#include <QSettings>
#include <QCoreApplication>
/***********************************************************************************************
**返回应用层的消息类型
*/
enum SEND_APP_MSG
{
    MSG_CONNECT_SERVICE=1,              //连接服务
    MSG_ACK_PUSH_USB,                   //连接USB
    MSG_ACK_PULL_USB,                   //移除USB
    MSG_ACK_COLLECTION_START,           //采集开始
    MSG_ACK_COLLECTION_STOP,            //采集停止
    MSG_ACK_COLLECTION_FINISH           //采集完成
};

/***********************************************************************************************
**返回应用层的消息指令
*/
/*MSG_CONNECT_SERVICE: 连接服务*/
#define START_SUCCESS                       0  //通信成功
#define	START_FAIL                          1  //通信失败
#define FATAL_ERROR                         2  //与服务之间的socket出现异常

/*MSG_ACK_PUSH_USB: 连接手机USB数据线 130*/
#define	PUSH_SUCCESS                        0    //成功
#define PUSH_FAIL_DEVICE_ERROR              1	 //设备错误
#define PUSH_FAIL_UNDISCODE                 3    //无法识别的指令
#define PUSH_FAIL_LONGTIME_UNRECOGNIZED     4	 //手机长时间未识别，请用户再次插拔手机和重开手机相关权限

/*MSG_ACK_PULL_USB：断开手机USB数据线 130*/
#define	PULL_SUCCESS                        0    //成功
#define PULL_FAIL                           1	 //失败


/*MSG_ACK_COLLECTION_FINISH:采集完成 126*/
#define MSG_CHECK_FINISH_SUCCESS            0   //成功
#define MSG_CHECK_FINISH_FAIL               2   //失败
/*
Desc:
Failed to start acquistion 采集服务启动失败
Exited 采集服务异常退出
*/


/*MSG_ACK_COLLECTION_START:开始采集 121*/
#define MSG_START_CHECK_SUCCESS             0    //成功
#define MSG_START_CHECK_DEVICE_FAIL         1
/*
desc:
No device connected 没有设备连接
No device mapped to this id 在映射表中没有此设备
This device is already runing 设备已经在运行
This is already a same device runing 相同的设备已经在运行
Please replay and try again 设备未拔出又开始采集
*/
#define MSG_START_CHECK_SERVICE_FAIL         2
/*
desc:
Failed to start acquistion 采集服务启动失败
Exited 采集服务异常退出
*/
#define  MSG_START_CHECK_FAIL_UNDISCODE      3 //无法识别的指令



/*MSG_ACK_COLLECTION_STOP: 停止采集 123*/
#define MSG_STOP_SUCCESS                     0	//成功
#define MSG_STOP_DEVICE_FAIL                 1
/*
desc:
No device connected 没有设备连接
No device mapped to this id 在映射表中没有此设备
This device is already runing 设备已经在运行
This is already a same device runing 相同的设备已经在运行
Please replay and try again 设备未拔出又开始采集
*/
#define MSG_STOP_SERVICE_FAIL                2
/*
desc:
Failed to start acquistion 采集服务启动失败
Exited 采集服务异常退出
*/
#define MSG_STOP_FAIL_UNDISCODE              3 //无法识别的指令


#define IP                          "127.0.0.1"
#define PORT                        7370
#define RECVBUFLEN                  8192
#define SUCCESS                     true
#define FAIL                        false

#define STR_C_S_HEARTBEAT                               "OPTIONS * HTTP/1.1\r\n\r\n"
#define STR_S_C_HEARTBEAT                               "HTTP/1.1 200 OK\r\n\r\n"
#define STR_S_C_HEARTBEAT_LENGTH                        strlen(STR_S_C_HEARTBEAT)
#define STR_COMMAND_REQUESTLINE                         "Post /pda HTTP/1.1\r\n"
#define COMMAND_REQUESTLINE_LENGTH                      strlen(STR_COMMAND_REQUESTLINE)
#define STR_ACKCOMMAND_REQUESTLINE                      "HTTP/1.1 200 OK\r\n"
#define ACKCOMMAND_REQUESTLINE_LENGTH                   strlen(STR_ACKCOMMAND_REQUESTLINE)
#define STR_REQUEST_NOCODETYPE_HEADER                   "Content-Type:application/json\r\n"
#define REQUEST_NOCODETYPE_HEADER_LENGTH                strlen(STR_REQUEST_NOCODETYPE_HEADER)
#define STR_REQUEST_CONTENTTYPE_HEADER                  "Content-Type:application/json; charset=utf-8\r\n"
#define REQUEST_CONTENTTYPE_HEADER_LENGTH               strlen(STR_REQUEST_CONTENTTYPE_HEADER)
#define STR_REQUEST_NOCODETYPE_HEADER                   "Content-Type:application/json\r\n"
#define STR_REQUEST_BODYLENGTH                          "Content-Length:"
//USB状态[连接/断开]
#define STR_USBSTATE_JONBODY_HEADER                     "{\r\n\"header\":\r\n{\r\n\"version\":1,\"command\":130\r\n},\r\n"
#define STR_USBSTATE_JONBODY_HEADER_LENGTH              strlen(STR_USBSTATE_JONBODY_HEADER)
#define STR_USBSTATE_JONBODY_CONNECTION_BODY            "\"body\":\r\n{\r\n\"state\":true\r\n}\r\n}\r\n"
#define STR_USBSTATE_JONBODY_CONNECTION_BODY_LENGTH     strlen(STR_USBSTATE_JONBODY_CONNECTION_BODY)
#define STR_USBSTATE_JONBODY_UNCONNECTION_BODY          "\"body\":\r\n{\r\n\"state\":false\r\n}\r\n}\r\n"
#define STR_USBSTATE_JONBODY_UNCONNECTION_BODY_LENGTH   strlen(STR_USBSTATE_JONBODY_UNCONNECTION_BODY)

//开始采集
#define STR_COLLECTIONSTART_JONBODY_HEADER              "{\r\n\"header\":\r\n{\r\n\"version\":1,\"command\":121\r\n},"
//停止采集
#define STR_COLLECTIONSTOP_JONBODY_HEADER               "{\r\n\"header\":\r\n{\r\n\"version\":1,\"command\":123\r\n},\r\n"

//服务端消息
#define STARTCOLLECTION_MSG         121
#define STOPCOLLECTION_MSG          123
#define FINISHCOLLECTION_MSG        126
#define USBSTATE_MSG                130
#define UNKNOW_MSG                  0



#ifndef MOBILECOLLECTIONUSBTHREAD_H
#define MOBILECOLLECTIONUSBTHREAD_H
//手机采集检测数据线状态线程类
class MobileCollectionUSBThread : public QThread
{
    Q_OBJECT
public:
    MobileCollectionUSBThread(QObject *parent = 0): QThread(parent)
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
signals:
    void sendCheckUSBState();   //检测USB连接状态

};
#endif // MOBILECOLLECTIONUSBTHREAD_H

#ifndef MOBILECOLLECTIONHEARTTHREAD_H
#define MOBILECOLLECTIONHEARTTHREAD_H
//手机采集心跳线程类
class MobileCollectionHeartThread : public QThread
{
    Q_OBJECT
public:
    MobileCollectionHeartThread(QObject *parent = 0): QThread(parent)
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
signals:
    void sendHeart();           //心跳
    void sendHeartTimeOut();    //心跳超时
};
#endif // MOBILECOLLECTIONHEARTTHREAD_H


//手机采集主类
class MobileCollection : public QObject
{
    Q_OBJECT
    Q_ENUMS(SEND_APP_MSG)
public:
    enum SEND_APP_MSG{
        MSG_CONNECT_SERVICE=1,              //连接服务
        MSG_ACK_PUSH_USB,                   //连接USB
        MSG_ACK_PULL_USB,                   //移除USB
        MSG_ACK_COLLECTION_START,           //采集开始
        MSG_ACK_COLLECTION_STOP,            //采集停止
        MSG_ACK_COLLECTION_FINISH,          //采集完成
        MSG_ACK_THREAD_DESTRUCTOR           //线程清理
    };
public:
    MobileCollection();
    ~MobileCollection();
    int SendData(const char *pszData, int nDataLen);                //发送数据
    void DisconnectService();                                       //断开与采集服务之间的连接
    bool ConnectUSB();                                              //连接USB
    bool DisconnectUSB();                                           //断开USB
    int  StopCollection(QString strDevID);                          //停止采集手机
    void DealData(const char *pszData, int nDataLen);               //处理数据
    bool GetCheckUSBStateSwitch() const;                            //获取检测USB状态开关
    bool GetHeartSwitch() const;                                    //获取心跳开关
private slots:
    void onSendCheckUSBState();                                     //响应检测USB连接状态
    void onDelayedTimeout();                                        //响应当连接服务成功后延时发送消息
    void onSendHeartTimeOut();                                      //响应心跳超时
    void onSendHeart();                                             //响应心跳
    void onConnected();                                             //响应连接服务器成功
    void onDisconnected();                                          //响应断开服务器连接成功
    void onReadyRead();                                             //响应接收数据
    void onError(QAbstractSocket::SocketError errType);             //响应显示错误

public:
    //外部接口
    Q_INVOKABLE void connectService();                              //与采集服务之间建立连接
    Q_INVOKABLE bool startCollection(QJsonObject bodyObject);       //开始采集手机

    Q_INVOKABLE bool startFearVideoCheckTool();
    //Q_INVOKABLE bool collectLevel();
    Q_INVOKABLE void destructor();//清理线程
private:
    //验证心跳包
    bool JudgeHeartBeatAckFrame(const char *pszData);
    //获取请求head的长度
    int GetRequestLine(const char *pszData);
    //获取包含"Content-Type:"串的请求head长度
    int GetRequestHeadersContentType(const char *pszData, int& nContentTypePos);
    //获取包含"Content-Length:"串的请求head长度
    int GetRequestHeadersContentLength(const char *pszData, int& nContentLengthPos);
    //获取请求body长度
    int GetRequestBody(const char *pszData, int& nContentPos);
    //分派消息指令
    void DispatchMessageCmd(const char *pszData, int nLen);
    //分派检测手机连接状态消息
    void DispatchL_F_DEVICEID_ACK(const char *pszData, int nLen, int nCmdType);
    //分派开始采集手机消息
    void DispatchL_F_STARTCOLLECTION_ACK(const char *pszData, int nLen, int nCmdType);
    //分派采集完成消息
    void DispatchL_F_COLLECTIONFINISH_MSG(const char *pszData, int nLen, int nCmdType);
    //分派停止采集消息
    void DispatchL_F_STOPCOLLECTION_MSG(const char *pszData, int nLen, int nCmdType);
    //设置发送检测手机USB连接状态（true 连接， false 断开）
    void SetSendCheckPhoneUSBState(bool bSendCheckPhoneUSBState);
    //获取发送检测手机USB连接状态（true 连接， false 断开）
    bool GetSendCheckPhoneUSBState() const;
    //设置检测USB状态开关
    void SetCheckUSBStateSwitch(bool bCheckUSBStateSwitch);
    //设置心跳开关
    void SetHeartSwitch(bool bHeartSwitch);
    //设置开始采集所需要的数据项（json）
    void SetStartCollectionJsonBody(QJsonObject bodyObject);
    //获取开始采集所需要的数据项（json）
    QJsonObject GetStartCollectionJsonBody() const;
    //设置UUID
    void SetUUID(QString strUUID);
    //获取UUID
    QString GetUUID() const;

    //设置开始采集是否成功的状态
    void SetStartCollectionSuccessState(bool bStartCollectionSuccess);
    //获取开始采集是否成功的状态
    bool GetStartCollectionSuccessState();
    //查找软件安装路径
    QString searchSoftwareExecutionPath(QString softwareName);
public:
    MobileCollectionHeartThread     *m_pHeartThread;
    MobileCollectionUSBThread       *m_pUSBThread;
    QTcpSocket *m_pTcpSocket;
    int m_HeartCount;               //心跳次数

private:
    QTimer      *m_delayedTimer;
    bool        m_bSendCheckPhoneUSBState;      //发送检测手机USB数据线的连接与断开的标志：TRUE【连接】；FALSE【断开】
    bool        m_bCheckUSBStateSwitch;         // 检测USB状态开关： true 检测， false 不检测
    bool        m_bHeartSwitch;                //心跳开关： true 发送心跳， false 停止发送
    QJsonObject m_jsonStartCollectionJsonBody;
    QString     m_strUUID;
    bool        m_bStartCollectionSuccess;

signals:
    void mobileCollectionInfo(int Type, int Code, QString Msg); //页面响应信号
};
//获取发送检测手机USB连接状态（true 连接， false 断开）
inline bool MobileCollection::GetSendCheckPhoneUSBState() const
{
    return  m_bSendCheckPhoneUSBState;
}
//获取检测USB状态开关
inline bool MobileCollection::GetCheckUSBStateSwitch() const
{
    return  m_bCheckUSBStateSwitch;
}
//获取心跳开关
inline bool MobileCollection::GetHeartSwitch() const
{
    return m_bHeartSwitch;
}
//获取开始采集所需要的数据项（json）
inline QJsonObject MobileCollection::GetStartCollectionJsonBody() const
{
    return  m_jsonStartCollectionJsonBody;
}
//获取UUID
inline QString MobileCollection::GetUUID() const
{
    return m_strUUID;
}
//获取开始采集是否成功的状态
inline bool MobileCollection::GetStartCollectionSuccessState()
{
    return m_bStartCollectionSuccess;
}
#endif // MOBILECOLLECTION_H

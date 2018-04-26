#ifndef OPERATEHTTP_H
#define OPERATEHTTP_H

#include <windows.h>
#include <QObject>
#include <QString>
#include <QMap>
#include <QList>
#include <QThread>
#include <qDebug>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include "src/OperateHttp/curl/curl.h"

#include <QJSEngine>
#include <QJSValue>

/**********************************************************************
 * 说明：
 * 1、需要在pro中链接libcurl库，如
 * LIBS += -L$$PWD\src\OperateHttp\curl -llibcurl
 * 2、OperateHttp为接口类，其余类为工具类，因此使用者只需关心OperateHttp类即可。
 *
 * 注意：
 * 1、调用Post接口时：
 *    传入的bodyData格式为需要发送的格式为：
 *    key1(type1)=val1&key2(type2)=val2&...&keyn(typen)=valn
 *    其中type为OperateHttp::ECONTENTTYPE中的数据，两个key(type)=val之间用&连接且不可加空格。
 *    例：
 *    collect1(0)={\"name\":\"sunpeng\"}&collect2(0)={\"age\":\"18\"}
 *    若有无key的数据时则只能有一个(type)=val且后面不能跟其他[key](type)=val, 即：
 *    (type)=val 正确
 *    (type1)=val1&key2(type2)=val2 错误
 *    (type1)=val1&(type2)=val2 错误
 *    例：
 *    (0)={\"name\":\"sunpeng\", \"age\":\"18\"}
 * 2、用户需处理返回则需连接OperateHttp::httpDone信号以获取返回信息。
 * 3、用户传入id，当查询完成或出错时，会在OperateHttp::httpDone信号中携带
 *    并原样返回，以在某些情况下对应http操作发起者。若不需关注此id，则填入空串即可。
 * 4、OperateHttp::httpDone中data为收到的数据，err为错误
 *    若err为-1则为OperateHttp内部返回错误并在data中描述，描述为{\"describe\":\"...\"}
 * 5、未测试文件传输及有cookie或ssl、代理的情况。
 * *******************************************************************/

//#define __OPERATEHTTP_DEBUG__

class OperateHttp:public QObject
{
    Q_OBJECT

public:
    enum ECONTENTTYPE           // body的type
    {
        ECONTENTTYPE_JSON,      // json文本
        ECONTENTTYPE_TEXT,      // 普通key-val文本
        ECONTENTTYPE_FILE       // 带有上传文件的文本
    };

public:
    OperateHttp();
    ~OperateHttp();

public:
    // id为传递进来的唯一标识符，发送httpDone信号时原样返回，由于是异步，返回值恒等于0，即返回值无意义
    Q_INVOKABLE int get(const QString &id, const QString &url, const QString &proxyIP = "", const int &proxyPort = -1, const int &proxyEnable = 0);
    Q_INVOKABLE int post(const QString &id, const QString &url, const QString &data, const QString cookieFile = "", const QString sslFile = "", const QString proxyIP = "", const int proxyPort = -1, const int &proxyEnable = 0);

    Q_INVOKABLE int get(QString url,
                        QJSValue callback,
                        QString token = "",
                        const QString &proxyIP = "",
                        const int &proxyPort = -1,
                        const int &proxyEnable = 0);
    Q_INVOKABLE int post(QString url,
                         QJSValue callback,
                         const QString data,
                         QString token = "",
                         const QString cookieFile = "",
                         const QString sslFile = "",
                         const QString &proxyIP = "",
                         const int &proxyPort = -1,
                         const int &proxyEnable = 0);
signals:
    void httpDone(QString id, QString data, int err);

private slots:
    void threadDone(QString id, QString data, int err, QJSValue callback);      // 线程结束，进行清理并发送完成信号操作

private:
    static QMutex m_MutexCurlGlobalOpertion;
};

struct HttpErr          // HTTP错误
{
public:
    int m_ErrCode;      // 错误码
    //QString m_Describe; // 描述
};

typedef class _HttpBaseInfo
{
public:
    _HttpBaseInfo()
    {
        m_proxyPort = -1;
    }
    virtual ~_HttpBaseInfo() {}

public:
    enum    EWORKTYPE m_type;
    QString m_id;
    QString m_url;
    QString m_proxyIP;
    int     m_proxyPort;
    int     m_proxyEnable;
    QJSValue callback;
    QString token;
} HttpBaseInfo;

typedef class _HttpGetInfo:public HttpBaseInfo
{
public:
    virtual ~_HttpGetInfo() {}  // 关联HttpBaseInfo，使delete HttpBaseInfo*时自动删除除基类以外的部分
} HttpGetInfo;

typedef class _HttpPostInfo:public HttpBaseInfo
{
public:
    virtual ~_HttpPostInfo() {} // 关联HttpBaseInfo，使delete HttpBaseInfo*时自动删除除基类以外的部分

public:
    QString m_data;
    QString m_cookieFile;       // cookie路径
    QString m_sslFile;          // ssl路径
} HttpPostInfo;

enum EWORKTYPE
{
    EWORKTYPE_GET,      // 线程内部使用，记录是Get操作
    EWORKTYPE_POST      // 线程内部使用，记录是Post操作
};
struct PostData
{
private:
    PostData()
    {
        m_pKey  = NULL;
        m_pVal  = NULL;
        m_pType = NULL;
    }

public:
    PostData(QString key, QString val, QString type)
    {
        // 转utf8时QString的length()会改变
        m_pKey  = new char[strlen(key.toUtf8().data()) +1];
        m_pVal  = new char[strlen(val.toUtf8().data()) +1];
        m_pType = new char[strlen(type.toUtf8().data())+1];
        strcpy(m_pKey,  key.toUtf8().data());
        strcpy(m_pVal,  val.toUtf8().data());
        strcpy(m_pType, type.toUtf8().data());
    }

    PostData(const PostData &other)
    {
        m_pKey  = new char[strlen(other.m_pKey) +1];
        m_pVal  = new char[strlen(other.m_pVal) +1];
        m_pType = new char[strlen(other.m_pType)+1];
        strcpy(m_pKey,  other.m_pKey);
        strcpy(m_pVal,  other.m_pVal);
        strcpy(m_pType, other.m_pType);
    }

    ~PostData()
    {
        delete [] m_pKey;   m_pKey  = NULL;
        delete [] m_pVal;   m_pVal  = NULL;
        delete [] m_pType;  m_pType = NULL;
    }

public:
    char *m_pKey;
    char *m_pVal;
    char *m_pType;
};

class WorkThread:public QThread
{
    Q_OBJECT

public:
    WorkThread();
    ~WorkThread();

public:
    void setHttpInfo(const HttpBaseInfo *pInfo);    // 设置信息
    HttpBaseInfo *getInfo();    // 获得信息，清理时delete使用

protected:
    virtual void run();         // 覆盖run函数

private:
    static size_t processRecvData(void* buffer, size_t size, size_t nmemb, void*);  // 收到的数据

private:
    bool initCurl(CURL **ppCurl);   // 对curl进行get和post共同具有的操作

private:
    void runGet();      // Get处理
    void runPost();     // Post处理
    void runDone();     // 结束处理

    bool analysisPostData(const QString &data, QList<PostData> &ltData);
    QString generateReply(const QString &describe);

signals:
    void threadDone(QString id, QString data, int err, QJSValue callback=NULL);  // 发送信号告知OperateHttp运行结束，使OperateHttp进行后续操作

public:
    static QMap<Qt::HANDLE, QString> s_Ret;     // 利用线程句柄记录收到的信息，为了处理分页
    static QMutex s_MutexRet;                   // 由于多线程中会对s_Ret有插入/删除处理，所以对s_Ret进行操作时需要加锁

private:
    HttpBaseInfo *m_pInfo;  // 信息，当进行不同处理时强转成不同类型
    //HttpErr m_err;          // 错误信息
    int m_ErrCode;
    QString m_Describe;
};

#endif // OPERATEHTTP_H

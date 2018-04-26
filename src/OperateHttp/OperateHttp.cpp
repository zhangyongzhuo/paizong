#pragma execution_character_set("utf-8")
#include "OperateHttp.h"

QMutex OperateHttp::m_MutexCurlGlobalOpertion;

OperateHttp::OperateHttp()
{
    qRegisterMetaType<ECONTENTTYPE>("ECONTENTTYPE");
    static bool bAlreadyInitialized = false;
    OperateHttp::m_MutexCurlGlobalOpertion.lock();
    if (!bAlreadyInitialized)
    {
        curl_global_init(CURL_GLOBAL_ALL);
        bAlreadyInitialized = true;
    }
    OperateHttp::m_MutexCurlGlobalOpertion.unlock();
}

OperateHttp::~OperateHttp()
{
//  curl_global_cleanup();      // 多实例时，由于无法保障全部使用完毕，因此不进行清理操作
}

int OperateHttp::get(const QString &id, const QString &url, const QString &proxyIP, const int &proxyPort, const int &proxyEnable)
{
    WorkThread *pThread = new WorkThread;
    connect(pThread, &WorkThread::threadDone, this, &OperateHttp::threadDone);
    HttpGetInfo *pInfo = new HttpGetInfo;
    pInfo->m_type = EWORKTYPE_GET;
    pInfo->m_id = id;
    pInfo->m_url = url;
    pInfo->m_proxyIP = proxyIP;
    pInfo->m_proxyPort = proxyPort;
    pInfo->m_proxyEnable=proxyEnable;
    static int bbb = 0;
    QString s = "getThread" + bbb;
    ++bbb;
    //qDebug() << "getData=";
    pThread->setObjectName(s);
    pThread->setHttpInfo(pInfo);
    pThread->start();

    return 0;
}

int OperateHttp::post(const QString &id, const QString &url, const QString &data, const QString cookieFile, const QString sslFile, const QString proxyIP, const int proxyPort, const int &proxyEnable )
{
    WorkThread *pThread = new WorkThread;
    connect(pThread, &WorkThread::threadDone, this, &OperateHttp::threadDone);
    HttpPostInfo *pInfo = new HttpPostInfo;
    pInfo->m_type = EWORKTYPE_POST;
    pInfo->m_id = id;
    pInfo->m_url = url;
    pInfo->m_data = data;
    pInfo->m_cookieFile = cookieFile;
    pInfo->m_sslFile = sslFile;
    pInfo->m_proxyIP = proxyIP;
    pInfo->m_proxyPort = proxyPort;
    pInfo->m_proxyEnable=proxyEnable;
    static int aaa = 0;
    QString s = "postThread" + aaa;
    ++aaa;
    //qDebug() << "postData=" << data;
    pThread->setObjectName(s);
    pThread->setHttpInfo(pInfo);
    pThread->start();

    return 0;
}

void OperateHttp::threadDone(QString id, QString data, int err, QJSValue callback)
{
    WorkThread *pSender = qobject_cast<WorkThread*>(sender());
#ifdef __OPERATEHTTP_DEBUG__
//    qDebug() << "~~~~~~~~~~~~~~~~OperateHttp-Recv~~~~~~~~~~~~~~~~";
//    qDebug() << "OperateHttp-RecvId : " << id;
//    qDebug() << "OperateHttp-RecvData : " << data;
//    qDebug() << "OperateHttp-RecvErr : " << err;
//    qDebug() << "~~~~~~~~~~~~~~~~OperateHttp-RecvEnd~~~~~~~~~~~~~~~~";
#endif
    pSender->wait(1000);
    if (pSender->isRunning())
    {
        qDebug() << "isRuning";
        pSender->quit();
        pSender->wait();
    }
    //WorkThread::s_MutexRet.lock();
    //qDebug() << "release : s_Ret.size()" << WorkThread::s_Ret.size();
    //WorkThread::s_MutexRet.unlock();

    delete pSender->getInfo();
    delete pSender;

    emit httpDone(id, data, err);

    if(callback.toString() != "undefined"){

        //qDebug()<<"hava callback err:"<<err;
        //qDebug()<<"hava callback data:"<<data;
        QJSValue tempcode = callback.engine()->newObject();
        QJSValue tempdata = callback.engine()->newObject();
        tempcode = err;
        tempdata = data;
        QJSValueList valueList;
        valueList.append(tempcode);
        valueList.append(tempdata);
        callback.call(valueList);
    }
}

//function(code, data)
int OperateHttp::get(QString url, QJSValue callback, QString token, const QString &proxyIP, const int &proxyPort, const int &proxyEnable)
{

    WorkThread *pThread = new WorkThread;
    connect(pThread, &WorkThread::threadDone, this, &OperateHttp::threadDone);
    HttpGetInfo *pInfo = new HttpGetInfo;
    pInfo->m_type = EWORKTYPE_GET;
    pInfo->m_id = "0";
    pInfo->m_url = url;
    pInfo->m_proxyIP = proxyIP;
    pInfo->m_proxyPort = proxyPort;
    pInfo->callback = callback;
    pInfo->token = "token:"+token;
    pInfo->m_proxyEnable=proxyEnable;
    static int bbb = 0;
    QString s = "getThread" + bbb;
    ++bbb;
    //qDebug() << "getData=";
    pThread->setObjectName(s);
    pThread->setHttpInfo(pInfo);
    pThread->start();

    return 0;

//    QJSValue code = callback.engine()->newObject();
//    QJSValue data = callback.engine()->newObject();
//    code = 200;
//    data = "hylink: " + url;
//    QJSValueList valueList;
//    valueList.append(code);
//    valueList.append(data);
//    callback.call(valueList);
}

int OperateHttp::post(QString url, QJSValue callback, const QString data, QString token, const QString cookieFile, const QString sslFile, const QString &proxyIP, const int &proxyPort, const int &proxyEnable )
{
    WorkThread *pThread = new WorkThread;
    connect(pThread, &WorkThread::threadDone, this, &OperateHttp::threadDone);
    HttpPostInfo *pInfo = new HttpPostInfo;
    pInfo->m_type = EWORKTYPE_POST;
    pInfo->m_id = "0";
    pInfo->m_url = url;
    pInfo->m_data = data;
    pInfo->m_cookieFile = cookieFile;
    pInfo->m_sslFile = sslFile;
    pInfo->m_proxyIP = proxyIP;
    pInfo->m_proxyPort = proxyPort;
    pInfo->m_proxyEnable=proxyEnable;
    pInfo->callback = callback;
    pInfo->token = "token:"+token;
    static int aaa = 0;
    QString s = "postThread" + aaa;
    ++aaa;
    //qDebug() << "postData=" << data;
    pThread->setObjectName(s);
    pThread->setHttpInfo(pInfo);
    pThread->start();

    return 0;
}

QMap<Qt::HANDLE, QString> WorkThread::s_Ret;
QMutex WorkThread::s_MutexRet;

WorkThread::WorkThread()
{
    m_pInfo = NULL;
}

WorkThread::~WorkThread()
{

}

void WorkThread::setHttpInfo(const HttpBaseInfo *pInfo)
{
    m_pInfo = (HttpBaseInfo *)pInfo;
}

HttpBaseInfo *WorkThread::getInfo()
{
    return m_pInfo;
}

void WorkThread::run()
{
    switch (m_pInfo->m_type)
    {
        case EWORKTYPE_GET:
        {
            runGet();
        }
            break;
        case EWORKTYPE_POST:
        {
            runPost();
        }
            break;
        default:
            break;
    }
}

size_t WorkThread::processRecvData(void *buffer, size_t size, size_t nmemb, void *)
{
    s_MutexRet.lock();
    QMap<Qt::HANDLE, QString>::iterator itRet = WorkThread::s_Ret.find(QThread::currentThreadId());
    if (itRet != WorkThread::s_Ret.end())
    {
        char *pTemp = new char[size*nmemb+1];
        memcpy(pTemp, (char *)buffer, size*nmemb);
        pTemp[size*nmemb] = '\0';
        itRet.value() += pTemp;
        delete [] pTemp;
    }
    s_MutexRet.unlock();

    return size*nmemb;
}

bool WorkThread::initCurl(CURL **ppCurl)
{
    *ppCurl = curl_easy_init();    // 初始化
    if (NULL == *ppCurl)
    {
#ifdef __OPERATEHTTP_DEBUG__
        qDebug() << "OperateHttp:生成Curl实例出错";
#endif
        m_ErrCode = -1;
        m_Describe = generateReply(QString("%1(id=%2)").arg("生成Curl实例出错").arg(m_pInfo->m_id));
        runDone();

        return false;
    }

    //curl_easy_setopt(*ppCurl, CURLOPT_VERBOSE, 1L);    // 打开调试信息
    curl_easy_setopt(*ppCurl, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V4);   // 设置为ipv4类型
    curl_easy_setopt(*ppCurl, CURLOPT_FOLLOWLOCATION, 1L);   // 设置允许302跳转
    curl_easy_setopt(*ppCurl, CURLOPT_NOSIGNAL, 1L);    // 防止curl被alarm信号干扰
    curl_easy_setopt(*ppCurl, CURLOPT_TIMEOUT, 60L);   // 超时时间，秒
    curl_easy_setopt(*ppCurl, CURLOPT_URL, m_pInfo->m_url.toUtf8().data());    // url
    curl_easy_setopt(*ppCurl, CURLOPT_HEADER, 0L);    // 设置httpheader 解析, 不需要将HTTP头写传入回调函数
   // if (m_pInfo->m_proxyIP != "" && -1 != m_pInfo->m_proxyPort)    // 设置代理
    if (m_pInfo->m_proxyEnable ==1)    // 设置代理
    {
        QString proxy = "http://"+m_pInfo->m_proxyIP + ":" + QString::number(m_pInfo->m_proxyPort, 10);
        curl_easy_setopt(*ppCurl, CURLOPT_PROXY, proxy.toUtf8().data());
        qDebug()<<"代理："<<proxy;
    }

    return true;
}

void WorkThread::runGet()
{
#ifdef __OPERATEHTTP_DEBUG__
    qDebug() << "~~~~~~~~~~~~~~~~OperateHttp-GetSend~~~~~~~~~~~~~~~~";
    qDebug() << "id=" << m_pInfo->m_id;
    qDebug() << "url=" << m_pInfo->m_url;
    qDebug() << "~~~~~~~~~~~~~~~~OperateHttp-GetSendEnd~~~~~~~~~~~~~~~~";
#endif
    //qDebug() << "locking...";
    s_MutexRet.lock();
    //qDebug() << "+lock";
    WorkThread::s_Ret.insert(QThread::currentThreadId(), QString());
    //qDebug() << "-lock";
    s_MutexRet.unlock();
    CURL *curl = NULL;
    if (false == initCurl(&curl))
        return;

//    char szData[DATABUFFERSIZE] = {0};
//    curl_easy_setopt(curl, CURLOPT_WRITEDATA, szData);  // 使用CURLOPT_WRITEFUNCTION时如果使用最后一个参数必须指定CURLOPT_WRITEDATA
    ///////////////////////////////向头中添加token
    struct curl_slist *headers=NULL;
    if(m_pInfo->token != ""){
        headers = curl_slist_append(headers, m_pInfo->token.toUtf8().data());
        //headers = curl_slist_append(headers, "User-Agent: Go-http-client/1.1");
        //headers = curl_slist_append(headers, "Accept-Encoding: gzip");
        headers = curl_slist_append(headers, "Content-Type: application/json");
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    }

    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, NULL);
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, NULL);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WorkThread::processRecvData);

    try{
        m_ErrCode = (int)curl_easy_perform(curl);     // 执行
    } catch (...) {
        m_ErrCode = -1;
    }

    if (0 != m_ErrCode)
        m_Describe = generateReply(curl_easy_strerror((CURLcode)m_ErrCode));
    else
    {
        curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &m_ErrCode);
    }
    //qDebug()<<"'3333333333:'"<<m_ErrCode;
    //qDebug()<<"'4444444444:'"<<m_Describe;

    curl_slist_free_all(headers); //清理头
    curl_easy_cleanup(curl);    // 清理

    runDone();
}

void WorkThread::runPost()
{
    //qDebug() << "locking...";
    s_MutexRet.lock();
    //qDebug() << "+lock";
    WorkThread::s_Ret.insert(QThread::currentThreadId(), QString());
    //qDebug() << "-lock";
    s_MutexRet.unlock();
    CURL *curl = NULL;
    if (false == initCurl(&curl)){
        qDebug()<<"initCurl(&curl) 失败";
        return;
    }


    HttpPostInfo *pInfo = (HttpPostInfo *)m_pInfo;
    if (0 == strncmp(pInfo->m_url.toStdString().c_str(), "https://", 8) && pInfo->m_sslFile != "")   // 设置证书
    {
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 1L);
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 1L);
        curl_easy_setopt(curl, CURLOPT_CAINFO, pInfo->m_sslFile.toStdString().c_str());
    }
    else
    {
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, NULL);
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, NULL);
    }
    if (pInfo->m_cookieFile != "")
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, pInfo->m_cookieFile);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WorkThread::processRecvData);

    //qDebug()<<"-----------启动线程";

    // 添加包体
    QList<PostData> ltData;
    QList<PostData>::iterator itData;
    if (false == analysisPostData(pInfo->m_data, ltData) || 0 == ltData.size())
        return;
#ifdef __OPERATEHTTP_DEBUG__
    qDebug() << "~~~~~~~~~~~~~~~~OperateHttp-PostSend~~~~~~~~~~~~~~~~";
    qDebug() << "id=" << pInfo->m_id;
    qDebug() << "url=" << pInfo->m_url;
#endif
    itData = ltData.begin();
    if (1 == ltData.size() && '\0' == (*itData).m_pKey[0])
    {
#ifdef __OPERATEHTTP_DEBUG__
        qDebug() << "1 == ltData.size() && '\\0' == (*itData).m_pKey[0]";
        qDebug() << "OperateHttp-SendKey:" << (*itData).m_pKey;
        qDebug() << "OperateHttp-SendVal:" << (*itData).m_pVal;
        qDebug() << "OperateHttp-SendType:" << (*itData).m_pType;
#endif
        curl_easy_setopt(curl,CURLOPT_POST, 1);     // 设置 为POST 方法
        curl_easy_setopt(curl,CURLOPT_POSTFIELDS, (*itData).m_pVal);      // POST 的数据内容
        curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, strlen((*itData).m_pVal));  // POST的数据长度
    }
    else
    {
#ifdef __OPERATEHTTP_DEBUG__
        qDebug() << "!(1 == ltData.size() && '\\0' == (*itData).m_pKey[0])";
#endif
        struct curl_httppost *formpost = NULL;  // POST 需要的参数
        struct curl_httppost *lastptr  = NULL;
        for (itData = ltData.begin(); itData != ltData.end(); ++itData) // 不同的post参数必须存在不同的数组内，否则会被覆盖并且为了兼容不同长度的参数，因此PostData需要new出里面的参数
        {
#ifdef __OPERATEHTTP_DEBUG__
            qDebug() << "OperateHttp-SendKey:" << (*itData).m_pKey;
            qDebug() << "OperateHttp-SendVal:" << (*itData).m_pVal;
            qDebug() << "OperateHttp-SendType:" << (*itData).m_pType;
#endif
            curl_formadd(&formpost, &lastptr, CURLFORM_CONTENTTYPE, (*itData).m_pType, CURLFORM_PTRNAME, (*itData).m_pKey, CURLFORM_PTRCONTENTS, (*itData).m_pVal, CURLFORM_CONTENTSLENGTH, strlen((*itData).m_pVal), CURLFORM_END);
        }
        if (NULL != formpost)
            curl_easy_setopt(curl, CURLOPT_HTTPPOST, formpost);
    }

//    struct curl_httppost *formpost = NULL;  // POST 需要的参数
//    struct curl_httppost *lastptr  = NULL;
//    curl_formadd(&formpost,
//                 &lastptr,
//                 CURLFORM_CONTENTTYPE,
//                 "application/json",
//                 CURLFORM_PTRNAME,
//                 pKey,
//                 CURLFORM_PTRCONTENTS,
//                 pVal,
//                 CURLFORM_CONTENTSLENGTH,
//                 pInfo->m_data.length()-4,
//                 CURLFORM_END);

//    if (NULL != formpost)
//        curl_easy_setopt(curl, CURLOPT_HTTPPOST, formpost);


//    curl_easy_setopt(curl,CURLOPT_POST, 1);     // 设置 为POST 方法
//    //curl_easy_setopt(curl, CURLFORM_CONTENTTYPE, "application/json");
//      curl_easy_setopt(curl,CURLOPT_POSTFIELDS, pInfo->m_data.right(pInfo->m_data.length()-4).toUtf8().data());      // POST 的数据内容
//    curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, pInfo->m_data.length()-4);  // POST的数据长度
    ///////////////////////////////向头中添加类型
//    struct curl_slist *headers=NULL;
//    headers = curl_slist_append(headers, "Content-Type: application/json");
//    headers = curl_slist_append(headers, "Accept: application/json");
//    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    struct curl_slist *headers=NULL;
    QString token_t=m_pInfo->token.toUtf8().data();
    QString auth="Authorization:"+ token_t.mid(6,token_t.length()-6);
    headers = curl_slist_append(headers, auth.toLatin1().data());
   //headers = curl_slist_append(headers, "Authorization:eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI4NDJiZDhkZi1hNmViLTQzNTMtYjM2NS02NmU4ZTRjODNkMDEiLCJpYXQiOjE1MDQyMjc3NTYsInN1YiI6IjE4NiIsImlzcyI6IlNlY3VyZSBDZW50ZXIiLCJncm91cGNvZGUiOiI0MTAzMDAwMzAwMDAiLCJ1dHlwZSI6IjQiLCJpZGNhcmQiOiIyMzAxMDMxOTkxMDMwNDIyMTAiLCJleHAiOjE1MDQyMzEzNTZ9.oV1KE2UfcKg0yKals-TY_ifl3QkCJUw-MjBO8XbRJ4U");
    headers = curl_slist_append(headers, "Content-Type: application/json");
    headers = curl_slist_append(headers, m_pInfo->token.toUtf8().data());
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);

    try{
        //qDebug() << "post给别人的数据:" << (*itData).m_pVal;
        //qDebug() << "post给别人的数据:" <<  pInfo->m_data.right(pInfo->m_data.length()-4).toUtf8().data();
        m_ErrCode = (int)curl_easy_perform(curl);     // 执行
    } catch (...) {
        m_ErrCode = -1;
    }
    if (0 != m_ErrCode)
        m_Describe = generateReply(curl_easy_strerror((CURLcode)m_ErrCode));
    else
    {
        curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &m_ErrCode);
    }
    //curl_slist_free_all(headers); //清理头
    curl_easy_cleanup(curl);    // 清理

    runDone();
#ifdef __OPERATEHTTP_DEBUG__
    qDebug() << "~~~~~~~~~~~~~~~~OperateHttp-PostSendEnd~~~~~~~~~~~~~~~~";
#endif
}

void WorkThread::runDone()
{
    s_MutexRet.lock();
    QMap<Qt::HANDLE, QString>::iterator itRet = WorkThread::s_Ret.find(QThread::currentThreadId());
    if (itRet != WorkThread::s_Ret.end())
    {
        if (m_Describe != ""){
            emit threadDone(m_pInfo->m_id, m_Describe, m_ErrCode, m_pInfo->callback);
        }
        else{
            emit threadDone(m_pInfo->m_id, itRet.value(), m_ErrCode, m_pInfo->callback);
        }
        WorkThread::s_Ret.erase(itRet);
    }
    s_MutexRet.unlock();
}

bool WorkThread::analysisPostData(const QString &data, QList<PostData> &ltData)
{
    QStringList temp;
    temp.append(data);//.split(QRegExp("&"));
    QStringList::iterator it;
    char *pKey = new char[strlen(data.toUtf8().data())+1];   pKey[0] = '\0';
    char *pVal = new char[strlen(data.toUtf8().data())+1];   pVal[0] = '\0';

    //qDebug() <<"'----------temp.length:"<<temp.length();

    for (it = temp.begin(); it != temp.end(); it++)
    {
        int nType = -1;
        sscanf((*it).toUtf8().data(), "%[^()](%d)=%s", pKey, &nType, pVal);

        //qDebug() << "---nType"<<nType<<"---pKey[0]"<<pKey[0]<<"---pVal"<<pVal;

        if (-1 == nType){
            sscanf((*it).toUtf8().data(), "(%d)=%s", &nType, pVal);
        }

        //qDebug() << "===nType"<<nType<<"===pKey[0]"<<pKey[0]<<"===pVal"<<pVal;

        if (-1 == nType || (1 != temp.size() && '\0' == pKey[0]))
        {
#ifdef __OPERATEHTTP_DEBUG__
            qDebug() << "QperateHttp:-1 == nType || (1 != temp.size() && '\\0' == szKey[0])";
#endif
            m_ErrCode = -1;
            m_Describe = "报体填写出错";//generateReply(QString("%1(id=%2):%3").arg("报体填写出错").arg(m_pInfo->m_id).arg(data));
            runDone();

            delete [] pKey;
            delete [] pVal;

            return false;
        }
        switch ((OperateHttp::ECONTENTTYPE)nType)
        {
        case OperateHttp::ECONTENTTYPE_JSON:
            {
                ltData.push_back(PostData(pKey, pVal, "application/json"));
            }
            break;
       case OperateHttp::ECONTENTTYPE_TEXT:
            {
                ltData.push_back(PostData(pKey, pVal, "application/x-www-form-urlencoded"));
            }
            break;
       case OperateHttp::ECONTENTTYPE_FILE:
            {
                ltData.push_back(PostData(pKey, pVal, "application/octet-stream"));
            }
            break;
        default:
            {
//#ifdef __OPERATEHTTP_DEBUG__
                qDebug() << "传入类型错误:" << nType;
//#endif
                m_ErrCode = -1;
                m_Describe = generateReply(QString("%1(id=%2):%3").arg("传入类型错误").arg(m_pInfo->m_id).arg(nType,1,10,QChar(' ')));

                delete [] pKey;
                delete [] pVal;

                return false;
            }
            break;
        }
    }
    delete [] pKey;
    delete [] pVal;

    return true;
}

QString WorkThread::generateReply(const QString &describe)
{
    QJsonDocument doucument;
    QJsonObject json;

    json.insert("describe", describe);
    doucument.setObject(json);

    return doucument.toJson();
}



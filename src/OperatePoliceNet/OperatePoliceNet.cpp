#pragma execution_character_set("utf-8")
#include "OperatePoliceNet.h"

OperatePoliceNet* pn;

OperatePoliceNet::OperatePoliceNet()
{
    qRegisterMetaType<EPOLICENETST>("EPOLICENETST");
    pn = this;
}

OperatePoliceNet::~OperatePoliceNet()
{

}

void OperatePoliceNet::setRelease(const bool &release)
{
    m_bRelease = release;
}

// 联网
void OperatePoliceNet::connectPoliceNet()
{
    m_operType = EOPERTYPE_CONNECT;
    if (m_bRelease)
        fnOneKeyNetwork(TRUE, OperatePoliceNet::fnPoliceNetSt);
    else
        emit pn->policeNetStatus(EPOLICENETST_CONNECTOK, "");
}

// 断网
void OperatePoliceNet::disconnectPoliceNet()
{
    m_operType = EOPERTYPE_DISCONNECT;
    qDebug()<<"m_bRelease"<<m_bRelease;
    if (m_bRelease)
    {
        fnOneKeyNetwork(FALSE, OperatePoliceNet::fnPoliceNetSt);
    }
    else
    {
        emit pn->policeNetStatus(EPOLICENETST_DISCONNECTOK, "");
    }

}

void OperatePoliceNet::fnPoliceNetSt(BOOL bSuccess, LPCTSTR strErrMsg)
{
    //错误信息
    int nLen = WideCharToMultiByte( CP_ACP, 0, strErrMsg, -1, NULL, 0, NULL, NULL );
    char* pResult = new char[nLen];
    WideCharToMultiByte( CP_ACP, 0, strErrMsg, -1, pResult, nLen, NULL, NULL );
    qDebug()<<"onekeynet err msg:"<<QString::fromLocal8Bit(pResult);
    delete pResult;
    pResult = NULL;
    ///////////////////////////////////////////////////////
    if (EOPERTYPE_CONNECT == pn->m_operType)
        emit pn->policeNetStatus(bSuccess?EPOLICENETST_CONNECTOK:EPOLICENETST_CONNETFAILED, (char *)strErrMsg);
    else if (EOPERTYPE_DISCONNECT == pn->m_operType)
        emit pn->policeNetStatus(bSuccess?EPOLICENETST_DISCONNECTOK:EPOLICENETST_DISCONNECTFAILED, (char *)strErrMsg);
}

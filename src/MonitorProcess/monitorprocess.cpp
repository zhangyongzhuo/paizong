#pragma execution_character_set("utf-8")
#include <QFile>
#include <QDebug>
#include <QProcess>
#include "monitorprocess.h"
#include <QCoreApplication>
#include <QDir>
#include "tlhelp32.h"
#include <QUrl>
#include <stdlib.h>

MonitorProcess::MonitorProcess()
{
    m_pMonitorProcessThread = new MonitorProcessThread(this);    
    //m_isInit = false;
    m_pMonitorProcessThread->m_previousStatus="0";
    m_pMonitorProcessThread->m_currentStatus  ="0";//不在
}

MonitorProcess::~MonitorProcess()
{
    if(m_pMonitorProcessThread->isRunning())
    {
        qDebug()<<"小键盘 线程正在运行";
        while(m_pMonitorProcessThread->isRunning());
    }
    if(m_pMonitorProcessThread!=NULL)
    {
        delete m_pMonitorProcessThread;
        m_pMonitorProcessThread = NULL;
        qDebug()<<" 释放";
    }
}

int MonitorProcess::GetProcessidFromName(QString name)
{
    PROCESSENTRY32 pe;
    DWORD id=0;
    HANDLE hSnapshot=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
    pe.dwSize=sizeof(PROCESSENTRY32);
    if(!Process32First(hSnapshot,&pe))
        return 0;
    while(1)
    {
        pe.dwSize=sizeof(PROCESSENTRY32);
        if(Process32Next(hSnapshot,&pe)==FALSE)
            break;
        QString exeName = QString::fromStdWString(pe.szExeFile);
        if(exeName==name)
        {
            id=pe.th32ProcessID;
            break;
        }
    }
    CloseHandle(hSnapshot);

    if(id != 0){
        return 1;
    }else{
        return 0;
    }
}

//获取进程状态 传入进程名
int MonitorProcess::getProcessStatus(QString processName)
{
    if (processName == NULL)
    {
        qDebug() << "进程状态判断失败 进程名为空";
        return -1;
    }
    //接到识别任务后迅速返回 启动线程继续做识别任务
    m_processName = processName;
    if(!m_pMonitorProcessThread->isRunning())
    {
        //m_pReadIdcardThread->m_ReadIdcardThreadRun = FALSE;
        m_pMonitorProcessThread->m_MonitorProcess = TRUE;
        m_pMonitorProcessThread->startRun();
    }

    return 0;
}

//停止
void MonitorProcess::stopProcessIdentification( void ){

    if(m_pMonitorProcessThread->isRunning())
    {
        m_pMonitorProcessThread->m_MonitorProcess = FALSE;
        while(m_pMonitorProcessThread->isRunning());
    }
}



///////////////////////////////////////////////////////////////////
void MonitorProcessThread::run()
{
    //qDebug() << "进程判断开始";
    MonitorProcess *parent = (MonitorProcess *)m_parent;
    //qDebug() << "进入线程了-------------";
    while(m_MonitorProcess)
    {
        //parent->m_pMonitorProcessThread->wait(100);
        //wait(100);
        msleep(100);
        if (parent->m_processName!="")
        {
            if(parent->GetProcessidFromName(parent->m_processName)!= 1){
                m_currentStatus="0";
                if(m_currentStatus!=m_previousStatus){
                    //由在转为不在
                    emit parent->monitorProcessfinished(parent->m_processName,1);
                }
                m_previousStatus="0";
            }else{
                m_currentStatus="1";
                if(m_currentStatus!=m_previousStatus){
                    //由不在转为在
                    emit parent->monitorProcessfinished(parent->m_processName,2);
                }
                m_previousStatus="1";
            }
        }else{
            msleep(50);
        }
    }

    qDebug() << "进程判断结束";
    return ;
}

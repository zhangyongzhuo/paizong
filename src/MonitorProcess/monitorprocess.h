#pragma execution_character_set("utf-8")
#ifndef MONITORPROCESS_H
#define MONITORPROCESS_H
#include <QString>
#include <QObject>
#include <QThread>
#include <QDateTime>
#include <QImage>
#include <QBuffer>
#include <QRegExpValidator>
#include <QDebug>
#include "src/OperateConfigFile/OperateConfigFile.h"
#include <Windows.h>
#include <stdlib.h>
#include <QDesktopServices>


class MonitorProcessThread: public QThread
{
    Q_OBJECT
public:
    MonitorProcessThread(QObject *parent = 0): QThread(parent)
    {
        m_parent = parent;
        m_MonitorProcess = TRUE;
    }
    void startRun()
    {
        start(HighestPriority);
    }
protected:
void run();

public:
    QObject *m_parent;
    BOOL     m_MonitorProcess;
    QString         m_currentStatus;
    QString         m_previousStatus;
};

class MonitorProcess:public QObject
{
    Q_OBJECT
public:
    MonitorProcess();
    ~MonitorProcess();

    MonitorProcessThread    *m_pMonitorProcessThread;
    QString         m_processName;


public:
    Q_INVOKABLE int getProcessStatus(QString processName);
    //通过传入进程名称 查看进程是否存在
    Q_INVOKABLE int GetProcessidFromName(QString name);
    Q_INVOKABLE void stopProcessIdentification( void );//


signals:
    void monitorProcessfinished(QString processName,int status);

};

#endif // MONITORPROCESS_H



#ifndef ENUMONLINEPHONES_H
#define ENUMONLINEPHONES_H

#include <Windows.h>
#include <QObject>
#include <QThread>

class ReadPhonesThread : public QThread
{
        Q_OBJECT
public:
        ReadPhonesThread(QObject *parent = 0): QThread(parent)
        {
            m_parent = parent;
            m_ReadPhonesThread = TRUE;
        }
        void startRun()
        {
            start(HighestPriority);
        }
protected:
    void run();
public:
    QObject *m_parent;

    BOOL     m_ReadPhonesThread;
};


class EnumOnlinePhones : public QObject
{
    Q_OBJECT
public:
    EnumOnlinePhones();
    ~EnumOnlinePhones();

signals:
    void readPhonesNumberChanged(QStringList phones); //手机个数发生变化

public:
     Q_INVOKABLE int  startOnlinePhonesMonitor();//启动手机个数监控
     Q_INVOKABLE void stopOnlinePhonesMonitor();//停止手机个数监控

public:
    Q_INVOKABLE QStringList enumOnlinePhones();

    ReadPhonesThread *m_thread;
};

#endif // ENUMONLINEPHONES_H

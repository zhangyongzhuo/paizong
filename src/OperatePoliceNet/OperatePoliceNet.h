#ifndef OPERATEPOLICENET_H
#define OPERATEPOLICENET_H

#include <windows.h>
#include <QObject>
#include <QString>
#include <QMetaType>
#include <QDebug>
#include "src/OperatePoliceNet/OneKeyNetwork/OneKeyNetwork.h"

/***************************************************************************************
 * 说明：
 * 需要在pro中连接OneKeyNetwork.lib，如：
 * LIBS += -L$$PWD\src\OperatePoliceNet\OneKeyNetwork -lOneKeyNetwork
 * qml中需要连接处理PoliceNetStatus信号。
 * main函数中需要注册此类，如
 * qmlRegisterType<OperatePoliceNet>("com.hylink.fmcp.ctrl", 2, 0, "OperatePoliceNet");
 * ************************************************************************************/

#pragma comment(lib, "OneKeyNetwork.lib")

//
enum EOPERTYPE
{
    EOPERTYPE_CONNECT,
    EOPERTYPE_DISCONNECT
};

class OperatePoliceNet:public QObject
{
    Q_OBJECT

public:
    // 操作联网状态
    enum EPOLICENETST
    {
        EPOLICENETST_CONNECTOK=1,         // 联网成功
        EPOLICENETST_CONNETFAILED,      // 联网失败
        EPOLICENETST_DISCONNECTOK,      // 断网成功
        EPOLICENETST_DISCONNECTFAILED   // 断网失败
    };

public:
    OperatePoliceNet();
    ~OperatePoliceNet();

public:
    Q_INVOKABLE void setRelease(const bool &release);
    Q_INVOKABLE void connectPoliceNet();    // 联网
    Q_INVOKABLE void disconnectPoliceNet(); // 断网

signals:
    void policeNetStatus(enum EPOLICENETST st, QString error);

protected:
    static void fnPoliceNetSt(BOOL bSuccess, LPCTSTR strErrMsg);

private:
    bool m_bRelease;
    enum EOPERTYPE m_operType;
};

#endif // OPERATEPOLICENET_H

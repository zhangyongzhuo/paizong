#pragma execution_character_set("utf-8")
#include "EnumOnlinePhones.h"

#include <Windows.h>
#include <SetupAPI.h>
#include <Devpropdef.h>
#include <QDebug>
#include <Devpkey.h>
#include <Cfgmgr32.h>

QStringList EnumOnlinePhones::enumOnlinePhones()
{
    HDEVINFO m_hDevInfo; // 类似设备句柄，以下暂且称为设备句柄
    SP_DEVINFO_DATA m_DeviceInfoData; // 设备详细属性信息
    QStringList result;

    m_hDevInfo = SetupDiGetClassDevs(NULL, NULL, NULL, DIGCF_ALLCLASSES | DIGCF_PRESENT);

    ZeroMemory(&m_DeviceInfoData, sizeof(SP_DEVINFO_DATA));
    int DeviceIndex = 0;
    m_DeviceInfoData.cbSize = sizeof(SP_DEVINFO_DATA);

    DWORD DataT;
    DWORD buffersize = 0;

    while (SetupDiEnumDeviceInfo(
                                 m_hDevInfo,
                                 DeviceIndex,
                                 &m_DeviceInfoData)) {
        DeviceIndex++;

        SetupDiGetDeviceRegistryProperty(
                m_hDevInfo,
                &m_DeviceInfoData,
                SPDRP_DEVICEDESC,
                &DataT,
                NULL,
                0,
                &buffersize);


        BYTE *buffer = (BYTE*)malloc(buffersize);
        SetupDiGetDeviceRegistryProperty(
                m_hDevInfo,
                &m_DeviceInfoData,
                SPDRP_DEVICEDESC,
                &DataT,
                buffer,
                buffersize,
                NULL);

        QString str = QString::fromUtf16((char16_t*)buffer);
        free(buffer);

        if(str=="USB Composite Device"){
            result << "安卓";
            //排除X3上原有的几类驱动
            //获取总线已报备设备名称

//            SP_DEVINFO_DATA m_DeviceData;
//            DEVPROPTYPE m_DevpropType;
//            DWORD bufSize = 0;

//            SetupDiGetDeviceProperty(m_hDevInfo,
//                                     &m_DeviceData,
//                                     &DEVPKEY_Device_BusReportedDeviceDesc,
//                                     &m_DevpropType,
//                                     NULL,
//                                     0,
//                                     &bufSize,
//                                     0);
//            BYTE *buffer = (BYTE*)malloc(bufSize);
//            SetupDiGetDeviceProperty(m_hDevInfo,
//                                     &m_DeviceData,
//                                     &DEVPKEY_Device_BusReportedDeviceDesc,
//                                     &m_DevpropType,
//                                     buffer,
//                                     bufSize,
//                                     NULL,
//                                     0);
//            QString str = QString::fromUtf16((char16_t*)buffer);
//            free(buffer);
//            qDebug()<<"总线已报告："<<str;

            continue;
        }

        if(str=="Apple Mobile Device USB Driver"){
            result << "苹果";
            continue;
        }


    }

    if (m_hDevInfo) {
        SetupDiDestroyDeviceInfoList(m_hDevInfo);
    }

    return result;
}

EnumOnlinePhones::EnumOnlinePhones()
{
    m_thread = new ReadPhonesThread(this);
}

EnumOnlinePhones::~EnumOnlinePhones()
{

}

int  EnumOnlinePhones::startOnlinePhonesMonitor(){//启动手机个数监控

    if(m_thread->isRunning())
    {
        m_thread->m_ReadPhonesThread = FALSE;
    }
    m_thread->m_ReadPhonesThread = TRUE;
    m_thread->startRun();
    return 0;
}
void EnumOnlinePhones::stopOnlinePhonesMonitor(){//停止手机个数监控
    if(m_thread->isRunning())
    {
        m_thread->m_ReadPhonesThread = FALSE;
        while(m_thread->isRunning());
    }
}

void ReadPhonesThread::run(){

    qDebug()<<"手机采集---启动";
    bool isHavePhone = false;


    while( m_ReadPhonesThread )
    {
//        QStringList result = [];//enumOnlinePhones();
//        if(result.length() >= 1 && !isHavePhone){
//            //有手机
//            qDebug()<<"有手机 发信号";
//            isHavePhone = true;

//        }
//        else if(result.length() == 0 && isHavePhone){
//            //没手机
//            qDebug()<<"没手机 发信号";
//            isHavePhone = false;
//        }
    }

}



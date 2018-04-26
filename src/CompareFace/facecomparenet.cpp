#pragma execution_character_set("utf-8")


#include "facecomparenet.h"
#include "src/publicdata.h"
#include <QHttpMultiPart>

//引用windows API
#include <tlhelp32.h>
#pragma comment(lib, "user32.lib")


FaceCompareNet::FaceCompareNet(QObject *parent) : QObject(parent)
{
    qDebug()<<"FaceCompareNet::FaceCompareNet";
    m_pFaceCompareThread = new FaceCompareThread(this);
}

FaceCompareNet::~FaceCompareNet()
{
    //反初始化函数
    //FaceSDK_Stop();//这句一定要加，否则退出后会报异常的！坑！
    qDebug()<<"~FaceCompareNet";
    if(m_pFaceCompareThread!=NULL)
    {
        delete m_pFaceCompareThread;
        m_pFaceCompareThread = NULL;
        qDebug()<<"face 释放";
    }
}

//开始人脸比对
int FaceCompareNet::StartFaceCompare(QString faceImagPath, QString cardImagPath)
{
    qDebug()<<"FaceCompareNet 启动人证比对";
    m_faceImagPath=faceImagPath;
    m_cardImagPath=cardImagPath;
    m_pFaceCompareThread->StartRun();
    return 0;
}

//获取人脸比对结果
QString FaceCompareNet::GetCompareResult(float compareResult , float compareBoundaryValue)
{
    qDebug()<<"face compare result:"<<compareResult<<",boundary-value:"<<compareBoundaryValue;
    if(compareResult >= compareBoundaryValue)
        return "ok";
    else if(compareResult<compareBoundaryValue && compareResult>0)
        return "bad";
    else if(compareResult==0)
    {
        DWORD errorCode = FaceSDK_GetError();

        if(errorCode==0)
            qDebug()<<"face compare error code{0: success}";
        else if(errorCode==111)
            qDebug()<<"face compare error code{111: data packet error}";
        else if(errorCode==222)
            qDebug()<<"face compare error code{222: data format error}";
        else if(errorCode==333)
            qDebug()<<"face compare error code{333: none people face}";
        else if(errorCode==444)
            qDebug()<<"face compare error code{444: data error}";
        else if(errorCode==999)
            qDebug()<<"face compare error code{999: server no response}";
        else
            qDebug()<<"face compare error code{Unknown}"<<errorCode;

        qDebug()<<"Face compare error: compare result:"<<compareResult;
        return "error";
    }
    return "";
}

void FaceCompareThread::run()
{
    FaceCompareNet *parent = (FaceCompareNet *)m_parent;
    //开始比对
    float compareBoundaryValue = parent->m_PerInfo.GetConfigFaceCompareBoundaryValue();
    parent->m_faceImagPath =  parent->m_faceImagPath.mid(8);// file:///
    parent->m_cardImagPath =  parent->m_cardImagPath.mid(8);// file:///

    parent->m_cardImagPath =  parent->m_cardImagPath.replace("\\","/");


    QByteArray baFaceImagPath =  parent->m_faceImagPath.toUtf8();
    char *pFaceImagPath = baFaceImagPath.data();

    QByteArray baCardImagPath =  parent->m_cardImagPath.toUtf8();
    char *pCardImagPath = baCardImagPath.data();
    float compareResult = FaceSDK_CMP(pFaceImagPath,pCardImagPath);
    QString endresult=parent->GetCompareResult(compareResult , compareBoundaryValue);
    emit parent->finishcompare(endresult);

}

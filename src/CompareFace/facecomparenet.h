/********************************************************************
 * 人证比对
 ********************************************************************/

#ifndef FACECOMPARENET_H
#define FACECOMPARENET_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QObject>
#include <QTimer>
#include "src/photoocrinfo.h"
#include "src/CompareOrDetectFace/FaceCompare/FaceSDK.h"

class FaceCompareThread : public QThread
{
        Q_OBJECT
public:
        FaceCompareThread(QObject *parent = 0): QThread(parent)
        {
            m_parent = parent;
            m_FaceCompareThreadRun = TRUE;
        }
        void StartRun()
        {
            start(HighestPriority);
        }
protected:
    void run();
public:
    QObject *m_parent;

    BOOL     m_FaceCompareThreadRun;
};

class FaceCompareNet : public QObject
{
    Q_OBJECT
public:
    explicit FaceCompareNet(QObject *parent = 0);
    ~FaceCompareNet();
signals:
     void finishcompare(QString endresult);
public :
    QString GetCompareResult(float compareResult , float compareBoundaryValue);//获取人脸比对结果
    Q_INVOKABLE int StartFaceCompare(QString faceImagPath, QString cardImagPath);//开始人脸比对

public:
    FaceCompareThread  *m_pFaceCompareThread;
    PersonInfoCollect m_PerInfo;
    QString m_faceImagPath;
    QString m_cardImagPath;
};

#endif // FACECOMPARENET_H

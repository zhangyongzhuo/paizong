/********************************************************************
 * 人证比对
 ********************************************************************/
#ifndef FACECOMPARENET_H
#define FACECOMPARENET_H
#include <QThread>
#include <QObject>
#include <QDebug>
#include <QFile>
#include <QDir>
#include <windows.h>
#include "src/CompareOrDetectFace/FaceCompare/FaceSDK.h"
#include "src/CompareOrDetectFace/FaceDetect/FaceLib.h"
#include <QMetaType>

#include <QJSEngine>
#include <QJSValue>

class CompareOrDetectFaceThread : public QThread
{
    Q_OBJECT
public:
    CompareOrDetectFaceThread(QObject *parent = 0): QThread(parent)
    {
        m_parent = parent;
    }
    void startRun()
    {
        start(HighestPriority);
    }
protected:
    void run();
public:
    QObject *m_parent;
};

class CompareOrDetectFace : public QObject
{
    Q_OBJECT
    Q_ENUMS(EFACE_RET)
    Q_ENUMS(EOPERATE_TYPE)
public:
    enum EFACE_RET{
        EFACE_RET_PASS = 1, //通过
        EFACE_RET_NOPASS,   //不通过
        EFACE_RET_ERROR     //出错
    };

    enum EOPERATE_TYPE{
        EOPERATE_TYPE_ALL = 1,  //人脸截取+比对
        EOPERATE_TYPE_COMPARE,  //比对
        EOPERATE_TYPE_DETECT    //截取
    };
public:
    explicit CompareOrDetectFace(QObject *parent = 0);
    ~CompareOrDetectFace();
signals:
    void compareOrDetectFinished(EFACE_RET ret, QString detectImagPath, QString taskName="");
public :
    //开始人脸比对或截取 参1：操作类型 参2：要截取的照片 参3：要与参2进行比对的照片 参4：比对结果边界值  参5:此次操作的任务名称 参6:剪切后照片存储的路径
    Q_INVOKABLE void startFaceCompareOrDetect(EOPERATE_TYPE type
                                              , QString detectImagPath
                                              , QString compareImagPath
                                              , float   compareBoundaryValue
                                              , QString taskName=""
                                              /*, QString afterDetectPath*/);
//    Q_INVOKABLE void startFaceCompareOrDetect(EOPERATE_TYPE type, QString detectImagPath,
//                                              QString compareImagPath, float compareBoundaryValue,
//                                              QJSValue callback);

//    Q_INVOKABLE int getFaceCompareLicense(){
//        long err = FaceSDK_GetError();
//        qDebug()<<"-----人脸比对结果："<<err;
//        return err;
//    }

public:
    bool copyFileToPath(QString sourceDir, QString toDir, bool coverFileIfExist);
public:
    CompareOrDetectFaceThread  *m_pCompareOrDetectFaceThread;
    EOPERATE_TYPE               m_operateType;
    QString                     m_detectImagPath;
    QString                     m_compareImagPath;
    float                       m_compareBoundaryValue;
//    QJSValue                    m_callback;
    QString                     m_taskName;
public:
    QString       detectImage(); //截取人脸
    EFACE_RET     compareFace(); //比对人脸
};

#endif // FACECOMPARENET_H

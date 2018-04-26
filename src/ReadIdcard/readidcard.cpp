#pragma execution_character_set("utf-8")
#include "readidcard.h"
//#include <QMessageBox>
#include <SetupAPI.h>
#include <QDebug>
#include <QThread>
#include <QDir>


//dll导出函数
typedef int(PASCAL *lpCVR_InitComm)(int port);      //初始化端口
typedef int(PASCAL *lpCVR_CloseComm)();			    //关闭端口
typedef int(PASCAL *lpCVR_Authenticate)();		    //认证信息
typedef int(PASCAL *lpCVR_Read_Content)(int active);//读信息
typedef int(PASCAL *lpCVR_GetSAMID)(int active);    //

lpCVR_InitComm CVR_InitComm;
lpCVR_CloseComm CVR_CloseComm;
lpCVR_Authenticate CVR_Authenticate;
lpCVR_Read_Content CVR_Read_Content;
lpCVR_GetSAMID CVR_GetSAMID;

HINSTANCE dllHandle = NULL;
static BOOL bLoaded = FALSE;
BOOL bReady = FALSE;

ReadIdcard::ReadIdcard()
{
    m_pReadIdcardThread = new ReadIdcardThread(this);
}


ReadIdcard::~ReadIdcard()
{
    //qDebug()<<"~ReadIdcard()";
    bLoaded = FALSE;

    if(bReady){
        stopIdcardIdentification();
    }

    if(dllHandle!=NULL)
    {
        //qDebug()<<"dllHandle!=NULL 执行FreeLibrary";
        FreeLibrary(dllHandle);
        dllHandle = NULL;
        //qDebug()<<"FreeLibrary(dllHandle);";
    }

    if(m_pReadIdcardThread!=NULL)
    {
        delete m_pReadIdcardThread;
        m_pReadIdcardThread = NULL;
        //qDebug()<<"Read ID 释放";
    }
}
//加载dll
BOOL ReadIdcard::loadDll( void )
{
    //qDebug()<<"LoadDll( void )";

    if(!bLoaded)
        bLoaded = TRUE;
    else
        return TRUE;

    //qDebug()<<"if(!bLoaded)";

    QString szDLLPath = QCoreApplication::applicationDirPath();
    szDLLPath.append("\\termb.dll");

    dllHandle=LoadLibrary(szDLLPath.toStdWString().data());
    if (dllHandle!=NULL)
    {
        //qDebug()<<"LoadLibrary(szDLLPath.toStdWString().data())";
        CVR_InitComm=(lpCVR_InitComm)GetProcAddress(dllHandle,("CVR_InitComm"));
        CVR_CloseComm=(lpCVR_CloseComm)GetProcAddress(dllHandle,("CVR_CloseComm"));
        CVR_Authenticate=(lpCVR_Authenticate)GetProcAddress(dllHandle,("CVR_Authenticate"));
        CVR_Read_Content=(lpCVR_Read_Content)GetProcAddress(dllHandle,("CVR_Read_Content"));
        return TRUE;
    }
    else
    {
        //qDebug()<<"dllHandle==NULL";
        return FALSE;
    }
}

//初始化设备
BOOL ReadIdcard::initDevice()
{
    // TODO: Add extra validation here
    BOOL bInitRes = FALSE;
    int iRetUSB=0;
    int iPort=0;
    for (iPort=1001; iPort<=1016; iPort++)
    {
        iRetUSB=CVR_InitComm(iPort);
        if (iRetUSB==1)
        {
            bInitRes = TRUE;
            break;
        }
        if(iRetUSB == 0)
        {
           qDebug()<<"动态库加载失败USB！";
        }
    }

    //m_bInitOK = bInitRes;
    return bInitRes;
}
//关闭设备
BOOL ReadIdcard::closeDevice()
{
    CVR_CloseComm();
    return TRUE;
}
//将读取的身份证信息存入本地
// wz.txt 数据信息
// zp.bmp 身份证照片
//返回值为二代身份证信息
QString ReadIdcard::saveIdcardInfo()
{
    int j=0;
    QString strTxtPath = QCoreApplication::applicationDirPath();
    strTxtPath.append("\\wz.txt");

    QFile file(strTxtPath);
    QString ret;
    QJsonObject json_object;
    QJsonDocument json_doc;

    if(file.exists())
    {
        if(!file.open(QIODevice::ReadWrite|QIODevice::Text)){
           return "";
        }
        QString readIdcardInfo;
        QTextStream in(&file);
        in.setCodec("UTF-16");
        readIdcardInfo = in.readAll();
        QStringList stringList = readIdcardInfo.split(' ');
        for(int i=0;i<stringList.size();i++){
            if(stringList.at(i)!=""){
                switch(j)
                {
                    case 0:
                    {
                        json_object.insert("name",stringList.at(i) );
                        j++;
                        break;
                    }
                    case 1:
                    {

                        QString tmpCode;
                        QString nationStr;
                        QString birthStr;
                        QString addressStr;

                        if(stringList.at(i).mid(0,1)=="1"){
                            json_object.insert("sex","男");
                        }else{
                            json_object.insert("sex","女");
                        }
                        tmpCode=stringList.at(i).mid(1,2);
                        nationStr=getDecodeNation(tmpCode.toInt());
                        birthStr=stringList.at(i).mid(3,4)+"年"+stringList.at(i).mid(7,2)+"月"+stringList.at(i).mid(9,2)+"日";
                        addressStr=stringList.at(i).mid(11);

                        json_object.insert("nation",nationStr);
                        json_object.insert("birth",birthStr);
                        json_object.insert("address",addressStr);
                        j++;
                        break;
                    }
                    case 2:
                    {
                        json_object.insert("idcard",stringList.at(i).mid(0,18));
                        json_object.insert("depart",stringList.at(i).mid(18));
                        j++;
                        break;
                    }
                    case 3:
                    {
                        json_object.insert("validdate",stringList.at(i));
                        j++;
                        break;
                    }
                 }
            }

        }
        file.close();
    }
    QString strPhotoPath = QCoreApplication::applicationDirPath();
    strPhotoPath.append("\\zp.bmp");

    copyFileToPath(strPhotoPath,m_photoPath,true);
    ////////////////////////////////////////////显示照片
    //载入图片
    //if(::GetFileAttributes(strPhotoPath.toStdWString().data())== -1)//文件不存在
    if(::GetFileAttributes(m_photoPath.toStdWString().data())== -1)//文件不存在
    {
        json_object.insert("face","");
    }
    else//文件存在
    {
         json_object.insert("face",m_photoPath);
    }
    json_doc.setObject(json_object);
    ret = json_doc.toJson();
    return ret;
}

//检测二代证键盘设备ID： USB\VID_0400&PID_C35A&REV_0063
//USB\VID_0400&PID_C35A
BOOL ReadIdcard::detectKeyboardDevice( void )
{
    BOOL result = FALSE;
    QString strDeviceID;

    DWORD dwFlag = (DIGCF_ALLCLASSES | DIGCF_PRESENT);
    HDEVINFO hDevInfo = SetupDiGetClassDevs(NULL, NULL, NULL, dwFlag);
    if( INVALID_HANDLE_VALUE == hDevInfo )
    {
        SetupDiDestroyDeviceInfoList(hDevInfo);
        return result;
    }
    // 准备遍历所有设备查找USB
    SP_DEVINFO_DATA sDevInfoData;
    sDevInfoData.cbSize = sizeof(SP_DEVINFO_DATA);
    TCHAR szDIS[MAX_PATH]; // Device Identification Strings,
    DWORD nSize = 0 ;
    for(int i = 0; SetupDiEnumDeviceInfo(hDevInfo,i,&sDevInfoData); i++ )
    {
        nSize = 0;
        if ( !SetupDiGetDeviceInstanceId(hDevInfo, &sDevInfoData, szDIS, sizeof(szDIS), &nSize) )
        {
            break;
        }

        strDeviceID = QString::fromUtf16((const ushort*)szDIS); //WcharToChar

        strDeviceID.toUpper();
        strDeviceID = strDeviceID.left(21);
        if( strDeviceID == "USB\\VID_0400&PID_C35A" )
        {
            result = TRUE;
            break;
        }
    }

    SetupDiDestroyDeviceInfoList(hDevInfo);
    return result;
}


 //译码名族
QString ReadIdcard::getDecodeNation(int code){
    QString nation;
        switch(code){
        case 01: nation ="汉";break;
        case 02: nation ="蒙古";break;
        case 03: nation ="回";break;
        case 04: nation ="藏";break;
        case 05: nation ="维吾尔";break;
        case 06: nation ="苗";break;
        case 07: nation ="彝";break;
        case 8:  nation ="壮";break;
        case 9:  nation ="布依";break;
        case 10: nation ="朝鲜";break;
        case 11: nation ="满";break;
        case 12: nation ="侗";break;
        case 13: nation ="瑶";break;
        case 14: nation ="白";break;
        case 15: nation ="土家";break;
        case 16: nation ="哈尼";break;
        case 17: nation ="哈萨克";break;
        case 18: nation ="傣";break;
        case 19: nation ="黎";break;
        case 20: nation ="傈僳";break;
        case 21: nation ="佤";break;
        case 22: nation ="畲";break;
        case 23: nation ="高山";break;
        case 24: nation ="拉祜";break;
        case 25: nation ="水";break;
        case 26: nation ="东乡";break;
        case 27: nation ="纳西";break;
        case 28: nation ="景颇";break;
        case 29: nation ="柯尔克孜";break;
        case 30: nation ="土";break;
        case 31: nation ="达斡尔";break;
        case 32: nation ="仫佬";break;
        case 33: nation ="羌";break;
        case 34: nation ="布朗";break;
        case 35: nation ="撒拉";break;
        case 36: nation ="毛南";break;
        case 37: nation ="仡佬";break;
        case 38: nation ="锡伯";break;
        case 39: nation ="阿昌";break;
        case 40: nation ="普米";break;
        case 41: nation ="塔吉克";break;
        case 42: nation ="怒";break;
        case 43: nation ="乌孜别克";break;
        case 44: nation ="俄罗斯";break;
        case 45: nation ="鄂温克";break;
        case 46: nation ="德昂";break;
        case 47: nation ="保安";break;
        case 48: nation ="裕固";break;
        case 49: nation ="京";break;
        case 50: nation ="塔塔尔";break;
        case 51: nation ="独龙";break;
        case 52: nation ="鄂伦春";break;
        case 53: nation ="赫哲";break;
        case 54: nation ="门巴";break;
        case 55: nation ="珞巴";break;
        case 56: nation ="基诺";break;
        case 97: nation ="其他";break;
        case 98: nation ="外国血统中国籍人士";break;
        default :nation ="";
        }
        return nation;
    }


//启动二代证键盘识别获取身份证信息  返回值身份证信息json字符串
int ReadIdcard::startIdcardIdentification(QString photoPath)
{
    m_photoPath = photoPath;
    if(!m_pReadIdcardThread->isRunning())
    {
        //m_pReadIdcardThread->m_ReadIdcardThreadRun = FALSE;
        m_pReadIdcardThread->m_ReadIdcardThreadRun = TRUE;
        m_pReadIdcardThread->startRun();
    }

    return 0;
}
//停止二代证键盘识别
void ReadIdcard::stopIdcardIdentification( void ){
    if ( detectKeyboardDevice() )
    {
        closeDevice();
    }
    if(m_pReadIdcardThread->isRunning())
    {
        m_pReadIdcardThread->m_ReadIdcardThreadRun = FALSE;
        while(m_pReadIdcardThread->isRunning());
    }
}

//拷贝文件：
bool ReadIdcard::copyFileToPath(QString sourceDir, QString toDir, bool coverFileIfExist)
{
    toDir.replace("\\","/");
    if (sourceDir == toDir){
        return true;
    }
    if (!QFile::exists(sourceDir)){
        return false;
    }
    QDir *createfile     = new QDir;
    bool exist = createfile->exists(toDir);
    if (exist){
        if(coverFileIfExist){
            createfile->remove(toDir);
        }
    }//end if

    if(!QFile::copy(sourceDir, toDir))
    {
        return false;
    }
    return true;
}

///////////////////////////////////////////////////////////////////
void ReadIdcardThread::run()
{
    qDebug() << "thread start";
    //EMREADIDRESULT  ReadResult;
    ReadIdcard *parent = (ReadIdcard *)m_parent;   
    if ( !parent->loadDll() )
    {
        qDebug() << "load dll failed!";
    }

    while( m_ReadIdcardThreadRun )
    {
        if ( bReady )
        {
            INT nRes =CVR_Authenticate();
            if(nRes== 1)
            {
                if (1==CVR_Read_Content(1) )
                {
                    QString idcardInformation=parent->saveIdcardInfo();
                    //ReadResult = EMREADIDRESULT_IDReadSuccess;
                    emit parent->readIdcardFinished(idcardInformation); //读到数据了
                }
                else
                {
                    //ReadResult = EMREADIDRESULT_IDReadContentErr;
                    qDebug()<<"ID read content Err";
                    //emit parent->ReadIdcardError("ID read content Err");
                }
            }
            else
            {
                //ReadResult = EMREADIDRESULT_IDInitFaild;
                //emit parent->ReadIdcardError("ID init faild");
                //qDebug()<<"ID init faild";
                bReady = FALSE;
            }
        }else{
            if (parent->detectKeyboardDevice())
            {
                if (parent->initDevice() )
                {
                    //qDebug()<<"ReadIdcardThread InitDevice";
                    bReady = TRUE;
                }
            }
        }
    }

    //qDebug() << "thread exit";
}

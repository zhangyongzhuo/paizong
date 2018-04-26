#pragma execution_character_set("utf-8")
#include "QmlData.h"
#include <QCoreApplication>
#include <QDir>
#include <QProcess>
#include "tlhelp32.h"
#include <QSettings>

QmlData::QmlData()
{
    m_AppPath = QCoreApplication::applicationDirPath();
}

//设置警员身份证号
void QmlData::setPoliceIdcard(QString policeIdcard)
{
    m_PoliceIdcard = policeIdcard;
}

//生成档案编号 使用登录的警员身份证号
QString QmlData::makeOptargetId()
{
    QDateTime ctime;
    QString ss;
    ctime = QDateTime::currentDateTime();
    int year=ctime.date().year();
    int month=ctime.date().month();
    int day=ctime.date().day();
    int hour=ctime.time().hour();
    int minute=ctime.time().minute();
    int second=ctime.time().second();
    int msec=ctime.time().msec();
    ss.sprintf("%4d%02d%02d%02d%02d%02d%03d",year,month,day,hour,minute,second,msec);

    return m_PoliceIdcard+ss;
}

//生成档案编号文件夹
QString QmlData::makeOptargetIdDir(QString optargetId)
{
    QString optargetIdDir = m_AppPath+"/../app-data/CollectData";
    bool ok;
    QDir temp;
    bool exist = temp.exists(optargetIdDir);
    if(exist)
    {
        optargetIdDir+="/"+optargetId;
        exist = temp.exists(optargetIdDir);
        if(!exist)
        {
            temp.mkdir(optargetIdDir);
        }
    }
    else
    {
        ok = temp.mkdir(optargetIdDir);
        if( ok )
        {
            //qDebug()<<"create:"+optargetIdDir;
            optargetIdDir+="/"+optargetId;
            exist = temp.exists(optargetIdDir);
            if(!exist)
            {
                temp.mkdir(optargetIdDir);
            }
        }

    }
    //qDebug()<<"optargetIdDir:"<<optargetIdDir;

    return optargetIdDir;
}

QString QmlData::transformImage2Base64(QString imgPath)
{
    QString strRetResult;
    QImage image(imgPath);
    QByteArray ba;
    QBuffer buf(&ba);
    image.save(&buf, "JPG",20);
    strRetResult = ba.toBase64();
    buf.close();
    return strRetResult;
}

QString QmlData::transformBase642Image(QString imgBase64, QString path)
{
    QByteArray ret = QByteArray::fromBase64(imgBase64.toUtf8());
    QImage retResult;
    retResult.loadFromData(ret);
    retResult.save(path);
    return path;
}

bool QmlData::deleteFile(QString path)
{
    return QFile::remove(path);
}

bool QmlData::deleteOptargetIdDir(QString path)
{
    path = m_AppPath+"/../app-data"+path;
    //qDebug()<<"要删的文件夹:"<<path;
    if (path.isEmpty())
        return false;

    QDir dir(path);
    if (!dir.exists())
        return true;

    dir.setFilter(QDir::AllEntries | QDir::NoDotAndDotDot);
    QFileInfoList fileList = dir.entryInfoList();
    QFileInfoList::iterator itFile;
    for (itFile = fileList.begin(); itFile != fileList.end(); ++itFile)
    {
        if ((*itFile).isFile())
            (*itFile).dir().remove((*itFile).fileName());
        else
            deleteDir((*itFile).absoluteFilePath());
    }

    return dir.rmpath(dir.absolutePath());
}

bool QmlData::deleteDir(QString path)
{
    if (path.isEmpty())
        return false;

    QDir dir(path);
    if (!dir.exists())
        return true;

    dir.setFilter(QDir::AllEntries | QDir::NoDotAndDotDot);
    QFileInfoList fileList = dir.entryInfoList();
    QFileInfoList::iterator itFile;
    for (itFile = fileList.begin(); itFile != fileList.end(); ++itFile)
    {
        if ((*itFile).isFile())
            (*itFile).dir().remove((*itFile).fileName());
        else
            deleteDir((*itFile).absoluteFilePath());
    }

    return dir.rmpath(dir.absolutePath());
}

bool QmlData::isRealNumbers(QString src)
{
    QRegExp rxPureNumbers("^[+-]?[0-9]{1,}(\.[0-9]{1,})?$");
    return rxPureNumbers.exactMatch(src);
}

bool QmlData::isPureNumbers(QString src)
{
    QRegExp rxPureNumbers("^[0-9]{1,}$");
    return rxPureNumbers.exactMatch(src);
}

bool QmlData::isContains(QString src, QString specified)
{
    return src.contains(specified, Qt::CaseSensitive);
}

QString QmlData::makeRootDir()
{
    return m_AppPath;
}

QString QmlData::getHttpsUserAndPwd()
{
    return HTTPS_USER_PWD;
}

QString QmlData::cutStr(QString str, int nStartPost, int nEndPost)
{
    if(nEndPost == 0)
        return str.mid(nStartPost);
    else
        return str.mid(nStartPost, nEndPost);
}
bool QmlData::isContainKey(QString str, QString key)
{
    if(str.contains(key)){
        return true;
    }else{
        return false;
    }
}

QString QmlData:: splitStr(QString str,QString  conditions,int nCut)
   {
       QStringList list = str.split(conditions); // 注意，如果str是空字符串，list1会增加一个空字符串到列表里，其size=1，我为此吃过苦头～
       return list[nCut];
   }


//拷贝单个文件
bool QmlData::copyFileToPath(QString sourceDir, QString toDir, bool coverFileIfExist)
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
//拷贝文件下的所有文件
bool QmlData::copyAllFileToPath(QString sourceDir, QString toDir)
{
    sourceDir.replace("\\","/");
    toDir.replace("\\","/");
    if (sourceDir == toDir){
        return true;
    }
    QDir dir(sourceDir);
    if (!dir.exists()){
        return false;
    }
    dir.setFilter(QDir::AllEntries | QDir::NoDotAndDotDot);
    QFileInfoList fileList = dir.entryInfoList();
    foreach (QFileInfo fi, fileList){//遍历文件列表
        if (QFile::exists(toDir+"/"+fi.fileName())){//目标文件夹内已存在此文件，则不拷贝，继续遍历
            continue;
        }
        if(!QFile::copy(sourceDir+"/"+fi.fileName(), toDir+"/"+fi.fileName())){//拷贝文件出错
            return false;
        }
    }
    return true;
}
QString  QmlData::onConvert(QString source)
{
    return source.toUtf8().toPercentEncoding();
}

//调用升级程序客户端
bool QmlData::startUpgradeTool(QString proxyParam)
{
    QString upgradePath = m_AppPath + "/../../hlk-upgrade-service/UpgradeService.exe";
    qDebug()<<"升级客户端路径："<<upgradePath;
    QProcess *process = new QProcess();
    QString workPath =m_AppPath + "/../../hlk-upgrade-service/";
    if(process->startDetached(upgradePath, QStringList(proxyParam), workPath)){
        //qDebug()<<"send param:"<< QStringList(proxyParam);
        return true;
    }else{
        return false;
    }
}


int QmlData::GetProcessidFromName(QString name)
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

QString QmlData::searchSoftwareExecutionPath(QString softwareName)
{
    QString key = "HKEY_LOCAL_MACHINE\\SOFTWARE\\";
    QSettings reg(key+softwareName, QSettings::NativeFormat);
    QString path = reg.value("Path").toString();
    return path;
}
//通过传入进程名称 到注册表中找到路径并启动
int QmlData::StartProcessByName(QString name)
{
    QString temp = searchSoftwareExecutionPath(name);
    QString videoPath = temp+"\\"+name+".exe";
    QProcess process;
    if(process.execute(videoPath, QStringList())==0)
    {
        return true;
    }
    else
    {
        return false;
    }

}
QString QmlData::getNation(int code){
    QString strNation;
    switch(code)
    {
    case 01: strNation ="汉";break;
    case 02: strNation ="蒙古";break;
    case 03: strNation ="回";break;
    case 04: strNation ="藏";break;
    case 05: strNation ="维吾尔";break;
    case 06: strNation ="苗";break;
    case 07: strNation ="彝";break;
    case 8:  strNation ="壮";break;
    case 9:  strNation ="布依";break;
    case 10: strNation ="朝鲜";break;
    case 11: strNation ="满";break;
    case 12: strNation ="侗";break;
    case 13: strNation ="瑶";break;
    case 14: strNation ="白";break;
    case 15: strNation ="土家";break;
    case 16: strNation ="哈尼";break;
    case 17: strNation ="哈萨克";break;
    case 18: strNation ="傣";break;
    case 19: strNation ="黎";break;
    case 20: strNation ="傈僳";break;
    case 21: strNation ="佤";break;
    case 22: strNation ="畲";break;
    case 23: strNation ="高山";break;
    case 24: strNation ="拉祜";break;
    case 25: strNation ="水";break;
    case 26: strNation ="东乡";break;
    case 27: strNation ="纳西";break;
    case 28: strNation ="景颇";break;
    case 29: strNation ="柯尔克孜";break;
    case 30: strNation ="土";break;
    case 31: strNation ="达斡尔";break;
    case 32: strNation ="仫佬";break;
    case 33: strNation ="羌";break;
    case 34: strNation ="布朗";break;
    case 35: strNation ="撒拉";break;
    case 36: strNation ="毛南";break;
    case 37: strNation ="仡佬";break;
    case 38: strNation ="锡伯";break;
    case 39: strNation ="阿昌";break;
    case 40: strNation ="普米";break;
    case 41: strNation ="塔吉克";break;
    case 42: strNation ="怒";break;
    case 43: strNation ="乌孜别克";break;
    case 44: strNation ="俄罗斯";break;
    case 45: strNation ="鄂温克";break;
    case 46: strNation ="德昂";break;
    case 47: strNation ="保安";break;
    case 48: strNation ="裕固";break;
    case 49: strNation ="京";break;
    case 50: strNation ="塔塔尔";break;
    case 51: strNation ="独龙";break;
    case 52: strNation ="鄂伦春";break;
    case 53: strNation ="赫哲";break;
    case 54: strNation ="门巴";break;
    case 55: strNation ="珞巴";break;
    case 56: strNation ="基诺";break;
    case 97: strNation ="其他";break;
    case 98: strNation ="外国血统中国籍人士";break;
    default :strNation ="";
    }
    return strNation;
}

QString QmlData::GetDeviceId()
{
    return g_deviceId;
}

//--依据年、月判断最大日
QString QmlData::nextMonthMaxDay(int year,int month,int day){
    //是否2月?(闰年29，非闰28):(小月？30天:31天)
    int maxDay = 0;
    int nextDay = 0;
    if(month == 2){
        if(isLeapYear(year)){
            maxDay = 29;
            if(day==29){
                if(month<12){
                    month=month+1;
                }else{
                    month=1;
                    year=year+1;
                }
                nextDay=1;
            }else{
                nextDay=day+1;
            }
        }else{
            maxDay = 28;
            if(day==28){
                if(month<12){
                    month=month+1;
                }else{
                    month=1;
                    year=year+1;
                }
                nextDay=1;
            }else{
                nextDay=day+1;
            }
        }
    }else{
        if(isBigMonth(month)){
            maxDay = 31;
            if(day==31){
                if(month<12){
                    month=month+1;
                    nextDay=1;
                }else{
                    month=1;
                    year=year+1;
                    nextDay=1;
                }
                nextDay=1;
            }else{
                nextDay=(day+1);
            }
        } else {
            maxDay = 30;
            if(day==30){
                if(month<12){
                    month=month+1;
                }else{
                    month=1;
                    year=year+1;
                }
                nextDay=1;
            }else{
                nextDay=day+1;
            }
        }
    }
    return QString::number(year, 10)   + '-' + QString::number(month, 10) +'-'+QString::number(nextDay, 10);
}

bool QmlData::isBigMonth(int month){
    bool bigMonth = false;
    if(month !=4&&month !=6&&month !=9&&month !=11){
        bigMonth = true;
    }else{
        bigMonth = false;
    }
    //console.log("month is bigMonth:",bigMonth)
    return bigMonth;
}
//--判断是否闰年
bool QmlData::isLeapYear(int year){
    bool leap = false;
    if(year%400==0||year%4==0&&year%100!=0)
        leap = true ;//是闰年
    else
        leap = false; //不是闰年
    //console.log(year,"is leap year:",leap)
    return leap;
}
//QString转int
int QmlData::str_int(QString str){
    return atoi(str.toLatin1().data());
}
//int转QString
QString QmlData::int_str(int str){
    return QString::number(str, 10) ;
}
//判断文件是否存在 参数 文件名带绝路径 如果没有绝对路径默认当前工作路径
bool QmlData::isFileExist(QString fileName)
{
    QFile file(m_AppPath + "/" + fileName);
    return file.exists();
}
//调用小键盘
bool QmlData::startVkeyBoard()
{
    QString keyBoardPath = m_AppPath + "/V2.0/VkeyBoard.exe";
    //qDebug()<<"小键盘调用路径："<<keyBoardPath;
    QProcess *process = new QProcess();
    QStringList args;
    args.append("-hwnd");
    if(process->startDetached(keyBoardPath,args))
    {
        return true;
    }
    else
    {
        return false;
    }
}

//根据进程名字杀死进程
int QmlData::killTaskl(const QString& exe)
{
    //1、根据进程名称找到PID
    HANDLE hProcessSnap;
    PROCESSENTRY32 pe32;

    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hProcessSnap == INVALID_HANDLE_VALUE)
    {
        return -1;
    }

    pe32.dwSize = sizeof(PROCESSENTRY32);

    if (!Process32First(hProcessSnap, &pe32))
    {
        CloseHandle(hProcessSnap);
        return -1;
    }

    BOOL    bRet = FALSE;
    DWORD dwPid = -1;
    while (Process32Next(hProcessSnap, &pe32))
    {
        //将WCHAR转成const char*
        int iLn = WideCharToMultiByte (CP_UTF8, 0, const_cast<LPWSTR> (pe32.szExeFile), static_cast<int>(sizeof(pe32.szExeFile)), NULL, 0, NULL, NULL);
        std::string result (iLn, 0);
        WideCharToMultiByte (CP_UTF8, 0, pe32.szExeFile, static_cast<int>(sizeof(pe32.szExeFile)), const_cast<LPSTR> (result.c_str()), iLn, NULL, NULL);
        if (0 == strcmp(exe.toStdString().c_str(), result.c_str ()))
        {
            dwPid = pe32.th32ProcessID;
            bRet = TRUE;
            qDebug()<<"zhaodao";
            break;
        }
    }

    CloseHandle(hProcessSnap);
    qDebug()<<dwPid;
   // 2、根据PID杀死进程
    HANDLE hProcess=NULL;
    //打开目标进程
    hProcess=OpenProcess(PROCESS_TERMINATE,FALSE,dwPid);
    if (hProcess==NULL) {
        qDebug()<<"Open Process fAiled ,error:"<<GetLastError();
        return -1;
    }
    //结束目标进程
    DWORD ret=TerminateProcess(hProcess,0);
    if(ret==0) {
        qDebug()<<"kill task faild,error:"<<GetLastError();
        return -1;
    }

    return 0;
}


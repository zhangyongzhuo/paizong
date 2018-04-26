#ifndef QMLDATA_H
#define QMLDATA_H
#include <QString>
#include <QObject>
#include <QDateTime>
#include <QImage>
#include <QBuffer>
#include <QRegExpValidator>
#include <QDebug>
#include <Windows.h>

#define HTTPS_USER_PWD "FKLJ:FKLJ"
#define RUN_KEY "HKEY_LOCAL_MACHINE\\SOFTWARE\\FKLJ"

extern QString g_deviceId;

class QmlData:public QObject
{
    Q_OBJECT
public:
    QmlData();
    Q_ENUMS(INTO_TYPE)
    Q_ENUMS(FUNCTION_TYPE)
    Q_ENUMS(VISIT_TYPE)
public:
    enum INTO_TYPE{        
        INTO_TYPE_INFOSET = 1,     //信息设置
        INTO_TYPE_VERSONUPDATE,    //版本升级
        INTO_TYPE_POINTCARD_PERSION=15 ,       //卡点盘查-人
        INTO_TYPE_POINTCARD_CAR=16 ,        //卡点盘查-车
        INTO_TYPE_THREEREAL_ROOM = 17,         //实有房屋
        INTO_TYPE_THREEREAL_UNIT = 18,         //实有单位
        INTO_TYPE_THREEREAL_PERSION = 20,       //实有人口

    };
    enum FUNCTION_TYPE{
        FUNCTION_TYPE_ATTENDANCE_CLOCK = 1,    //考勤打卡
        FUNCTION_TYPE_SYSTEMSET=2,     //系统设置
        FUNCTION_TYPE_INFORMATION_ACQUISITION,    //信息采集information acquisition
        FUNCTION_TYPE_POINTCARD      //维稳核查
    };
    enum VISIT_TYPE{                 //进入页面的访问方式
        VISIT_TYPE_INCREASE = 1,     //增加
        VISIT_TYPE_DELETE,           //删除
        VISIT_TYPE_MODIFY,           //修改
        VISIT_TYPE_SEE               //查看
    };
private:
    QString m_PoliceIdcard; //警员身份证号
    QString m_AppPath;

public:
    //设置警员身份证号
    Q_INVOKABLE void setPoliceIdcard(QString policeIdcard);
    //返回根路径
    Q_INVOKABLE QString makeRootDir();
    //生成档案编号 使用登录的警员身份证号
    Q_INVOKABLE QString makeOptargetId();
    //生成档案编号文件夹
    Q_INVOKABLE QString makeOptargetIdDir(QString optargetId);
    //图片-->base64编码
    Q_INVOKABLE QString transformImage2Base64(QString imgPath);        // imgPath为能访问到图片的路径
    //base64编码-->图片
    Q_INVOKABLE QString transformBase642Image(QString imgBase64, QString path);
    //删除本地文件(文件、照片)
    Q_INVOKABLE bool deleteFile(QString path);
    //删除本地文件夹
    Q_INVOKABLE bool deleteDir(QString path);
    Q_INVOKABLE bool deleteOptargetIdDir(QString path);
    //判断一个字符串是否为实数
    Q_INVOKABLE bool isRealNumbers(QString src);
    //判断一个字符串是否只为纯数字组成(不可包含+-.等)
    Q_INVOKABLE bool isPureNumbers(QString src); 
    //是否包含指定字符串
    Q_INVOKABLE bool isContains(QString src, QString specified);
    //返回https用户名及密码
    Q_INVOKABLE QString getHttpsUserAndPwd();
    //剪切字符串
    Q_INVOKABLE QString cutStr(QString str, int nStartPost, int nEndPost);
    //分割字符串
    Q_INVOKABLE QString splitStr(QString str,QString  conditions,int nCut);
    //在字符串中查找是否包含指令字符
    Q_INVOKABLE bool isContainKey(QString str, QString key);
    //拷贝单个文件
    Q_INVOKABLE bool copyFileToPath(QString sourceDir, QString toDir, bool coverFileIfExist);
    //拷贝文件下的所有文件
    Q_INVOKABLE bool copyAllFileToPath(QString sourceDir, QString toDir);
    //汉字转码
    Q_INVOKABLE QString  onConvert(QString source);
    //调用升级程序客户端
    Q_INVOKABLE bool startUpgradeTool(QString proxyParam);
    //通过传入进程名称 查看进程是否存在
    Q_INVOKABLE int GetProcessidFromName(QString name);

    //查找软件安装路径
    Q_INVOKABLE QString searchSoftwareExecutionPath(QString softwareName);

    Q_INVOKABLE int StartProcessByName(QString name);
    Q_INVOKABLE QString getNation(int code);

    //获取软件启动模式
    Q_INVOKABLE QString GetDeviceId();
    //--依据年、月判断最大日
    Q_INVOKABLE QString nextMonthMaxDay(int year,int month,int day);
    
    Q_INVOKABLE bool isBigMonth(int month);
    //--判断是否闰年
    Q_INVOKABLE bool isLeapYear(int year);
    //QString转int
    Q_INVOKABLE int str_int(QString str);
    //int转QString
    Q_INVOKABLE QString int_str(int str);
    //判断文件是否存在 参数 文件名带绝路径 如果没有绝对路径默认当前工作路径
    Q_INVOKABLE bool isFileExist(QString fileName);
    Q_INVOKABLE bool startVkeyBoard();
    //根据进程名字杀死进程
    Q_INVOKABLE int killTaskl(const QString& exe);
};

#endif // QMLDATA_H

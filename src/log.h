#ifndef LOG_H
#define LOG_H
#include <qapplication.h>
#include <stdio.h>
#include <stdlib.h>
#include <QtDebug>
#include <QFile>
#include <QTextStream>
#include <QTextCodec>

void outputMessage(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    static QMutex mutex;
    mutex.lock();

    QString text;
    switch(type)
    {
    case QtDebugMsg:
        text = QString("Debug:");
        break;

    case QtWarningMsg:
        text = QString("Warning:");
        break;

    case QtCriticalMsg:
        text = QString("Critical:");
        break;

    case QtFatalMsg:
        text = QString("Fatal:");
        abort();
    }

    QString message = QString("[%1] %2 %3").arg(QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss")).arg(text).arg(msg);

    QString fileName = QDateTime::currentDateTime().toString("yyyy-MM-dd") + ".txt";
    QString AppPath = QCoreApplication::applicationDirPath();

    QFile file(AppPath+"/../app-data/LogFile/" + fileName);
    file.open(QIODevice::WriteOnly | QIODevice::Append);
    QTextStream text_stream(&file);
    text_stream << message << "\r\n"<< endl;
    file.flush();
    file.close();

    mutex.unlock();
}

inline QString GBK2UTF8(const QString &inStr)
{
    QTextCodec *gbk = QTextCodec::codecForName("GB18030");
    //QTextCodec *utf8 = QTextCodec::codecForName("UTF-8");

    QString g2u = gbk->toUnicode(gbk->fromUnicode(inStr));              // gbk  convert utf8
    return g2u;
}

inline QString UTF82GBK(const QString &inStr)
{
    QTextCodec *gbk = QTextCodec::codecForName("GB18030");
    //QTextCodec *utf8 = QTextCodec::codecForName("UTF-8");

    QString utf2gbk = gbk->toUnicode(inStr.toLocal8Bit());
    return utf2gbk;
}

inline std::string gbk2utf8(const QString &inStr)
{
    return GBK2UTF8(inStr).toStdString();
}

inline QString utf82gbk(const std::string &inStr)
{
    QString str = QString::fromStdString(inStr);

    return UTF82GBK(str);
}

#endif // LOG_H


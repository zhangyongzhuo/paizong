TEMPLATE = app

QT += qml quick webengine multimedia
QT += widgets

CONFIG += c++11

TARGET = hlk-amss

SOURCES += main.cpp \
    src/ReadIdcard/readidcard.cpp \
    src/CompareOrDetectFace/CompareOrDetectFace.cpp \
    src/CheckAuthorization/CheckAuthorization.cpp \
    QmlData.cpp \
    src/OperateHttp/OperateHttp.cpp \
    src/OperateConfigFile/OperateConfigFile.cpp \
    src/OcrIdcardOrBlurDetect/OcrIdcardOrBlurDetect.cpp \
    src/OcrCar/ocrcar.cpp \
    src/MonitorProcess/monitorprocess.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    logo.rc

RC_FILE = logo.rc

HEADERS += \
    src/CompareOrDetectFace/CompareOrDetectFace.h \
    src/CompareOrDetectFace/FaceDetect/FaceLib.h \
    src/ReadIdcard/readidcard.h \
    src/CompareOrDetectFace/FaceCompare/FaceSDK.h \
    src/CheckAuthorization/CheckAuthorization.h \
    QmlData.h \
    src/OperateHttp/OperateHttp.h \
    src/log.h \
    src/OperateConfigFile/OperateConfigFile.h \
    src/OcrIdcardOrBlurDetect/OcrIdcardOrBlurDetect.h \
    src/OcrCar/ocrcar.h \
    src/MonitorProcess/monitorprocess.h

LIBS += -L$$PWD\src\CompareOrDetectFace\FaceCompare -lFaceSDK
LIBS += -L$$PWD\src\CompareOrDetectFace\FaceDetect -lFaceLib
LIBS += -L$$PWD\src\OcrIdcardOrBlurDetect\OcrInterface -lOcrInterface
LIBS += -L$$PWD\src\OcrIdcardOrBlurDetect\BlurDetect -lBlurDetect
LIBS += -L$$PWD\src\ReadIdcard\utility -lutility
LIBS += -L$$PWD\src\OcrCar\plateocr -lPlateOcr
LIBS += -lSetupapi
LIBS += -LCfgmgr32
LIBS += -L$$PWD\src\CheckAuthorization\OpenSSL\lib -llibcrypto
LIBS += -L$$PWD\src\CheckAuthorization\OpenSSL\lib -llibssl
LIBS += -L$$PWD\src\CheckAuthorization\Validate -lPcInfo
LIBS += -L$$PWD\src\CheckAuthorization\Validate -lSafeDll
LIBS += -L$$PWD\src\curl -llibcurl
LIBS += -L$$PWD\src\dgb -ldbghelp
QMAKE_CXXFLAGS += /MP

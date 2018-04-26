import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL

Rectangle{
    property string norml_color: JSL.themeColor()
    property string abnormal_color: "#FF5A5A"
    property string normal_interval_color: "#E5F7FA"
    property string abnormal_interval_color: "#FFEEEE"
    property string devID: ""
    property bool bNormal: true //true 正常， false 异常
    property string bottomText: "正常"
    property bool bUnderline: false
    property string text_page1_line1: ""
    property string text_page1_line2: ""
    property string text_page1_line3: ""
    property string text_page1_line4: ""
    property string text_page2_line1: ""
    property string text_page2_line2: ""
    property string text_page2_line3: ""
    property string text_page2_line4: ""
    property bool bNormalPhonebook: true
    property bool bNormalSms: true
    property bool bNormalCalllog: true
    property bool bNormalApp: true
    property bool bTurn: true
    property bool bTerr: false
    property bool bTurnEnable: true
    property bool delEnable: true
    signal deleteButtonClicked()
    signal phoneInfoChangeLook()
    signal addPhoneNumber()
    radius: 10
    width: 170
    height: 220
    border.width: 1
    border.color: bNormal ? norml_color : abnormal_color
    color: "#00000000"
    clip: true
    Rectangle{//上区域 暴恐音视频
        radius: 10
        anchors.top: parent.top
        anchors.topMargin: 1
        width: parent.width-3
        height: 180
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#FFFFFF"
        clip: true
        visible: bTerr ? true : false
        Image{
            source:"qrc:/images/images/bkysp.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Rectangle{//上区域
        visible: bTerr ? false : true
        radius: 10
        anchors.top: parent.top
        anchors.topMargin: 1
        width: parent.width-3
        height: 180
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#FFFFFF"
        clip: true
        Flow{//页1
            id: page1
            width: parent.width
            height: 170
            Rectangle{//行1
                radius: 10
                width: 168
                height: 40
                clip: true
                Text{
                    font.family: "SimHei"
                    font.pixelSize: 20
                    color: "#474747"
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    text: text_page1_line1
                }
            }
            Rectangle{//行2
                width: 168
                height: 40
                clip: true
                color: bNormal ? normal_interval_color : abnormal_interval_color
                Text{
                    font.family: "SimHei"
                    font.pixelSize: 20
                    color: "#474747"
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    text: text_page1_line2
                }
            }
            Rectangle{//行3
                width: 168
                height: 40
                clip: true
                Text{
                    font.family: "SimHei"
                    font.pixelSize: 20
                    color: "#474747"
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    text: text_page1_line3
                }
            }
            Rectangle{//行4
                width: 168
                height: 40
                clip: true
                color: bNormal ? normal_interval_color : abnormal_interval_color
                Text{
                    font.family: "SimHei"
                    font.pixelSize: 20
                    color:  bUnderline ? "#FF5A5A" : "#474747"
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    font.underline: bUnderline ? true : false
                    text: bUnderline ? "点击补充手机号" : text_page1_line4
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            if(bUnderline){
                                emit: addPhoneNumber()
                            }
                        }
                    }
                }
            }
        }
        Flow{//页2
            id: page2
            width: parent.width
            height: 170
            visible: false
            Rectangle{//行1
                radius: 10
                width: 168
                height: 40
                clip: true
                Text{
                    font.family: "SimHei"
                    font.pixelSize: 20
                    color: bNormalPhonebook ? "#474747" : "#FF5A5A"
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    text: text_page2_line1
                }
            }
            Rectangle{//行2
                width: 168
                height: 40
                clip: true
                color: bNormal ? normal_interval_color : abnormal_interval_color
                Text{
                    font.family: "SimHei"
                    font.pixelSize: 20
                    color:  bNormalSms ? "#474747" : "#FF5A5A"
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    text: text_page2_line2
                }
            }
            Rectangle{//行3
                width: 168
                height: 40
                clip: true
                Text{
                    font.family: "SimHei"
                    font.pixelSize: 20
                    color:  bNormalCalllog ? "#474747" : "#FF5A5A"
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    text: text_page2_line3
                }
            }
            Rectangle{//行4
                width: 168
                height: 40
                clip: true
                color: bNormal ? normal_interval_color : abnormal_interval_color
                Text{
                    font.family: "SimHei"
                    font.pixelSize: 20
                    color:  bNormalApp ? "#474747" : "#FF5A5A"
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    text: text_page2_line4
                }
            }
        }
    }
    Rectangle{//遮挡
        z: 1
        anchors.top: parent.top
        anchors.topMargin: 172
        width: parent.width-2
        height: 13
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#FFFFFF"
        anchors.horizontalCenterOffset: 0
    }
    Rectangle{//下区域
        radius: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        width: parent.width
        height: 40
        color: bNormal ? norml_color : abnormal_color
        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 7
            font.family: "SimHei"
            font.pixelSize: 20
            color: "#FFFFFF"
            text: bottomText
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(bTurnEnable){
                    if (bTurn) {
                        page1.visible = false
                        page2.visible = true
                        bTurn = false
                    } else {
                        page1.visible = true
                        page2.visible = false
                        bTurn = true
                    }
                }
            }
        }
    }
    HLK_SimpleImageButton{
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.right: parent.right
        anchors.rightMargin: 2
        normal_path: "qrc:/images/images/tb002-2.png"
        checked_path: "qrc:/images/images/tb002-2.png"
        width: 20
        height: 20
        visible: delEnable
        onClicked: {
            emit: deleteButtonClicked()
        }
    }
}

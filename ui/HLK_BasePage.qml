import QtQuick 2.4
import QtGraphicalEffects 1.0
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL

//基础页面
Rectangle{
    property string pageTitle : "无标题"
    property string themeColor: JSL.themeColor()
    property alias finish: finish
    property alias back: back
    property bool bFinishButtonClicked: false

    property bool bBackUsed: true

    width: 1280
    height: 768
    color: '#f2f2f4'

    MouseArea {
        anchors.fill: parent
        onClicked: {
            emit: componentRecovery()
        }
    }

    Rectangle{
        width: parent.width
        height: 80
        color: themeColor

        Text {//标题
            id: title
            color: "#FFFFFF"
            text: pageTitle
            font.pixelSize: 26
            font.family: "黑体"
            font.bold: true
            anchors.centerIn: parent
        }

        //返回
        HLK_ToolButton{
            id: back
            x: 10
            anchors.verticalCenter: parent.verticalCenter
            imgPath: "qrc:/images/images/back.png"
            btnText: "返回"
            onClicked: {
                if(bBackUsed){ //返回按钮可用
                    if(typeof stackView.currentItem.beforePopEvent !== 'undefined'){
                        stackView.currentItem.beforePopEvent()
                    }
                    stackView.pop()
                    if(typeof stackView.currentItem.afterPopEvent !== 'undefined'){
                        stackView.currentItem.afterPopEvent()
                    }
                }
            }
        }

        //完成
        HLK_ToolButton{
            id: finish
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.verticalCenter: parent.verticalCenter
            imgPath: "qrc:/images/images/finish.png"
            btnText: "完成"
        }
    }
}






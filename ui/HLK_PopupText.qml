import QtQuick 2.0
import "qrc:/base/js/common.js" as JSL

Rectangle{
    property string popupWindowTitle:""
    property string themeColor: JSL.themeColor()
    property alias controlArea: controlArea
    property bool isShowClose: false
    property int windowHeight: 200
    property int popWidth:500
    //property alias title: title

    id: popupWindow

    width: 1280
    height: 768
    color: "#99000000"
    Rectangle{
        id: controlArea
        anchors.centerIn: parent
        width: popWidth
        height: windowHeight
        color: "#FFFFFF"
        radius: 10

        HLK_TextEdit {
            id: title
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.left: parent.left
            anchors.leftMargin: 20
            width:popWidth-40
            textSize: 20
            onCursorVisibleChanged: {
                if(title.cursorVisible){
                    if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                        qmlData.startVkeyBoard()
                    }
                }else{
                    getFocus.focus = true
                }
            }
            onTextChanged: {
                popupWindowTitle=title.text
            }
        }

        HLK_SimpleImageButton{
            id: close
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            normal_path: "qrc:/images/images/close_2.png"
            checked_path: "qrc:/images/images/close_1.png"
            onClicked: {
                popupWindow.visible = false
            }
            visible: isShowClose
        }

        Rectangle{
            y:70 + title.height
            anchors.horizontalCenter: parent.horizontalCenter
            width: popWidth-40
            height: 1
            color: "#DBDBDB"
        }
    }
    Connections{
        target: mainQml
        onOtherPlus:{
            title.text=""
        }
    }
}


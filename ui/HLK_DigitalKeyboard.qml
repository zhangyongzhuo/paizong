import QtQuick 2.4
import "qrc:/base/js/common.js" as JSL
Rectangle{
    property alias keyboard: keyboard
    id: keyboard
    color: "#99000000"
    width: 400
    height: 335


    onVisibleChanged: {
        if(visible){
            emit: digiPressChanged("")
        }
    }

    Rectangle{
        width: 395
        height: 25
        color: JSL.themeColor()
        HLK_SimpleImageButton{
            id: close
            anchors.right: parent.right
            normal_path: "qrc:/images/images/close.png"
            checked_path: "qrc:/images/images/close_x.png"
            width: 25
            height: 25
            onClicked: {
                keyboard.visible = false
                getFocus.focus = true

            }
        }
    }
    Flow{
        id: digiKeyPage
        width:400
        height:335
        spacing:10
        anchors.left: parent.left
        anchors.leftMargin: 7
        anchors.top: parent.top
        anchors.topMargin: 35
        HLK_PlateNumberKey{ keyText: "1"; keyEvent.onClicked: { digiTextChange("1")}}
        HLK_PlateNumberKey{ keyText: "2"; keyEvent.onClicked: { digiTextChange("2")}}
        HLK_PlateNumberKey{ keyText: "3"; keyEvent.onClicked: { digiTextChange("3")}}
        HLK_PlateNumberKey{ keyText: "4"; keyEvent.onClicked: { digiTextChange("4")}}
        HLK_PlateNumberKey{ keyText: "5"; keyEvent.onClicked: { digiTextChange("5")}}
        HLK_PlateNumberKey{ keyText: "6"; keyEvent.onClicked: { digiTextChange("6")}}
        HLK_PlateNumberKey{ keyText: "7"; keyEvent.onClicked: { digiTextChange("7")}}
        HLK_PlateNumberKey{ keyText: "8"; keyEvent.onClicked: { digiTextChange("8")}}
        HLK_PlateNumberKey{ keyText: "9"; keyEvent.onClicked: { digiTextChange("9")}}
        HLK_PlateNumberKey{ keyText: "0"; keyEvent.onClicked: { digiTextChange("0")}}
        HLK_PlateNumberKey{ keyText: "X"; keyEvent.onClicked: { digiTextChange("X")}}
        HLK_PlateNumberKey{ keyText: "删除"; keyEvent.onClicked: { digiTextChange(""); digiTextDel()}}
    }

    HLK_MultilineTextEdit {
        id: getFocus
        visible: false
    }
}


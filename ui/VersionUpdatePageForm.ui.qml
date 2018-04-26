import QtQuick 2.4
import "qrc:/controls/ui"
import QtQuick.Controls 1.2
import QtMultimedia 5.4

HLK_BasePage{
    pageTitle: "在线更新"
    property alias versionBtn: versionBtn  //检查版本
    Rectangle {
        width: 1235
        x: 20
        y: 275
        height: 125
        color: "#FFFFFF"
        radius: 10

        HLK_Button {
            x: parent.x + 450
            anchors.verticalCenter: parent.verticalCenter
            id: versionBtn
            button_text: "检查版本"
            width: 260
            height: 50
        }
    }
    //property alias updateprogress: updateprogress  //进度条
   /* Rectangle {
        x: 10
        y: 100
        width: 1235
        height: 500
        color: "#FFFFFF"
        radius: 10
        Rectangle {
            anchors.centerIn: parent
            width: 680
            height: 460*/

//            HLK_BusyProgress{
//                id:updateprogress
//                x: 200
//                y: 300
//            }
//            HLK_NormalText{
//                id:percent
//                x:350
//                y:370
//                font.pixelSize:50
//                textFormat: Text.RichText
//                text: updateprogress.rectangle+'<font size="-2">  正在更新!</font>'
//            }
//        }
//    }


    HLK_MessageBox{
        id: messagebox
    }
}

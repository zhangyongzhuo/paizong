import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

RadioButton {
    property int btnWidth: 94
    property int btnHeight: 80
    //property bool   btnEnabled: true
    property string btnText: "24"
    property bool   btnBaseColorVisible : false      //基础底色是否显示
    property bool   btnState : true                 //当前是否异常
    property bool   btnStateVisible : false          //异常状态是否显示
    property bool   isBlack : true   //字体颜色是否为黑色 正常字黑色 反之灰色

    width:btnWidth
    height:btnHeight
    //enabled:btnEnabled

    style: RadioButtonStyle{
        indicator: null

        background: Rectangle{

            Rectangle {
                visible: btnBaseColorVisible

                width: 50
                height: 50
                color: '#B2E7F0'
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10
                radius: 180
                antialiasing: true
                smooth: true
            }

            Rectangle {
                width: 50
                height: 50
                color: checked ? JSL.themeColor() : '#FFFFFF'
                opacity: checked ? 1 : 0
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10
                radius: 180
                antialiasing: true
                smooth: true
            }

            Text {
                text: btnText
                font.pixelSize: 40
                font.family: "SimHei"
                color: checked ? "white" : (isBlack ? "black": "#CACACA")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 15
            }

            Rectangle {
                color: btnState ? JSL.themeColor() : '#FF943E'
                visible: btnStateVisible
                width: 10
                height: 10
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                radius: 180                
                antialiasing: true
                smooth: true
            }
        }
    }
}



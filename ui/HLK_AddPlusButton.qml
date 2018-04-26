import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL

Button{
    width: 40
    height: 40
    property string imgPath: ""
    property string themeColor: JSL.themeColor()
    property string button_sound: "qrc:/sounds/sounds/about.wav"
    style: ButtonStyle{
        background: Rectangle{
            anchors.fill: parent
            color: "#EEEEEE"
            radius: 5
            border.width: 1
            border.color: pressed ? themeColor : "#EEEEEE"
            layer.enabled: pressed ? true : false           //第一个是图层是否起用
            layer.effect: DropShadow {                      //图层起作用后表现形式是阴影
                transparentBorder: true                     //透明边框
                color: themeColor
                radius:  8
                samples: 16
            }
            Image{
                z: 1
                width:24
                height:24
                anchors.centerIn: parent
                source: "qrc:/images/images/rzbd_add2.png"
            }
        }
    }
}



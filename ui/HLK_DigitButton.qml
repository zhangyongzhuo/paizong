import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL

Button{
    width: btnwidth
    height: 225-53
    property string imgPath: ""
    property string maxText: ""
    property string minText: ""
    property bool isvisible:false
    property string themeColor: JSL.themeColor()
    property string button_sound: "qrc:/sounds/sounds/about.wav"
    property int btnwidth:160

    style: ButtonStyle{
        background: Rectangle{
            anchors.fill: parent
            color: "#FFFFFF"
            radius: 10
            border.width:  0
            border.color: pressed ?toptext.color =themeColor: toptext.color="#949494"
            layer.enabled: false
            layer.effect: DropShadow {
                transparentBorder: true
                color: themeColor
                radius:  8
                samples: 16
            }


            Rectangle{
                width: 1
                height: 109
                color: "#cecece"
                x:5
                anchors.top: parent.top
                anchors.topMargin: 30
                visible:isvisible
//                anchors.left: parent.right
//                anchors.leftMargin:10
//                anchors.verticalCenter: parent.verticalCenter
//                anchors.centerIn: parent
            }
            Text{
                id:toptext
                anchors.top: parent.top
                anchors.topMargin: 43
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "SimHei"
                font.pixelSize: 60
                color: "#474747" //"#949494"
                text: maxText
            }
            Text{
                id:bottomtext
                anchors.top: toptext.bottom
                anchors.topMargin: 18
//                    anchors.bottom: parent.bottom
//                    anchors.bottomMargin: 40
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "SimHei"
                font.pixelSize: 20
                color: "#474747"//"#8d8d8d"
                text: minText
            }

        }
    }
//    Audio{
//        id: sound
//        source: button_sound
//    }
//    onClicked: {
//        sound.play()
//    }

}



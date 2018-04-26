import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL

Button{
    width: btnwidth
    height: 100
    property string imgPath: ""
    property string leftImage:""
    property string maxText: ""
    property string minText: ""
    property bool isvisible:false
    property string themeColor: JSL.themeColor()
    property string button_sound: "qrc:/sounds/sounds/about.wav"
    property int btnwidth:100
    property int maxSize:60
    property int toprec:10
    property string publicColor: "#FFFFFF"

    style: ButtonStyle{
        background: Rectangle{
            anchors.fill: parent
            //color: publicColor
            Image {
                source: leftImage
            }
            radius: 10
           // border.width:  0
           // border.color: pressed ?toptext.color ="#ffffff": toptext.color="#ffffff"
            layer.enabled: false
            layer.effect: DropShadow {
                transparentBorder: true
                color: themeColor
                radius:  8
                samples: 16
            }
            Text{
                id:toptext
                anchors.top: parent.top
                anchors.topMargin: toprec
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "SimHei"
                font.pixelSize:maxSize
                color: "#ffffff"
                text: maxText
            }
            Text{
                id:bottomtext
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "SimHei"
                font.pixelSize: 16
                color: "#ffffff"
                text: minText
            }

        }
    }
    Audio{
        id: sound
        source: button_sound
    }
    onClicked: {
        sound.play()
    }

}



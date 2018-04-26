import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

Button{
    property string imgPath: ""
    property string btnText: ""
    property string themeColor: JSL.themeColor()
    property string button_sound: "qrc:/sounds/sounds/about.wav"
    property bool   mute: false
    property int    textLeftMargin: 18

    id: btn
    height: 40
    width: 100
    style: ButtonStyle{
        background: Rectangle{
            color:  control.pressed ? "#118DA2" : themeColor
            Image{
                fillMode: Image.Pad
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                source: imgPath
            }
        }
        label: HLK_NormalText{
            text: btnText
            anchors.left: parent.left
            anchors.leftMargin: textLeftMargin
            font.pixelSize: 20
            color: "#FFFFFF"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Timer{
        id: timeout
        interval: 500
        repeat: false
        onTriggered: {
           enabled = true
        }
    }
    onClicked: {
        timeout.start()
        enabled = false
    }

//    Audio{
//        id: sound
//        source: button_sound
//    }

//    onClicked: {
//        if(!mute){
//            sound.play()
//        }
//    }
}



import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL

Button{
    height: 100
    property string imgPath: ""
    property string btnText: ""
    property int btnwidth: 216
    property string themeColor: JSL.themeColor()
    property string button_sound: "qrc:/sounds/sounds/about.wav"
    property bool isShowAdd: true
    property bool isShowRight: false

    width: btnwidth
    style: ButtonStyle{
        background: Rectangle{
            anchors.fill: parent
            color: "#EDEDED"
            radius:10
            border.width: pressed ? 1 : 0
            border.color: pressed ? themeColor : "#EDEDED"
            layer.enabled: pressed ? true : false
            layer.effect: DropShadow {
                transparentBorder: true
                color: themeColor
                radius:  8
                samples: 16
            }
            Image{
                anchors.fill: parent
                source: imgPath
//                Row{
//                    // anchors.centerIn: parent
//                     spacing:10
                    Image{
                       // anchors.verticalCenter: parent.verticalCenter
                        id:addpng
                        source: "qrc:/images/images/ly_add.png"
                        anchors.top: parent.top
                        anchors.topMargin: 45
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        visible: isShowAdd
                    }
                    Text{
                        id:centertext
                        anchors.top: parent.top
                        anchors.topMargin: 40
                        anchors.left: addpng.right
                        anchors.leftMargin: 10
                        font.family: "SimHei"
                        font.pixelSize: 24
                        color: "#474747"
                        text: btnText
                    }
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



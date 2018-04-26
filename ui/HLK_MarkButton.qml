import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL

Button {
    id:markQml
    property string button_sound: "qrc:/sounds/sounds/about.wav"
    property bool   mute: false
    property bool   markEnable:true
    property string button_text:""
    property int btnWidth:button_text.length*20+20
    property string themeColor: JSL.themeColor()
    signal realisticTextclick(string text)               //写实标签按钮被点击
    //width: 100
    width:btnWidth
    height: 40
    enabled: markEnable
    style: ButtonStyle{
        background: Rectangle{
            border.width: 1
            border.color: themeColor
            anchors.margins: 10
            //enabled: markEnable

            Text{
                //anchors.margins: 10
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 20
                font.family: "黑体"
                color: JSL.themeColor()
                text: button_text
             }
        }
    }

    Audio{
        id: sound
        source: button_sound
    }
    onClicked: {
        emit: realisticTextclick(button_text)
        if(!mute){
            sound.play()
        }
    }

}




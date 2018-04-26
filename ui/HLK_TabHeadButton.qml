import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

RadioButton {
    id: tabHeadBtn

    property string headName:'题头'         //显示文字
    property string normalColor:'#9D9D9D'  //正常状态颜色
    property string checkedColor:'#FFFFFF' //选中状态颜色
    property string buttonSound: 'qrc:/sounds/sounds/about.wav'
    property int    buttonWidth:180
    property int    buttonHeigh:60
    property int    buttonBorder:0
    property bool delEnable: false
    signal deleteButtonClicked()
    width: buttonWidth
    height: buttonHeigh

    style: RadioButtonStyle{
        background: Rectangle{
            color: checked ? checkedColor : normalColor
            border.color:'#9D9D9D'
            border.width:buttonBorder
        }

        label: HLK_TabHeadText{
            fontText: control.text
            fontColor: checked ? normalColor : checkedColor
            fontWidth:buttonWidth
            elide: Text.ElideRight
        }

        indicator: null
    }
    HLK_SimpleImageButton{
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.right: parent.right
        anchors.rightMargin: 2
        normal_path: "qrc:/images/images/tb002-2.png"
        checked_path: "qrc:/images/images/tb002-2.png"
        width: 20
        height: 20
        visible: delEnable
        onClicked: {
            emit: deleteButtonClicked()
        }
    }

//    Audio{
//        id: sound
//        source: buttonSound
//    }

//    onClicked: {
//        sound.play()
//    }
}

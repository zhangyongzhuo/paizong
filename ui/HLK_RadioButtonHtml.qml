import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

RadioButton {
    property string themeColor: JSL.themeColor()
    property string textNormalColor:'#474747'
    property string textCheckedColor: themeColor
    property string buttonText: ""
    property int    buttonWidth:150
    property int    buttonHeigh:60
    property int    buttonBorder:0

    width: buttonWidth
    height: buttonHeigh

    style: RadioButtonStyle{
        background: Rectangle{
            color: "#00000000"
            Rectangle{
                radius: 10
                width: buttonWidth
                height: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                color: themeColor
                visible: checked ? true : false
            }
            Rectangle{
                z: 1
                width: buttonWidth
                height: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                color: "#F0F0F0"
                visible: checked ? true : false
            }
        }
        label: Text{
            text: getCtrlText(control.text)
            width: buttonWidth
            font.family: 'SimHei'
            font.pixelSize: 22
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: checked ? textCheckedColor : textNormalColor
        }
        indicator: null
    }
    function getCtrlText(text){
        if(text.length>6){
            return text.substring(0,6)
        }else{
            return text
        }
    }
}

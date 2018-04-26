import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

RadioButton {
    property string themeColor: JSL.themeColor()
    property string textNormalColor:'#474747'
    property string textCheckedColor: themeColor
    property string backgroudNormalColor:'#FFFFFF'
    property string backgroudCheckedColor:'#E8E8E9'
    property string buttonText: ""
    property int    buttonWidth:170
    property int    buttonHeigh:60
    property int    buttonBorder:0

    width: buttonWidth
    height: buttonHeigh

    style: RadioButtonStyle{
        background: Rectangle{
            color: checked ? backgroudCheckedColor : backgroudNormalColor
            Rectangle{
                width: 4
                height: buttonHeigh
                color: themeColor
                visible: checked ? true : false
            }
        }
        label: Text{
            text: control.text
            width: buttonWidth
            font.family: 'SimHei'
            font.pixelSize: 22
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: checked ? textCheckedColor : textNormalColor
        }
        indicator: null
    }
}

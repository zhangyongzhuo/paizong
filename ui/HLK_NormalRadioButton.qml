import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

RadioButton{
    property string themeColor: JSL.themeColor()
    property string defaultColor: "#979797"
    property int code: -1
    property bool isChecked: false
    property int fontSize: 24
    style:RadioButtonStyle{
        spacing:10
        indicator: Rectangle{
            implicitHeight: 16
            implicitWidth: 16
            radius: 20
            border.color: control.checked? themeColor : defaultColor
            border.width: 2

            Rectangle{
                anchors.fill: parent
                implicitHeight: 5
                implicitWidth: 5
                visible: control.checked
                color: themeColor
                radius: 180
                anchors.margins: 5
            }
        }

        label:Text{
            color: control.checked ? themeColor : defaultColor
            text: control.text
            font.family: "SimHei"
            font.pixelSize: fontSize
            wrapMode: Text.WordWrap
        }
    }
    checked: isChecked
}

import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

CheckBox {
    id:zxj
    //text: "Check Box"
    property string check_text:""
    property string themeColor: JSL.themeColor()
    property string defaultColor: "#979797"
    property int textWidth: 260
    property int textSize: 24
    property int yHigh: 0
    y: yHigh
    style: CheckBoxStyle {
        spacing: 10
        indicator: Rectangle {
            implicitWidth: 16
            implicitHeight: 16
            border.color: control.checked ? themeColor : defaultColor;
            border.width: 2

            Rectangle {
                anchors.fill: parent
                implicitHeight: 5
                implicitWidth: 5
                visible: control.checked
                color: themeColor
                anchors.margins: 3
            }
        }
        label: HLK_NormalText{
            color: control.checked ? themeColor : defaultColor
            text: control.text
            font.family: "SimHei"
            font.pixelSize: textSize
            width: textWidth
            wrapMode: Text.WordWrap
        }
    }
}

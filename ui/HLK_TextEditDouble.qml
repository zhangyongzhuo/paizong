import QtQuick 2.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL
import "qrc:/base/js/theme.js" as Theme

Rectangle{
    width:  100
    height: 50
    border.width: 1
    border.color: cursorVisible ? themeColor : Theme.borderColor()
    clip: true
    radius: 10
    property bool iscanedit:true
    property alias textLeft: inputTextLeft.text
    property alias textSizeLeft: inputTextLeft.font.pixelSize
    property alias hintLeft: hintLeft.text
    property bool cursorVisible: (inputTextLeft.cursorVisible | inputTextRight.cursorVisible)
    property double   coefficient:0.65
    property alias textRight: inputTextRight.text
    property alias textSizeRight: inputTextRight.font.pixelSize
    property alias hintRight: hintRight.text
    property int textSize: 28

    property string themeColor: Theme.focusedColor()
    property int leftMargin: 5
    property int rightMargin: 5
    property int textMode: TextInput.NoWrap //textMode: TextInput.NoWrap
    property bool onlyRead: false
    property bool isEnable: true
    signal dataChanged(bool status)
    signal timeChanged(bool status)
    layer.enabled: cursorVisible ? true : false
    layer.effect: DropShadow {
        transparentBorder: true
        color: themeColor
        radius:  8
        samples: 16
    }
    enabled: isEnable
    color: isEnable ? "#FFFFFF" : "#F2F2F4"

    Row{
        anchors.fill: parent
        anchors.margins: 1
        Rectangle{
            width:  parent.width * coefficient
            height: parent.height
            radius: 10
            Text {
                id: hintLeft
                anchors { fill: parent; leftMargin: 5 }
                verticalAlignment: Text.AlignVCenter
                text: ""
                font.pixelSize: 24
                font.family: "SimHei"
                color: "#707070"
                opacity: inputTextLeft.length ? 0 : 1
            }

            TextInput {
                id: inputTextLeft
                text: ""
                anchors.fill: parent
                anchors.leftMargin: leftMargin
                anchors.rightMargin: rightMargin
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: textSize
                anchors.left: parent.left
                clip: true
                font.family: "黑体"
                selectByMouse: true
                cursorVisible: false
                enabled: iscanedit
                readOnly: onlyRead
                wrapMode: textMode
                onCursorVisibleChanged: {
                    emit: dataChanged(inputTextLeft.cursorVisible)
                }
            }
        }
        Rectangle{
            width:  1
            height: parent.height
            color: Theme.borderColor()
        }
        Rectangle{
            radius: 10
            width:  parent.width * (1-coefficient) -1
            height: parent.height
            Text {
                id: hintRight
                anchors { fill: parent; leftMargin: 5 }
                verticalAlignment: Text.AlignVCenter
                text: ""
                font.pixelSize: 24
                font.family: "SimHei"
                color: "#707070"
                opacity: inputTextRight.length ? 0 : 1
            }

            TextInput {
                id: inputTextRight
                text: ""
                anchors.fill: parent
                anchors.leftMargin: leftMargin
                anchors.rightMargin: rightMargin
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 28
                anchors.left: parent.left
                clip: true
                font.family: "黑体"
                selectByMouse: true
                cursorVisible: false
                enabled: iscanedit
                readOnly: onlyRead
                wrapMode: textMode
                onCursorVisibleChanged: {
                    emit: timeChanged(inputTextRight.cursorVisible)
                }
            }
        }
    }
}

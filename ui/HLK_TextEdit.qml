import QtQuick 2.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL
import "qrc:/base/js/theme.js" as Theme

Rectangle{
    id: rec
    width:  100
    height: 50
    border.width: 1
    border.color: cursorVisible ? themeColor : Theme.borderColor()
    clip: true
    radius: 10
    property bool iscanedit:true
    property alias text: inputText.text
    property alias inputText: inputText
    property alias textSize: inputText.font.pixelSize
    property alias hint: hint.text
    property alias cursorVisible: inputText.cursorVisible
    property bool inputTextEchoMode: false //false 正常模式， true 密码模式
    property string themeColor: Theme.focusedColor()
    property int leftMargin: 5
    property int rightMargin: 5
    property int hintSize:24
    property int inputSize:28
    property int textMode: TextInput.NoWrap //textMode: TextInput.NoWrap
    property bool onlyRead: false
    property bool isEnable: true
    property int maxLength: 512
    property string pagename:""

    layer.enabled: cursorVisible ? true : false
    layer.effect: DropShadow {
        transparentBorder: true
        color: themeColor
        radius:  8
        samples: 16
    }
    enabled: isEnable
    color: isEnable ? "#FFFFFF" : "#F2F2F4"
    Text {
        id: hint
        anchors { fill: parent; leftMargin: 14 }
        verticalAlignment: Text.AlignVCenter
        text: ""
        font.pixelSize: hintSize
        font.family: "SimHei"
        color: "#707070"
        opacity: inputText.length ? 0 : 1
    }

    TextInput {
        id: inputText
        text: ""
        anchors.fill: parent
        anchors.leftMargin: leftMargin
        anchors.rightMargin: rightMargin
       // anchors.topMargin: 12
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: inputSize
        anchors.left: parent.left
        clip: true
        font.family: "黑体"
        selectByMouse: true
        cursorVisible: false
        echoMode: inputTextEchoMode ? TextInput.Password : TextInput.Normal
        passwordMaskDelay:200
        passwordCharacter:"*"
        enabled: iscanedit
        readOnly: onlyRead
        wrapMode: textMode
        onLengthChanged:{
            if(inputText.length>maxLength){
                var prePosition = cursorPosition;
                inputText.text = inputText.text.substring(0, inputText.text.length-1);
                cursorPosition = Math.min(prePosition, inputText.text.length);
            }
        }

        onCursorVisibleChanged: {
            if(cursorVisible){
                emit: boxAreaOpend(pagename)
            }
        }
    }
}

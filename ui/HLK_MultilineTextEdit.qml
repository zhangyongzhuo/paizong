import QtQuick 2.4
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import "qrc:/base/js/common.js" as JSL


Rectangle{
    id: rec
    width: 100
    height: 50
    border.width: 1
    border.color: cursorVisible ? themeColor : "#979797"
    clip: true
    radius: 10

    property alias text: txt.text
    property alias txt: txt
    property alias hint: hint.text
    property alias cursorVisible: txt.cursorVisible
    property string themeColor: JSL.themeColor()
    property int maxLength: 512
    property int mode: 0
    property string modehint:""
    property int textSize: 24
    property string pagename:""

    property bool isEnable: true

    color: isEnable ? "#FFFFFF" : "#F2F2F4"

    layer.enabled: cursorVisible ? true : false
    layer.effect: DropShadow {
        transparentBorder: true
        color: themeColor
        radius:  8
        samples: 16
    }

    Text {
        id: hint
        anchors { fill: parent; leftMargin: 14 }
        verticalAlignment: Text.AlignVCenter
        text: modehint
        font.pixelSize: 24
        font.family: "SimHei"
        color: "#707070"
        opacity: txt.length ? 0 : 1
    }

    Flickable {
         id: flick
         anchors.fill: parent
         clip: true

         function ensureVisible(r)
         {
             if (contentX >= r.x)
                 contentX = r.x;
             else if (contentX+width <= r.x+r.width)
                 contentX = r.x+r.width-width;
             if (contentY >= r.y)
                 contentY = r.y;
             else if (contentY+height <= r.y+r.height)
                 contentY = r.y+r.height-height;
         }

         TextEdit {
             id: txt
             anchors.fill: parent
             anchors.left: parent.left
             anchors.leftMargin: 5
             anchors.topMargin: 0
             anchors.right: parent.right
             anchors.bottom: parent.bottom
             anchors.top: parent.top
             font.pixelSize: textSize
             font.family: "SimHei"
             focus: true
             selectByMouse: true
             //wrapMode: TextEdit.Wrap
             wrapMode: TextEdit.WrapAnywhere
             onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
             onLengthChanged:{
                 if(txt.length>maxLength){
                    var prePosition = cursorPosition;
                    txt.text = txt.text.substring(0, maxLength)
                    cursorPosition = Math.min(prePosition, txt.text.length);
                 }
             }
             onCursorVisibleChanged: {
                 if(cursorVisible){
                     emit: boxAreaOpend(pagename)
                 }
             }

         }
     }

//    TextEdit{
//        id: txt
//        anchors.fill: parent
//        anchors.left: parent.left
//        anchors.leftMargin: 5
//        anchors.topMargin: 0
//        anchors.right: parent.right
//        anchors.bottom: parent.bottom
//        anchors.top: parent.top
//        font.pixelSize: 28
//        font.family: "SimHei"
//        selectByMouse: true
//        cursorVisible: false
//        wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
//        clip: true
//        onTextChanged: {
//            if(JSL.isContainHyphen(txt.text)){
//                messagebox.text = "不能包含特殊字符'&',否则数据将无法保存"
//                messagebox.visible = true
//                return
//            }
//        }
//    }

}

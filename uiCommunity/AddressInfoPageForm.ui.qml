import QtQuick 2.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0

//地址信息
Item {
    width: 1070
    height: 220 //300
    property alias thinkChange:thinkChange
    property alias streetAddress:streetAddress
    property alias areaNumber:areaNumber
    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"
        Rectangle {
            anchors.fill: parent
            anchors.margins: 20
            width:parent.width-40
            height:parent.height-40
            HLK_Button {
                id: thinkChange
                anchors.top: parent.top
                anchors.right: parent.right
                width:143
                button_text: "二维码扫描"
            }
            Flow
            {
                anchors.top:parent.top
                anchors.topMargin: 60
                anchors.left: parent.left
                width:parent.width
                height:parent.height-70
                spacing: 20
                Row {
                    width: parent.width
                    spacing: 10
                    HLK_NormalText {
                        y:streetAddress.y + 13
                        text: "街道地址:"
                        width: 110
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: streetAddress
                        width: 509
                    }
                    HLK_NormalText {
                        y:streetNumber.y + 13
                        text: "街道号:"
                        width: 110
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: streetNumber
                        width: 270
                    }
                }
                Row {
                    width: parent.width
                    spacing: 10
                    HLK_NormalText {
                        y:areaAddress.y + 13
                        text: "小区地址:"
                        width: 110
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: areaAddress
                        width: 509
                    }
                    HLK_NormalText {
                        y:areaNumber.y + 13
                        text: "小区号:"
                        width: 110
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: areaNumber
                        width: 270
                    }
                }
            }
        }
    }
}

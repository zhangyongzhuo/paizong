import QtQuick 2.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0

//房主信息
Item {
    width: 1070
    height: 460 //300
    property alias rentedRoom: rentedRoom
    property alias rentedArea: rentedArea
    property alias rent: rent
    property alias leaseDate: leaseDate
    property alias houseGrade: houseGrade
    property alias personLiable: personLiable
    property alias signTime: signTime
    property alias remark: remark
    property alias remarksNumber: remarksNumber
    property int defaultTextSize: 20
    property alias getFocusComboBox: getFocusComboBox
    //property alias bfRec:bfRec
    property bool cadeEnabled:false
    property string colorR:"#F2F2F4"

    property alias signTimeText:signTimeText //责任书签订时间文本提示

    //获取焦点
    HLK_TextEdit {
        id: getFocusComboBox
        visible: false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            emit: componentRecovery()
        }
    }
    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"
        enabled: cadeEnabled
        Rectangle {
            anchors.fill: parent
            anchors.margins: 20
            width: parent.width - 40
            height: parent.height - 40
            color:colorR
            Flow {
                width: parent.width
                height: parent.height
                spacing: 20
                Row {
                    width: parent.width
                    spacing: 10
                    z: 1
                    HLK_NormalText {
                        y: rentedRoom.y + 13
                        text: "出租房间数:"
                        width: 140
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: rentedRoom
                        width: 265
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: cadeEnabled
                    }
                    HLK_Text {
                        textWidth: 65
                        textContent: '( 间 )'
                    }
                    HLK_NormalText {
                        y: rentedArea.y + 13
                        text: "出租面积:"
                        width: 150
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: rentedArea
                        width: 260
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: cadeEnabled
                    }
                    HLK_Text {
                        textWidth: 100
                        textContent: '( 平方米 )'
                    }
                }
                Row {
                    width: parent.width
                    spacing: 10
                    HLK_NormalText {
                        y: rent.y + 13
                        text: "出租日期:"
                        width: 140
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: rent
                        width: 340
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: cadeEnabled
                    }
                    HLK_NormalText {
                        y: leaseDate.y + 13
                        text: "租金(元/月):"
                        width: 150
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: leaseDate
                        width: 370
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: cadeEnabled
                    }
                }
                Row {
                    width: parent.width
                    spacing: 10
                    z: 1
                    HLK_NormalText {
                        y: houseGrade.y + 13
                        text: "房屋等级:"
                        width: 140
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_ComboBox {
                        id: houseGrade
                        model: houseGradeData
                        currentIndex: -1
                        boxWidth  : 340
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                        isEnable: cadeEnabled
                        initHeight: 100
                    }
                    ListModel {
                        id: houseGradeData
                    }
                    HLK_NormalText {
                        y: personLiable.y + 13
                        text: "治安责任人:"
                        width: 150
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: personLiable
                        width: 370
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: false
                        text: policeName
                    }
                }
                Row {
                    width: parent.width
                    spacing: 10
                    HLK_NormalText {
                        id: signTimeText
                        y: signTime.y + 13
                        //text: "责任书签订时间:"
                        width: 140
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: signTime
                        width: 340
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: cadeEnabled
                    }
                }
                Row {
                    width: parent.width
                    height: 140
                    spacing: 10
                    HLK_NormalText {
                        //y:remark.y + 13
                        text: "备注:"
                        width: 140
                        y: 60
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_MultilineTextEdit {
                        id: remark
                        modehint: ""
                        maxLength: 256
                        width: parent.width - 150
                        height: 140
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: cadeEnabled
                        Text {
                            id: remarksNumber
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 5
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            color: '#666666'
                            //text: control.text
                            font.family: "SimHei"
                            font.pixelSize: defaultTextSize
                            wrapMode: Text.WordWrap
                        }
                        onTextChanged: {
                            remarksNumber.text = remark.text.length + "/" + 256
                        }
                    }
                }
            }
         }
//         Rectangle {
//             id:bfRec
//             visible:false
//             anchors.fill: parent
//             anchors.margins: 12
//             width: parent.width - 40
//             height: parent.height - 40
//              color:"#F2F2F4"
//         }
    }
}

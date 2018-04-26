import QtQuick 2.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0
//从业人员其他信息
Item {
    width: 1070
    height: 300 //300
    property alias owerName:owerName
    property alias phoneNumber:phoneNumber
    property alias foreignSur:foreignSur
    property alias foreignName:foreignName
    property int defaultTextSize: 20
    property alias getFocusComboBox: getFocusComboBox
    property bool cadeEnabled:true
    property string colorR:"#F2F2F4"
    property alias fixedPhone:fixedPhone
    property alias order: order
    property alias internal: internal
    property alias security: security
    property alias technical: technical
    property alias fire: fire

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
        enabled: cadeEnabled
        anchors.fill: parent
        color: "#FFFFFF"
        Rectangle {
            anchors.fill: parent
            anchors.margins: 20
            width:parent.width-40
            height:parent.height-40

            Flow{
                width:parent.width
                height:parent.height
                spacing:20
                Row {
                    width: parent.width
                    spacing: 10
                    HLK_NormalText {
                        y:owerName.y + 13
                        text: "<font color='red'>*</font>手机号码1:"
                        width: 110
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: owerName
                        width: 370
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: cadeEnabled
                    }
                    HLK_NormalText {
                        y:phoneNumber.y + 13
                        text: "手机号码2:"
                        width: 150
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: phoneNumber
                        width: 370
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: cadeEnabled
                    }
                }
                Row {
                    width: parent.width
                    spacing: 10
                    HLK_NormalText {
                        y:foreignSur.y + 13
                        text: "QQ号码:"
                        width: 110
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: foreignSur
                        width: 370
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: cadeEnabled
                    }
                    HLK_NormalText {
                        y:foreignName.y + 13
                        text: "微信号码:"
                        width: 150
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: foreignName
                        width: 370
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: cadeEnabled
                    }
                }
                Row {
                    width: parent.width
                    spacing: 10
                    HLK_NormalText {
                        y:fixedPhone.y + 13
                        text: "     固话:"
                        width: 110
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: fixedPhone
                        width: 370
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: cadeEnabled
                    }
                }
            }
            Row {
                y:215
                width: 1070
                height: 36
                spacing: 20

                HLK_Text {
                    textWidth: 110
                    textHeight: 36
                    textContent: "管理类型:"
                }
                HLK_Checkbox {
                    id: order
                    width: parent.width / 13
                    text: "保安"
                    textSize: defaultTextSize
                    yHigh: 10
//                    onClicked: {
//                        ztry.checked = false
//                        zdgz.checked = false
//                        fzqk.checked = false
//                        xdfds.checked = false
//                    }

                }
                HLK_Checkbox {
                    id: internal
                    width: parent.width / 13
                    text: "法人"
                    textSize: defaultTextSize
                    yHigh: 10
                    onClicked: {
                        //wskbj.checked = false
                    }
                }
                HLK_Checkbox {
                    id: security
                    width: parent.width / 8
                    text: "治安负责人"
                    textSize: defaultTextSize
                    yHigh: 10
                    onClicked: {
                        //wskbj.checked = false
                    }
                }
                HLK_Checkbox {
                    id: technical
                    width: parent.width / 8
                    text: "消防负责人"
                    textSize: defaultTextSize
                    yHigh: 10
                    onClicked: {
                        //wskbj.checked = false
                    }
                }
                HLK_Checkbox {
                    id: fire
                    width: parent.width / 8
                    text: "实际经营人"
                    textSize:defaultTextSize
                    yHigh: 10
                    onClicked: {
                        //wskbj.checked = false
                    }
                }
            }
        }
    }
    ListModel {
        id: familyTiesData
        ListElement {
            text: "出租房"
            code: "0"
        }
        ListElement {
            text: "廉租房"
            code: "1"
        }
    }
    ListModel {
        id: familyTiesSecData
        ListElement {
            text: "整租"
            code: "0"
        }
        ListElement {
            text: "部分出租"
            code: "1"
        }
    }
}

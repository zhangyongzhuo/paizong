import QtQuick 2.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0
//出租房屋其他录入信息
Item {
    width: 1070
    height: 370 //300
    property alias idType:idType
    //property alias idNumber:idNumber
    property alias owerName:owerName
    property alias phoneNumber:phoneNumber
    property alias foreignSur:foreignSur
    property alias foreignName:foreignName
    property int defaultTextSize: 20
    property alias getFocusComboBox: getFocusComboBox
    property bool cadeEnabled:true
    property string colorR:"#F2F2F4"
    property alias familyTies:familyTies
    property alias familyTiesData:familyTiesData
    property alias familyTiesSec:familyTiesSec
    property alias familyTiesSecData:familyTiesSecData
    property alias fixedPhone:fixedPhone
    //下拉框变成模糊查找
//    property alias idTypeChange:idTypeChange
//    property alias idTypeChangeView:idTypeChangeView
//    property alias idChangeData:idChangeData

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

             Column{
                 width: parent.width
                 spacing: 20
                 z:1
                Row {
                    width: parent.width
                    spacing: 10
                    HLK_NormalText {
                        id:idTypeText
                        y:idType.y + 13
                        text: "<font color='red'>*</font>人口类型:"
                        width: 110
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_ComboBox {
                        id: idType
                        model: idTypeData
                        currentIndex: -1
                        boxWidth  : 910
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                        isEnable: cadeEnabled
                    }
                    ListModel {
                        id: idTypeData
                    }
                }
                Row{
                    width: parent.width
                    z:0
                    spacing:10
                    HLK_NormalText {
                        y:familyTies.y + 13
                        text: "<font color='red'>*</font>家庭关系:"
                        width: 110
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_ComboBox {
                        id: familyTies
                        model: familyTiesData
                        boxWidth:450
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                    }
                    HLK_ComboBox {
                        id: familyTiesSec
                        model: familyTiesSecData
                        boxWidth:450
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                        initHeight: 380
                    }
                }
            }

            Flow{
                y:140
                width:parent.width
                height:parent.height
                spacing:20
                Row {
                    width: parent.width
                    spacing: 10
                    HLK_NormalText {
                        y:owerName.y + 13
                        text: "<font color='red'>*</font>电话号码1:"
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
                        text: "电话号码2:"
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

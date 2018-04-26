import QtQuick 2.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0
//托管人信息
Item {
    width: 1070
    height: 300 //300
    property alias idType:idType
    property alias idNumber:idNumber
    property alias owerName:owerName
    property alias phoneNumber:phoneNumber
    property alias foreignSur:foreignSur
    property alias foreignName:foreignName
    property alias relationOwer:relationOwer
    property alias relationOwerData:relationOwerData
    property int defaultTextSize: 20
    property alias getFocusComboBox: getFocusComboBox
    property bool cadeEnabled:false
    property string colorR:"#F2F2F4"
//    证件种类下拉框用模糊查找
//    property alias idTypeChange:idTypeChange
//    property alias idTypeChangeView:idTypeChangeView
//    property alias idChangeData:idChangeData


    //获取焦点
    HLK_TextEdit {
        id: getFocusComboBox
        visible: false
    }

//    ExclusiveGroup {
//        id: eg
//    }

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
            width:parent.width-40
            height:parent.height-40
            color:colorR
             Column{

                 width: parent.width
                 spacing: 0
                 z:1
                 Row {
                    width: parent.width
                    spacing: 10
                    HLK_NormalText {
                        y:idType.y + 13
                        text: idType.currentText == "" ? "  证件种类" : "<font color='red'>*</font>证件种类:"
                        width: 110
                        horizontalAlignment: Text.AlignRight
                    }
//                    HLK_TextEdit {
//                        id: idType
//                        width: 370
//                        textSize: defaultTextSize
//                        pagename: PAGENAME
//                    }
                    HLK_ComboBox {
                        id: idType
                        model: idTypeData
                        currentIndex: -1
                        boxWidth  : 370
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                        isEnable: false
                    }
                    ListModel {
                        id: idTypeData
                        ListElement {
                            text: ""
                        }
                    }
                    HLK_NormalText {
                        y:idNumber.y + 13
                        text: idType.currentText == "" ? "证件号码:" : "<font color='red'>*</font>证件号码:"
                        width: 150
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: idNumber
                        width:370
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: false
                    }
                }
//                Row {
//                    x:120
//                    height:1
//                    HLK_Border {
//                    id: idTypeChange
//                    radius: 10
//                    width: 370
//                    height: 240
////                    x:340
////                    y:340
//                    color: "white"
//                    visible: false
//                    ListView {
//                        id:idTypeChangeView
//                        anchors.fill: parent
//                        anchors.topMargin: 5
//                        anchors.leftMargin: 5
//                        anchors.rightMargin: 5
//                        clip: true
//                        model: idChangeData.model
//                        highlight: Rectangle{
//                               color:"#BFEFFF"
//                               radius: 3
//                        }
//                        highlightFollowsCurrentItem: true
//                        focus: true

//                        delegate: Text{
//                            width:parent.width
//                            font.pixelSize: 20
//                            height: 35
//                            verticalAlignment: Text.AlignVCenter
//                            font.family: "黑体"
//                            color: "#000000"
//                            text: model.text

//                            MouseArea {
//                                anchors.fill: parent
//                                onClicked: {
//                                    var user = idChangeData.model.get(index).text
//                                    idType.text = user
//                                    //fromArea.text=idType.text
//                                    idTypeChange.visible = false
//                                    getFocus.focus = true
//                                    //emit: changeUserName(user)
//                                }
//                            }
//                        }
//                    }
//                    }
//                }
            }
            Flow{
                y:70
                width:parent.width
                height:parent.height
                spacing:20
                Row {
                    width: parent.width
                    spacing: 10
                    HLK_NormalText {
                        y:owerName.y + 13
                        text: idType.currentText == "" ? "      姓名:" : "<font color='red'>*</font>姓名:"
                        width: 110
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: owerName
                        width: 370
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: false
                    }
                    HLK_NormalText {
                        y:phoneNumber.y + 13
                        text: idType.currentText == "" ? "联系电话:" : "<font color='red'>*</font>联系电话:"
                        width: 150
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: phoneNumber
                        width: 370
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: false
                    }
                }
                Row {
                    width: parent.width
                    spacing: 10
                    HLK_NormalText {
                        y:foreignSur.y + 13
                        text: "    外文姓:"
                        width: 110
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: foreignSur
                        width: 370
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: false

                    }
                    HLK_NormalText {
                        y:foreignName.y + 13
                        text: "  外文名:"
                        width: 150
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_TextEdit {
                        id: foreignName
                        width: 370
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: false
                    }
                }
                Row {
                    width: parent.width
                    spacing: 10
                    //z:2
                    HLK_NormalText {
                        y:relationOwer.y + 13
                        text: "与房主关系:"
                        width: 110
                        horizontalAlignment: Text.AlignRight
                    }
                    HLK_ComboBox {
                        id: relationOwer
                        model: relationOwerData
                        currentIndex: -1
                        width: 434
                        boxWidth  : 370
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                        isEnable: false
                    }
                    ListModel {
                        id: relationOwerData
                        ListElement {
                            text: ""
                        }
                    }
                }
            }
        }
    }
//    HLK_JsonListModel {
//        id: idChangeData
//    }
}

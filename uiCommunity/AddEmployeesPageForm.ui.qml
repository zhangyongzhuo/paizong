import QtQuick 2.4
import "qrc:/controls/ui"


//添加从业人员页
Item {
    width: 1140
    height: 240
    property alias personInfoView: personInfoView
    property alias addPersonInfoBtn: addPersonInfoBtn
    property alias addPersonInfoRec: addPersonInfoRec
    property alias infoModel: infoModel
    property int viewCurrentIndex: -1
    property alias messagebox: messagebox
    property bool enabledDel: true

    MouseArea {
        anchors.fill: parent
        onClicked: {
            emit: componentRecovery()
        }
    }

    Rectangle {
        id: addPersonInfoRec
        anchors.fill: parent
        color: "#FFFFFF"
        HLK_AddButton {
            id: addPersonInfoBtn
            x: 20
            y: 30
            width: 143
            height: 183
            imgPath: "qrc:/images/images/qinshu.png"
        }
        ListView {
            id: personInfoView
            x: addPersonInfoBtn.x + addPersonInfoBtn.width + 40
            y: addPersonInfoBtn.y
            clip: true
            width: 915
            height: 200
            orientation: ListView.Horizontal
            spacing: 10
            visible: true
            highlightMoveDuration: 1
            snapMode: ListView.SnapOneItem
            model: ListModel {
                id: infoModel
                ListElement {
                    IMG: ""
                    ROW1: ""
                    ROW2: ""
                    ROW3: ""
                    relationJson: ""
                }
            }
            delegate: HLK_NormalInfo {
                image: IMG
                row1: ROW1
                row2: ROW2
                row3: ROW3
                model: infoModel
                delvisible: enabledDel
                lineSpacing: 25
                onDeleteButtonClicked: {
                    viewCurrentIndex = index
                    addPersonInfoRec.enabled = false
                    popWindow.visible = true
                }
                onClicked: {
                    emit:changeBtnClicked(infoModel.get(index).relationJson, PAGENAME)
                }
            }
        }
    }
    HLK_PopupWindow {
        id: popWindow
        visible: false
        anchors.fill: parent
        popupWindowTitle: "是否要删除此人信息？"
        Row {
            spacing: 50
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
            HLK_Button {
                width: 130
                button_text: "是"
                onClicked: {
                    emit:deleteBtnClicked(infoModel.get(viewCurrentIndex).relationJson, PAGENAME)
                    infoModel.remove(viewCurrentIndex)
                    addPersonInfoRec.enabled = true
                    popWindow.visible = false
                }
            }
            HLK_Button {
                width: 130
                button_text: "否"
                onClicked: {
                    addPersonInfoRec.enabled = true
                    popWindow.visible = false
                }
            }
        }
    }
    HLK_MessageBox {
        id: messagebox
    }
}

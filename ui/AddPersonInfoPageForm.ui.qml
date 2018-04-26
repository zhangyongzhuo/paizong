import QtQuick 2.4
import "qrc:/controls/ui"
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import com.hylink.fmcp.ctrl 2.0


//添加人员信息页
Item {
    width: 1140
    height: 240
    property alias personInfoView: personInfoView
    property alias addPersonInfoBtn: addPersonInfoBtn
    property alias addPersonInfoRec: addPersonInfoRec
    property alias infoModel: infoModel
    property alias popWindow: popWindow
    property alias driver: driver
    property alias passenger: passenger
    property alias popWindowAlert: popWindowAlert
    property alias isAddBtn: isAddBtn
    property alias noAddBtn: noAddBtn
    property bool isvisible: true
    property bool isEnabled: true
    property alias popWindowDelete:popWindowDelete
    signal deletePersonClicked(int index)

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
            imgPath: "qrc:/images/images/renyuan.png"
        }
        ListView {
            id: personInfoView
            x: addPersonInfoBtn.x + addPersonInfoBtn.width + 40
            y: addPersonInfoBtn.y
            clip: true
            width: 915
            height: 200 //flagModel.count>4 ? 200 : 100
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
                delvisible: isvisible
                enabled: isEnabled
                lineSpacing: 25

                onDeleteButtonClicked: {
                    emit: deletePersonClicked(index)
                }
//                MouseArea {
//                    x: 400 - 25
//                    y: 0
//                    width: 25
//                    height: 25
//                    enabled: delvisible
//                    onClicked: {
//                        var sendToGo = {
//                            optargetId: []
//                        }
//                        //删除普通人和车
//                        sendToGo.optargetId.push(infoModel.get(
//                                                     index).relationJson)

//                        //将本地文件夹删除
//                        qmlData.deleteOptargetIdDir(
//                                    "/CollectData/" + infoModel.get(
//                                        index).relationJson)

//                        //从列表中将数据删除
//                        infoModel.remove(index)

//                        var url = "http://" + goIpPort + "/clearOptargetId/" + JSON.stringify(
//                                    sendToGo)
//                        operatehttp.get(url, function (code, data) {
//                            if (code == 200) {
//                                console.log("删除车辆联系人成功")
//                            } else {
//                                console.log("根据档案编号删除数据失败")
//                            }
//                        })
//                    }
//                }
            }
        }
        }

        HLK_PopupWindow {
            id: popWindow
            visible: false
            anchors.fill: parent
            popupWindowTitle: "人车关系"
            isShowClose: true
            ExclusiveGroup {
                id: eg
            }

            Row {
                spacing: 140
                anchors.horizontalCenter: parent.horizontalCenter
                y: 130
                HLK_NormalRadioButton {
                    id: driver
                    text: "驾驶员"
                    exclusiveGroup: eg
                }
                HLK_NormalRadioButton {
                    id: passenger
                    text: "乘客"
                    exclusiveGroup: eg
                }
            }
        }
        HLK_PopupWindow {
            id: popWindowDelete
            visible: false
            anchors.fill: parent
            popupWindowTitle: "是否要删除该人员？"
            Row {
                spacing: 100
                anchors.horizontalCenter: parent.horizontalCenter
                y: 130
                HLK_Button {
                    width: 130
                    button_text: "是"
                        onClicked: {
                            var sendToGo = {
                                optargetId: []
                            }
                            //删除普通人和车
                            sendToGo.optargetId.push(infoModel.get(
                                                         commonIndex).relationJson)

                            //将本地文件夹删除
                            qmlData.deleteOptargetIdDir(
                                        "/CollectData/" + infoModel.get(
                                            commonIndex).relationJson)

                            //从列表中将数据删除
                            infoModel.remove(commonIndex)

                            var url = "http://" + goIpPort + "/clearOptargetId/" + JSON.stringify(
                                        sendToGo)
                            operatehttp.get(url, function (code, data) {
                                if (code == 200) {
                                    addPersonInfoRec.enabled = true
                                    popWindowDelete.visible = false
                                    console.log("删除车辆联系人成功")
                                } else {
                                    console.log("根据档案编号删除数据失败")
                                }
                            })
                    }
                }
                HLK_Button {
                    width: 130
                    button_text: "否"
                    onClicked: {
                        addPersonInfoRec.enabled = true
                        popWindowDelete.visible = false
                    }
                }
            }

       }

        HLK_PopupWindow {
            id: popWindowAlert
            visible: false
            anchors.fill: parent
            popupWindowTitle: ""
            Row {
                spacing: 100
                anchors.horizontalCenter: parent.horizontalCenter
                y: 130
                HLK_Button {
                    id: isAddBtn
                    width: 130
                    button_text: "是"
                }
                HLK_Button {
                    id: noAddBtn
                    width: 130
                    button_text: "否"
                }
            }
        }

}

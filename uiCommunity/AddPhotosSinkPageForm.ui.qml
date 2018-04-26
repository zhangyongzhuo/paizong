import QtQuick 2.4
import "qrc:/controls/ui"
import QtQuick.Controls 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

Item {
    property string themeColor: JSL.themeColor()
    property alias shotBtn: shotBtn
    property alias photoDisplyView: photoDisplyView //照片显示view
    property alias photoDisplyViewModel: photoDisplyViewModel //照片显示model
    property bool delvisible: true
    property int viewCurrentIndex: -1

    ListModel {
        id: photoDisplyViewModel
        ListElement {
            photopath: ""
        }
    }

    Rectangle {

        width: 1070
        height: 190

        MouseArea {
            anchors.fill: parent
            onClicked: {
                emit: componentRecovery()
            }
        }

        Rectangle {
            id: page
            anchors.fill: parent
            color: "#FFFFFF"

            Flow {
                spacing: 20
                x: 20
                y: 18
                HLK_AddButton {
                    id: shotBtn
                    width: 200
                    height: 151
                    imgPath: "qrc:/images/images/zhaopian.png"
                }
                Rectangle {
                    //多张照片显示区域
                    width: 850
                    height: 151
                    //color: 'black'
                    ListView {
                        id: photoDisplyView
                        visible: false
                        width: 850
                        height: 151
                        clip: true
                        spacing: 18
                        highlightMoveDuration: 1
                        orientation: ListView.Horizontal
                        snapMode: ListView.SnapOneItem
                        model: photoDisplyViewModel
                        delegate: Image {
                            width: 200
                            height: 151
                            cache: false
                            source: photopath

                            MouseArea{//放大所点击的图片
                                anchors.fill: parent
                                onClicked: {
                                    var path = photoDisplyViewModel.get(index).photopath
                                    doubleMax.imgPath= path
                                    doubleMax.maxVisble = true
                                    doubleMax.bgVisble = true

                                }
                            }

                            Image {
                                id: selected
                                source: "qrc:/images/images/tb002-2.png"
                                anchors.right: parent.right
                                anchors.top: parent.top
                                visible: delvisible

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        viewCurrentIndex = index
                                        popWindow.visible = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        HLK_PopupWindow {
            id: popWindow
            visible: false
            anchors.fill: parent
            popupWindowTitle: "是否要删除此图片？"
            Row {
                spacing: 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 50
                HLK_Button {
                    width: 130
                    button_text: "是"
                    onClicked: {
                        var delImgPath = photoDisplyViewModel.get(
                                    viewCurrentIndex).photopath
                        var tempImgpath = qmlData.cutStr(delImgPath, 8, 0)
                        photoDisplyViewModel.remove(viewCurrentIndex)
                        qmlData.deleteFile(tempImgpath)

                        page.enabled = true
                        popWindow.visible = false
                    }
                }
                HLK_Button {
                    width: 130
                    button_text: "否"
                    onClicked: {
                        page.enabled = true
                        popWindow.visible = false
                    }
                }
            }
        }
    }
//    //图片预览
//    Rectangle {
//        id: picMax_bg
//        color: "black"
//        opacity: 0.7
//        anchors.fill: parent
//        visible: false
//        MouseArea {
//            anchors.fill: parent
//            onClicked: {
//                picMax_bg.visible = false
//                picMax.visible = false
//            }
//        }
//    }

//    Image {
//        id: picMax
//        width: 660
//        height: 466
//        anchors.verticalCenter: parent.verticalCenter
//        anchors.horizontalCenter: parent.horizontalCenter
//    }
}

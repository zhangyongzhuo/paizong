import QtQuick 2.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0


//写实信息页
Rectangle {
    id: realis
    width: 1070
    property alias realis: realis
    property alias realText: realText
    property alias realistictext: realistictext //写实text
    property alias takephoto: takephoto //拍照按钮
    property alias photoDisplyView: photoDisplyView //照片显示view
    property alias photoDisplyViewModel: photoDisplyViewModel //照片显示model
    //    property alias takeVideo: takeVideo
    //    property alias videoDisplyViewModel: videoDisplyViewModel
    property bool delvisible: true
    property int viewCurrentIndex: -1
    property alias grid: grid
    property var modelRe: []
    property alias markRe: markRe

    MouseArea {
        anchors.fill: parent
        onClicked: {
            emit: componentRecovery()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"
        Flow {
            x: 20
            y: 30
            width: 930
            spacing: 30
            Row {
                //照片区域
                width: 930
                spacing: 50
                HLK_NormalText {
                    y: 50
                    text: "照片:"
                    width: 20
                }
                Column {
                    spacing: 7
                    HLK_AddButton {
                        //点击拍照按钮
                        id: takephoto
                        width: 150
                        height: 180
                        imgPath: "qrc:/images/images/zhaopian.png"
                    }
                    Text {
                        //width: 143
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "现场采集"
                        font.pixelSize: 18
                        font.family: "黑体"
                        font.underline: false
                        color: "#474747"
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
                Rectangle {
                    //多张照片显示区域
                    id: photoRectangle
                    width: 750
                    height: 180
                    ListView {
                        id: photoDisplyView
                        visible: false
                        width: 750
                        height: 180
                        clip: true
                        spacing: 18
                        highlightMoveDuration: 1
                        orientation: ListView.Horizontal
                        snapMode: ListView.SnapOneItem
                        model: ListModel {
                            id: photoDisplyViewModel
                            ListElement {
                                photopath: ""
                            }
                        }
                        delegate: Image {
                            width: 150
                            height: 180
                            cache: false
                            source: photopath

                            MouseArea{//放大所点击的图片
                                anchors.fill: parent
                                onClicked: {
                                    var path = photoDisplyViewModel.get(index).photopath
//                                    picMax.source = path
//                                    picMax_bg.visible = true
//                                    picMax.visible = true
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
            Column {
                spacing: 20
                Row {
                    //写实
                    width: 960
                    spacing: 20
                    HLK_NormalText {
                        id: realText
                        // y: realistictext.y + 13
                        text: "写实:"
                        width: 50
                    }
                    Flow {
                        //动态加载标签
                        id: grid
                        width:960
                        //height: 180
                        spacing: 20
                        Repeater {
                            id: markRe
                            model: modelRe
                            HLK_MarkButton {
                                button_text: modelData
                                markEnable: PAGEMODE == QmlData.VISIT_TYPE_SEE ? false : true
                                onClicked: {
                                    realistictext.text = realistictext.text + button_text + ";"
                                }
                            }
                        }
                    }
                }
                HLK_MultilineTextEdit {
                    x: realText.x + realText.width + 20
                    id: realistictext
                    mode: 1
                    modehint: "写实最多输入字符不超过三行"
                    width: 960
                    height: 100
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

    HLK_PopupWindow {
        id: popWindow
        visible: false
        anchors.fill: parent
        popupWindowTitle: "是否要删除此图片？"
        Row {
            spacing: 50
            anchors.horizontalCenter: parent.horizontalCenter
            y: 220
            HLK_Button {
                width: 130
                button_text: "是"
                onClicked: {
                    var delImgPath = photoDisplyViewModel.get(
                                viewCurrentIndex).photopath
                    var tempImgpath = qmlData.cutStr(delImgPath, 8, 0)
                    photoDisplyViewModel.remove(viewCurrentIndex) //删除列表中的图片
                    qmlData.deleteFile(tempImgpath) //删除本地图片

                    popWindow.visible = false
                }
            }
            HLK_Button {
                width: 130
                button_text: "否"
                onClicked: {
                    popWindow.visible = false
                }
            }
        }
    }

}

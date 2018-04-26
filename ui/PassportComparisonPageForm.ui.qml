import QtQuick 2.4
import "qrc:/controls/ui"
import QtQuick.Controls 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

Rectangle {
    id: addphotoid
    property string themeColor: JSL.themeColor()
    property alias shotBtn: shotBtn
    property alias face_preview: face_preview
    property alias indicator: indicator
    property alias compareResult: compareResult
    property bool isdisplay: false
    property string rowone: ""
    property string rowtwo: ""
    property string cardColor: ""
    property string passportColor: ""
    property alias cardCompare: cardCompare
    property alias passportCompare: passportCompare
    property bool isShowRowone: false
    property bool isShowRowtwo: false

    width: 1140
    height: 240

    MouseArea {
        anchors.fill: parent
        onClicked: {
            emit: componentRecovery()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"
        Row {
            x: 20
            y: 20
            spacing: 50
            HLK_AddButton {
                id: shotBtn
                y: 10
                width: 143
                height: 183
                imgPath: "qrc:/images/images/face.png"
            }
            Row {
                spacing: 200
                Rectangle {
                    visible: isdisplay
                    width: 143
                    height: 183
                    radius: 10
                    y: 9
                    color: "#EEEEEE"
                    Image {
                        //人脸
                        id: face_preview
                        anchors.centerIn: parent
                        cache: false
                        source: "qrc:/images/images/renyuan.png"
                        onSourceChanged: {
                            face_preview.width = 143
                            face_preview.height = 183
                        }
                        MouseArea {
                            //放大所点击的图片
                            anchors.fill: parent
                            onClicked: {
                                var path = face_preview.source
                                doubleMax.imgPath= path
                                doubleMax.maxVisble = true
                                doubleMax.bgVisble = true
//                                picMax.source = path
//                                picMax_bg.visible = true
//                                picMax.visible = true
                            }
                        }
                    }
                }
                Rectangle {
                    id: compareResult
                    width: 450
                    height: 200
                    Column {
                        //anchors.top: parent.top
                        //anchors.topMargin: 50
                        //anchors.left: parent.left
                        //anchors.leftMargin:20
                        //anchors.verticalCenter: parent.verticalCenter
                        //anchors.fill: parent
                        width: 450
                        height: 200
                        spacing: 20
                        Row {
                            id: showRowone
                            visible: isShowRowone
                            spacing: 10
                            Image {
                                id: cardCompare
                                width: 30
                                height: 30
                                cache: false
                                source: ""
                            }
                            Text {
                                width: 250
                                height: 50
                                font.family: "SimHei"
                                font.pixelSize: 28
                                color: cardColor
                                text: rowone
                            }
                            anchors.top: parent.top
                            anchors.topMargin: showRowtwo.visible ? 50 : 80
                        }
                        Row {
                            id: showRowtwo
                            visible: isShowRowtwo
                            spacing: 10
                            Image {
                                id: passportCompare
                                width: 30
                                height: 30
                                cache: false
                                source: ""
                            }
                            Text {
                                width: 250
                                height: 50
                                font.family: "SimHei"
                                font.pixelSize: 28
                                color: passportColor
                                text: rowtwo
                            }

                            anchors.top: parent.top
                            anchors.topMargin: showRowone.visible ? 110 : 80
                        }
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

    BusyIndicator {
        id: indicator
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        running: false
    }
}

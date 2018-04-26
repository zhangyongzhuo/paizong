import QtQuick 2.4
import "qrc:/controls/ui/"
import QtQuick.Controls 1.2
import QtMultimedia 5.4

//身份证识别页
HLK_BasePage{
    pageTitle: "拍照"
    property alias shoot: shoot
    property alias cameraLoader: cameraLoader
    property alias idcardIndicator: idcardIndicator
    property alias messagebox: messagebox

    property string photoFlag: ""
    property int photoindex: 0
    property bool bFirstShot: true
    property int photoModelCount: 0
    property string delImgPath: ""
    property bool bHaveDelItem: false
    property alias photoModel: photoModel
    //property alias picMax:picMax
    //property alias picMax_bg:picMax_bg
    property alias photoListView:photoListView
    property alias photoNumber:photoNumber

    property int viewCurrentIndex: -1   //当前选中的照片

    Rectangle {
        x: 20
        y: 100
        width: 1235
        height: 400
        color: "#FFFFFF"
        radius: 10
        Rectangle {
            anchors.centerIn: parent
            width: 480
            height: 360

            HLK_CameraLoader{
                id: cameraLoader
                anchors.fill: parent
            }

            BusyIndicator{
                id: idcardIndicator
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                running: false
            }
        }

        HLK_ImageButton{
            id: shoot
            x: 1000
            anchors.verticalCenter: parent.verticalCenter
            imagePath: "qrc:/images/images/camera2.png"
            imagePressePath:"qrc:/images/images/camera1.png"
        }
    }
    Rectangle{//图片列
        id:photoRectangle
        color:"#FFFFFF"
        width: 1240
        height: 195
        radius: 10
        x: 20
        y: 520

        Component{
            id: imgDelegate
            Item{
                id: wrapper
                width: 200+20
                height: 151+20
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        wrapper.ListView.view.currentIndex = index
                        photoindex = index
                        var path = photoModel.get(index).value
                        delImgPath = path

                        photoModel.setProperty(photoindex, "flag", true)
                        var tempImgpath = delImgPath
                        var n = tempImgpath.indexOf("IMG_")
                        var imgName = tempImgpath.substring(n, tempImgpath.length)
                        photoModel.setProperty(photoindex, "resname", imgName)
                        bHaveDelItem = true

                    }
                }
                Column {
                    Image {
                        id: img
                        width: 200
                        height: 151
                        source: value
                        cache:false

                        MouseArea{//放大所点击的图片
                            anchors.fill: parent
                            onClicked: {
                                wrapper.ListView.view.currentIndex = index
                                photoindex = index
                                var path = photoModel.get(index).value
//                                picMax.source = path
//                                picMax_bg.visible = true
//                                picMax.visible = true
                                doubleMax.imgPath= path
                                doubleMax.maxVisble = true
                                doubleMax.bgVisble = true
                            }
                        }
                        Image{
                            id: selected
                            source:"qrc:/images/images/tb002-2.png"
                            anchors.right: parent.right
                            anchors.top: parent.top
                            visible: true

                            MouseArea{
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

        ListView {
            id: photoListView
            orientation: ListView.Horizontal

            anchors.left: parent.left
            anchors.leftMargin: 10
            y: 10
            height: 195
            width: 1220

            clip: true
            spacing: 10
            focus: true
            delegate: imgDelegate
            model: ListModel{
                id: photoModel
                ListElement {
                    value: ""
                    name: ""
                    type: "image"
                    flag: false
                    resname: ""
                }
            }
        }
        Text{
            id:photoNumber
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5
            color: '#666666'
            //text: control.text
            font.family: "SimHei"
            font.pixelSize: 24
            wrapMode: Text.WordWrap
        }
    }
    //图片预览
//    Rectangle{
//        id:picMax_bg
//        color:"black"
//        opacity:0.7
//        anchors.fill: parent
//        visible: false
//        MouseArea{
//            anchors.fill: parent
//            onClicked: {
//                picMax_bg.visible = false
//                picMax.visible = false
//            }
//        }
//    }

//    Image{
//        id: picMax
//        width: 660
//        height: 466
//        anchors.verticalCenter: parent.verticalCenter
//        anchors.horizontalCenter: parent.horizontalCenter
//    }

    HLK_MessageBox{
        id: messagebox
    }

    HLK_PopupWindow {
        id: popWindow
        visible: false
        anchors.fill: parent
        popupWindowTitle: "是否要删除此图片？"
        Row {
            spacing: 100
            anchors.horizontalCenter: parent.horizontalCenter
            y: 400
            HLK_Button {
                width: 130
                button_text: "是"
                onClicked: {
                    var delImgPath = photoModel.get(viewCurrentIndex).value
                    var tempImgpath = qmlData.cutStr(delImgPath, 8, 0)
                    photoModel.remove(viewCurrentIndex) //删除列表中的图片
                    qmlData.deleteFile(tempImgpath) //删除本地图片
                    photoNumber.text=photoModel.count+"/5"

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

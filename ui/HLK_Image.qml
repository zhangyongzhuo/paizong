import QtQuick 2.4

Image {
    property int imgWidth: 143
    property int imgHeight: 183
    property bool imgCache: false
    property string imgSource: ""
    property bool imgDelete: false
    signal deleteButtonClicked()
    //双击图片最大
    signal doubleMaxClicked()

    width: imgWidth
    height: imgHeight
    cache: imgCache
    source: imgSource

    HLK_SimpleImageButton{
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.right: parent.right
        anchors.rightMargin: 2
        normal_path: "qrc:/images/images/tb002-2.png"
        checked_path: "qrc:/images/images/tb002-2.png"
        width: 20
        height: 20
        visible: imgDelete
        onClicked: {
            emit: deleteButtonClicked()
        }
    }
    MouseArea{//放大所点击的图片
        x:0
        y:0
        width:imgWidth-22
        height:imgHeight-22
        onClicked: {
            emit: doubleMaxClicked()
        }
    }
}



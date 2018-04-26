import QtQuick 2.0

Item {
    property string imgPath: ""           //双击放大显示的图片路径
    property bool maxVisble: false        //黑色底色区域是否显示
    property bool bgVisble: false         //放大图片是否显示
    width: 1280
    height:730

    Rectangle {
        id: picMax_bg
        color: "black"
        opacity: 0.7
        anchors.fill: parent
        visible: bgVisble
        MouseArea {
            anchors.fill: parent
            onClicked: {
                bgVisble = false
                maxVisble = false
            }
        }
    }
    Image {
        id: picMax
        width: 640//906//920//660
        height:480//640//650//466
        source:imgPath
        visible:maxVisble
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

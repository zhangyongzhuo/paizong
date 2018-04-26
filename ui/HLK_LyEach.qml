import QtQuick 2.0

Item {
    width:1220
    height:80
    property string iconpath: ""
    property string btnText: ""
    Rectangle{
        id:oneline
        width: 6
        height: 32
        color: "#07a1bc"
//        anchors.top:parent.top
//        anchors.topMargin: 20
        anchors.verticalCenter: parent.verticalCenter

    }
    Image {
        id:twoline
        source: iconpath
        anchors.left:oneline.right
        anchors.leftMargin: 14
        anchors.verticalCenter: parent.verticalCenter
    }
    Text{
//        anchors.top:parent.top
//        anchors.topMargin: 23
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: twoline.right
        anchors.leftMargin: 10
        font.family: "SimHei"
        font.pixelSize: 28
        color: "#343434"
        text: btnText
    }
}

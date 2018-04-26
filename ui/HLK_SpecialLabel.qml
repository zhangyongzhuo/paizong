import QtQuick 2.0

Item {
    width:200
    height:80
    property string iconpath: ""
    property string btnText: ""
    property string timeText: ""
    property string lineColor: ""
    Rectangle{
        width: 6
        height: 32
        color: lineColor
        anchors.verticalCenter: parent.verticalCenter
    }
    Image {
        source: iconpath
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.verticalCenter: parent.verticalCenter
    }
    Text{
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 70
        font.family: "SimHei"
        font.pixelSize: 28
        color: "#343434"
        text: btnText
    }
    Text{
        anchors.top: parent.top
        anchors.topMargin: 75
        anchors.left: parent.left
        anchors.leftMargin: 70
        font.family: "SimHei"
        font.pixelSize: 20
        color: "#5A5A5A"
        text: timeText
    }
}

import QtQuick 2.0

Rectangle {
    property int barWidth: 1280
    property int barHeight: 100
    property string barColor: "#FFFFFF"
    property string barTextL: ""
    property string barTextR: ""
    signal sysSetNavigationClicked()

    color: barColor
    width: barWidth
    height: barHeight
    MouseArea{
        anchors.fill: parent
        onClicked: {
            emit: sysSetNavigationClicked()
        }
    }
    Text{
        id: textL
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
        text: barTextL
        font.pixelSize: 28
        font.family: "SimHei"
        color: "#4D4D4D"
    }
    Text{
        id: textR
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        text: barTextR
        font.pixelSize: 22
        font.family: "SimHei"
        color: "#AAAAAA"
    }
}

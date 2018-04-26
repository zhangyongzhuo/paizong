import QtQuick 2.0

HLK_Border{
    property alias text: mb_text.text
    property int nIntervalTime: 2000
    signal hideMessagebox()

    id: messageBox
    height: 100
    width: mb_text.width + 50
    visible: false
    bg_color:"#D5D5D5"
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    HLK_NormalText{
        id: mb_text
        color: "#fb2409"
        text: ""
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    onVisibleChanged: {
        if(visible){
            tm.start()
        }
    }

    Timer{
        id: tm
        interval: nIntervalTime
        running: false
        onTriggered: {
            messageBox.visible = false
            hideMessagebox()

        }
    }
}

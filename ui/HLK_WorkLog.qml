import QtQuick 2.0

Rectangle {
    property string workLogText:""   //
    property string workLogTime:""
    property bool btnVisble:false //编辑是否可见
    property alias workLog:workLog
    width:  1240
    height: workLog.height+80
    color:"#f2f2f4"

    signal enterEtitMode()

    Rectangle {
        x:0
        y:0
        height: workLog.height+60
        width:  1240
        color:"#ffffff"
        Text{
            id:workLog
            x:20
            y:20
            text:workLogText
            font.pixelSize: 20
            font.family: "SimHei"
            width: parent.width-40
            lineHeight: 2
            color: "#474747"
            wrapMode: Text.WrapAnywhere
            elide: Text.ElideLeft
        }
        Text{
            text:workLogTime
            font.pixelSize: 20
            font.family: "SimHei"
            width: 200
            color: "#999999"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20

        }
        HLK_Button{
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20
            button_text:"编辑"
            visible:btnVisble
            onClicked: {
                emit:enterEtitMode()
            }
    }
}
}

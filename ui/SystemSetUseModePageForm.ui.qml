import QtQuick 2.4
import "qrc:/controls/ui"
import QtQuick.Controls 1.2
import QtMultimedia 5.4

HLK_BasePage {
    property alias modeOnline: modeOnline
    property alias modeOffline: modeOffline
    property alias messagebox: messagebox
    pageTitle: "使用模式"
    Rectangle {
        color: "#FFFFFF"
        x: 20
        y: 100
        width: 1240
        height: 100

        Row {
            x: 30
            anchors.verticalCenter: parent.verticalCenter
            HLK_NormalText {
                width: 150
                text: "使用模式:"
            }
            ExclusiveGroup {
                id: eg
            }
            HLK_NormalRadioButton {
                id: modeOnline
                width: 200
                text: "在线"
                exclusiveGroup: eg
            }
            HLK_NormalRadioButton {
                id: modeOffline
                width: 200
                text: "离线"
                exclusiveGroup: eg
            }
        }
    }
    HLK_MessageBox {
        id: messagebox
    }
}

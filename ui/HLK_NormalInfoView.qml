import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL
Item {
    width: 400
    height: 200
    property alias infoModel: infoModel

    Component {
        id: infoDelegate
        Rectangle {
            width: 450
            height: 200
            color: "#EDEDED"

            Image {
                anchors.left: parent.left
                width: 150
                height: 200
                cache: false
                source: IMG
            }

            Column {
                anchors.top: parent.top
                anchors.topMargin: 30
                anchors.left: parent.left
                anchors.leftMargin: 170
                spacing: 20
                Text{
                    width: 250
                    height: 50
                    font.family: "SimHei"
                    font.pixelSize: 28
                    color: JSL.themeColor()
                    text: ROW1
                }
                HLK_NormalText{
                    text: ROW2
                }
                HLK_NormalText{
                    text: ROW3
                }
            }
        }
    }
    ListView{
        anchors.fill: parent
        clip: true
        orientation: ListView.Horizontal
        focus: true
        spacing: 10
        model: ListModel {
            id: infoModel
            ListElement {
                IMG: ""
                ROW1: ""
                ROW2: ""
                ROW3: ""
            }
        }
        delegate: infoDelegate
    }

}

import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL
Button {
    width: 200
    height: 136
    property string image: ""
    property string row1: ""
    property string row2: ""
    property string row3: ""
    style: ButtonStyle{
        background: Rectangle{
            color: "#FFFFFF"
            Column {
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.left: parent.left
                anchors.leftMargin: 15
                spacing: 10
                Text{
                    width: 250
                    height: 40
                    font.family: "SimHei"
                    font.pixelSize: 28
                    color: JSL.themeColor()
                    text: row1
                }
                Rectangle{
                    height: 1
                    width: 150
                    color: "#DCDCDC"
                }
                HLK_NormalText{
                    text: row2
                }
                HLK_NormalText{
                    text: row3
                }
            }
        }
    }
}

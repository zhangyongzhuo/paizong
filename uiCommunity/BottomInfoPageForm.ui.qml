import QtQuick 2.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0

//底部展位模块
Item {
    width: 1070
    height: 220 //300

    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"
        Rectangle {
            anchors.fill: parent
            anchors.top: parent.top
            anchors.topMargin: 60
            Text{
                anchors.fill: parent
                text:"已经到达底部了"
                font.family:'SimHei'
                font.pixelSize:50
                color: '#979797'
                horizontalAlignment: Text.AlignHCenter
                //verticalAlignment: Text.AlignVCenter
            }
        }
    }
}

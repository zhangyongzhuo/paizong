import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL
//import "qrc:/common/util.js" as Util
//import "qrc:/common/"
//import "qrc:/timeControl/"
Item{//
    id:root

    scale: PathView.iconScale!==undefined?PathView.iconScale:1
    opacity: PathView.iconOpacity!==undefined?PathView.iconOpacity:1
    z:PathView.iconZ!==undefined?PathView.iconZ:1

    signal selected(int index);

    transform: Rotation {
        id: rotation

        origin.x: root.width/2
        origin.y: root.height/2
        axis.x: 1
        axis.y: 0
        axis.z: 0
        angle: root.PathView.iconAngle!==undefined?root.PathView.iconAngle:0
    }

    Text{
        id:timeText
        anchors.centerIn: parent
        text:order?Number(modelData)+orderStartNum:modelData
        verticalAlignment: Text.AlignVCenter
        font.pixelSize:root.PathView.isCurrentItem ? 32:30
        font.bold: root.PathView.isCurrentItem ?true:false
        color: root.PathView.isCurrentItem ? highlightColor : textColor
    }

    MouseArea{
        id:itemMouseArea
        anchors.fill: parent

//        onClicked: {
//            root.selected(index)
//        }
    }

}//Item

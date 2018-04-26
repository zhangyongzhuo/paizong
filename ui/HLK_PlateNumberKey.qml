import QtQuick 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4

Item{
    width: baseWidth
    height: baseHeight
    property string baseColor: "white"
    property string enteredColor: "yellow"
    property string exitedColor: "white"
    property string clickedColor: "orange"
    property int fontSize: 20
    property string fontFamily: "微软雅黑"
    property int baseWidth: 90
    property int baseHeight: 90
    property int baseRadius: 45
    property string keyText: ""
    property alias keyEvent: keyEvent
    property alias keyName: keyName

    Rectangle{
        width: baseWidth
        height: baseHeight
        radius: baseRadius
        color: baseColor
        Text{
            id:keyName
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: keyText
            font.family: fontFamily
            font.pointSize: fontSize
        }
        MouseArea{
            id: keyEvent
            anchors.fill: parent
//            hoverEnabled: true
//            //onEntered: parent.color = enteredColor
//            onExited: {
//                parent.color = exitedColor
//            }
            onClicked: {
                parent.color = clickedColor
                emit: digiPressChanged(keyText)
            }

        }

        Connections{
            target: mainQml
            onDigiPressChanged:{
                if(text != keyText){
                    keyEvent.parent.color = exitedColor
                }
            }
        }
    }
}

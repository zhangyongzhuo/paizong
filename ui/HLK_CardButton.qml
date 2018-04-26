import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL

Button{
    width: 150
    height:wholeHight//100// 180
    property int wholeHight: 180
    property int imageHight:143
    property int rightHight: 86
    property int rightWidth: 90
    property bool checked: false
    property string name:""
    property string phoneNumber:"电话:暂缺"
    property bool canChecked: true
    property bool delEnable: false
    property string themeColor: JSL.themeColor()

    signal checkedButtonClicked(bool select)

    style: ButtonStyle{
        background: Rectangle{
            anchors.fill: parent
            color: "#EEEEEE"
            radius: 10
            border.width: 1
            border.color: "#EEEEEE"

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                y:5
                height: parent.height/4*3
                width: parent.width-5
                color: parent.color
                Text {
                    height: parent.height
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: name
                    font.pixelSize: 26
                    font.family: "SimHei"
                    color: "#474747"
                    wrapMode:Text.WrapAnywhere
                    elide: Text.ElideRight
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

            }

            Rectangle {
                y:parent.height/4*3
                width: 150
                height: 2
                color: "#FFFFFF"
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                y:parent.height/4*3
                height: parent.height/4
                color: parent.color
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text:phoneNumber// "电话:暂缺"
                    font.pixelSize: 18
                    font.family: "SimHei"
                    color: "#474747"
                }

            }
            Image{
                id:photoimage
                width:141
                height:imageHight
//                width: 141
//                height: 143
                //source:photosource

                Image{
                    source: "qrc:/images/images/ico1.png"
                    anchors.centerIn: parent
                    visible: canChecked?checked:false
                    width:rightWidth
                    height:rightHight
                }

            }

        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            checked = !checked
            emit: checkedButtonClicked(checked)
        }
    }
}



import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL
Button {
    width: 390
    height: 138
    property string image: ""
    property string row1: ""
    property string row2: ""
    property string row3: ""
    property bool   isShowText:false
    property int    isShowUpload:1
    property string showTextTitle:"在户人数"
    property string showText:""
    property int    lineSpacing: 10
    property int    imgwidth: 110
    property int    imgheight: 136
    property int    topdistance:1
    property bool   isvisible:false
    property bool   globalTask:false

    property string borderColor:"#E4E4E4"

    //property bool   isDeletechecked: false

    //property bool   isDeletechecked: false

    property alias deletecheck: deletecheck
    property string backgroundColor: "#FFFFFF"

    style: ButtonStyle{
        background: Rectangle{
            color: backgroundColor
            Image {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: topdistance
                anchors.leftMargin: topdistance
                width: imgwidth
                height: imgheight
                cache: false
                source: image
                visible: !isShowText
                verticalAlignment:Image.AlignVCenter
            }
            Column {
                visible: isShowText
                Text{
                    width: 110
                    height: 36
                    font.family: "SimHei"
                    font.pixelSize: 16
                    color: JSL.themeColor()
                    text: showTextTitle
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                }
                Text{
                    width: 110
                    height: 100
                    font.family: "SimHei"
                    font.pixelSize: 60
                    color: JSL.themeColor()
                    text: showText
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                }
            }

            Column {
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.left: parent.left
                anchors.leftMargin: 130
                spacing: lineSpacing
                Text{
                    width: 250
                    height: 40
                    font.family: "SimHei"
                    font.pixelSize: 28
                    color: JSL.themeColor()
                    text: row1//.length>8 ? row1.substring(0,8)+'...' : row1
                    elide: Text.ElideRight
                }
                Rectangle{
                    height: 1
                    width: 250
                    color: "#DCDCDC"
                }
                Text{
                    width: 250
                    elide: Text.ElideRight
                    color:"#343434"
                    text: row2
                    font.pixelSize: 20
                    font.family: "SimHei"
                }
                Text{
                    width: 250
                    elide: Text.ElideRight
                    color:"#343434"
                    text: row3
                    font.pixelSize: 20
                    font.family: "SimHei"
                }
//                HLK_NormalText{
//                    text: row2//JSL.isCardNo(row2) || JSL.checkMobile(row2) ? row2 : (row2.length>10 ? row2.substring(0,10)+'...' : row2)
//                }
//                HLK_NormalText{
//                    text: row3//JSL.isCardNo(row3) || JSL.checkMobile(row3) ? row3 : (row3.length>10 ? row3.substring(0,10)+'...' : row3)
//                }
            }

            Image {
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10
                width: 35
                height: 28
                cache: false
                source:'qrc:/images/images/wsc.png'
                visible: isShowUpload == 1 ? false : true
            }

            border.width: 1
            border.color: borderColor
        }
    }
    Text{
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.right: parent.left
        anchors.rightMargin: 40
        width: 100
        height: 34
        font.family: "SimHei"
        font.pixelSize: 18
        color: 'red'
        text:"全局任务"
        visible:globalTask
    }
    HLK_Checkbox{
        id:deletecheck
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 8
        visible:isvisible
        //visible:ISVISIBLE
        //visible:true//checkVisible
        z:1
    }
}

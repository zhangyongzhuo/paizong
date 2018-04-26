import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL
Button {
    width: 400
    height: 183
    property string image: ""
    property string row1: ""
    property string row2: ""
    property string row3: ""
    property bool   isShowText:false
    property int    isShowUpload:1
    property string showTextTitle:"在户人数"
    property string showText:""
    property int    lineSpacing: 10
    property int imgwidth: 143
    property int imgheight: 183
    property int topdistance:0
    property var model: model
    property bool delvisible: true
    signal deleteButtonClicked()

    style: ButtonStyle{
        background: Rectangle{
            color: "#EEEEEE"
            Image {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: topdistance
                width: imgwidth
                height: imgheight
                cache: false
                //source:image
                visible: !isShowText
                verticalAlignment:Image.AlignVCenter               
                anchors.leftMargin: topdistance
                source: image=="" ? "qrc:/images/images/NoPicture.jpg" : image
            }
            Column {
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.left: parent.left
                anchors.leftMargin: 180
                spacing: lineSpacing
                Text{
                    width: 250
                    //elide: Text.ElideRight
                    height: 32
                    font.family: "SimHei"
                    font.pixelSize: 24
                    color: JSL.themeColor()
                    text: row1.length>8 ? row1.substring(0,8)+'...' : row1
                }

//                Text{
//                    width: 250
//                    elide: Text.ElideRight
//                    color:"#343434"
//                    text: row2
//                    font.pixelSize: 20
//                    font.family: "SimHei"
//                }
//                Text{
//                    width: 250
//                    elide: Text.ElideRight
//                    color:"#343434"
//                    text: row3
//                    font.pixelSize: 20
//                    font.family: "SimHei"
//                }
                HLK_NormalText{
                    text: JSL.isCardNo(row2) || JSL.checkMobile(row2) ? row2 : (row2.length>10 ? row2.substring(0,10)+'...' : row2)
                }
                HLK_NormalText{
                    text: JSL.isCardNo(row3) || JSL.checkMobile(row3) ? row3 : (row3.length>10 ? row3.substring(0,10)+'...' : row3)
                }
            }
//            Image{
//                id: selected
//                source: "qrc:/images/images/tb002-2.png"
//                anchors.right: parent.right
//                anchors.top: parent.top
//                visible:delvisible
//                MouseArea {
//                    anchors.fill: parent
//                    onClicked: {
//                        console.log("--------11111111111111")
//                        emit: deleteButtonClicked()
//                    }
//                }
//            }

        }
    }

    HLK_SimpleImageButton{
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.right: parent.right
        anchors.rightMargin: 2
        normal_path: "qrc:/images/images/tb002-2.png"
        checked_path: "qrc:/images/images/tb002-2.png"
        width: 20
        height: 20
        visible: delvisible
        onClicked: {
            emit: deleteButtonClicked()
        }
    }
}

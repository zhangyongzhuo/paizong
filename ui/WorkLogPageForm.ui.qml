import QtQuick 2.4
import "qrc:/controls/ui/"
import QtQuick.Controls 1.2
import QtMultimedia 5.4
import QtQuick.Controls.Styles 1.2

//工作日志页
HLK_BasePage{
    pageTitle: "工作日志"
    //property alias currentTime:currentTime //
    property alias workSpecification:workSpecification
    property alias wordsNumber:wordsNumber
    property alias messagebox: messagebox
    property alias busying: busying
    property int defaultTextSize: 28
    Rectangle {
        y:100
        width: parent.width-40
        height: parent.height - 130
        color: "#FFFFFF"
        anchors.horizontalCenter: parent.horizontalCenter
//        Flow {
//            x: 20
//            y: 50
//            width: 1000
//            spacing: 50
//            Row {
//                //照片区域
//                width: 1000
//                spacing: 20
//                HLK_NormalText {
//                    //y: 50
//                    text: "日志时间:"
//                    width: 80
//                }
//                HLK_NormalText {
//                    id:currentTime
//                    //y: 50
//                    text: "默认当前服务时间,且不可修改"
//                    width: 400
//                }
//            }
//            Column {
//                spacing: 20
                Row {
                    x: 20
                    y: 20
                    width: 1100
                    spacing: 20
                    HLK_NormalText {
                        id: realText
                        y: workSpecification.y + 13
                        text: "工作描述:"
                        width: 80
                    }
                    HLK_MultilineTextEdit{
                        x: realText.x + realText.width + 20
                        id: workSpecification
                        width: 1100
                        height: 460
                        textSize: defaultTextSize
                        Text{
                            id:wordsNumber
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 5
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            color: '#666666'
                            //text: control.text
                            font.family: "SimHei"
                            font.pixelSize: 24
                            wrapMode: Text.WordWrap
                        }
                        onTextChanged: {
                            wordsNumber.text=workSpecification.text.length+"/"+512
                        }
                    }
//                    Label{
//                        id:wordsNumber
//                        anchors.bottom: parent.bottom
//                        anchors.bottomMargin: 5
//                        anchors.right: parent.right
//                        anchors.rightMargin: 5
//                    }
                }
//            }
//            HLK_NormalText {
//                width: 480
//            }
//        }
    }

    HLK_MessageBox{
        id: messagebox
    }
    BusyIndicator{
        id: busying
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        running: false
    }
}

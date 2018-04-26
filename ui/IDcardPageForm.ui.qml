import QtQuick 2.4
import QtMultimedia 5.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0


//身份证采集页
Item {
    id: cardModular
    width: 1140
    height: defaultHeight + view.height
    property alias flagModel: flagModel //标签
    property alias idcardCollectonBtn: idcardCollectonBtn //OCR识别
    property alias faceImg: faceImg
    property alias cardInfo_idcard: cardInfo_idcard
    property alias cardInfo_name: cardInfo_name
    property alias cardInfo_sex: cardInfo_sex
    property alias cardInfo_nation: cardInfo_nation
    property alias cardInfo_birth: cardInfo_birth
    property alias cardInfo_address: cardInfo_address
    property alias idcard: cardInfo_idcard.text
    property alias view: view
    property alias cardModular: cardModular
    property int defaultImgWidth: 110
    property alias onLineCheckBtn: onLineCheckBtn
    //property alias offLineCheckBtn: offLineCheckBtn
    property string checkText: ""
    property alias btnArea: btnArea
    property int defaultHeight: 178
    property bool collectonVisble: false

    property bool cadeEnabled:true //修改状况下除了在线核查按钮外其他不可用


    MouseArea {
        anchors.fill: parent
        onClicked: {
            emit: componentRecovery()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"
        Flow {
            //照片
            x: 20
            y: 20
            width: 120
            spacing: 15
            Rectangle {
                x: 169
                y: 358
                width: 143
                height: 183
                radius: 10
                color: "#EEEEEE"
                Image {
                    //身份证头像
                    width: 143
                    height: 183
                    id: faceImg
                    anchors.centerIn: parent
                    cache: false
                    source: "qrc:/images/images/sfzn.png"
                    onSourceSizeChanged: {
                        if (width > defaultImgWidth) {
                            width = parent.width
                            height = parent.height
                        }
                    }
                }
            }
        }

        Flow {
            //身份证信息
            x: 180
            y: 20
            width: 1000
            spacing: 20
            enabled: cadeEnabled
            Row {
                width: 425
                spacing: 20
                HLK_NormalText {
                    y: cardInfo_idcard.y + 13
                    text: "身份证:"
                    width: 80
                }
                HLK_TextEdit {
                    id: cardInfo_idcard
                    width: 345

                }
            }
            Row {
                width: 495
                spacing: 20
                HLK_NormalText {
                    y: cardInfo_name.y + 13
                    text: "　　姓　名:"
                    width: 130
                }
                HLK_TextEdit {
                    id: cardInfo_name
                    width: 345
                }
            }

            Row {
                width: 183
                spacing: 20
                z: 1
                HLK_NormalText {
                    y: cardInfo_sex.y + 13
                    text: "性　别:"
                    width: 80
                }
                HLK_TextEdit {
                    id: cardInfo_sex
                    width: 103
                }
            }

            Row {
                width: 222
                spacing: 20
                z: 2
                HLK_NormalText {
                    y: cardInfo_nation.y + 13
                    text: "　　民　族:"
                    width: 120
                }
                HLK_TextEdit {
                    id: cardInfo_nation
                    width: 102
                }
                ListModel {
                    id: nationData
                    ListElement {
                        text: "汉"
                        code: "1"
                    }
                    ListElement {
                        text: "满"
                        code: "2"
                    }
                }
            }

            Row {
                width: 495
                spacing: 20
                HLK_NormalText {
                    y: cardInfo_birth.y + 13
                    text: "　　出　生:"
                    width: 130
                }
                HLK_TextEdit {
                    id: cardInfo_birth
                    width: 345
                    hint: '日期:1979年01月01日'
                }
            }

            Row {
                width: 940
                spacing: 20
                HLK_NormalText {
                    y: cardInfo_address.y + 13
                    text: "住　址:"
                    width: 80
                }
                HLK_TextEdit {
                    id: cardInfo_address
                    width: 840
                }
            }
        }
        Rectangle {
            Column {
                x: 20
                y: 220
                id: btnArea
                spacing: 15
                enabled: cadeEnabled
                HLK_Button {
                    id: idcardCollectonBtn
                    button_text: "拍照识别"
                    width: 143
                }
                HLK_Button {
                    //id: idcardCollectonBtn
                    button_text: "人像识别"
                    visible: collectonVisble
                    width: 143
                    //MouseArea {
                    //    anchors.fill: parent
                        onClicked: {
                            // var faceRecognitionUrl = operateconfigfile.getExternalLinksFaceRecognition()
                            // Qt.openUrlExternally(faceRecognitionUrl)
                            // stackView.push("qrc:/singleFunction/ui/UndocumentedPage.qml")
                            emit: faceRecognitionOperation()
                        }
                   // }
                }
            }
            ListView {
                id: view
                x: 180
                y: onLineCheckBtn.y

                width: 775
                height: 100 //flagModel.count>5 ? 200 : 100
                clip: true
                orientation: ListView.Horizontal
                spacing: 10
                model: ListModel {
                    id: flagModel
                    ListElement {
                        FLAGNAME: ""
                        FLAGCOLOR: ""
                    }
                }
                delegate: HLK_Label {
                    label_text: FLAGNAME
                    label_color: FLAGCOLOR
                }
            }
            HLK_Button {
                id: onLineCheckBtn
                x: 975
                // y: 233
                anchors.verticalCenter: btnArea.verticalCenter
                button_text: checkText
                width: 143
                visible: false
            }
        }
    }
}

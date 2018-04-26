import QtQuick 2.4
import "qrc:/controls/ui"
import QtQuick.Controls 1.2
import QtMultimedia 5.4


//身份证识别页
HLK_BasePage {
    pageTitle: "拍照识别"
    property alias shot: shot
    property alias cameraLoader: cameraLoader
    property alias idcardIndicator: idcardIndicator //繁忙标志
    property alias messagebox: messagebox

    property alias cardInfo_name: cardInfo_name
    property alias cardInfo_sex: cardInfo_sex
    property alias cardInfo_birth: cardInfo_birth
    property alias cardInfo_nation: cardInfo_nation
    property alias cardInfo_idcard: cardInfo_idcard
    property alias cardInfo_address: cardInfo_address
    property alias faceImg: faceImg
    property int defaultImgWidth: 110

    Rectangle {
        x: 20
        y: 100
        width: 1235
        height: 400
        color: "#FFFFFF"
        radius: 10
        Rectangle {
            anchors.centerIn: parent
            width: 480
            height: 360

            HLK_CameraLoader {
                id: cameraLoader
                anchors.fill: parent
            }

            BusyIndicator {
                id: idcardIndicator
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                running: false
            }
        }

        HLK_ImageButton {
            id: shot
            x: 1000
            anchors.verticalCenter: parent.verticalCenter
            imagePath: "qrc:/images/images/camera2.png"
            imagePressePath:"qrc:/images/images/camera1.png"
            visible: false
        }
    }

    Rectangle {
        x: 20
        y: 520
        width: 1235
        height: 230
        color: "#FFFFFF"
        radius: 10

        Flow {
            //身份证信息
            x: 50
            y: 20
            width: 1000
            spacing: 20
            Row {
                width: 410
                spacing: 20
                HLK_NormalText {
                    y: cardInfo_idcard.y + 13
                    text: "身份证:"
                    width: 80
                }
                HLK_TextEdit {
                    id: cardInfo_idcard
                    width: 330
                }
            }
            Row {
                width: 480
                spacing: 20
                HLK_NormalText {
                    y: cardInfo_name.y + 13
                    text: "　　姓　名:"
                    width: 130
                }
                HLK_TextEdit {
                    id: cardInfo_name
                    width: 330
                }
            }

            Row {
                width: 175
                spacing: 20
                z: 1
                HLK_NormalText {
                    y: cardInfo_sex.y + 13
                    text: "性　别:"
                    width: 80
                }
                HLK_TextEdit {
                    id: cardInfo_sex
                    width: 95
                }
            }

            Row {
                width: 215
                spacing: 20
                z: 1
                HLK_NormalText {
                    y: cardInfo_nation.y + 13
                    text: "　　民　族:"
                    width: 120
                }
                HLK_TextEdit {
                    id: cardInfo_nation
                    width: 95
                }
            }

            Row {
                width: 480
                spacing: 20
                HLK_NormalText {
                    y: cardInfo_birth.y + 13
                    text: "　　出　生:"
                    width: 130
                }
                HLK_TextEdit {
                    id: cardInfo_birth
                    width: 330
                }
            }

            Row {
                width: 910
                spacing: 20
                HLK_NormalText {
                    y: cardInfo_address.y + 13
                    text: "住　址:"
                    width: 80
                }
                HLK_TextEdit {
                    id: cardInfo_address
                    width: 810
                }
            }
        }

        Rectangle {
            x: 1030
            y: 20
            width: 143
            height: 183
            radius: 10
            color: "#EEEEEE"
            Image {
                //身份证头像
                id: faceImg
                anchors.centerIn: parent
                cache: false
                source: "qrc:/images/images/sfzn.png"
                /*onSourceSizeChanged: {
                    if (width > defaultImgWidth) {
                        width = parent.width
                        height = parent.height
                    }
                }*/
            }
        }
    }
    HLK_MessageBox {
        id: messagebox
    }

}

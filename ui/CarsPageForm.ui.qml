import QtQuick 2.4
import "qrc:/controls/ui"
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4


//车辆采集页
Rectangle {
    property alias plateTypeData: plateTypeData
    property alias licensePlateNo: licensePlateNo //车牌号码
    property alias carNumberShotBtn: carNumberShotBtn //车牌号码拍照识别按钮
    property alias licensePlateType: licensePlateType //号牌种类
    property alias carColor: carColor //车身颜色
    property alias vinCode: vinCode //VIN码
    property alias model: model //型号
    property alias brand: brand //品牌
    property alias owner: owner //车辆所有人
    property alias ownerTel: ownerTel //所有人联系方式
    property alias engineNumber: engineNumber //发动机号
    property alias remarks: remarks //备注
    property alias flagModel: flagModel //查回来的标签
    property alias messagebox: messagebox

    property alias keyboard: keyboard
    property int defaultImgWidth: 110
    property alias onLineCheckBtn: onLineCheckBtn
    property alias page: page
    property string checkText: ""

    property alias getFocusComboBox: getFocusComboBox

    //获取焦点
    HLK_TextEdit {
        id: getFocusComboBox
        visible: false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            emit: componentRecovery()
        }
    }

    ListModel {
        id: plateTypeData
        ListElement{
            text:""
            code:""
        }

    }

    width: 1140
    height: 320
    color: "#FFFFFF"
    id: page
    HLK_Button {
        id: onLineCheckBtn
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25
        button_text: checkText
        width: 143
        height: 50
        visible: false
    }
    Row {
        id: carSelectConditionRow
        x: 20
        y: 34
        z: 3
        spacing: 30
        HLK_NormalText {
            y: licensePlateNo.y + 13
            text: "车牌号码:"
            width: 80
        }
        HLK_TextEdit {
            id: licensePlateNo
            width: 492
            rightMargin: 50
            pagename:PAGENAME
            HLK_SimpleImageButton {
                id: carNumberShotBtn
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                normal_path: "qrc:/images/images/photo.png"
                checked_path: "qrc:/images/images/photo1.png"
            }
        }

        HLK_NormalText {
            y: licensePlateType.y + 13
            text: "号牌种类:"
            width: 80
        }
        HLK_ComboBox {
            id: licensePlateType
            width: 360
            model: plateTypeData
            currentIndex: -1
            pagename: PAGENAME
        }
    }

    Rectangle {
        id: carImgArea
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        width: 143
        height: 183
        radius: 10
        color: "#EEEEEE"
        Image {
            id: faceImg
            anchors.centerIn: parent
            cache: false
            source: "qrc:/images/images/car.png"
            onSourceSizeChanged: {
                if (width > defaultImgWidth) {
                    width = parent.width
                    height = parent.height
                }
            }
        }
    }

    Flow {
        x: faceImg.width + 80
        y: carImgArea.y
        width: 900
        height: 183
        spacing: 24
        Row{
            width: 900
            spacing: 10
            HLK_NormalText {
                text: "车身颜色:"
                width: 100
            }

            HLK_NormalText {
                id: carColor
                width: 150
            }

            HLK_NormalText {
                text: "VIN　 码:"
                width: 100
            }

            HLK_NormalText {
                id: vinCode
                width: 150
            }
            HLK_NormalText {
                text: "发动机号:"
                width: 100
            }
            HLK_NormalText {
                id: engineNumber
                width: 280
            }
        }
        Row{
            width: 900
            spacing: 10

            HLK_NormalText {
                text: "车辆品牌:"
                width: 100
            }

            HLK_NormalText {
                id: brand
                width: 150
            }

            HLK_NormalText {
                text: "所 有 人:"
                width: 100
            }

            HLK_NormalText {
                id: owner
                width: 540
            }
        }
        Row{
            width: 900
            spacing: 10

            HLK_NormalText {
                text: "车辆型号:"
                width: 100
            }

            HLK_NormalText {
                id: model
                width: 150
            }

            HLK_NormalText {
                text: "联系方式:"
                width: 100
            }

            HLK_NormalText {
                id: ownerTel
                width: 150
            }

            HLK_NormalText {
                text: "备　　注:"
                width: 100
            }

            HLK_NormalText {
                id: remarks
                width: 280
            }
        }
        ListView {
            id: view
            width: 750
            height: 100
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
                width: 150
            }
        }
    }

    HLK_PlateNumberKeyboard {
        id: keyboard
        z: 6
        y: -200
        visible: false
    }
    HLK_MessageBox {
        id: messagebox
    }
}

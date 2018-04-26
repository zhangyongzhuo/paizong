import QtQuick 2.4
import QtMultimedia 5.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2


//实有房屋信息块
Item {
    property alias messagebox: messagebox

    property alias rentSituation: rentSituation //出租情况
    property alias rentPurposes: rentPurposes //租房用途
    property alias rentType: rentType //租住类型
    property alias rentPathway: rentPathway //承租途径
    property alias expirationDate: expirationDate //到期时间
    property alias ownerRelationship: ownerRelationship //与房主关系
    property alias ownerName: ownerName //房主姓名
    property alias ownerIdcard: ownerIdcard //房主身份证号
    property alias ownerTel: ownerTel //房主电话
    property alias ownerCurrentAdd: ownerCurrentAdd //房主现住址
    property alias qq: qq //QQ号
    property alias weChat: weChat //微信号
    property alias wifi: wifi //网络情况（wifi名称）
    property alias roomRate: roomRate //房费

    width: 1140
    height: 490
    MouseArea {
        anchors.fill: parent
        onClicked: {
            emit: componentRecovery()
        }
    }

    Rectangle {

        anchors.fill: parent
        color: '#FFFFFF'
        Flow {
            width: 1120
            height: 330
            y: 25
            x: 10
            spacing: 15
            HLK_Text {
                textWidth: 140
                textContent: '出租情况:'
            }
            HLK_ComboBox {
                id: rentSituation
                model: rentSituationData
                width: 380
            }

            HLK_Text {
                textWidth: 140
                textContent: '租房用途:'
            }
            HLK_ComboBox {
                id: rentPurposes
                model: rentPurposesData
                width: 400
            }
            HLK_Text {
                textWidth: 140
                textContent: '租住类型:'
            }
            HLK_ComboBox {
                id: rentType
                model: rentTypeData
                width: 380
            }
            HLK_Text {
                textWidth: 140
                textContent: '承租途径:'
            }
            HLK_ComboBox {
                id: rentPathway
                model: rentPathwayData
                width: 400
            }
            HLK_Text {
                textWidth: 140
                textContent: '到期时间:'
            }
            HLK_TextEdit {
                id: expirationDate
                width: 380
            }
            HLK_Text {
                textWidth: 140
                textContent: '与房主关系:'
            }
            HLK_TextEdit {
                id: ownerRelationship
                width: 400
            }
            HLK_Text {
                textWidth: 140
                textContent: '房主姓名:'
            }
            HLK_TextEdit {
                id: ownerName
                width: 380
            }
            HLK_Text {
                textWidth: 140
                textContent: '房主身份证:'
            }
            HLK_TextEdit {
                id: ownerIdcard
                width: 400
            }
            HLK_Text {
                textWidth: 140
                textContent: '房主电话:'
            }
            HLK_TextEdit {
                id: ownerTel
                width: 380
            }
            HLK_Text {
                textWidth: 140
                textContent: '房主现住址:'
            }
            HLK_TextEdit {
                id: ownerCurrentAdd
                width: 400
            }

            HLK_Text {
                textWidth: 140
                textContent: '网络情况:'
            }
            HLK_TextEdit {
                id: wifi
                width: 380
                hint: 'wifi名称'
            }
            HLK_Text {
                textWidth: 140
                textContent: '房费:'
            }
            HLK_TextEdit {
                id: roomRate
                width: 400
            }
            HLK_Text {
                textWidth: 140
                textContent: '房主QQ:'
            }
            HLK_TextEdit {
                id: qq
                width: 380
            }
            HLK_Text {
                textWidth: 140
                textContent: '房主微信:'
            }
            HLK_TextEdit {
                id: weChat
                width: 400
            }
        }
    }

    ListModel {
        id: rentSituationData
        ListElement {
            text: "出租房"
            code: "01"
        }
        ListElement {
            text: "部分出租房"
            code: "02"
        }
        ListElement {
            text: "自住房"
            code: "03"
        }
    }

    ListModel {
        id: rentPurposesData
        ListElement {
            text: "居住"
            code: "01"
        }
        ListElement {
            text: "商用"
            code: "02"
        }
        ListElement {
            text: "仓库"
            code: "03"
        }
        ListElement {
            text: "其他"
            code: "04"
        }
    }

    ListModel {
        id: rentTypeData
        ListElement {
            text: "家庭租住"
            code: "01"
        }
        ListElement {
            text: "单位租住"
            code: "02"
        }
        ListElement {
            text: "多人合租"
            code: "03"
        }
        ListElement {
            text: "单人租住"
            code: "04"
        }
        ListElement {
            text: "混合租住"
            code: "05"
        }
        ListElement {
            text: "旅馆式租住"
            code: "06"
        }
        ListElement {
            text: "其他租住"
            code: "07"
        }
    }

    ListModel {
        id: rentPathwayData
        ListElement {
            text: "房主直接出租"
            code: "01"
        }
        ListElement {
            text: "中介"
            code: "02"
        }
        ListElement {
            text: "承租人转租"
            code: "03"
        }
        ListElement {
            text: "其他"
            code: "04"
        }
    }

    HLK_MessageBox {
        id: messagebox
    }
}

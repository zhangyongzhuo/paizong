import QtQuick 2.4
import QtMultimedia 5.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2


//实有人员寄住人口信息块
Item {
    property alias messagebox: messagebox
    property alias liveAwayTeyp: liveAwayTeyp //寄住类别
    property alias liveAwayReason: liveAwayReason //寄住原因
    property alias liveAwayTime: liveAwayTime //寄住开始时间
    property alias leaveTime: leaveTime //预计离开时间
    property alias resideAddress: resideAddress //居住处所
    property alias remarks: remarks //备注

    width: 1170
    height: 390
    MouseArea {
        anchors.fill: parent
        onClicked: {
            emit: componentRecovery()
        }
    }

    Rectangle {
        width: 1170
        height: 390
        anchors.fill: parent
        color: '#FFFFFF'

        Column{
            width: parent.width
            height: parent.height
            y: 20
            x: 20
            spacing: 20
            Row{
                spacing:40
                Row{
                    spacing:15
                    HLK_Text {
                        textWidth: 150
                        textContent: "<font color='red'>*</font>寄住开始时间:"
                    }
                    HLK_TextEdit {
                        id: liveAwayTime
                        width: 330
                        }
                    }
                Row{
                    spacing:15
                    HLK_Text {
                        textWidth: 150
                        textContent: '预计离开时间:'
                    }
                    HLK_TextEdit {
                        id: leaveTime
                        width: 330
                    }
                }
            }
            Row{
                z:2
                spacing:40
                Row{
                    spacing:15
                    HLK_Text {
                        textWidth: 150
                        textContent: "<font color='red'>*</font>寄住类别:"
                    }
                    HLK_ComboBox {
                        id: liveAwayTeyp
                        model: liveAwayTeypData
                        boxWidth:330
                        boxHeight : 50
                        boxRadius : 6
                        boxTopMargin : 12
                    }
                }
                Row{
                    spacing:15
                    HLK_Text {
                        textWidth: 150
                        textContent: '寄住原因:'
                    }
                    HLK_ComboBox {
                        id: liveAwayReason
                        model: liveAwayReasonData
                        boxWidth:330
                        boxHeight : 50
                        boxRadius : 6
                        boxTopMargin : 12
                    }
                }
            }
            Row{
                z:1
                spacing:15
                HLK_Text {
                    textWidth: 150
                    textContent: '居住处所:'
                }
                HLK_ComboBox {
                    id: resideAddress
                    model: resideAddressData
                    boxWidth:330
                    boxHeight : 50
                    boxRadius : 6
                    boxTopMargin : 12
                }
            }
            Row{
                spacing:15
                HLK_Text {
                    textWidth: 150
                    textHeight:140
                    textContent: '备    注:'
                }
                HLK_TextEdit {
                    id: remarks
                    width: 863
                    height:140
                }
            }
        }
    }

    ListModel {
        id: liveAwayTeypData
        ListElement {
            text: "1-出生"
            code: "01"
        }
        ListElement {
            text: "2-迁入"
            code: "02"
        }
        ListElement {
            text: "3-所内迁入"
            code: "03"
        }
        ListElement {
            text: "4-常住变寄住"
            code: "04"
        }
        ListElement {
            text: "5-从农村到城镇居住"
            code: "05"
        }
    }

    ListModel {
        id: liveAwayReasonData
        ListElement {
            text: "01-工作调动"
            code: "01"
        }
        ListElement {
            text: "02-现住地系动迁区"
            code: "02"
        }
        ListElement {
            text: "03-郊区非农业人口迁入市区"
            code: "03"
        }
        ListElement {
            text: "04-借租房屋不能落户"
            code: "04"
        }
        ListElement {
            text: "05-有两处房户口空挂一处"
            code: "05"
        }
        ListElement {
            text: "06-新大楼未落户口"
            code: "06"
        }
        ListElement {
            text: "07-就学"
            code: "07"
        }
        ListElement {
            text: "08-农业人口购房"
            code: "08"
        }
        ListElement {
            text: "99-其他"
            code: "09"
        }
    }

    ListModel {
        id: resideAddressData
        ListElement {
            text: "树状图"
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

    HLK_MessageBox {
        id: messagebox
    }
}

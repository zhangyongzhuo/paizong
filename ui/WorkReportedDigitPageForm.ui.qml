import QtQuick 2.4
import QtGraphicalEffects 1.0
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4

//工作报备界面
HLK_BasePage{
    pageTitle: "报备统计"
    property alias reportView:reportView
    property alias reportModel:reportModel
    //property alias eachReport:eachReport
    property alias boxMonths:boxMonths   //月份筛选下拉框
    property alias boxMonthsModel:boxMonthsModel   //月份筛选下拉框
    property alias busying:busying //繁忙标志
    property alias reportType:reportType
    property alias noReport:noReport
    property alias messagebox:messagebox
    property alias reportTypeModel:reportTypeModel
    signal revokeReport(var id, var index) //撤销审批信号

    Rectangle{
        x:20
        y:100
        width: 1240
        height:80
        z:99
        color: "#FFFFFF"
        Row{
            x:20
            anchors.verticalCenter: parent.verticalCenter
           // anchors.horizontalCenter: parent.horizontalCenter
            spacing:20
            HLK_ComboBox {
                width:200
                id: boxMonths
                //height:60
                boxWidth  : 181
                boxHeight : 40
                boxRadius : 6
                boxTopMargin : 6
                model: boxMonthsModel
            }
            HLK_ComboBox {
                id:reportType
                width:200
                //height:60
                boxWidth  : 151
                boxHeight : 40
                boxRadius : 6
                boxTopMargin : 6
                model: reportTypeModel
                currentIndex: 0
            }
        }
        ListModel {
            id: boxMonthsModel
            ListElement { text: "" }
        }
        ListModel {
            id: reportTypeModel
            ListElement {text:"全部";code:""}
            ListElement {text:"未审核";code:"400201"}
            ListElement {text:"已批准";code:"400203"}
            ListElement {text:"已驳回";code:"400202"}
        }

    }
     //审批人index
    ListView{//V
        id: reportView
        x: 20
        y: 200
        width: 1240
        height:550
        clip: true
        highlightMoveDuration: 1
        cacheBuffer: 2000
        //implicitHeight:eachReport.hight+20
//        model: ListModel{//M
//            id: reportModel
//            ListElement{
//                PreparationText:""
//                StartTimeStr:""
//                EndTimeStr:""
//                TimeLong:0
//                PlaceStr:""
//                Reason:""
//            }
//        }
        model: reportModel
        delegate:HLK_ReportPage{
            modeStr:reportJson          //报备照片json字符串数组
            //id:eachReport
            preparationText:PreparationText
            startTimeStr:StartTimeStr
            endTimeStr:EndTimeStr
            timeLong:TimeLong
            placeStr:PlaceStr
            approverPer:ApproverPer
            reason:Reason
            examineApproval:ExamineApproval
            approverOpi:ApproverOpi
            onRevokeAction:{
                //发送撤销审批信号
                emit:revokeReport(reportModel.get(index).Id, index)
            }
        }

    }
    //
    ListModel {
        id: reportModel
        ListElement {
            reportJson:""   //报备照片json字符串数组//""
            PreparationText:""
            StartTimeStr:""
            EndTimeStr:""
            TimeLong:0.0
            Id:0
            PlaceStr:""
            Reason:""
            ApproverPer:""
            ExamineApproval:""
            ApproverOpi:""
        }
    }
    Text {
        id:noReport
        x:40
        y:200
        color: "#999"
        font.pixelSize: 24
        font.family: "SimHei"
        text:"暂无报备"
        width: 90
        visible:false
    }

    BusyIndicator{
        id: busying
        x:640
        anchors.verticalCenter: parent.verticalCenter
        running: false
    }
    HLK_MessageBox{
        id: messagebox
    }
}

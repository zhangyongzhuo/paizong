import QtQuick 2.4
import QtGraphicalEffects 1.0
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import com.hylink.fmcp.ctrl 2.0

//日志统计界面
HLK_BasePage{
    pageTitle: "日志统计"
    property alias reportView:reportView
    property alias reportModel:reportModel
    //property alias eachReport:eachReport
    property alias boxMonths:boxMonths   //月份筛选下拉框
    property alias boxMonthsModel:boxMonthsModel   //月份筛选下拉框
    property alias busying:busying //繁忙标志
    property alias noLog:noLog
    property alias messagebox: messagebox

    Rectangle{
        x:20
        y:100
        width: 1240
        height:80
        z:99
        color: "#FFFFFF"
            HLK_ComboBox {
                x:20
                anchors.verticalCenter: parent.verticalCenter
                width:200
                id: boxMonths
                //height:60
                boxWidth  : 181
                boxHeight : 40
                boxRadius : 6
                boxTopMargin : 6
                model: boxMonthsModel
            }       
        ListModel {
            id: boxMonthsModel
            ListElement { text: "" }
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
        cacheBuffer: 550
        //implicitHeight:eachReport.hight+20
        model: ListModel{//M
            id: reportModel
            ListElement{
                WorkLogText:""
                WorkLogTime:""
                BtnVisble:true
                Id:0
            }
        }
        delegate:HLK_WorkLog{
           workLogText:WorkLogText   //
           workLogTime:WorkLogTime
           btnVisble:BtnVisble
           onEnterEtitMode:{
           //编辑操作
               stackView.push({item:"qrc:/wholeFunction/ui/WorkLogPage.qml",
                         properties:{workLogText:WorkLogText,
                                     entryPageMode:QmlData.VISIT_TYPE_MODIFY,
                                     logId:Id}})
           }
        }

    }

        Text {
            id:noLog
            x:40
            y:200
            color: "#999"
            font.pixelSize: 24
            font.family: "SimHei"
            text:"暂无日志"
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

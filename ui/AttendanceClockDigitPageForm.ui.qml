import QtQuick 2.4
import "qrc:/controls/ui/"
import QtQuick.Controls 1.2
import QtMultimedia 5.4
import QtQuick.Controls.Styles 1.2


//身份证识别页
HLK_BasePage{
    pageTitle: "考勤统计"

    property alias timeBusying     :timeBusying      //有效月份繁忙标志
    property alias statisticBusying:statisticBusying //月统计数据繁忙标志
    property alias monthBusying    :monthBusying     //日历繁忙标志
    property alias dayBusying      :dayBusying       //每天详细信息繁忙标志
    property alias revokeBusying   :revokeBusying    //撤销报备繁忙标志

    property alias messagebox:messagebox //消息提示

    property alias boxMonths:boxMonths   //月份筛选下拉框
    property alias boxMonthsModel:boxMonthsModel   //月份筛选下拉框

    property alias articleModel:articleModel //日历

    property string signinTime:"无"       //签到时间
    property bool   signinState:true         //签到状态 true正常
    property bool   signinStateVisible:true  //签到状态显示
    property string signinStateText:"获取中"  //签到状态文字 正常 迟到 早退 缺卡
    property string signinImage:""           //签到照片
    property bool   signinImageVisible:false  //签到照片是否可见

    property string signoutTime:"无"         //签退时间
    property bool   signoutState:true        //签退状态 true正常
    property bool   signoutStateVisible:true  //签到状态显示
    property string signoutStateText:"获取中"  //签到状态文字 正常 迟到 早退 缺卡
    property string signoutImage:''           //签退照片
    property bool   signoutImageVisible:false //签退照片是否可见

    property bool   noHaveAttVisible:true    //当天没有考勤信息
    property bool   noHaveRepVisible:true    //当天没有报备信息

    property string work:"0"         //出勤（天）
    property string rest:"0"         //调休（天）
    property string attendance:"0"   //考勤（小时）
    property string jurisdiction:"0" //辖区（小时）
    property string beOut:"0"        //外出（小时）
    property string overtime:"0"     //加班（小时）
    property string askLeave:"0"     //请假（小时）
    property string late:"0"         //迟到（次）
    property string leaveEarly:"0"   //早退（次）
    property string absent:"0"       //旷工（次）

    property alias reportModel:reportModel  //报备


    signal currentDayChanged(var text, var stateVisible, var isCurrentDay) //当前日期发生变化的信号
    signal revokeReport(var id, var index) //撤销审批信号

    Rectangle{
        anchors.top: parent.top
        anchors.topMargin: 90
        anchors.horizontalCenter: parent.horizontalCenter
        width:1220
        height: 670
        color: '#F0F0F0'

        Column{
            spacing: 20
            Row{
                spacing: 10
                //日历区域
                Column{
                    Rectangle{
                        z:99
                        width:658
                        height:60
                        HLK_ComboBox {
                            x:20
                            id: boxMonths
                            boxWidth  : 181
                            boxHeight : 40
                            boxRadius : 6
                            boxTopMargin : 6
                            model: boxMonthsModel
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        ListModel {
                            id: boxMonthsModel
                            ListElement { text: ""; code:""}
                        }
                    }
                    ListView {
                        //详细信息
                        width: 658
                        height: 40
                        clip: true
                        orientation:ListView.Horizontal
                        model: ListModel {
                            ListElement { VALUE: "一"}
                            ListElement { VALUE: "二"}
                            ListElement { VALUE: "三"}
                            ListElement { VALUE: "四"}
                            ListElement { VALUE: "五"}
                            ListElement { VALUE: "六"}
                            ListElement { VALUE: "日"}
                        }
                        delegate: Text {
                            width: 94
                            height: 40
                            text: VALUE
                            font.family: "SimHei"
                            font.pixelSize: 22
                            color: "#A2A2A2"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                    Rectangle{
                        width:658
                        height:500
                        GridView {
                            id: articleView
                            width: 658
                            height: 500
                            cellWidth: 94
                            cellHeight: 80
                            //clip: true
                            interactive:false
                            ExclusiveGroup {
                                id: eg
                            }
                            model: ListModel {
                                id: articleModel
                                ListElement {
                                    DATE:""
                                    ISBLACK: true
                                    TEXT: ""
                                    BCVISIBLE:false
                                    STATE:false
                                    STATEVISIBLE:false
                                    CHECK:false
                                }
                            }
                            delegate: HLK_CalendarButton {
                                exclusiveGroup:eg
                                isBlack: ISBLACK
                                btnText: TEXT
                                btnBaseColorVisible : BCVISIBLE      //基础底色是否显示
                                btnState : STATE                     //当前是否异常
                                btnStateVisible : STATEVISIBLE       //异常状态是否显示
                                onCheckedChanged: {
                                    if(checked){
                                        emit: currentDayChanged(DATE,STATEVISIBLE,BCVISIBLE)
                                    }
                                }
                                checked: CHECK
                            }
                        }
                    }
                }
                //详细信息区域
                Column{
                    Rectangle{
                        width:552
                        height:191
                        Rectangle{
                            width:552-40
                            height:191-40
                            anchors.centerIn: parent
                            visible: !noHaveAttVisible
                            Column{
                                spacing: 10
                                Row{
                                    spacing: 47
                                    Row{
                                        spacing: 10
                                        Text{
                                            height: 24
                                            width:155
                                            text:"签到时间 "+signinTime
                                            font.pixelSize: 22
                                            font.family: "SimHei"
                                            color: "#474747"
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        HLK_AttButton{
                                            btnVisible: signinStateVisible
                                            btnColor: signinState ? "#00AECC" : "#FF943E"
                                            btnText: signinStateText
                                        }
                                    }
                                    Row{
                                        spacing: 10
                                        Text{
                                            height: 24
                                            width:155
                                            text:"签退时间 "+signoutTime
                                            font.pixelSize: 22
                                            font.family: "SimHei"
                                            color: "#474747"
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        HLK_AttButton{
                                            btnVisible: signoutStateVisible
                                            btnColor: signoutState ? "#00AECC" : "#FF943E"
                                            btnText: signoutStateText
                                        }
                                    }
                                }

                                Row{
                                    spacing: 123
                                    HLK_RadiusImage{
                                        imgVisible:signinImageVisible
                                        imgSource:signinImage
                                    }
                                    HLK_RadiusImage{
                                        imgVisible:signoutImageVisible
                                        imgSource:signoutImage
                                    }
                                }
                            }
                        }

                        Rectangle{
                            width:552
                            height:191
                            visible: noHaveAttVisible
                            Text{
                                x:10
                                y:10
                                text:"当天没有考勤信息"
                                font.pixelSize: 22
                                font.family: "SimHei"
                                color: "#474747"
                            }
                        }
                    }

                    Rectangle{
                        width:552
                        height:409
                        //color: '#F0F0F0'
                        //此处为一个list
                        ListView {
                            id: reportView
                            visible: !noHaveRepVisible
                            clip: true

                            width: 552
                            height: 409
                            highlightMoveDuration: 1
                            cacheBuffer: 2000

                            model: ListModel {
                                id:reportModel
                                ListElement {
                                    reportJson:""   //报备照片json字符串数组//""
                                    PreparationText:""//报备类型
                                    StartTimeStr:""  //开始时间
                                    EndTimeStr:""    //结束时间
                                    TimeLong:0       //时长(暂时不用)
                                    Id:0
                                    PlaceStr:""      //地点
                                    Reason:""        //原因
                                    ApproverPer:""   //审批人
                                    ExamineApproval:""
                                    ApproverOpi:"无"   //审批意见
                                }
                            }
                            delegate:HLK_ReportPageSmall {
                                modeStr:reportJson          //报备照片json字符串数组
                                preparationText:PreparationText
                                startTimeStr:StartTimeStr
                                endTimeStr:EndTimeStr
                                timeLong:TimeLong
                                placeStr:PlaceStr
                                approverPer:ApproverPer
                                reason:Reason
                                examineApproval:ExamineApproval
                                approverOpi:ApproverOpi
                                withdraw.onClicked: {
                                    //发送撤销审批信号
                                    emit:revokeReport(reportModel.get(index).Id, index)
                                }
                            }
                        }

                        Rectangle{
                            width:552
                            height:409
                            visible: noHaveRepVisible
                            Rectangle{
                                height: 1
                                width: 552
                                color: "#DCDCDC"
                            }
                            Text{
                                x:10
                                y:10
                                height: 24
                                width:155
                                text:"当天没有报备信息"
                                font.pixelSize: 22
                                font.family: "SimHei"
                                color: "#474747"
                            }
                        }
                    }
                }
            }

            //本月统计
            Row{
                x:20
                spacing: 10
                height: 30
                Image {
                    source: "qrc:/images/images/tj.png"
                }

                ListView {
                    clip: true
                    width: 1160
                    height: 30
                    orientation: ListView.Horizontal

                    model: ListModel {
                        ListElement {
                            text:""
                        }
                    }
                    delegate:Text {
                        text:'本月统计：出勤<font color="#00AECC">'+work+'</font>天&nbsp;\
                               调休<font color="#00AECC">'+rest+'</font>天&nbsp;\
                               考勤<font color="#00AECC">'+attendance+'</font>小时&nbsp;\
                               辖区<font color="#00AECC">'+jurisdiction+'</font>小时&nbsp;\
                               外出<font color="#00AECC">'+beOut+'</font>小时&nbsp;\
                               加班<font color="#00AECC">'+overtime+'</font>小时&nbsp;\
                               请假<font color="#00AECC">'+askLeave+'</font>小时&nbsp;\
                               迟到<font color="#00AECC">'+late+'</font>次&nbsp;\
                               早退<font color="#00AECC">'+leaveEarly+'</font>次&nbsp;\
                               旷工<font color="#00AECC">'+absent+'</font>次&nbsp;'
                        font.pixelSize: 20
                        font.family: "SimHei"
                        color: "#474747"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }

    BusyIndicator{
        id: timeBusying
        x:640
        anchors.verticalCenter: parent.verticalCenter
        running: false
    }

    BusyIndicator{
        id: statisticBusying
        x:640
        anchors.verticalCenter: parent.verticalCenter
        running: false
    }

    BusyIndicator{
        id: monthBusying
        x:640
        anchors.verticalCenter: parent.verticalCenter
        running: false
    }

    BusyIndicator{
        id: dayBusying
        x:640
        anchors.verticalCenter: parent.verticalCenter
        running: false
    }

    BusyIndicator{
        id: revokeBusying
        x:640
        anchors.verticalCenter: parent.verticalCenter
        running: false
    }

    HLK_MessageBox{
        id: messagebox
    }

}

import QtQuick 2.4
import "qrc:/controls/ui/"
import QtQuick.Controls 1.2
import QtMultimedia 5.4
import QtQuick.Controls.Styles 1.2

//身份证识别页
HLK_BasePage{
    pageTitle: "考勤打卡"
    property alias cameraLoader: cameraLoader
    property alias busying: busying
    property alias messagebox: messagebox

    property string signinIcon:"qrc:/images/images/1.png"   //签到图标
    property string signinTime:"正在获取"       //签到时间
    property bool signinState:true           //签到状态 true正常
    property bool signinStateVisible:false    //签到状态显示
    property string signinStateText:"正常"    //签到状态文字 正常 迟到 早退 缺卡

    property string signoutIcon:"qrc:/images/images/1.png"   //签退图标
    property string signoutTime:"正在获取"      //签退时间
    property bool signoutState:true          //签退状态 true正常
    property bool signoutStateVisible:false    //签到状态显示
    property string signoutStateText:"正常"  //签到状态文字 正常 迟到 早退 缺卡

    property alias updataClock: updataClock //更新打卡
    property bool  updataClockVisible:false //更新打卡状态显示
    property alias clockBtn: clockBtn       //打卡按钮
    property bool  workHoursVisible: false  //考勤工时是否显示
    property double workHours:0              //考勤工时
    property string clockText: "拍照签到"    //打卡文字
    property string clockTime:"正在获取"     //打卡时间
    property string pictureTime:"正在获取"   //照片水印

    property int    clockRange:0            //是否进入考勤范围 -1不在考勤范围内 0定位中 1在考勤范围
    property string clockRangeText:"定位中"  //考勤范围文字提示
    property string clockRangeIcon:"qrc:/images/images/fww.png"

    property string windowTitle:"未在辖区范围内，请填写工作报备！"

//    property string work:"0"         //出勤(天)
//    property string rest:"0"         //调休(天)
//    property string attendance:"0"   //考勤
//    property string jurisdiction:"0" //辖区工作
//    property string report:"0"       //工作报备
//    property string askLeave:"0"     //请假
//    property string late:"0"         //迟到
//    property string leaveEarly:"0"   //早退
//    property string absent:"0"       //旷工


    property alias popWindow:popWindow //工作报备
    property alias isReportedBtn:isReportedBtn //立即报备


    property alias isUpdataBtn:isUpdataBtn   //确定更新

    //签到摄像区域
    Row {
        id:cameraArea
        y:160
        width: parent.width
        height: 400
        spacing: 50
        //签到功能栏
        Column{
            //签到时间
            width: 320
            Row {
                x:60
                height: 30
                spacing: 10
                Image {
                    source: signinIcon
                }
                Text {
                    text: "签到时间 "+signinTime
                    font.pixelSize: 24
                    font.family: "SimHei"
                    color: "#9D9D9D"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            //竖线
            Row{
                x:75
                y:30
                spacing: 30
                Rectangle {
                    width: 1
                    height: 290
                    color: "#DCDCDC"
                }

                //签到状态
                HLK_AttButton{
                    y:10
                    btnVisible: signinStateVisible
                    btnColor: signinState ? "#00AECC" : "#FF943E"
                    btnText: signinStateText
                }
            }
            //签退时间
            Row {
                x:60
                y:320
                height: 30
                spacing: 10
                Image {
                    source: signoutIcon
                }
                Text {
                    text: "签退时间 "+signoutTime
                    font.pixelSize: 24
                    font.family: "SimHei"
                    color: "#9D9D9D"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        //照相区
        Rectangle {
            width: 520
            height: 390
            //color: "black"
            HLK_CameraLoader{
                id: cameraLoader
                anchors.fill: parent
            }

            BusyIndicator{
                id: busying
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                running: false
            }

            Rectangle {
                width: 520
                height: 50
                color: "black"
                opacity: 0.4
                anchors.bottom: parent.bottom
            }

            Text{
                text: pictureTime
                font.pixelSize: 28
                font.family: "SimHei"
                color: "#FFFFFF"
                anchors.left: parent.left
                anchors.leftMargin: 20
                font.bold: true
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
            }


        }

        //拍照按钮区
        Rectangle{
            width: 300
            height: 400
            color: "#F0F0F0"
            //拍照签到
            Button{
                visible: workHoursVisible
                enabled: false
                width:170
                height: 170
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                style: ButtonStyle{
                    background: Rectangle{
                        color: "#00000000"
                        Image{
                            anchors.fill: parent
                            anchors.centerIn: parent
                            source: "qrc:/images/images/jyan.png"
                        }
                        Text {
                            text: workHours
                            font.pixelSize: 50
                            font.family: "SimHei"
                            color: "#FFFFFF"
                            font.bold: true
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: 40
                        }
                        Text{
                            text: "打卡工时"
                            font.pixelSize: 24
                            font.family: "SimHei"
                            color: "#FFFFFF"
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 44
                        }
                    }

                }
            }

            //拍照签到
            Button{
                id:clockBtn
                width:170
                height: 170
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                style: ButtonStyle{
                    background: Rectangle{
                        color: "#00000000"
                        Image{
                            anchors.fill: parent
                            anchors.centerIn: parent
                            source: "qrc:/images/images/pzan1.png"
                        }
                        Text {
                            text: clockText
                            font.pixelSize: 28
                            font.family: "SimHei"
                            color: "#FFFFFF"
                            font.bold: true
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: 60
                        }
                        Text{
                            text: clockTime
                            font.pixelSize: 24
                            font.family: "SimHei"
                            color: "#C2E4EC"
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 44
                        }
                    }

                }
            }



        }
    }

    //签退状态
    HLK_AttButton{
        y:520
        x:100
        btnVisible: signoutStateVisible
        btnColor: signoutState ? "#00AECC" : "#FF943E"
        btnText: signoutStateText
    }

    //更新打卡
    Button{
        id:updataClock
        width:100
        height:30
        y:554
        x:100
        visible:signoutStateVisible
        style: ButtonStyle{
            background: Rectangle{
                color: "#F0F0F0"
                border.width: 1
                radius: 6
                border.color: "#00AECC"
                Text {
                    text: "更新打卡"
                    font.pixelSize: 18
                    font.family: "SimHei"
                    color: "#00AECC"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        onClicked: {
            updataWindow.visible = true
        }
    }

    //考勤范围区域
    Row{
        y:590
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10
        Image {
            source: clockRangeIcon
        }
        Text {
            text: clockRangeText
            font.pixelSize: 26
            font.family: "SimHei"
            color: "#474747"
        }
    }

    Rectangle {
        y:660
        width: 1280
        height: 1
        color: "#DCDCDC"
    }

    //本周考勤
//    Column{
//        visible: false
//        y:660
//        spacing: 30
//        Rectangle {
//            width: 1280
//            height: 1
//            color: "#DCDCDC"
//        }

//        Row{
//            x:20
//            spacing: 10
//            height: 30
//            Image {
//                source: "qrc:/images/images/tj.png"
//            }
//            Text {
//                text: '本月统计：出勤<font color="#00AECC">'+work+'</font>天&nbsp;\
//                       调休<font color="#00AECC">'+rest+'</font>天&nbsp;\
//                       考勤<font color="#00AECC">'+attendance+'</font>小时&nbsp;\
//                       辖区<font color="#00AECC">'+jurisdiction+'</font>小时&nbsp;\
//                       外出<font color="#00AECC">'+report+'</font>小时&nbsp;\
//                       加班<font color="#00AECC">'+report+'</font>小时&nbsp;\
//                       请假<font color="#00AECC">'+askLeave+'</font>次&nbsp;\
//                       迟到<font color="#00AECC">'+late+'</font>次&nbsp;\
//                       早退<font color="#00AECC">'+leaveEarly+'</font>次&nbsp;\
//                       旷工<font color="#00AECC">'+absent+'</font>次&nbsp;'
//                font.pixelSize: 20
//                font.family: "SimHei"
//                color: "#474747"
//                anchors.verticalCenter: parent.verticalCenter
//            }
//        }

////        //本周考勤
////        Row{
////            x:50
////            spacing: 10
////            height: 30
////            Image {
////                source: "qrc:/images/images/tj.png"
////            }
////            Text {
////                text: '本周考勤： 辖区工作<font color="#00AECC">'+jurisdiction+'</font>小时&nbsp;\
////                       工作报备<font color="#00AECC">'+report+'</font>小时&nbsp;\
////                       请假<font color="#00AECC">'+askLeave+'</font>次&nbsp;\
////                       迟到<font color="#00AECC">'+late+'</font>次&nbsp;\
////                       早退<font color="#00AECC">'+leaveEarly+'</font>次&nbsp;\
////                       旷工<font color="#00AECC">'+absent+'</font>次&nbsp;'
////                font.pixelSize: 22
////                font.family: "SimHei"
////                color: "#474747"
////                anchors.verticalCenter: parent.verticalCenter
////            }
////        }
//    }

    HLK_MessageBox{
        id: messagebox
    }

    HLK_PopupWindow {
        id: popWindow
        visible: false
        anchors.fill: parent
        popupWindowTitle: windowTitle
        Row {
            spacing: 100
            anchors.horizontalCenter: parent.horizontalCenter
            y: 400
            HLK_Button {
                id: isReportedBtn
                width: 130
                button_text: "立即报备"
                onClicked: {
                    popWindow.visible = false
                }
            }
            HLK_Button {
                width: 130
                button_text: "稍后报备"
                onClicked: {
                    popWindow.visible = false
                }
            }
        }
    }

    HLK_PopupWindow {
        id: updataWindow
        visible: false
        anchors.fill: parent
        popupWindowTitle: "确定要更新此次打卡记录么？"
        Row {
            spacing: 100
            anchors.horizontalCenter: parent.horizontalCenter
            y: 400
            HLK_Button {
                id: isUpdataBtn
                width: 130
                button_text: "确定"
                onClicked: {
                    updataWindow.visible = false
                }
            }
            HLK_Button {
                width: 130
                button_text: "取消"
                onClicked: {
                    updataWindow.visible = false
                }
            }
        }
    }
}

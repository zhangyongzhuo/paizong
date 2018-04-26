import QtQuick 2.4
import QtGraphicalEffects 1.0
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import com.hylink.fmcp.ctrl 2.0

//主页
Item {
//    property int currentFunctionType: 0 //当前操作类型
    property string themeColor: JSL.themeColor()
    property alias exitBtn: exitBtn             //退出按钮
    property alias popWindowExit: popWindowExit //退出按钮-提示框
    property alias isExitBtn: isExitBtn         //退出按钮-是
    property alias noExitBtn: noExitBtn         //退出按钮-否

    property alias changeUserBtn: changeUserBtn //切换用户按钮
    property alias popWindowChangeUser: popWindowChangeUser //切换用户-提示框
    property alias isChangeUser: isChangeUser   //切换用户-是
    property alias noChangeUser: noChangeUser   //切换用户-否

    property alias messagebox: messagebox
    property alias mainPage: mainPage           //主界面
    property alias systemSetArea: systemSetArea //系统设置区域
    property alias infoCollectArea: infoCollectArea//信息采集区域
    property alias versionUpdateBtn: versionUpdateBtn //在线升级按钮
    property alias informationSettingsBtn: informationSettingsBtn //信息设置按钮
    property alias attendanceClockArea: attendanceClockArea  //考勤打卡区域
    property alias attendanceClockDigitBtn: attendanceClockDigitBtn //本周考勤工时
    property alias attendanceClockBtn: attendanceClockBtn    //考勤打卡
    property alias workReportedDigitBtn: workReportedDigitBtn//本周工作报备次数
    property alias workReportedBtn: workReportedBtn          //工作报备
    property alias workDiaryDigitBtn: workDiaryDigitBtn      //本周日志
    property alias workDiaryBtn: workDiaryBtn                //工作日志
    property alias historicHouseDigitBtn:historicHouseDigitBtn
    property alias historicHouseDigitBtnBtn:historicHouseDigitBtnBtn
    property alias historicUnitDigitBtn:historicUnitDigitBtn
    property alias historicUnitBtn:historicUnitBtn
    property alias historicPersonDigitBtn:historicPersonDigitBtn
    property alias historicPersonBtn:historicPersonBtn
    property alias historicDataDigitBtn:historicDataDigitBtn
    property alias historicDataBtn:historicDataBtn
    property alias addSynchroDigitBtn:addSynchroDigitBtn//地址信息同步
    property alias addSynchroBtn:addSynchroBtn
    property alias employeeDigitBtn:employeeDigitBtn//从业人员
    property alias employeeBtn:employeeBtn

    property alias pointcardArea:pointcardArea
    property alias personInquirieskdDigitBtn:personInquirieskdDigitBtn
    property alias personInquirieskdBtn:personInquirieskdBtn
    property alias carInquirieskdDigitBtn:carInquirieskdDigitBtn
    property alias carInquirieskdBtn:carInquirieskdBtn

    property alias orgBtn:orgBtn //管辖单位

    property alias busying:busying //繁忙标志

    property alias busyingAddr:busyingAddr //用于地址查询的繁忙标志
    property alias popWindow:popWindow

    property alias funBtnModel: funBtnModel
    signal funBtnClicked(int funBtnID)

    property string mainPageTitle:""    //主页标题

    anchors.fill: parent
    Column {
        id: mainPage
        anchors.fill: parent

        Rectangle {
            //页头
            id: header
            width: parent.width
            height: 80
            color: themeColor

            Text {
                //标题
                id: title
                color: "white"
                text: mainPageTitle
                font.pixelSize: 26
                font.family: "SimHei"
                font.bold: true
                x: 30
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                //头像
                id: faceImg
                width: 60
                height: 60
                radius: width / 2
                color: themeColor
                anchors.right: parent.right
                anchors.rightMargin: orgBtn.width+265+30 + name.width
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    id: _image
                    cache: false
                    smooth: true
                    visible: false
                    anchors.fill: parent
                    source: "qrc:/images/images/home_user0.png"
                    sourceSize: Qt.size(parent.size, parent.size)
                    antialiasing: true
                    width: 100
                    height: 100
                }
                Rectangle {
                    id: _mask
                    color: "black"
                    anchors.fill: parent
                    radius: width / 2
                    visible: false
                    antialiasing: true
                    smooth: true
                }
                OpacityMask {
                    id: mask_image
                    anchors.fill: _image
                    source: _image
                    maskSource: _mask
                    visible: true
                    antialiasing: true
                }
            }
            Text {
                id: name
                anchors.right: parent.right
                anchors.rightMargin: orgBtn.width+265+30
                anchors.verticalCenter: parent.verticalCenter
                color: "#FFFFFF"
                text: policeName
                font.pixelSize: 20
                font.family: "黑体"
            }

            Rectangle {
                width: 1
                height: 30
                color: "#6FE0F1"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: orgBtn.width+265+15
            }

            Text {
                id: orgBtn
                anchors.right: parent.right
                anchors.rightMargin: 265
                anchors.verticalCenter: parent.verticalCenter
                color: "#FFFFFF"
                font.pixelSize: 20
                font.family: "黑体"              
                //maximumLineCount: 3
                width: JSL.getByteLen(text) > 50 ? 500 : JSL.getByteLen(text) * 10
                elide: Text.ElideRight

                MouseArea{
                    anchors.fill: orgBtn
                    onClicked: {
                        orgShow.visible = true
                    }
                }
            }

            Rectangle {
                width: 1
                height: 30
                color: "#6FE0F1"
                anchors.right: parent.right
                anchors.rightMargin: 250
                anchors.verticalCenter: parent.verticalCenter
            }

            HLK_ToolButton {
                id: changeUserBtn
                anchors.right: parent.right
                anchors.rightMargin: 145
                anchors.verticalCenter: parent.verticalCenter
                btnText: "切换用户"
                textLeftMargin: 1
            }

            Rectangle {
                width: 1
                height: 30
                color: "#6FE0F1"
                anchors.right: parent.right
                anchors.rightMargin: 135
                anchors.verticalCenter: parent.verticalCenter
            }

            HLK_ToolButton {
                id: exitBtn
                anchors.right: parent.right
                anchors.rightMargin: 25
                anchors.verticalCenter: parent.verticalCenter
                imgPath: "qrc:/images/images/home_exit.png"
                btnText: "退出"
            }
        }

        Row {
            //页体
            id: body
            width: parent.width
            height: parent.height - header.height

            Rectangle {
                //页体侧栏
                id: sider
                width: 162
                height: parent.height
                color: "#FFFFFF"
                border.width: 2
                border.color: "#DBDBDD"

                ExclusiveGroup {
                    id: eg
                }

                ListView {
                    y: 10
                    width: parent.width
                    height: parent.height - 200
                    clip: true
                    spacing: 15
                    model: ListModel {
                        id: funBtnModel
                        ListElement {
                            BTN_ID: -1
                            BTN_TEXT: ""
                            BTN_IMG_NORMAL: ""
                            BTN_IMG_CHECKED: ""
                            BTN_CHECKED: false
                        }
                    }
                    delegate: HLK_RadioButton {
                        width: sider.width
                        height: 90
                        normal_image: BTN_IMG_NORMAL
                        checked_image: BTN_IMG_CHECKED
                        text: BTN_TEXT
                        exclusiveGroup: eg
                        checked: BTN_CHECKED
                        onClicked: {
                            emit: funBtnClicked(funBtnModel.get(index).BTN_ID)
                        }
                    }
                }

                Column {
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 20                    

                    Row {
                        visible: isShowLongitudeAndLatitude
                        Text {
                            font.family: "SimHei"
                            font.pixelSize: 16
                            color: "#474747"
                            text: "经度:" + longitude
                            width: 128
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: (""+longitude).length <= 12 ? Text.AlignHCenter : Text.AlignLeft
                            clip: true
                        }
                    }

                    Row {
                        visible: isShowLongitudeAndLatitude
                        Text {
                            font.family: "SimHei"
                            font.pixelSize: 16
                            color: "#474747"
                            text: "纬度:" + latitude
                            width: 128
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: (""+latitude).length <= 12 ? Text.AlignHCenter : Text.AlignLeft
                            clip: true
                        }
                    }
                }
            }

            Rectangle {
                //页体主区域
                width: parent.width - sider.width
                height: parent.height
                color: "#00000000"
                Flow {
                    id: pointcardArea
                    anchors.centerIn: parent
                    spacing: 50
                    visible: currentFunctionType
                             == QmlData.FUNCTION_TYPE_PATROL ? true : false //false
                    Column {
                        spacing: -70
                        width: 228
                        HLK_DigitButton {
                            id: personInquirieskdDigitBtn
                            x: 15
                            maxText: "0"
                            minText: "盘查人数"
                            height: 225
                            btnwidth: 198
                        }
                        HLK_PublicImageButton {
                            id: personInquirieskdBtn
                            imgPath: "qrc:/images/images/home_clry.png"
                            btnText: "人员盘查"
                            btnwidth: 228
                        }
                    }
                    Column {
                        spacing: -70
                        width: 228
                        HLK_DigitButton {
                            id: carInquirieskdDigitBtn
                            x: 15
                            maxText: "0"
                            minText: "盘查车数"
                            height: 225
                            btnwidth: 198
                        }
                        HLK_PublicImageButton {
                            id: carInquirieskdBtn
                            imgPath: "qrc:/images/images/home_clpc.png"
                            btnText: "车辆盘查"
                            btnwidth: 228
                        }
                    }
                }

                Flow {
                    id: systemSetArea
                    anchors.centerIn: parent
                    spacing: 50
                    Column {
                        spacing: -70
                        width: 228
                        HLK_DigitButton {
                            id: versionUpdateDigitBtn
                            x: 15
                            maxText: "2.0"
                            minText: "当前版本"
                            height: 225
                            btnwidth: 198
                        }
                        HLK_PublicImageButton {
                            id: versionUpdateBtn
                            imgPath: "qrc:/images/images/home_xtsj.png"
                            btnText: "版本更新"
                            btnwidth: 228
                            isShowAdd: false
                        }
                    }
                    Column {
                        spacing: -70
                        width: 228
                        HLK_DigitButton {
                            id: informationSettingsDigitBtn
                            x: 15
                            maxText: "1"
                            minText: "个性化"
                            height: 225
                            btnwidth: 198
                        }
                        HLK_PublicImageButton {
                            id: informationSettingsBtn
                            imgPath: "qrc:/images/images/home_xtsz.png"
                            btnText: "信息设置"
                            btnwidth: 228
                            isShowAdd: false
                        }
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    id: attendanceClockArea
                    color: "#00000000"

                    Flow {

                        anchors.centerIn: parent
                        spacing: 50
                        Column {
                            spacing: -70
                            width: 228
                            HLK_DigitButton {
                                id: attendanceClockDigitBtn
                                x: 15
                                maxText: "0"
                                minText: "本月考勤工时"
                                height: 225
                                btnwidth: 198
                            }
                            HLK_PublicImageButton {
                                id: attendanceClockBtn
                                imgPath: "qrc:/images/images/home_kqdk.png"
                                btnText: "考勤打卡"
                                btnwidth: 228
                            }
                        }
                        Column {
                            spacing: -70
                            width: 228
                            HLK_DigitButton {
                                id: workReportedDigitBtn
                                x: 15
                                maxText: "0"
                                minText: "本月报备次数"
                                height: 225
                                btnwidth: 198
                            }
                            HLK_PublicImageButton {
                                id: workReportedBtn
                                imgPath: "qrc:/images/images/home_wqbb.png"
                                btnText: "工作报备"
                                btnwidth: 228
                            }
                        }
                        Column {
                            spacing: -70
                            width: 228
                            HLK_DigitButton {
                                id: workDiaryDigitBtn
                                x: 15
                                maxText: "0"
                                minText: "本月日志"
                                height: 225
                                btnwidth: 198
                            }
                            HLK_PublicImageButton {
                                id: workDiaryBtn
                                imgPath: "qrc:/images/images/home_gzrz.png"
                                btnText: "工作日志"
                                btnwidth: 228
                            }
                        }
                    }

                    BusyIndicator{
                        id: busying
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        running: false
                    }

                    Text {
                        font.family: "SimHei"
                        font.pixelSize: 16
                        color: "#474747"
                        text: "正在获取统计信息，请稍候..."
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 100
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: busying.running
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    id: infoCollectArea
                    color: "#00000000"
                    Row {
                        x:130
                        y:80
                        //anchors.centerIn: parent
                        spacing: 80
                        Column {
                            spacing: -70
                            width: 228
                            HLK_DigitButton {
                                id: historicHouseDigitBtn
                                x: 15
                                maxText: "0"
                                minText: "历史房屋"
                                height: 225
                                btnwidth: 198
                            }
                            HLK_PublicImageButton {
                                id: historicHouseDigitBtnBtn
                                imgPath: "qrc:/images/images/home_kqdk.png"
                                btnText: "出租房屋"
                                btnwidth: 228
                                enabled: !busyingAddr.running
                            }
                        }
                        Column {
                            spacing: -70
                            width: 228
                            HLK_DigitButton {
                                id: historicUnitDigitBtn
                                x: 15
                                maxText: "0"
                                minText: "历史单位"
                                height: 225
                                btnwidth: 198
                            }
                            HLK_PublicImageButton {
                                id: historicUnitBtn
                                imgPath: "qrc:/images/images/home_wqbb.png"
                                btnText: "实有单位"
                                btnwidth: 228
                                enabled: !busyingAddr.running
                            }
                        }
                        Column {
                            spacing: -70
                            width: 228
                            HLK_DigitButton {
                                id: historicPersonDigitBtn
                                x: 15
                                maxText: "0"
                                minText: "历史人员"
                                height: 225
                                btnwidth: 198
                            }
                            HLK_PublicImageButton {
                                id: historicPersonBtn
                                imgPath: "qrc:/images/images/home_gzrz.png"
                                btnText: "实有人口 "
                                btnwidth: 228
                                enabled: !busyingAddr.running
                            }
                        }
                    }//////////////////////////////
                    Row {
                        x:140
                        y:380
                        //anchors.centerIn: parent
                        spacing: 80
                        Column {
                            spacing: -70
                            width: 228
                            HLK_DigitButton {
                                id: historicDataDigitBtn
                                x: 15
                                maxText: Number(historicPersonDigitBtn.maxText) + Number(historicUnitDigitBtn.maxText)+ Number(historicHouseDigitBtn.maxText)
                                minText: "历史数据"
                                height: 225
                                btnwidth: 198
                            }
                            HLK_PublicImageButton {
                                id: historicDataBtn       //keyPersonnelBtn
                                imgPath: "qrc:/images/images/tjhz.png"
                                btnText: "重点人员"
                                btnwidth: 228
                                isShowAdd: false
                            }
                        }
                        Column {
                            spacing: -70
                            width: 228
                            HLK_DigitButton {
                                id: employeeDigitBtn
                                x: 15
                                //maxText: Number(historicPersonDigitBtn.maxText) + Number(historicUnitDigitBtn.maxText)+ Number(historicHouseDigitBtn.maxText)
                                minText: "历史数据"
                                height: 225
                                btnwidth: 198
                            }
                            HLK_PublicImageButton {
                                id: employeeBtn
                                imgPath: "qrc:/images/images/tjhz.png"
                                btnText: "从业人员"
                                btnwidth: 228
                                isShowAdd: false
                            }
                        }
                        Column {
                            spacing: -70
                            width: 228
                            HLK_DigitButton {
                                id: addSynchroDigitBtn
                                x: 15
                                //maxText: Number(historicPersonDigitBtn.maxText) + Number(historicUnitDigitBtn.maxText)+ Number(historicHouseDigitBtn.maxText)
                                minText: ""
                                height: 225
                                btnwidth: 198
                            }
                            HLK_PublicImageButton {
                                id: addSynchroBtn
                                imgPath: "qrc:/images/images/tjhz.png"
                                btnText: "地址信息同步"
                                btnwidth: 228
                                isShowAdd: false
                            }
                        }
                    }

                    BusyIndicator{
                        id: busyingAddr
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        running: false
                    }

                    Text {
                        font.family: "SimHei"
                        font.pixelSize: 16
                        color: "#474747"
                        text: "正在获取地址信息，请稍候..."
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 100
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: busyingAddr.running
                    }
                }
            }
        }
    }

    HLK_PopupWindow {
        id: popWindowExit
        visible: false
        anchors.fill: parent
        popupWindowTitle: "是否要退出系统？"
        Row {
            spacing: 100
            anchors.horizontalCenter: parent.horizontalCenter
            y: 400
            HLK_Button {
                id: isExitBtn
                width: 130
                button_text: "是"
            }
            HLK_Button {
                id: noExitBtn
                width: 130
                button_text: "否"
            }
        }
    }

    HLK_PopupWindow {
        id: popWindowChangeUser
        visible: false
        anchors.fill: parent
        popupWindowTitle: "是否要切换用户？"
        Row {
            spacing: 100
            anchors.horizontalCenter: parent.horizontalCenter
            y: 400
            HLK_Button {
                id: isChangeUser
                width: 130
                button_text: "是"
            }
            HLK_Button {
                id: noChangeUser
                width: 130
                button_text: "否"
            }
        }
    }

    HLK_MessageBox {
        id: messagebox
    }


    HLK_JsonListModel{
        id: orgShowModel
        json:JSON.stringify(orgList)
    }

    Item {
        id:orgShow
        width: 1280
        height:730
        visible: false

        Rectangle {
            id: orgShow_bg
            color: "black"
            opacity: 0.7
            anchors.fill: parent
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    orgShow.visible = false
                }
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: parent.width*2/3
            height: parent.height*2/3
            radius: 10

            ListView{
                id: orgShow_navi
                anchors.fill: parent
                //anchors.margins: 80

                clip:  true
                highlightMoveDuration: 1
                model: orgShowModel.model
                currentIndex: getIndexByName(model, operateconfigfile.getOrgCode())

                delegate: Text{
                    width: parent.width
                    height:60
                    text: model.orgname 
                    font.family: "黑体"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter

                    font.pixelSize: index == orgShow_navi.currentIndex ? 30 : 20
                    font.bold: index == orgShow_navi.currentIndex ? true:false
                    color: index == orgShow_navi.currentIndex ? themeColor : "#3e6792"

                    MouseArea{
                        anchors.fill: parent
                        onClicked: { 
                            operateconfigfile.setOrgId(orgShowModel.model.get(index).id)
                            operateconfigfile.setOrgName(orgShowModel.model.get(index).orgname)
                            operateconfigfile.setOrgCode(orgShowModel.model.get(index).orgcode)
                            operateconfigfile.setOrgJb(orgShowModel.model.get(index).orgjb)
                            orgBtn.text = operateconfigfile.getOrgName()
                            orgShow_navi.currentIndex = index



                            orgShow.visible = false
                        }
                    }
                }
           }
        }

    }
    HLK_PopupWindow {
        id: popWindow
        visible: false
        anchors.fill: parent
        popupWindowTitle: "获取标准地址失败，是否重新获取？"
        Row {
            spacing: 100
            anchors.horizontalCenter: parent.horizontalCenter
            y: 400
            HLK_Button {
                width: 130
                button_text: "是"
                onClicked: {
                    //调用获取标准地址函数
                    getAddr()
                    popWindow.visible = false
                    mainPage.enabled = false
                }
            }
            HLK_Button {
                width: 130
                button_text: "否"
                onClicked: {
                    popWindow.visible = false
                    mainPage.enabled = false
                }
            }
        }
    }

}

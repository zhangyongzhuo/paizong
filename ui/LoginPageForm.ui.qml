import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL

Item {
    property string version: "2.0.0.5"
    property string themeColor: JSL.themeColor()
    property alias exitBtn: exitBtn //退出按钮
    property alias loginBtn: loginBtn //登录按钮
    property alias idcard: idcard //身份证输入框
    property alias password: password //密码输入框
    property int pageWidth: 1280
    property int pageHeight: 768
    property alias policeDataArea: policeDataArea
    property alias policeData: policeData
    property alias messagebox: messagebox
    property alias busyIndicator: busyIndicator
    property alias popWindowExit: popWindowExit
    property alias isExitBtn: isExitBtn
    property alias noExitBtn: noExitBtn
    property alias mainPage: mainPage
    property alias loginArea: loginArea
    property alias setArea: setArea
    property alias setBtn: setBtn
    property alias proxySwitch: proxySwitch
    property alias proxyIP: proxyIP
    property alias proxyPort: proxyPort
    property alias proxyUser: proxyUser
    property alias proxyPassword: proxyPassword
    property alias loginServerIP: loginServerIP
    property alias loginServerPort: loginServerPort
    property alias setMakesure: setMakesure
    property alias setCancle: setCancle
    property bool isUseProxy: false
    property alias devRegBtn: devRegBtn
    property alias rememberPassword: rememberPassword
    property alias modeOnline: modeOnline
    property alias modeOffline: modeOffline
    property string englishTitle:""     //主页标题英文
    property string companyName: ""     //公司名称
    property string mainPageTitle:""    //主页标题

    signal changeUserName(string userName)
    width: pageWidth
    height: pageHeight
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (policeDataArea.visible == true){
                policeDataArea.visible = false
            }
            getFocus.focus = true
        }
    }

    Flow {
        id: mainPage
        anchors.fill: parent
        Rectangle {
            width: pageWidth
            height: 255
            // color: themeColor
            Image {
                anchors.fill: parent
                source: "qrc:/images/images/login_bg.png"
            }
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                spacing: 20
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    // anchors.verticalCenter: parent.verticalCenter
                    text: mainPageTitle
                    font.pixelSize: 50
                    font.family: "黑体"
                    font.bold: true
                    color: "#FFFFFF"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    // anchors.verticalCenter: parent.verticalCenter
                    text: englishTitle
                    font.pixelSize: 36
                    font.family: "黑体"
                    color: "#FFFFFF"
                }
            }
        }
        Rectangle {
            width: pageWidth
            height: 513
            color: "#E4E4E4"

            Rectangle {
                //阴影
                x: 365
                y: 177
                width: 682
                height: 300
                radius: 10
                rotation: -30
                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: "#D5D5D5"
                    }
                    GradientStop {
                        position: 1
                        color: "#E4E4E4"
                    }
                }
            }

            Rectangle {
                //登录框
                id: loginArea
                anchors.horizontalCenter: parent.horizontalCenter
                y: 30
                radius: 10
                width: 600
                height: 360
                color: "#FFFFFF"

                HLK_SimpleImageButton {
                    id: setBtn
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    normal_path: "qrc:/images/images/set.png"
                    checked_path: "qrc:/images/images/set.png"
                }
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 60
                    spacing: 10
                    Image {
                        y: idcard.y + 13
                        source: "qrc:/images/images/user.png"
                    }
                    Text {
                        y: idcard.y + 15
                        text: "用户名:"
                        font.pixelSize: 20
                        font.family: "黑体"
                        color: "#9D9D9D"
                    }
                    HLK_TextEdit {
                        id: idcard
                        width: 300
                        hint: '身份证号/警号'
                    }
                }
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 140
                    spacing: 10
                    Image {
                        y: password.y + 13
                        source: "qrc:/images/images/password.png"
                    }
                    Text {
                        y: password.y + 15
                        text: "密　码:"
                        font.pixelSize: 20
                        font.family: "黑体"
                        color: "#9D9D9D"
                    }
                    HLK_TextEdit {
                        id: password
                        width: 300
                        inputTextEchoMode: true
                    }
                }
                HLK_Checkbox {
                    id: rememberPassword
                    x: 385
                    y: 210
                    width: 150
                    text: "记住密码"
                }

                Text {
                    id: loginProblem
                    x: parent.x + 82
                    y: parent.y + 140
                    text: "登录遇到问题"
                    font.pixelSize: 14
                    font.family: "黑体"
                    color: themeColor
                    visible: false
                }

                HLK_Button2 {
                    id: exitBtn
                    x: parent.x - 245
                    y: 270
                    width: 130
                    button_text: "退出"
                }
                BusyIndicator {
                    id: busyIndicator
                    // x: parent.x - 75
                    y: 210
                    //anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    running: false
                }

                HLK_Button2 {
                    id: loginBtn
                    x: parent.x + 35
                    y: 270
                    width: 130
                    button_text: "登录"
                }

                Text {
                    id: devReg
                    x: parent.x + 65
                    y: 320
                    text: '设备注册'
                    font.family: "SimHei"
                    font.pixelSize: 20
                    color: themeColor
                    font.underline: true
                    visible: false//!operateconfigfile.getDevRegRegistered()
                    MouseArea {
                        id: devRegBtn
                        anchors.fill: parent
                    }
                }
            }

            Rectangle {
                //设置框
                id: setArea
                visible: false
                anchors.horizontalCenter: parent.horizontalCenter
                y: 30
                radius: 10
                width: 600
                height: 360
                color: "#FFFFFF"
                Text {
                    id: setArea_netSet
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    font.family: "SimHei"
                    font.pixelSize: 18
                    color: "#343434"
                    text: "代理设置"
                }

                Flow {
                    x: 20
                    y: setArea_netSet.y + 30
                    width: 600
                    height: 90
                    spacing: 10
                    z: 1
                    Text {
                        width: 60
                        height: 50
                        font.family: "SimHei"
                        font.pixelSize: 18
                        color: "#ADADAD"
                        text: "类型:"
                        verticalAlignment: Text.AlignVCenter
                    }

                    HLK_ComboBox {
                        id: proxySwitch
                        boxWidth: 140
                        textSize: 15
                        model: ListModel {
                            ListElement {
                                text: "使用代理"
                                code: "0"
                            }
                            ListElement {
                                text: "不使用代理"
                                code: "1"
                            }
                        }
                        onCurrentIndexChanged: {
                            if (proxySwitch.currentIndex == 0) {
                                isUseProxy = true
                            } else {
                                isUseProxy = false
                            }
                        }
                    }
                    Text {
                        width: 50
                        height: 50
                        font.family: "SimHei"
                        font.pixelSize: 18
                        color: "#ADADAD"
                        text: "地址:"
                        verticalAlignment: Text.AlignVCenter
                    }
                    HLK_TextEdit {
                        id: proxyIP
                        width: 140
                        textSize: 18
                        isEnable: isUseProxy
                    }
                    Text {
                        width: 50
                        height: 50
                        font.family: "SimHei"
                        font.pixelSize: 18
                        color: "#ADADAD"
                        text: "端口:"
                        verticalAlignment: Text.AlignVCenter
                    }
                    HLK_TextEdit {
                        id: proxyPort
                        width: 80
                        textSize: 18
                        isEnable: isUseProxy
                    }
                    Text {
                        width: 60
                        height: 50
                        font.family: "SimHei"
                        font.pixelSize: 18
                        color: "#ADADAD"
                        text: "用户名:"
                        verticalAlignment: Text.AlignVCenter
                    }
                    HLK_TextEdit {
                        id: proxyUser
                        width: 140
                        textSize: 18
                        isEnable: isUseProxy
                    }
                    Text {
                        width: 50
                        height: 50
                        font.family: "SimHei"
                        font.pixelSize: 18
                        color: "#ADADAD"
                        text: "密码:"
                        verticalAlignment: Text.AlignVCenter
                    }
                    HLK_TextEdit {
                        id: proxyPassword
                        width: 140
                        textSize: 18
                        isEnable: isUseProxy
                    }
                }
                Text {
                    id: setArea_loginServer
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top: parent.top
                    anchors.topMargin: 185
                    font.family: "SimHei"
                    font.pixelSize: 18
                    color: "#343434"
                    text: "登录服务器"
                }
                Flow {
                    x: 20
                    y: setArea_loginServer.y + 30
                    width: 600
                    height: 90
                    spacing: 10
                    Text {
                        width: 60
                        height: 50
                        font.family: "SimHei"
                        font.pixelSize: 18
                        color: "#ADADAD"
                        text: "地址:"
                        verticalAlignment: Text.AlignVCenter
                    }
                    HLK_TextEdit {
                        id: loginServerIP
                        textSize: 18
                        width: 140
                    }
                    Text {
                        width: 50
                        height: 50
                        font.family: "SimHei"
                        font.pixelSize: 18
                        color: "#ADADAD"
                        text: "端口:"
                        verticalAlignment: Text.AlignVCenter
                    }
                    HLK_TextEdit {
                        id: loginServerPort
                        textSize: 18
                        width: 140
                    }
                }
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 65
                    width: 600
                    height: 1
                    color: "#E4E4E4"
                }
                Row {
                    visible: false
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 15
                    HLK_NormalText {
                        width: 100
                        text: "使用模式:"
                    }
                    ExclusiveGroup {
                        id: eg
                    }
                    HLK_NormalRadioButton {
                        id: modeOnline
                        width: 100
                        text: "在线"
                        exclusiveGroup: eg
                    }
                    HLK_NormalRadioButton {
                        id: modeOffline
                        width: 100
                        text: "离线"
                        exclusiveGroup: eg
                    }
                }
                HLK_Button2 {
                    id: setMakesure
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    width: 65
                    height: 34
                    button_text: "确定"
                }
                HLK_Button2 {
                    id: setCancle
                    anchors.right: parent.right
                    anchors.rightMargin: 150
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    width: 65
                    height: 34
                    button_text: "取消"
                }
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                y: 420
                text: "支持二代身份证扫描"
                font.pixelSize: 14
                font.family: "黑体"
                //font.underline: true
                color: themeColor
                visible: false
            }

            Text {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 50
                text: companyName + version
                font.pixelSize: 22
                font.family: "黑体"
                color: "#9D9D9D"
            }
        }
    }

    HLK_JsonListModel {
        id: policeData
    }
    HLK_Border {
        id: policeDataArea
        radius: 10
        width: 300
        height: 240
        x: 548
        y: 395
        color: "white"
        visible: false
        ListView {
            anchors.fill: parent
            anchors.topMargin: 5
            anchors.leftMargin: 5
            clip: true
            model: policeData.model
            delegate: Text {
                font.pixelSize: 28
                font.family: "黑体"
                color: "#000000"
                text: model.PoliceIdcard
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var user = policeData.model.get(index).PoliceIdcard
                        idcard.text = user
                        policeDataArea.visible = false
                        getFocus.focus = true
                        emit: changeUserName(user)
                    }
                }
            }
        }
    }
    HLK_MessageBox {
        id: messagebox
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

}

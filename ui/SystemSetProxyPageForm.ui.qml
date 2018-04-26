import QtQuick 2.4
import "qrc:/controls/ui"
import QtQuick.Controls 1.2
import QtMultimedia 5.4

HLK_BasePage {
    property bool isUseProxy: false
    property alias useProxy: useProxy
    property alias unuseProxy: unuseProxy
    property alias proxyIP: proxyIP
    property alias proxyPort: proxyPort
    property alias proxyUsername: proxyUsername
    property alias proxyPassword: proxyPassword
    pageTitle: "代理信息"

    Rectangle {
        color: "#FFFFFF"
        x: 20
        y: 100
        width: 1240
        height: 100

        Row {
            x: 30
            anchors.verticalCenter: parent.verticalCenter
            HLK_NormalText {
                width: 900
                text: "是否使用代理:"
            }
            ExclusiveGroup {
                id: eg
            }
            HLK_NormalRadioButton {
                id: useProxy
                width: 150
                text: "使用"
                exclusiveGroup: eg
                onCheckedChanged: {
                    if (checked) {
                        isUseProxy = true
                    }
                }
            }
            HLK_NormalRadioButton {
                id: unuseProxy
                width: 150
                text: "不使用"
                exclusiveGroup: eg
                onCheckedChanged: {
                    if (checked) {
                        isUseProxy = false
                    }
                }
            }
        }
    }
    Rectangle {
        color: "#FFFFFF"
        x: 20
        y: 220
        width: 1240
        height: 300

        Flow {
            width: 1200
            height: 200
            anchors.horizontalCenter: parent.horizontalCenter
            y: 20
            spacing: 20
            Row {
                HLK_NormalText {
                    y: proxyIP.y + 13
                    width: 100
                    text: "代理IP:"
                }
                HLK_TextEdit {
                    id: proxyIP
                    width: 1100
                    isEnable: isUseProxy
                }
            }
            Row {
                HLK_NormalText {
                    y: proxyPort.y + 13
                    width: 100
                    text: "代理端口:"
                }
                HLK_TextEdit {
                    id: proxyPort
                    width: 1100
                    isEnable: isUseProxy
                }
            }
            Row {
                HLK_NormalText {
                    y: proxyUsername.y + 13
                    width: 100
                    text: "用户名:"
                }
                HLK_TextEdit {
                    id: proxyUsername
                    width: 1100
                    isEnable: isUseProxy
                }
            }
            Row {
                HLK_NormalText {
                    y: proxyPassword.y + 13
                    width: 100
                    text: "密码:"
                }
                HLK_TextEdit {
                    id: proxyPassword
                    width: 1100
                    isEnable: isUseProxy
                }
            }
        }
    }
}

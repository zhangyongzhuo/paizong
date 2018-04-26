import QtQuick 2.4
import "qrc:/controls/ui"
import QtQuick.Controls 1.2
import QtMultimedia 5.4

HLK_BasePage {
    pageTitle: "修改密码"
    property alias oldpassword: oldpassword //旧密码
    property alias newpassword: newpassword //新密码
    property alias confirmpassword: confirmpassword //重输新密码
    property alias messagebox: messagebox //提示框

    Rectangle {
        color: "#FFFFFF"
        x: 20
        y: 100
        width: 1240
        height: 250

        Flow {
            width: 1200
            height: 180
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 20
            Row {
                HLK_NormalText {
                    y: oldpassword.y + 13
                    text: "旧密码:"
                    width: 100
                }
                HLK_TextEdit {
                    id: oldpassword
                    width: 1090
                    inputTextEchoMode: true
                }
            }
            Row {
                HLK_NormalText {
                    y: newpassword.y + 13
                    text: "新密码:"
                    width: 100
                }
                HLK_TextEdit {
                    id: newpassword
                    width: 1090
                    inputTextEchoMode: true
                }
            }
            Row {
                HLK_NormalText {
                    y: confirmpassword.y + 13
                    text: "确认密码:"
                    width: 100
                }
                HLK_TextEdit {
                    id: confirmpassword
                    width: 1090
                    inputTextEchoMode: true
                }
            }
        }
    }
    HLK_MessageBox {
        id: messagebox
    }
}

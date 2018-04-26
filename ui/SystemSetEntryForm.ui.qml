import QtQuick 2.4
import "qrc:/controls/ui"
import QtQuick.Controls 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL


//信息设置入口页面
HLK_BasePage {
    signal pageJump(int type)
    //0 卡点信息， 1 代理信息， 2 使用模式， 3 修改密码
    pageTitle: "信息设置"

    Rectangle {
        y: 100
        width: parent.width
        height: 650
        color: "#F0F0F0"

        Flickable {
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: 100
            clip: true
            y: 100

            Flow {
                anchors.fill: parent
                spacing: 20
//                HLK_UniversalSystemSetNavigationBar {
//                    id: pointInfo
//                    barTextL: "卡点信息"
//                    barTextR: locationName.length > 20 ? JSL.subStringFromTo(
//                                                             locationName, 0,
//                                                             20) + " >" : locationName + " >"
//                    onSysSetNavigationClicked: {
//                        emit: pageJump(0)
//                    }
//                }
                HLK_UniversalSystemSetNavigationBar {
                    id: proxyInfo
                    barTextL: "代理信息"
                    barTextR: proxyEnable ? "使用 >" : "未使用 >"
                    onSysSetNavigationClicked: {
                        emit: pageJump(1)
                    }
                }
//                HLK_UniversalSystemSetNavigationBar {
//                    id: useMode
//                    barTextL: "使用模式"
//                    barTextR: online ? "在线 >" : "离线 >"
//                    onSysSetNavigationClicked: {
//                        emit: pageJump(2)
//                    }
//                }
//                HLK_UniversalSystemSetNavigationBar {
//                    id: updatePassword
//                    barTextL: "修改密码"
//                    barTextR: "　　　>"
//                    onSysSetNavigationClicked: {
//                        emit: pageJump(3)
//                    }
//                }
            }
        }
    }
}

import QtQuick 2.4

SystemSetEntryForm {

    Component.onCompleted: {
        finish.visible = false
    }

    onPageJump:{//type: 0 卡点信息， 1 代理信息， 2 使用模式， 3 修改密码
        switch(type){
//        case 0:
//            stackView.push("qrc:/systemSettings/ui/SystemSetPointPage.qml")
//            break
        case 1:
            stackView.push("qrc:/systemSettings/ui/SystemSetProxyPage.qml")
            break
//        case 2:
//            stackView.push("qrc:/systemSettings/ui/SystemSetUseModePage.qml")
//            break
//        case 3:
//            stackView.push("qrc:/systemSettings/ui/ModifyPasswordPage.qml")
//            break
        default:
            break
        }
    }
}

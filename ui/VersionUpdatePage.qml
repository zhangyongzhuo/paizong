import QtQuick 2.4
import QtMultimedia 5.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL
VersionUpdatePageForm {
    Component.onCompleted: {
        //updateprogress.value=0.5 //可以向进度条传进度值
    }

    finish.onClicked:{
        stackView.pop()
    }

    versionBtn.onClicked: {
        var proxyJson = {
            "isUseProxy": proxyEnable,
            "proxyIP": operateconfigfile.getProxyHttpsIP(),
            "proxyPort": String(operateconfigfile.getProxyHttpsPort()),
            "username": operateconfigfile.getProxyUsreName(),
            "password": operateconfigfile.getProxyPassword(),
            "serverIP": operateconfigfile.getRemoteIP(),
            "serverPort": String(operateconfigfile.getRemotePort())
        }
        if(qmlData.startUpgradeTool(JSON.stringify(proxyJson))){
            console.log("调用升级客户端成功")
        }else{
            console.log("调用升级客户端失败")
        }
    }
}

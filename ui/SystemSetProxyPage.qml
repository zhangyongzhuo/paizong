import QtQuick 2.4

SystemSetProxyPageForm {
    Component.onCompleted: {
        if(proxyEnable){
            useProxy.checked = true
        }else{
            unuseProxy.checked = true
        }
        proxyIP.text = operateconfigfile.getProxyHttpsIP()
        proxyPort.text = operateconfigfile.getProxyHttpsPort()
        proxyUsername.text = operateconfigfile.getProxyUsreName()
        proxyPassword.text = operateconfigfile.getProxyPassword()
    }
    finish.onClicked:{
        if(useProxy.checked==true){
            proxyEnable = true
        }else{
            proxyEnable = false
        }
        operateconfigfile.setProxyHttpsEnable(proxyEnable)
        operateconfigfile.setProxyHttpsIP(proxyIP.text)
        operateconfigfile.setProxyHttpsPort(Number(proxyPort.text))
        operateconfigfile.setProxyUserName(proxyUsername.text)
        operateconfigfile.setProxyPassword(proxyPassword.text)
        emit: finishTask()
        stackView.pop()
    }
}

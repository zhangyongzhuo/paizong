import QtQuick 2.1
import QtGraphicalEffects 1.0
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2
import com.hylink.fmcp.ctrl 2.0
import QtWebEngine 1.2

HLK_BasePage {
    pageTitle: "在线核查"
    property string checkURL: ""
    Component.onCompleted: {
        finish.visible = false
        console.log("online check url:"+checkURL)
    }
    WebEngineView {
        id: webView
        y: 80
        width: 1280
        height: 670
        url: checkURL
        smooth: true
        visible: true

        onNewViewRequested: request.openIn(webView)
    }

    BusyIndicator {
        id: idcardIndicator
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        running: webView.loading
    }
}




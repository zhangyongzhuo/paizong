import QtQuick 2.4
import "qrc:/controls/ui"
import "qrc:/cascade/ui"

Item {
    width: 400
    height: 300
    property alias progressBar: progressBar
    property alias page: page
    property bool isPageEnable: true

    HLK_ToolProgressBar {
        id: progressBar
        ctrlHeight: page.height
        ctrlIcon: PAGEICON
        ctrlText: PAGETITLE
        ctrlTopLine: PAGETOPLINE
        ctrlBottomLine: true
        x: 20
    }
    IDcardPage {
        id: page
        x: 115
        enabled: isPageEnable
    }
}

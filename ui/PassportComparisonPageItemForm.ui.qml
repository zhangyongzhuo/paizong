import QtQuick 2.4
import "qrc:/controls/ui"
import "qrc:/cascade/ui"
Item {
    width: 400
    height: 300
    property alias progressBar: progressBar
    property bool isPageEnable:true

    HLK_ToolProgressBar{
        id: progressBar
        x: 20
        ctrlHeight: page.height
        ctrlText: PAGETITLE
        ctrlIcon: PAGEICON
        ctrlTopLine: true
        ctrlBottomLine: true
    }
    PassportComparisonPage{
        id: page
        x: 115
        enabled: isPageEnable
    }

}

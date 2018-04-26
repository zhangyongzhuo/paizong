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
        ctrlHeight: page.height
        ctrlText: PAGETITLE
        ctrlIcon: PAGEICON
        ctrlTopLine: false
        ctrlBottomLine: PAGEBOTTOMLINE
        x: 20
    }
    CarsPage{
        id: page
        x: 115
        enabled:isPageEnable
    }
}

import QtQuick 2.4
import QtQml.Models 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.2
import "qrc:/controls/ui"
import "qrc:/item/ui"
import "qrc:/base/js/common.js" as JSL

HLK_BasePage {
    pageTitle: "人员盘查"
    property alias personModel: personModel
    property alias personView: personView
    property string itemPath: ""
    property alias messagebox: messagebox
    property alias popWindow: popWindow
    property alias busyIndicator: busyIndicator

    ListView {
        //V
        id: personView
        x: 0
        y: 110
        width: 1280
        height: 620
        clip: true

        highlightMoveDuration: 1
        cacheBuffer: 3000
        model: ListModel {
            //M
            id: personModel
            ListElement {
                PAGENAME: ""
                PAGEHEIGHT: 0
                PAGETITLE: ""
                PAGETOPLINE:true
                PAGEBOTTOMLINE: true
                PAGEICON: 0
                PAGENO: 0
                PAGEDATA: ""
                PAGELOCAL: false
                PAGEJUMP: 0
                PAGEMODE: 0
                PAGETYPE: 0
                PAGELAST: ""
                PAGETYPE_SD: ""
            }
        }
        delegate: Item {
            implicitHeight: PAGEHEIGHT != undefined ? personModel.get(
                                                          index).PAGEHEIGHT + 20 : 0
            Loader {
                //C
                id: loaderss
                source: (PAGENAME != undefined
                         && PAGENAME != '') ? "qrc:/item/ui/" + personModel.get(
                                                  index).PAGENAME + "Item.qml" : ""
            }
            // enabled: isPageEnable
        }
        section.property: "PAGENAME"
        section.criteria: ViewSection.FullString
    }
    HLK_PopupWindow {
        id: popWindow
        visible: false
        anchors.fill: parent
        popupWindowTitle: "此操作将不会保存当前的数据，是否继续？"
        Row {
            spacing: 100
            anchors.horizontalCenter: parent.horizontalCenter
            y: 400
            HLK_Button {
                id: isContinueBtn
                width: 130
                button_text: "是"
                onClicked: {
                    popWindow.visible = false
                    readIdcard.stopIdcardIdentification()
                    stackView.pop()
                }
            }
            HLK_Button {
                id: noContinueBtn
                width: 130
                button_text: "否"
                onClicked: {
                    popWindow.visible = false
                }
            }
        }
    }
    HLK_MessageBox {
        id: messagebox
    }

    BusyIndicator {
        id: busyIndicator
        y : 330
        anchors.horizontalCenter: parent.horizontalCenter
        running: false
    }
}

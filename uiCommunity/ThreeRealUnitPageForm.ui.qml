import QtQuick 2.4
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

HLK_BasePage {
    pageTitle: "实有单位"
    property alias personModel: personModel
    property alias messagebox: messagebox
    property alias popWindow: popWindow
    property alias basic_ui: basic_ui
    property alias unitPage: unitPage

    //导航条内容
    ListModel{
        id: basic_navi_model
        ListElement{
            key: "基本信息"
            value: "BaseInfoUnitPage"
            enable: false
            dataIndex: 0
        }

        ListElement{
            key: "照 片"
            value: "AddPhotosSinkPage"
            enable: false
            dataIndex:1
        }
    }

    ListModel {
        id: personModel
        ListElement {
            PAGENAME: ""
            PAGEHEIGHT: 0
            PAGETITLE: ""
            PAGETOPLINE: true
            PAGEBOTTOMLINE: true
            PAGEICON: 0
            PAGENO: 0
            PAGEDATA: ""
            PAGELOCAL: false
            PAGEJUMP: 0
            PAGETYPE: 0
            PAGEMODE: 0 //1增加 2删除 3修改 4查看 值为枚举 qmldata中有定义
            PAGELAST: ""
            enable: false
        }
    }


    ExclusiveGroup {
        id: eg
    }

    Item{
        id:unitPage
        y:80
        width: 1280
        height: 640
        Row{
            anchors.fill: parent
            //anchors.margins: 20
            spacing: 20
            //导航条
            Rectangle{
                height: parent.height
                width: 170

                ListView{
                    id: basic_navi
                    anchors.fill: parent
                    clip:  true
                    highlightMoveDuration: 1
                    model: basic_navi_model
                    spacing:20
                    currentIndex: getIndexByName(basic_navi_model, basic_ui.currentSection)
                    delegate: RadioButton{
                        width: 170
                        height:60
                        exclusiveGroup: eg
                        //checked:enable
                        style: RadioButtonStyle{
                            background: Rectangle{
                                color: enable ? '#e8e8e8' : "#FFFFFF"
                                Rectangle{
                                    height: parent.height
                                    anchors.right: parent.right
                                    width: 4
                                    visible: enable
                                    color: '#00aecc'
                                }
                            }
                            label: Text{
                                width: 170
                                height:100
                                text: key
                                font.pixelSize: 22
                                font.family: "SimHei"
                                color: enable ? "#00aecc" : "black"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            indicator: null
                        }

                        onClicked: {
                            basic_ui.positionViewAtIndex(index, ListView.Beginning)
                        }
                    }

                    onCurrentIndexChanged: {
                        for(var i=0; i<basic_navi_model.count; i++){
                            basic_navi_model.get(i).enable = false
                            if(i == currentIndex){
                                basic_navi_model.get(i).enable = true
                            }
                        }
                    }
               }
            }


            //瀑布流
            Item{
                height: parent.height
                width: 1070

                ListView{
                    id: basic_ui
                    anchors.fill: parent
                    clip: true
                    highlightMoveDuration: 1
                    cacheBuffer: 2000

                    model: personModel

                    delegate: Item {
                        z: 100 - index
                        implicitHeight: index == personModel.count-1 ? PAGEHEIGHT : PAGEHEIGHT+20
                        Loader {
                            //C
                            id: loaderss
                            source: (PAGENAME != undefined
                                     && PAGENAME != '') ? "qrc:/cascade/uiCommunity/" + PAGENAME + ".qml" : ""
                        }

                        Rectangle{
                            height: PAGEHEIGHT
                            anchors.left: parent.left
                            width: 6
                            visible: enable
                            color: '#00aecc'

                        }
                    }
                    section.property: "PAGENAME"
                    section.criteria: ViewSection.FullString

                    currentIndex: basic_navi.currentIndex

                    onCurrentIndexChanged: {
                        for(var i=0; i<personModel.count; i++){
                            personModel.get(i).enable = false
                            if(i == currentIndex){
                                personModel.get(i).enable = true
                            }
                        }
                    }
                }
            }
        }
    }

    HLK_MessageBox {
        id: messagebox
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
                    if(qmlData.GetProcessidFromName("VkeyBoard.exe") == 1){
                        qmlData.killTaskl("VkeyBoard.exe")
                    }
                    popWindow.visible = false
                    emit: finishTask()
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
}

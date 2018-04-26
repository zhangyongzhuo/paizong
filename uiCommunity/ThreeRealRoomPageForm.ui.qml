import QtQuick 2.4
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

HLK_BasePage {
    pageTitle: "出租房屋"
    property alias personModel: personModel
    property alias messagebox: messagebox
    property alias popWindow: popWindow

    property alias idcardWindow:idcardWindow  //提示窗口 - 读取到二代证信息的
    property string idcardName:""             //读取到的二代证人员姓名
    property alias fangzhu:fangzhu            //复选框-房主
    property alias chuzuren:chuzuren          //复选框-出租人
    property alias tuoguanren:tuoguanren      //复选框-托管人
    property alias queding:queding            //提示窗口-确定按钮
    property alias quxiao:quxiao              //提示窗口-取消按钮
    property alias idcardWindowLabel:idcardWindowLabel
    property alias basic_ui: basic_ui

    property alias roomPage: roomPage  //当前瀑布流界面


    //导航条内容
    ListModel{
        id: basic_navi_model
        ListElement{
            key: "基本信息"
            value: "BaseInfoPage"
            enable: false
            dataIndex: 0
        }
        ListElement{
            key: "证件信息"
            value: "DocumentInfoPage"
            enable: false
            dataIndex: 1
        }
        ListElement{
            key: "其他信息"
            value: "OwnerInfoPage"
            enable: false
            dataIndex: 2
        }
//        ListElement{
//            key: "托管人信息"
//            value: "CustodianInfoPage"
//            enable: false
//            dataIndex:2
//        }
//        ListElement{
//            key: "出租信息"
//            value: "RentInfoPage"
//            enable: false
//            dataIndex: 3
//        }
//        ListElement{
//            key: "出租人信息"
//            value: "LessorInfoPage"
//            enable: false
//            dataIndex: 4
//        }
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
        id:roomPage

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
                //y:20
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
                            source: "qrc:/cascade/uiCommunity/" + PAGENAME + ".qml"
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

                    currentIndex : basic_navi.currentIndex

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
                    readIdcard.stopIdcardIdentification()
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

    HLK_PopupWindow {
        id: idcardWindow
        visible: false
        anchors.fill: parent
        popupWindowTitle: "二代证信息"
        isShowClose: true
        windowHeight: idcardName.length <= 3 ? 220 : 250
        popWidth:500

        Rectangle{
            //color: 'red'
            width: 450
            height: idcardName.length <= 3 ? 130 : 160
            anchors.horizontalCenter: parent.horizontalCenter
            y: idcardName.length <= 3 ? 350 :340
            Flow{
                anchors.fill: parent
                spacing: 20
                Text{
                    id:idcardWindowLabel
                    //text:"读到["+idcardName+"]的二代证信息，填入下列哪些模块："
                    font.family: 'SimHei'
                    font.pixelSize: 20
                    color: '#343434'
                    width: 450
                    height: idcardName.length <= 3 ? 25 : 50
                    wrapMode:Text.WrapAnywhere
                    lineHeight:25
                    lineHeightMode:Text.FixedHeight
                }
                HLK_Checkbox {
                    id: fangzhu
                    width: 130
                    text: "房主信息"
                    textSize: 20
                }
                HLK_Checkbox {
                    id: chuzuren
                    width: 130
                    text: "出租人信息"
                    textSize: 20
                }
                HLK_Checkbox {
                    id: tuoguanren
                    width: 130
                    text: "托管人信息"
                    textSize: 20
                }

                Rectangle{
                    width: 25
                    height: 25
                }
                Row {
                    spacing: 100
                    HLK_Button {
                        id: queding
                        width: 130
                        button_text: "确定"
                    }
                    HLK_Button {
                        id: quxiao
                        width: 130
                        button_text: "取消"
                        onClicked: {
                            idcardWindow.visible = false
                        }
                    }
                }

            }
        }
    }

    HLK_MessageBox {
        id: messagebox
    }
}

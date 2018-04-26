import QtQuick 2.4
import QtMultimedia 5.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2


//实有房屋基本信息块
Item {
    property alias messagebox: messagebox
    property alias houseAddress: houseAddress //房屋地址
    property alias uintName: uintName //单元名称
    property alias rentalSituation: rentalSituation //出租情况
    property alias rentalSituationData: rentalSituationData //出租情况数据
    property alias ownerID: ownerID //房主身份证号
    property alias houseClass: houseClass //房屋类别
    property alias ownerTel: ownerTel //房主电话号
    property alias housePurpose: housePurpose //房屋用途
    property alias housePurposeData: housePurposeData //房屋用途数据
    property alias houseCount: houseCount //到期时间
    property alias houseNature: houseNature //房屋性质
    property alias houseNatureData: houseNatureData //房屋性质数据

    //property alias houseArea: houseArea //房屋面积
    //property alias isHouseLet: isHouseLet //是否出租
    //property alias houseunit: houseunit //所属单位
    //property alias remarks: remarks //备注
    //property alias remarksNumber: remarksNumber // 基本信息 - 备注（字数显示）
    property int    defaultTextSize: 20
    property alias getFocusComboBox: getFocusComboBox

    //房屋地址 一
    //property alias residenceAddress: residenceAddress
    property alias unitDataArea:unitDataArea
    property alias unitData: unitData
    //房屋地址 二
    //property alias residenceuintName:residenceuintName
    property alias dzxzDataArea:dzxzDataArea
    property alias dzxzData: dzxzData

    signal changeUnitZz() //暂住第一项发生变化
    //获取焦点
    HLK_TextEdit {
        id: getFocusComboBox
        visible: false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            emit: componentRecovery()
        }
    }

    width: 1070
    height: 370

    Rectangle {
        width: 1070
        height: 460
        anchors.fill: parent
        color: '#FFFFFF'

        Row{
            width: parent.width
            height: parent.height
            y: 20
            x: 20
            spacing:10
            HLK_Text {
                textWidth: 110
                textContent: "<font color='red'>*</font>房屋地址:"
            }
            HLK_TextEdit{
                id: houseAddress
                width : 530
                height : 50
                inputSize:defaultTextSize
                pagename: PAGENAME
            }
            HLK_TextEdit{
                id: uintName
                width : 370
                height : 50
                inputSize:defaultTextSize
                pagename: PAGENAME
            }
        }
        Row {
         z:6
         x:140
         y:70
         height:1
         spacing: 25
             Row{
                 width:515
                 height:1
                 HLK_Border {
                     id: unitDataArea
                     radius: 10
                     width: 530
                     height: 240
//                             x: 340
//                             y:collectionUnit.y+100 //340
                     color: "white"
                     visible: false
                     ListView {
                         id:unitDataView
                         anchors.fill: parent
                         anchors.topMargin: 5
                         anchors.leftMargin: 5
                         anchors.rightMargin: 5
                         clip: true
                         model: unitData.model
                         highlight: Rectangle{
                                color:"#BFEFFF"
                                radius: 3
                         }
                         highlightFollowsCurrentItem: true
                         focus: true

                         delegate: Text{
                             width:parent.width
                             font.pixelSize: defaultTextSize
                             height:35
                             verticalAlignment: Text.AlignVCenter
                             font.family: "黑体"
                             color: "#000000"
                             text: model.mlpxz

                             MouseArea {
                                 anchors.fill: parent
                                 onClicked: {
                                     var user = unitData.model.get(index).mlpxz
                                     zzjgCode = unitData.model.get(index).mldzid
                                     houseAddress.text = user
                                     unitDataArea.visible = false
                                     getFocus.focus = true
                                     //emit: changeUnitZz()
                                     //emit: changeUserName(user)
                                 }
                             }
                         }
                     }
                 }
            }
             HLK_Border {
                 id: dzxzDataArea
                 radius: 10
                 width: 370
                 height: 240
                 color: "white"
                 visible: false
                 ListView {
                     id:dzxzDataView
                     anchors.fill: parent
                     anchors.topMargin: 5
                     anchors.leftMargin: 5
                     anchors.rightMargin: 5
                     clip: true
                     model: dzxzData.model
                     highlight: Rectangle{
                            color:"#BFEFFF"
                            radius: 3
                     }
                     highlightFollowsCurrentItem: true
                     focus: true

                     delegate: Text{
                         width:parent.width
                         font.pixelSize: defaultTextSize
                         height:35
                         verticalAlignment: Text.AlignVCenter
                         font.family: "黑体"
                         color: "#000000"
                         text: model.hm

                         MouseArea {
                             anchors.fill: parent
                             onClicked: {
                                 var user = dzxzData.model.get(index).hm
                                 dzxzEndJson=dzxzData.model.get(index)
                                 uintName.text = user
                                 dzxzDataArea.visible = false
                                 getFocus.focus = true
                                 //emit: changeUserName(user)
                             }
                         }
                     }
                 }
             }
        }

        Column{
            width: parent.width
            height: parent.height
            y: 90
            x: 20
            spacing: 20
            Row{
                z:5
                spacing:50
                Row{
                    spacing:10
                    HLK_Text {
                        textWidth: 110
                        textContent: "<font color='red'>*</font>出租情况:"
                    }
                    HLK_ComboBox {
                        id: rentalSituation
                        model:rentalSituationData
                        boxWidth : 370
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                        initHeight:280
                    }
                }
                Row{
                    spacing:10
                    HLK_Text {
                        textWidth: 110
                        textContent: '房主身份证:'
                    }
                    HLK_TextEdit {
                        id: ownerID
                        width: 370
                        textSize: defaultTextSize
                        pagename: PAGENAME
                    }
                }
            }
            Row{
                z:4
                spacing:50
                Row{
                    spacing:10
                    HLK_Text {
                        textWidth: 110
                        textContent: '出租类型:'
                    }
                    HLK_ComboBox {
                        id: houseClass
                        model: houseClassData
                        boxWidth:370
                        boxHeight : 50
                        boxTopMargin : 12
                        initHeight:250
                        pagename: PAGENAME
                    }
                }
                Row{
                    spacing:10
                    HLK_Text {
                        textWidth: 110
                        textContent: '房主电话:'
                    }
                    HLK_TextEdit {
                        id: ownerTel
                        width: 370
                        textSize: defaultTextSize
                        pagename: PAGENAME
                    }
                }
            }
            Row{
                z:3
                spacing:50
                Row{
                    spacing:10
                    HLK_Text {
                        textWidth: 110
                        textContent: "<font color='red'>*</font>房屋性质:"
                    }
                    HLK_ComboBox {
                        id: houseNature
                        model:houseNatureData
                        boxWidth : 370
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                        initHeight:280
                    }
                }
                Row{
                    spacing:10
                    HLK_Text {
                        textWidth: 110
                        textContent: '房屋用途:'
                    }
                    HLK_ComboBox {
                        id: housePurpose
                        model:housePurposeData
                        boxWidth : 370
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                        initHeight:280
                    }
                }
            }
            Row{
                z:2
                spacing:50
                Row{
                    spacing:10
                    HLK_Text {
                        textWidth: 110
                        textContent: '到期时间:'
                    }
                    HLK_TextEdit {
                        id: houseCount
                        width: 370
                        textSize: defaultTextSize
                        pagename: PAGENAME
                    }
                }
//                Row{
//                    spacing:10
//                    HLK_Text {
//                        textWidth: 110
//                        textContent: '房屋面积:'
//                    }
//                    HLK_TextEdit {
//                        id: houseArea
//                        width: 260
//                        textSize: defaultTextSize
//                        pagename: PAGENAME
//                    }
//                    HLK_Text {
//                        textWidth: 100
//                        textContent: '( 平方米 )'
//                    }
//                }
            }
//            Row{
//                z:2
//                spacing:50
//                Row{
//                    spacing:10
//                    HLK_Text {
//                        textWidth: 110
//                        textContent: "<font color='red'>*</font>是否出租:"
//                    }
//                    HLK_ComboBox {
//                        id: isHouseLet
//                        model: isHouseLetData
//                        boxWidth:370
//                        boxHeight : 50
//                        boxTopMargin : 12
//                        pagename: PAGENAME
//                        initHeight:80
//                        onCurrentTextChanged: {
//                            if(isHouseLet.currentIndex==0){
//                                emit:sendPageUabled(false)
//                            }else{
//                                emit:sendPageUabled(true)
//                            }
//                        }
//                    }
//                }
//                Row{
//                    spacing:10
//                    HLK_Text {
//                        textWidth: 110
//                        textContent: '所属单位:'
//                    }
//                    HLK_TextEdit {
//                        id: houseunit
//                        width: 370
//                        textSize: defaultTextSize
//                        pagename: PAGENAME
//                    }
//                }
//            }
//            Row{
//                z:1
//                spacing:10
//                HLK_Text {
//                    textWidth: 110
//                    textHeight: 140
//                    textContent: '备    注:'
//                }
//                HLK_MultilineTextEdit {
//                    id: remarks
//                    modehint: ""
//                    maxLength: 256
//                    width: 910
//                    height:140
//                    textSize: defaultTextSize
//                    pagename: PAGENAME
//                    Text{
//                        id:remarksNumber
//                        anchors.bottom: parent.bottom
//                        anchors.bottomMargin: 5
//                        anchors.right: parent.right
//                        anchors.rightMargin: 5
//                        color: '#666666'
//                        //text: control.text
//                        font.family: "SimHei"
//                        font.pixelSize: 24
//                        wrapMode: Text.WordWrap
//                    }
//                    onTextChanged: {
//                        remarksNumber.text=remarks.text.length+"/"+256
//                    }
//                }
//            }
        }
    }
    ListModel {
        id: houseClassData
        ListElement {
            text: "整租"
            code: "0"
        }
        ListElement {
            text: "部分出租"
            code: "1"
        }
    }
    ListModel {
        id: rentalSituationData
        ListElement {
            text: "出租房"
            code: "0"
        }
        ListElement {
            text: "廉租房"
            code: "1"
        }
    }
    ListModel {
        id: housePurposeData
        ListElement {
            text: "仓储"
            code: "0"
        }
        ListElement {
            text: "办公"
            code: "1"
        }
    }
    ListModel {
        id: houseNatureData
        ListElement {
            text: "公产房"
            code: "0"
        }
        ListElement {
            text: "个人产权"
            code: "1"
        }
    }
//    ListModel {
//        id: houseNatureData
//    }

//    ListModel {
//        id: houseClassData
//    }

//    ListModel {
//        id: housePurposeData
//    }

//    ListModel {
//        id: isHouseLetData
//        ListElement {
//            text: "否"
//            code: "0"
//        }
//        ListElement {
//            text: "是"
//            code: "1"
//        }
//    }

    HLK_JsonListModel {
        id: unitData
    }
    HLK_JsonListModel {
        id: dzxzData
    }

    HLK_MessageBox {
        id: messagebox
    }
}


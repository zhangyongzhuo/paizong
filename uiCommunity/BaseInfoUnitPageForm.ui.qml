import QtQuick 2.5
import QtMultimedia 5.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2


//实有单位基本信息块
Item {
    property alias messagebox: messagebox

    property alias unitName: unitName //单位名称
    property alias unitClass: unitClass //单位类别
    property alias englishName: englishName //单位英文名称
    property alias englishAbbreviation: englishAbbreviation //单位英文缩写
//    property alias unitCode: unitCode //单位编码
    property alias telephone: telephone //联系电话
//    property alias unitAddress: unitAddress //单位地址描述
    property alias tradeClass: tradeClass //行业类别
    property alias faxNumber: faxNumber //传真号码
    property alias foreignUnit: foreignUnit //是否外资单位
    property alias foreignConcerning: foreignConcerning //是否涉外单位
    property alias orderSystem: orderSystem //是否安装治安管理信息系统
    property alias isFire: isFire//是否经消防安全验收合格
    property alias anotherName: anotherName //单位别名
    property alias url: url //网址
    //property alias managementType: managementType //管理类型
    property alias remarks: remarks //备注
    property alias remarksNumber: remarksNumber
//    property alias policeStation: policeStation //描述所属派出所
//    property alias responsibilityArea: responsibilityArea //描述所责任区

    property alias houseAddress: houseAddress //单位标准地址
    property alias uintName: uintName //单元名称
    signal changeUnitZz() //暂住第一项发生变化

    //房屋地址 一
    //property alias residenceAddress: residenceAddress
    property alias unitDataArea:unitDataArea
    property alias unitData: unitData
    //房屋地址 二
    //property alias residenceuintName:residenceuintName
    property alias dzxzDataArea:dzxzDataArea
    property alias dzxzData: dzxzData

    property alias order: order
    property alias internal: internal
    property alias security: security
    property alias technical: technical
    property alias fire: fire
    property alias otherBtn:otherBtn
    //property alias popText:popText
    property int defaultTextSize: 20

    width: 1070
    height: 870

    //获取焦点
    property alias getFocusComboBox:getFocusComboBox
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

    Rectangle {
        anchors.fill: parent
        color: '#FFFFFF'
        Column {

            width: 1070
            height: 870
            y: 20
            spacing: 20
            z:5
            Row {
                //z: 11
                spacing:15
                HLK_Text {
                    textWidth: 152
                    textContent: "<font color='red'>*</font>单位名称:"

                }
                HLK_TextEdit {
                    id: unitName
                    width:880
                    textSize: defaultTextSize
                    pagename: PAGENAME
                }
//                HLK_ComboBox {
//                    id: unitName
//                    model: unitNameData
//                    boxWidth:880
//                    boxHeight : 50
//                    boxTopMargin : 12
//                }
//                HLK_Text {
//                    textWidth: 152
//                    textContent: '单位编码:'
//                }
//                HLK_TextEdit {
//                    id: unitCode
//                    width: 350
//                    textSize: defaultTextSize
//                }
            }
            Row {
                //z: 10
                spacing: 15
                HLK_Text {
                    textWidth: 152
                    textContent: '单位英文名称:'
                }
                HLK_TextEdit {
                    id: englishName
                    width: 350
                    textSize: defaultTextSize
                    pagename: PAGENAME
                }
                HLK_Text {
                    textWidth: 152
                    textContent: '单位英文缩写:'
                }
                HLK_TextEdit {
                    id: englishAbbreviation
                    width: 350
                    textSize: defaultTextSize
                    pagename: PAGENAME
                }
            }
////////////////////////////
            Row {
                //z: 9
                width: 1070
                height: 36
                spacing: 20

                HLK_Text {
                    textWidth: 152
                    textHeight: 36
                    textContent: "<font color='red'>*</font>管理类型:"
                }
                HLK_Checkbox {
                    id: order
                    width: parent.width / 13
                    text: "治安"
                    textSize: defaultTextSize
                    yHigh: 10
//                    onClicked: {
//                        ztry.checked = false
//                        zdgz.checked = false
//                        fzqk.checked = false
//                        xdfds.checked = false
//                    }

                }
                HLK_Checkbox {
                    id: internal
                    width: parent.width / 13
                    text: "内保"
                    textSize: defaultTextSize
                    yHigh: 10
                    onClicked: {
                        //wskbj.checked = false
                    }
                }
                HLK_Checkbox {
                    id: security
                    width: parent.width / 13
                    text: "保安"
                    textSize: defaultTextSize
                    yHigh: 10
                    onClicked: {
                        //wskbj.checked = false
                    }
                }
                HLK_Checkbox {
                    id: technical
                    width: parent.width / 13
                    text: "技防"
                    textSize: defaultTextSize
                    yHigh: 10
                    onClicked: {
                        //wskbj.checked = false
                    }
                }
                HLK_Checkbox {
                    id: fire
                    width: parent.width / 13
                    text: "消防"
                    textSize:defaultTextSize
                    yHigh: 10
                    onClicked: {
                        //wskbj.checked = false
                    }
                }
            }
///////////////////////////////////////////
            Row {
                z: 4
                spacing: 15
                HLK_Text {
                    textWidth: 152
                    textContent: "<font color='red'>*</font>单位类别:"
                }
//                HLK_ComboBox {
//                    id: unitClass
//                    model: unitClassData
//                    boxWidth: 350
//                    boxHeight: 50
//                    boxTopMargin: 12
//                    pagename: PAGENAME
//                }

                HLK_FuzzySearchComboBox {
                    id: unitClass
                    //boxTopMargin : 12
                    wenbenWidth: 350
                    wenbenHeight:50
                    xialaHeight:240
                    //wenbenTextSize:20
                    wenbenPagename: PAGENAME
                    yuanshiList:unitClassList
//                    onChooseItemChanged: {
//                        console.log("----guojia:"+chooseItem.text)
//                        console.log("----guojia:"+chooseItem.code)
//                    }
                }
                HLK_Text {
                    textWidth: 152
                    textContent: '联系电话:'
                }
                HLK_TextEdit {
                    id: telephone
                    width: 350
                    textSize: defaultTextSize
                    pagename: PAGENAME
                }
            }
            Row {
                z: 3
                spacing:15
                HLK_Text {
                    textWidth: 152
                    textContent: "<font color='red'>*</font>单位标准地址:"
                }

                HLK_TextEdit{
                    id: houseAddress
                    width : 515
                    height : 50
                    inputSize:defaultTextSize
                    pagename: PAGENAME
                }

                HLK_TextEdit{
                    id: uintName
                    width : 350
                    height : 50
                    inputSize:defaultTextSize
                    pagename: PAGENAME
                }
            }

            Row {
             x:165
             height:1
             spacing: 15
                 Row{
                     width:515
                     height:1
                     HLK_Border {
                         id: unitDataArea
                         radius: 10
                         width: 515
                         height: 240
                         y:-20
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
                                 height:35
                                 verticalAlignment: Text.AlignVCenter
                                 font.pixelSize: defaultTextSize
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
                     width: 350
                     height: 240
                     y:-20
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
        }
        Column {

            width: 1070
            height: 500
            y: 355
            spacing: 20
            Row {
                z: 2
                spacing: 15
                HLK_Text {
                    textWidth: 152
                    textContent: '行业类别:'
                }
//                HLK_ComboBox {
//                    id: tradeClass
//                    model: tradeClassData
//                    boxWidth: 350
//                    boxHeight: 50
//                    boxTopMargin: 12
//                    pagename: PAGENAME
//                }

                HLK_FuzzySearchComboBox {
                    id: tradeClass
                    //boxTopMargin : 12
                    wenbenWidth: 350
                    wenbenHeight:50
                    xialaHeight:240
                    //wenbenTextSize:20
                    wenbenPagename: PAGENAME
                    yuanshiList:tradeClassList
//                    onChooseItemChanged: {
//                        console.log("----guojia:"+chooseItem.text)
//                        console.log("----guojia:"+chooseItem.code)
//                    }
                }
            }
            Row{
                spacing:15
                z: 1
                HLK_Text {
                    textWidth: 152
                    textContent: '是否外资单位:'
                }
                HLK_ComboBox {
                    id: foreignUnit
                    model: foreignUnitData
                    boxWidth: 350
                    boxHeight: 50
                    boxTopMargin: 12
                    currentIndex:-1
                    initHeight:80
                    pagename: PAGENAME
                }
                HLK_Text {
                    textWidth: 152
                    textContent: '是否涉外单位:'
                }
                HLK_ComboBox {
                    id: foreignConcerning
                    model: foreignConcerningData
                    boxWidth:350
                    boxHeight: 50
                    boxTopMargin: 12
                    currentIndex:-1
                    initHeight:80
                    pagename: PAGENAME
                }
            }
            Row {
                //z: 4
                spacing: 15
                HLK_Text {
                    textWidth: 152
                    textContent: '传真号码:'
                }
                HLK_TextEdit {
                    id: faxNumber
                    width: 350
//                    text: "暂无"
                    textSize: defaultTextSize
                    pagename: PAGENAME
                }
                HLK_Text {
                    textWidth: 152
                    textContent: '单位网址:'
                }
                HLK_TextEdit {
                    id: url
                    width: 350
                    textSize: defaultTextSize
                    pagename: PAGENAME
                }
            }
            Row{
                z: 0.5
                spacing: 15
                HLK_Text {
                    textWidth: 270
                    textContent: '是否安装治安管理信息系统:'
                }
                HLK_ComboBox {
                    id: orderSystem
                    model: orderSystemData
                    boxWidth: 230
                    boxHeight: 50
                    boxTopMargin: 12
                    currentIndex:-1
                    initHeight:80
                    pagename: PAGENAME
                }
                HLK_Text {
                    textWidth: 250
                    textContent: '是否经消防安全验收合格:'
                }
                HLK_ComboBox {
                    id: isFire
                    model: isFireData
                    boxWidth: 252
                    boxHeight: 50
                    boxTopMargin: 12
                    currentIndex:-1
                    initHeight:80
                    pagename: PAGENAME
                }
            }
            Row{
                //z: 2
                spacing: 15
                HLK_Text {
                    textWidth: 152
                    textContent: '单位别名:'
                }
                HLK_TextEdit {
                    id: anotherName
                    width: 822
                    textSize: defaultTextSize
                    pagename: PAGENAME
                }
                HLK_AddPlusButton{
                    id:otherBtn
                    y:5
                    //y:anotherName+10
                }

//                Image{
//                    width:30
//                    height:30
//                    source:"qrc:/images/images/add.png"
//                }
            }
            Row{
                //z: 1
                spacing: 15
                HLK_Text {
                    textWidth: 152
                    textHeight: 140
                    textContent: '备    注:'
                }
                HLK_MultilineTextEdit {
                    id: remarks
                    modehint: ""
                    maxLength:256
                    width: 880
                    height:140
                    textSize: defaultTextSize
                    pagename: PAGENAME
                    Text{
                        id:remarksNumber
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        anchors.right: parent.right
                        anchors.rightMargin: 5
                        color: '#666666'
                        //text: control.text
                        font.family: "SimHei"
                        font.pixelSize: 24
                        wrapMode: Text.WordWrap
                    }
                    onTextChanged: {
                        remarksNumber.text=remarks.text.length+"/"+256
                    }
                }
            }
        }
    }

    ListModel {
        id: unitNameData
        ListElement {
            text: "海邻科"
            code: "01"
        }
        ListElement {
            text: "新光电"
            code: "02"
        }
        ListElement {
            text: "自住房"
            code: "03"
        }
    }

    ListModel {
        id: unitClassData
    }

    ListModel {
        id: tradeClassData       
    }
    ListModel {
        id: foreignUnitData
        ListElement {
            text: "否"
            code: "0"
        }
        ListElement {
            text: "是"
            code: "1"
        }
    }
    ListModel {
        id: foreignConcerningData
        ListElement {
            text: "否"
            code: "0"
        }
        ListElement {
            text: "是"
            code: "1"
        }
    }
    ListModel {
        id: orderSystemData
        ListElement {
            text: "否"
            code: "0"
        }
        ListElement {
            text: "是"
            code: "1"
        }
    }
    ListModel {
        id: isFireData
        ListElement {
            text: "否"
            code: "0"
        }
        ListElement {
            text: "是"
            code: "1"
        }
    }
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

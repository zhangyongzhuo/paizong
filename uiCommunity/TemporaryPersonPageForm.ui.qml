import QtQuick 2.4
import QtMultimedia 5.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2


//实有人员暂住人口信息块
Item {
    property alias messagebox: messagebox

    property alias fromAdministrative: fromAdministrative //来自地行政区划
    //property alias comeFromAddrControl:comeFromAddrControl
    property alias fromArea: fromArea //来自地描述
    property alias stayReason: stayReason //暂住事由
    property alias stayDate: stayDate //暂住日期
    property alias registeredAreaClass: registeredAreaClass //户口所在地类型
    property alias moveReason: moveReason //迁移原因
    property alias fromCountry: fromCountry //来自国家
    property alias areaRange: areaRange //区域范围
    property alias resideAddress: resideAddress //居住处所
    property alias remarks: remarks //备注
    property alias remarksNumber: remarksNumber // 暂住备注内容长度
    property alias temporaryStay: temporaryStay //暂住人口
    property alias fromCityType: fromCityType  //来自地城乡分类
    property alias rentIt: rentIt // 房屋承租情况（暂住）
    property alias rentItZz:rentItZz
    property alias relationWithOwner: relationWithOwner // 与房主关系
    property alias houseOwnerCardType: houseOwnerCardType // 房主证件种类
    property alias houseOwnerCardNumber: houseOwnerCardNumber // 房主证件号码
    property alias houseOwnerName: houseOwnerName // 房主姓名
    property alias houseOwnerPhoneNumber: houseOwnerPhoneNumber // 房主联系电话
    property alias houseOwnerLiveAddress: houseOwnerLiveAddress // 房主居住地址（暂住）
    //property alias houseOwnerLiveUnit: houseOwnerLiveUnit // 房主居住地址单元号（暂住）
    property alias startRentDate: startRentDate
    property alias offHireDate: offHireDate

    property alias liveStay: liveStay //寄住人口
    property alias liveAwayTeyp: liveAwayTeyp //寄住类别
    property alias liveAwayReason: liveAwayReason //寄住原因
    property alias liveAwayTime: liveAwayTime //寄住开始时间
    property alias leaveTime: leaveTime //预计离开时间
    property alias liveResideAddress: liveResideAddress //居住处所
    property alias liveRentIt: liveRentIt // 房屋承租情况（寄住）
    property alias liveRelationWithOwner: liveRelationWithOwner // 与房主关系
    property alias liveHouseOwnerCardType: liveHouseOwnerCardType // 房主证件种类
    property alias liveHouseOwnerCardNumber: liveHouseOwnerCardNumber // 房主证件号码
    property alias liveHouseOwnerName: liveHouseOwnerName // 房主姓名
    property alias liveHouseOwnerPhoneNumber: liveHouseOwnerPhoneNumber // 房主联系电话
    property alias liveHouseOwnerLiveAddress: liveHouseOwnerLiveAddress // 房主居住地址（寄住）
    //property alias liveHouseOwnerLiveUnit: liveHouseOwnerLiveUnit // 房主居住地址单元号（寄住）
    property alias liveRemarks: liveRemarks //备注
    property alias liveRemarksNumber: liveRemarksNumber // 寄住备注内容长度

    property alias registeredAreaClassData: registeredAreaClassData
    property alias moveReasonData: moveReasonData
    property alias fromCountryData:fromCountryData
    property alias areaRangeData:areaRangeData
    property alias fromAdministrativeData:fromAdministrativeData
    property alias resideAddressData:resideAddressData
    property alias relationWithOwnerData:relationWithOwnerData
    property alias rentItData:rentItData
    property alias fromCityTypeData:fromCityTypeData
    property alias liveAwayTeypData:liveAwayTeypData
    property alias liveAwayReasonData:liveAwayReasonData
    property alias liveResideAddressData:liveResideAddressData
    property alias liveRentItData:liveRentItData
    property alias liveRelationWithOwnerData:liveRelationWithOwnerData
    property alias rentItJz:rentItJz
    property alias liveStartRentDate: liveStartRentDate
    property alias liveOffHireDate: liveOffHireDate

    //暂住一
    property alias residenceAddress: residenceAddress
    property alias unitDataArea:unitDataArea
    property alias unitData: unitData
    //暂住二
    property alias residenceuintName:residenceuintName   
    property alias dzxzDataArea:dzxzDataArea
    property alias dzxzData: dzxzData
    //寄住一
    property alias tmpsleepAddress: tmpsleepAddress
    property alias unitJzDataArea:unitJzDataArea
    property alias unitJzData: unitJzData
    //寄住二
    property alias tmpsleepuintName: tmpsleepuintName
    property alias dzxzJzDataArea:dzxzJzDataArea
    property alias dzxzJzData: dzxzJzData


    property alias stayReasonData: stayReasonData
    property int changeheight: 1010
    property int defaultTextSize: 20
    property alias getFocusComboBox: getFocusComboBox
    //property alias datePage:datePage

    property alias fromLandDataArea: fromLandDataArea
    property alias fromLandData: fromLandData
    property alias fromLandDataView:fromLandDataView


 signal changeUnitJz() //寄住第一项发生变化
    signal changeUnitZz() //暂住第一项发生变化

    width: 1170
    height: changeheight

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

    ExclusiveGroup {
        id: eg
    }

    Rectangle {
        width: 1170
        height: parent.height
        anchors.fill: parent
        color: '#FFFFFF'
        Row{
            width: 1170
            height: 50
            x:20
            y:20
            z:4
            spacing: 30
            HLK_Text {
                textWidth: 170
                textContent: "实有人口业务类型:"
            }
            Row {
                width: 570
                spacing: 50
                HLK_NormalRadioButton {
                    id:temporaryStay
                    width: 140
                    height: 52
                    fontSize:20
                    text: "暂住人口"
                    exclusiveGroup: eg
                    checked: true
                    onCheckedChanged: {
                        //temporaryStay.checked=true

                        if(temporaryStay.checked){
                            PAGEHEIGHT=1010//940
                            changeheight=1010//940
                        }
                    }
                }
                HLK_NormalRadioButton {
                    id:liveStay
                    width: 100
                    height: 52
                    fontSize:20
                    text: "寄住人口"
                    exclusiveGroup: eg
                    onCheckedChanged: {
                        //temporaryStay.checked=true
                        if(liveStay.checked){
                            PAGEHEIGHT=870//800
                            changeheight=870//800
                        }
                    }
                }
            }
       }



    //////////////////暂住人口/////////////
        Column{
            width: parent.width
            height: parent.height
            y: 80
            x: 20
            spacing: 20
            visible: temporaryStay.checked
            Column{
                width: parent.width
                spacing: 0
                                 z:99
                Row {
                    z: 11
                    spacing:15
                    HLK_Text {
                        textWidth: 170
                        textContent: "<font color='red'>*</font>居住地:"
                    }
                    HLK_TextEdit{
                        id: residenceAddress
                        //model:houseClassData
                        width : 500
                        height : 50
                        inputSize:defaultTextSize
                        pagename: PAGENAME
                    }

                    HLK_TextEdit{
                        id: residenceuintName
                        //model:houseClassData
                        width : 330
                        height : 50
                        inputSize:defaultTextSize
                        pagename: PAGENAME
                    }
                }
                Row {
                 x:185
                 height:1
                     Row{
                         width:515
                         height:1
                         HLK_Border {
                             id: unitDataArea
                             radius: 10
                             width: 500
                             height: 240
        //                     x: 340
        //                     y:collectionUnit.y+100 //340
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
                                             residenceAddress.text = user
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
                         width: 330
                         height: 240
                         x: 500
    //                     y:collectionUnit.y+100 //340
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
                                         residenceuintName.text = user
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
            Row{
                z: 10
                //spacing:10
                Row{
                    spacing:15
                    HLK_Text {
                        textWidth: 170
                        textContent: "<font color='red'>*</font>暂住事由:"
                    }
//                    HLK_ComboBox {
//                        id: stayReason
//                        model: stayReasonData
//                        boxWidth:330
//                        boxHeight : 50
//                        boxTopMargin : 12
//                        //hint:"输入搜索条件可下拉直接选择"
//                        hintSize:20
//                        pagename: PAGENAME
//                    }

                    HLK_FuzzySearchComboBox {
                        id: stayReason
                        wenbenWidth: 330
                        wenbenHeight:50
                        xialaHeight:300
                        wenbenPagename: PAGENAME
                        yuanshiList:stayReasonList
                    }


//                    HLK_TextEdit {
//                        id: stayReason
//                        width: 330
//                        inputSize: 20
//                        hint:"输入搜索条件可下拉直接选择"
//                        hintSize:20
//                        //inputTextEchoMode: true
//                    }
                }
                Row{
                    spacing:15
                    HLK_Text {
                        textWidth: 170
                        textContent: '户口所在地类型:'
                    }
                    HLK_ComboBox {
                        id: registeredAreaClass
                        model: registeredAreaClassData
                        boxWidth:330
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                        initHeight: 100
                        currentIndex: -1
                    }
                }
            }
            Row{
                z: 9
                //spacing:10
                Row{
                    spacing:15
                    HLK_Text {
                        textWidth: 170
                        textContent: '暂住日期:'
                    }
                    HLK_TextEdit {
                        id: stayDate
                        width: 330
                        textSize: defaultTextSize
                        pagename: PAGENAME
                    }
                }
                Row{
                    spacing:15
                    HLK_Text {
                        textWidth: 170
                        textContent: '迁移原因:'
                    }
//                    HLK_ComboBox {
//                        id: moveReason
//                        model: moveReasonData
//                        boxWidth:330
//                        boxHeight : 50
//                        boxTopMargin : 12
//                        pagename: PAGENAME
//                    }

                    HLK_FuzzySearchComboBox {
                        id: moveReason
                        wenbenWidth: 330
                        wenbenHeight:50
                        xialaHeight:300
                        wenbenPagename: PAGENAME
                        yuanshiList:moveReasonList
                    }
                }
            }
            Row{
                z: 8
                //spacing:90
                Row{
                    spacing:15
                    HLK_Text {
                        textWidth: 170
                        textContent: '来自国家:'
                    }
//                    HLK_ComboBox {
//                        id: fromCountry
//                        model: fromCountryData
//                        boxWidth:330
//                        boxHeight : 50
//                        boxTopMargin : 12
//                        pagename: PAGENAME
//                    }

                    HLK_FuzzySearchComboBox {
                        id: fromCountry
                        wenbenWidth: 330
                        wenbenHeight:50
                        xialaHeight:300
                        wenbenPagename: PAGENAME
                        yuanshiList:fromCountryList
                    }
                }
                Row{
                    spacing:15
                    HLK_Text {
                        textWidth: 170
                        textContent: '区域范围:'
                    }
                    HLK_ComboBox {
                        id: areaRange
                        model: areaRangeData
                        boxWidth:330
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                        initHeight: 380
                    }
                }
            }
            Column{
                width: parent.width
                spacing: 0
                z:7

                Row{
                    z: 7
                    //spacing:10

                    Row{
                        spacing:15
                        HLK_Text {
                            textWidth: 170
                            textContent: "<font color='red'>*</font>来自地行政区划:"
                        }
                        HLK_TextEdit {
                            id: fromAdministrative
                            width: 330
                            textSize: defaultTextSize
                            pagename: PAGENAME
                        }
                    }
                    Row{
                        spacing:15
                        HLK_Text {
                            textWidth: 170
                            textContent: "<font color='red'>*</font>来自地描述:"
                        }
                        HLK_TextEdit {
                            id: fromArea
                            width: 330
                            textSize: defaultTextSize
                            pagename: PAGENAME
                        }
                    }
                }
                Row {
                    x:185
                    height:1
                    HLK_Border {
                    id: fromLandDataArea
                    radius: 10
                    width: 330
                    height: 240
        //                             x:340
        //                             y:340
                    color: "white"
                    visible: false
                    ListView {
                        id:fromLandDataView
                        anchors.fill: parent
                        anchors.topMargin: 5
                        anchors.leftMargin: 5
                        anchors.rightMargin: 5
                        clip: true
                        model: fromLandData.model
                        highlight: Rectangle{
                               color:"#BFEFFF"
                               radius: 3
                        }
                        highlightFollowsCurrentItem: true
                        focus: true

                        delegate: Text{
                            width:parent.width
                            font.pixelSize: defaultTextSize
                            height: 35
                            verticalAlignment: Text.AlignVCenter
                            font.family: "黑体"
                            color: "#000000"
                            text: model.text

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    var user = fromLandData.model.get(index).text
                                    fromAdministrative.text = user
                                    fromArea.text=fromAdministrative.text
                                    fromLandDataArea.visible = false
                                    getFocus.focus = true
                                    //emit: changeUserName(user)
                                }
                            }
                        }
                    }
                    }
                }
            }


            Row{
                z: 6
                Row {
                    spacing:15
                    HLK_Text {
                        textWidth: 170
                        textContent: "<font color='red'>*</font>居住处所:"
                    }
//                    HLK_ComboBox {
//                        id: resideAddress
//                        model: resideAddressData
//                        boxWidth:330
//                        boxHeight : 50
//                        boxTopMargin : 12
//                        pagename: PAGENAME
//                    }
                    HLK_FuzzySearchComboBox {
                        id: resideAddress
                        wenbenWidth: 330
                        wenbenHeight:50
                        xialaHeight:300
                        wenbenPagename: PAGENAME
                        yuanshiList:resideAddressList
                    }

                }
                Row {
                    spacing:15
                    HLK_Text {
                        textWidth: 170
                        textContent: '来自地城乡分类:'
                    }
                    HLK_ComboBox {
                        id: fromCityType
                        model: fromCityTypeData
                        boxWidth:330
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                        initHeight: 380
                    }
                }
            }
            Row{
                z: 5
                Row {
                    spacing:15
                    HLK_Text {
                        id:rentItZz
                        textWidth: 170
                        textContent: resideAddress.wenben.text == "租赁房屋" ? "<font color='red'>*</font>房屋承租情况:" : '房屋承租情况:'
                    }
                    HLK_ComboBox {
                        id: rentIt
                        model: rentItData
                        boxWidth:330
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                        initHeight: 180
                        isEnable: false
                    }
                }
                Row {
                    spacing:15
                    HLK_Text {
                        textWidth: 170
                        textContent: "<font color='red'>*</font>与房主关系:"
                    }
                    HLK_ComboBox {
                        id: relationWithOwner
                        model: relationWithOwnerData
                        boxWidth:330
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                    }
                }
            }
            Row{
                z: 4
                Row {
                    spacing:15
                    HLK_Text {
                        textWidth: 170
                        textContent: '房主证件种类:'
                    }
                    HLK_ComboBox {
                        id: houseOwnerCardType
                        model: houseOwnerCardTypeData
                        boxWidth:330
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                    }
                }
                Row {
                    spacing:15
                    HLK_Text {
                        textWidth: 170
                        textContent: '房主证件号码:'
                    }
                    HLK_TextEdit {
                        id: houseOwnerCardNumber
                        width: 330
                        textSize: defaultTextSize
                        pagename: PAGENAME
                    }
                }
            }
            Row{
                z: 3
                Row {
                    spacing:15
                    HLK_Text {
                        textWidth: 170
                        textContent: '房主姓名:'
                    }
                    HLK_TextEdit {
                        id: houseOwnerName
                        width: 330
                        textSize: defaultTextSize
                        pagename: PAGENAME
                    }
                }
                Row {
                    spacing:15
                    HLK_Text {
                        textWidth: 170
                        textContent: '房主联系电话:'
                    }
                    HLK_TextEdit {
                        id: houseOwnerPhoneNumber
                        width: 330
                        textSize: defaultTextSize
                        pagename: PAGENAME
                    }
                }
            }
            Row{
                Row {
                    spacing:15
                    HLK_Text {
                        textWidth: 170
                        //textContent: "<font color='red'>*</font>起租日期:"
                        textContent:resideAddress.wenben.text == "租赁房屋" ? "<font color='red'>*</font>起租日期:":"起租日期:"
                    }
                    HLK_TextEdit {
                        id: startRentDate
                        width: 330
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: false
                    }
                }
                Row {
                    spacing:15
                    HLK_Text {
                        textWidth: 170
                        //textContent: "<font color='red'>*</font>拟停租日期:"
                        textContent:resideAddress.wenben.text == "租赁房屋" ? "<font color='red'>*</font>拟停租日期:":"拟停租日期:"
                    }
                    HLK_TextEdit {
                        id: offHireDate
                        width: 330
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: false
                    }
                }
            }
            Row {
                z: 2
                spacing:15
                HLK_Text {
                    textWidth: 170
                    textContent: "房主居住地址:"
                }
                HLK_TextEdit {
                    id: houseOwnerLiveAddress
                    width: 845
                    textSize: defaultTextSize
                    pagename: PAGENAME
                }
//                HLK_ComboBox {
//                    id: houseOwnerLiveAddress
//                    //model:houseClassData
//                    boxWidth : 500
//                    boxHeight : 50
//                    boxTopMargin : 12
//                    pagename: PAGENAME
//                }
//                HLK_ComboBox {
//                    id: houseOwnerLiveUnit
//                    //model:houseClassData
//                    boxWidth : 330
//                    boxHeight : 50
//                    boxTopMargin : 12
//                    pagename: PAGENAME
//                }
            }
            Row{
                z: 1
                spacing:15
                HLK_Text {
                    textWidth: 170
                    textHeight:140
                    textContent: '备    注:'
                }
                HLK_MultilineTextEdit {
                    id: remarks
                    modehint: ""
                    maxLength:256
                    width: 843
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

        /////////////寄住人口///////////
        Column{
            width: parent.width
            height: parent.height
            y: 80
            x: 20
            spacing: 20
            visible: liveStay.checked
            Column{
                width: parent.width
                spacing: 0
                                 z:99
                Row {
                    z: 9
                    spacing:15
                    HLK_Text {
                        textWidth: 150
                        textContent: "<font color='red'>*</font>居住地:"
                    }
                    HLK_TextEdit{
                        id: tmpsleepAddress
                        //model:houseClassData
                        width : 520
                        height : 50
                        inputSize:defaultTextSize
                        pagename: PAGENAME
                    }

                    HLK_TextEdit{
                        id: tmpsleepuintName
                        //model:houseClassData
                        width : 330
                        height : 50
                        inputSize:defaultTextSize
                        pagename: PAGENAME
                    }

                }
                Row {
                    x:165
                    height:1
                    Row{
                        width:535
                        height:1
                        HLK_Border {
                            id: unitJzDataArea
                            radius: 10
                            width: 520
                            height: 240
    //                     x: 340
    //                     y:collectionUnit.y+100 //340
                            color: "white"
                            visible: false
                             ListView {
                                 id:unitJzDataView
                                 anchors.fill: parent
                                 anchors.topMargin: 5
                                 anchors.leftMargin: 5
                                 anchors.rightMargin: 5
                                 clip: true
                                 model: unitJzData.model
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
                                             console.log("----index:"+index)
                                             var user = unitJzData.model.get(index).mlpxz
                                             tmpsleepAddress.text = user
                                             unitJzDataArea.visible = false
                                             getFocus.focus = true
                                             //emit: changeUnitJz()
                                         }
                                     }
                                 }
                             }
                        }
                    }
                     HLK_Border {
                         id: dzxzJzDataArea
                         radius: 10
                         width: 330
                         height: 240
                         x: 500
        //                     y:collectionUnit.y+100 //340
                         color: "white"
                         visible: false
                         ListView {
                             id:dzxzJzDataView
                             anchors.fill: parent
                             anchors.topMargin: 5
                             anchors.leftMargin: 5
                             anchors.rightMargin: 5
                             clip: true
                             model: dzxzJzData.model
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
                                         var user = dzxzJzData.model.get(index).hm
                                         dzxzJzEndJson=dzxzJzData.model.get(index)
                                         tmpsleepuintName.text = user
                                         dzxzJzDataArea.visible = false
                                         getFocus.focus = true

                                     }
                                 }
                             }
                         }
                     }
                }
            }

            Row{
                z: 8
                spacing:40             
                Row{
                    spacing:15
                    HLK_Text {
                        textWidth: 150
                        textContent: "<font color='red'>*</font>寄住类别:"
                    }
                    HLK_ComboBox {
                        id: liveAwayTeyp
                        model: liveAwayTeypData
                        boxWidth:330
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                        initHeight: 180
                    }
                }

                Row{
                    spacing:15
                    HLK_Text {
                        textWidth: 150
                        textContent: "寄住原因:"
                    }
                    HLK_ComboBox {
                        id: liveAwayReason
                        model: liveAwayReasonData
                        boxWidth:330
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                        initHeight: 310
                    }
                }
            }
            Row{
                z: 7
                spacing:40
                Row{
                    spacing:15
                    HLK_Text {
                        textWidth: 150
                        textContent: "<font color='red'>*</font>寄住开始时间:"
                    }
                    HLK_TextEdit {
                        id: liveAwayTime
                        width: 330
                        textSize: defaultTextSize
                        pagename: PAGENAME
                    }
                }
                Row{
                    spacing:15
                    HLK_Text {
                        textWidth: 150
                        textContent: '预计离开时间:'
                    }
                    HLK_TextEdit {
                        id: leaveTime
                        width: 330
                        textSize: defaultTextSize
                        pagename: PAGENAME
                    }
                }
            }
            Row{
                z: 6
                spacing:15
                HLK_Text {
                    textWidth: 150
                    textContent: "<font color='red'>*</font>居住处所:"
                }
//                HLK_ComboBox {
//                    id: liveResideAddress
//                    model: liveResideAddressData
//                    boxWidth:330
//                    boxHeight : 50
//                    boxTopMargin : 12
//                    pagename: PAGENAME
//                }

                HLK_FuzzySearchComboBox {
                    id: liveResideAddress
                    wenbenWidth: 330
                    wenbenHeight:50
                    xialaHeight:300
                    wenbenPagename: PAGENAME
                    yuanshiList:liveResideAddressList
                }
            }
            Row{
                z: 5
                spacing:40
                Row{
                    spacing:15
                    HLK_Text {
                        id:rentItJz
                        textWidth: 150
                        textContent:liveResideAddress.wenben.text == "租赁房屋" ? "<font color='red'>*</font>房屋承租情况:" : "房屋承租情况:"
                        //"<font color='red'>*</font>房屋承租情况:"
                    }
                    HLK_ComboBox {
                        id: liveRentIt
                        model:liveRentItData
                        boxWidth:330
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                        initHeight: 180
                        isEnable: false
                    }
                }
                Row{
                    spacing:15
                    HLK_Text {
                        textWidth: 150
                        textContent: "<font color='red'>*</font>与房主关系:"
                    }
                    HLK_ComboBox {
                        id: liveRelationWithOwner
                        model: liveRelationWithOwnerData
                        boxWidth:330
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                    }
                }
            }
            Row{
                z: 4
                spacing:40
                Row {
                    spacing:15
                    HLK_Text {
                        textWidth: 150
                        textContent: '房主证件种类:'
                    }
                    HLK_ComboBox {
                        id: liveHouseOwnerCardType
                        model: liveHouseOwnerCardTypeData
                        boxWidth:330
                        boxHeight : 50
                        boxTopMargin : 12
                        pagename: PAGENAME
                    }
                }
                Row {
                    spacing:15
                    HLK_Text {
                        textWidth: 150
                        textContent: '房主证件号码:'
                    }
                    HLK_TextEdit {
                        id: liveHouseOwnerCardNumber
                        width: 330
                        textSize: defaultTextSize
                        pagename: PAGENAME
                    }
                }
            }
            Row{
                z: 3
                spacing:40
                Row {
                    spacing:15
                    HLK_Text {
                        textWidth: 150
                        textContent: '房主姓名:'
                    }
                    HLK_TextEdit {
                        id: liveHouseOwnerName
                        width: 330
                        textSize: defaultTextSize
                        pagename: PAGENAME
                    }
                }
                Row {
                    spacing:15
                    HLK_Text {
                        textWidth: 150
                        textContent: '房主联系电话:'
                    }
                    HLK_TextEdit {
                        id: liveHouseOwnerPhoneNumber
                        width: 330
                        textSize: defaultTextSize
                        pagename: PAGENAME
                    }
                }
            }
            Row{
                spacing:40
                Row {
                    spacing:15
                    HLK_Text {
                        textWidth: 150
                        textContent:liveResideAddress.wenben.text == "租赁房屋" ? "<font color='red'>*</font>起租日期:":"起租日期:"
                    }
                    HLK_TextEdit {
                        id: liveStartRentDate
                        width: 330
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: false
                    }
                }
                Row {
                    spacing:15
                    HLK_Text {
                        textWidth: 150
                        //textContent: "<font color='red'>*</font>拟停租日期:"
                        textContent:liveResideAddress.wenben.text == "租赁房屋" ? "<font color='red'>*</font>拟停租日期:":"拟停租日期:"
                    }
                    HLK_TextEdit {
                        id: liveOffHireDate
                        width: 330
                        textSize: defaultTextSize
                        pagename: PAGENAME
                        isEnable: false
                    }
                }
            }
            Row {
                z: 2
                spacing:15
                HLK_Text {
                    textWidth: 150
                    textContent: "房主居住地址:"
                }
                HLK_TextEdit {
                    id: liveHouseOwnerLiveAddress
                    width: 865
                    textSize: defaultTextSize
                    pagename: PAGENAME
                }
//                HLK_ComboBox {
//                    id: liveHouseOwnerLiveAddress
//                    //model:houseClassData
//                    boxWidth : 520
//                    boxHeight : 50
//                    boxTopMargin : 12
//                    pagename: PAGENAME
//                }
//                HLK_ComboBox {
//                    id: liveHouseOwnerLiveUnit
//                    //model:houseClassData
//                    boxWidth : 330
//                    boxHeight : 50
//                    boxTopMargin : 12
//                    pagename: PAGENAME
//                }
            }
            Row{
                z: 1
                spacing:15
                HLK_Text {
                    textWidth: 150
                    textHeight:140
                    textContent: '备    注:'
                }
                HLK_MultilineTextEdit {
                    id: liveRemarks
                    modehint: ""
                    maxLength:256
                    width: 865
                    height:140
                    textSize: defaultTextSize
                    pagename: PAGENAME
                    Text{
                        id:liveRemarksNumber
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
                        liveRemarksNumber.text=liveRemarks.text.length+"/"+256
                    }
                }
            }
        }
    }
    //////////////////暂住人口/////////////
    ListModel {
        id: fromAdministrativeData
    }
    ListModel {
        id: stayReasonData
    }
    ListModel {
        id: registeredAreaClassData
    }
    ListModel {
        id: moveReasonData
    }
    ListModel {
        id: fromCountryData
    }
    ListModel {
        id: areaRangeData
    }
    ListModel {
        id: resideAddressData
    }
    ListModel {
        id: fromCityTypeData
    }
    ListModel {
        id: rentItData
    }
    ListModel {
        id: relationWithOwnerData
    }
    ListModel {
        id: houseOwnerCardTypeData
    }

    //////////////////寄住人口/////////////
    ListModel {
        id: liveAwayTeypData
    }

    ListModel {
        id: liveAwayReasonData
    }

    ListModel {
        id: liveResideAddressData
    }

    ListModel {
        id: liveRentItData
    }

    ListModel {
        id: liveRelationWithOwnerData
    }

    ListModel {
        id: liveHouseOwnerCardTypeData
    }
    HLK_JsonListModel {
        id: unitData
    }
    HLK_JsonListModel {
        id: dzxzData
    }
    HLK_JsonListModel {
        id: unitJzData
    }
    HLK_JsonListModel {
        id: dzxzJzData
    }
    HLK_JsonListModel {
        id: fromLandData
    }
    HLK_MessageBox {
        id: messagebox
    }
}



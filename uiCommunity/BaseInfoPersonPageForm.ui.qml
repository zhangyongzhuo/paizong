import QtQuick 2.5
import QtMultimedia 5.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2


//实有人员基本信息块
Item {
    property alias messagebox: messagebox
    property alias telephone: telephone //联系电话
    property alias beforeName: beforeName //曾用名
    property alias birthCountry: birthCountry //出生国家
    property alias birthArea: birthArea //出生地
    property alias nativeCountry: nativeCountry //籍贯国家
    property alias nativePlace: nativePlace //籍贯
    property alias marriage: marriage //婚姻状况
    property alias education: education //学历
    property alias political: political //政治面貌
    property alias bloodType: bloodType //血型
    property alias religion: religion //宗教信仰
    property alias militaryService: militaryService //兵役状况
    property alias tradeClass: tradeClass //职业类别
    property alias occupational: occupational //职业
    property alias workUnit: workUnit //工作单位
    property alias nativePlaceDesc: nativePlaceDesc //户籍地址描述
    property alias birthCountryData: birthCountryData
    property alias birthAreaData: birthAreaData
    property alias nativeCountryData: nativeCountryData
    property alias nativePlaceData: nativePlaceData
    property alias educationData: educationData
    property alias marriageData:marriageData
    property alias politicalData:politicalData
    property alias religionData:religionData
    property alias tradeClassData:tradeClassData
    property alias bloodTypeData:bloodTypeData
    property alias militaryServiceData:militaryServiceData
    property int defaultTextSize: 20
    property alias getFocusComboBox: getFocusComboBox

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
    height: 650

    Rectangle {
        anchors.fill: parent
        color: '#FFFFFF'
        Column {

            width: 1170
            height: 650
            y: 20
            spacing: 20
            Row{
                z:9
                spacing:15
                HLK_Text {
                    textWidth: 132
                    textContent: "<font color='red'>*</font>联系电话:"
                }
                HLK_TextEdit {
                    id: telephone
                    width: 370
                    textSize: defaultTextSize
                    pagename: PAGENAME
                }
            }
            Row{
                spacing:15
                z:8
                HLK_Text {
                    textWidth: 132
                    textContent: '出生国家:'
                }
//               HLK_ComboBox {
//                   id: birthCountry
//                   model: birthCountryData
//                   boxWidth:370
//                   boxHeight : 50
//                   boxTopMargin : 12
//                   pagename: PAGENAME
//               }

                HLK_FuzzySearchComboBox {
                    id: birthCountry
                    //boxTopMargin : 12
                    wenbenWidth: 370
                    wenbenHeight:50
                    xialaHeight:300
                    //wenbenTextSize:20
                    wenbenPagename: PAGENAME
                    yuanshiList:birthCountryList
//                    onChooseItemChanged: {
//                        console.log("----guojia:"+chooseItem.text)
//                        console.log("----guojia:"+chooseItem.code)
//                    }
                }

                HLK_Text {
                    textWidth: 132
                    textContent: '出 生 地:'
                }
//                HLK_ComboBox {
//                    id: birthArea
//                    model: birthAreaData
//                    boxWidth:370
//                    boxHeight : 50
//                    boxTopMargin : 12
//                    //hint:"请输入搜索内容"
//                    hintSize:20
//                    pagename: PAGENAME
//                }

                HLK_FuzzySearchComboBox {
                    id: birthArea
                    //boxTopMargin : 12
                    wenbenWidth: 370
                    wenbenHeight:50
                    xialaHeight:240
                    //wenbenTextSize:20
                    wenbenPagename: PAGENAME
                    yuanshiList:birthAreaList
                }
            }
            Row{
                z:7
                spacing:15
                HLK_Text {
                    textWidth: 132
                    textContent: '籍贯国家:'
                }
//                HLK_ComboBox {
//                    id: nativeCountry
//                    model: nativeCountryData
//                    //initHeight:240
//                    boxWidth:370
//                    boxHeight : 50
//                    boxTopMargin : 12
//                    pagename: PAGENAME
//                }

                HLK_FuzzySearchComboBox {
                    id: nativeCountry
                    wenbenWidth: 370
                    wenbenHeight:50
                    xialaHeight:240
                    wenbenPagename: PAGENAME
                    yuanshiList:nativeCountryList
                }

                HLK_Text {
                    textWidth: 132
                    textContent: '籍    贯:'
                }
//                HLK_ComboBox {
//                    id: nativePlace
//                    model: nativePlaceData
//                    boxWidth:370
//                    boxHeight : 50
//                    boxTopMargin : 12
//                    //hint:"请输入搜索内容"
//                    hintSize:20
//                    pagename: PAGENAME
//                }
                HLK_FuzzySearchComboBox {
                    id: nativePlace
                    wenbenWidth: 370
                    wenbenHeight:50
                    xialaHeight:240
                    wenbenPagename: PAGENAME
                    yuanshiList:nativePlaceList
                }
            }
            Row{
                z:6
                spacing:15
                HLK_Text {
                    textWidth: 132
                    textContent: '曾 用 名:'
                }
                HLK_TextEdit {
                    id: beforeName
                    width: 370
                    textSize: defaultTextSize
                    pagename: PAGENAME
                }
                HLK_Text {
                    textWidth: 132
                    textContent: '学    历:'
                }
//                HLK_ComboBox {
//                    id: education
//                    model: educationData
//                    //initHeight:240
//                    boxWidth:370
//                    boxHeight : 50
//                    boxTopMargin : 12
//                    pagename: PAGENAME
//                }
                HLK_FuzzySearchComboBox {
                    id: education
                    wenbenWidth: 370
                    wenbenHeight:50
                    xialaHeight:240
                    wenbenPagename: PAGENAME
                    yuanshiList:educationList
                }
            }
            Row{
                z:5
                spacing:15
                HLK_Text {
                    textWidth: 132
                    textContent: '婚姻状况:'
                }
                HLK_ComboBox {
                    id: marriage
                    model: marriageData
                    initHeight:280
                    boxWidth:370
                    boxHeight : 50
                    boxTopMargin : 12
                    pagename: PAGENAME
                }
                HLK_Text {
                    textWidth: 132
                    textContent: '政治面貌:'
                }
//                HLK_ComboBox {
//                    id: political
//                    model: politicalData
//                    boxWidth:370
//                    boxHeight : 50
//                    boxTopMargin : 12
//                    pagename: PAGENAME
//                }

                HLK_FuzzySearchComboBox {
                    id: political
                    wenbenWidth: 370
                    wenbenHeight:50
                    xialaHeight:300
                    wenbenPagename: PAGENAME
                    yuanshiList:politicalList
                }
            }
            Row{
                z:4
                spacing:15
                HLK_Text {
                    textWidth: 132
                    textContent: '宗教信仰:'
                }
                HLK_ComboBox {
                    id: religion
                    model: religionData
                    initHeight: 320
                    boxWidth:370
                    boxHeight : 50
                    boxTopMargin : 12
                    pagename: PAGENAME
                }
                HLK_Text {
                    textWidth: 132
                    textContent: '兵役状况:'
                }
                HLK_ComboBox {
                    id: militaryService
                    model: militaryServiceData
                    initHeight:210
                    boxWidth:370
                    boxHeight : 50
                    boxTopMargin : 12
                    pagename: PAGENAME
                }
            }
            Row{
                spacing:15
                z:3
                HLK_Text {
                    textWidth: 132
                    textContent: '血    型:'
                }
                HLK_ComboBox {
                    id: bloodType
                    model: bloodTypeData
                    initHeight:210
                    boxWidth:370
                    boxHeight : 50
                    boxTopMargin : 12
                    pagename: PAGENAME
                }
                HLK_Text {
                    textWidth: 132
                    textContent: '职业类别:'
                }
//                HLK_ComboBox {
//                    id: tradeClass
//                    model: tradeClassData
//                    //initHeight:260
//                    boxWidth:370
//                    boxHeight : 50
//                    boxTopMargin : 12
//                    pagename: PAGENAME
//                }

                HLK_FuzzySearchComboBox {
                    id: tradeClass
                    wenbenWidth: 370
                    wenbenHeight:50
                    xialaHeight:300
                    wenbenPagename: PAGENAME
                    yuanshiList:tradeClassList
                }
            }
            Row {
                spacing:15
                z:1
                HLK_Text {
                    textWidth: 132
                    textContent: '职    业:'
                }
                HLK_TextEdit {
                    id: occupational
                    width: 370
                    textSize: defaultTextSize
                    pagename: PAGENAME
                }
                HLK_Text {
                    textWidth: 132
                    textContent: '工作单位:'
                }
                HLK_TextEdit {
                    id: workUnit
                    width: 370
                    textSize: defaultTextSize
                    pagename: PAGENAME
                }
            }
            Row{
                spacing:15
                z:1
                HLK_Text {
                    textWidth: 170
                    textContent: "<font color='red'>*</font>户籍地址描述:"
                }
                HLK_TextEdit {
                    id: nativePlaceDesc
                    width: 864
                    textSize: defaultTextSize
                    isEnable: false
                    pagename: PAGENAME
                }
            }
        }
    }

    ListModel {
        id: birthCountryData
    }
    ListModel {
        id: birthAreaData
    }
    ListModel {
        id: nativeCountryData
    }
    ListModel {
        id: nativePlaceData
    }
    ListModel {
        id: marriageData
    }
    ListModel {
        id: educationData
    }
    ListModel {
        id: bloodTypeData
    }
    ListModel {
        id: militaryServiceData
    }
    ListModel {
        id: tradeClassData
    }
    ListModel {
        id: politicalData
    }
    ListModel {
        id: religionData
    }

    HLK_MessageBox {
        id: messagebox
    }
}


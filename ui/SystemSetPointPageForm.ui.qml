import QtQuick 2.4
import "qrc:/controls/ui"
import QtQuick.Controls 1.2
import QtMultimedia 5.4

HLK_BasePage {
    property alias pointName: pointName
    property alias jingdu: jingdu
    property alias weidu: weidu
    property alias bayonetData: bayonetData              //卡口下 拉框数据
    property alias bayonetDataArea:bayonetDataArea       //卡口下拉框区域
    property alias jurisdictionUnit:jurisdictionUnit
    //property alias jurisdictionUnitData:jurisdictionUnitData
    property alias pointType:pointType
    //property alias pointTypeData:pointTypeData
    property alias messagebox: messagebox
    property bool isclicked: true
    property alias bayonetTypeData:bayonetTypeData //卡口下拉框数据
    property alias pointNameBox:pointNameBox

    pageTitle: "卡点信息"
    MouseArea {
        x:0
        y:100
        width: 1280
        height: 768-100
        onClicked: {
            if (bayonetDataArea.visible == true)
                bayonetDataArea.visible = false
            getFocus.focus = true
        }
    }
    MouseArea {
        x:100
        y:0
        width: 1280-100-100
        height: 80
        onClicked: {
            if (bayonetDataArea.visible == true)
                bayonetDataArea.visible = false
            getFocus.focus = true
        }
    }
    Rectangle {
        color: "#FFFFFF"
        x: 20
        y: 100
        width: 1240
        height: 200
        Flow {
            width: 1200
            height: 150
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 20
            Row {
                z: 99
                HLK_NormalText {
                    y: pointName.y + 13
                    width: 100
                    text: "卡点名称:"
                }

                HLK_ComboBox {
                    id: pointNameBox
                    width: 1100
                    model: bayonetTypeData
                    currentIndex: -1
                    visible: online

                }

                HLK_TextEdit {
                    id: pointName
                    width: 1100
                    visible: !online
                }
            }
            Row {
                HLK_NormalText {
                  //  y: jurisdictionUnit.y + 13
                    width: 100
                    text: "管辖单位:"
                }

                HLK_NormalText {
                    id:jurisdictionUnit
                    width: 600
                    text: locationUnit
                }

               /* HLK_ComboBox {
                    id: jurisdictionUnit
                    width: 1100
                }
                ListModel{
                    id: jurisdictionUnitData
                    ListElement{
                        text: ""
                        //code:""
                    }
                }*/
                HLK_NormalText {
                  //  y: pointType.y + 13
                    width: 100
                    text: "卡点类型:"
                }
                HLK_NormalText {
                    id:pointType
                    width: 500
                    text: locationLevel
                }
                /*HLK_ComboBox {
                    id: pointType
                    width: 1100
                }
                ListModel {
                    id: pointTypeData
                    ListElement{
                        text: ""
                       // code:""
                    }
                }*/
            }
            Row {
                visible: isShowLongitudeAndLatitude
                HLK_NormalText {
                    //y: jingdu.y + 13
                    width: 100
                    text: "经    度:"
                }
                HLK_NormalText {
                    id:jingdu
                    width: 600
                    text: ""
                }
                HLK_NormalText {
                   // y: weidu.y + 13
                    width: 100
                    text: "纬    度:"
                }
                HLK_NormalText {
                    id: weidu
                    width: 100
                    text: ""
                }
            }
        }
    }

    ListModel {
        id: bayonetTypeData
        ListElement {
            text: ""
            code: ""
            level:""
            unit:""
        }
    }

        HLK_JsonListModel {
            id: bayonetData
        }
        HLK_Border{
            id: bayonetDataArea
            radius: 10
            width: 1100
            height: 240
            x: 140
            y: 175
            color:"white"
            visible: false
            ListView {
                anchors.fill: parent
                anchors.topMargin: 5
                anchors.leftMargin: 5
                clip:true
                model: bayonetData.model
                delegate: Text {
                    font.pixelSize: 28
                    font.family: "黑体"
                    color: "#000000"
                    text : model.kd_name
                    width:parent.width
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            isclicked=false
                            var obj = bayonetData.model.get(index)//需要改
                            pointName.text = obj.kd_name
                            console.log( JSON.stringify(obj))
                            console.log( obj.kd_unit)
                            jurisdictionUnit.text = obj.kd_unit
                            pointType.text = obj.kd_level
                            bayonetDataArea.visible = false
                            getFocus.focus = true
                            isclicked=true
                        }
                    }
                }
            }
        }
        HLK_MessageBox {
            id: messagebox
        }
}

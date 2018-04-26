import QtQuick 2.4
import QtMultimedia 5.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4


//车辆采集页
Rectangle {

   // property alias personType: personType //实有人口业务类型
   // property alias cardType: cardType //证件种类

    //property alias idType:idType
    property alias cardNo: cardNo //证件号码
    property alias name: name //姓名
    property alias sex: sex //性别
    property alias nation: nation //民族
    property alias birth: birth //出生
    property alias address: address //住址
    property alias onLineCheckBtn: onLineCheckBtn //在线核查
    property alias idcardCollection: idcardCollection //二代证采集
    property alias idcardImg: idcardImg //图片
    property alias flagModel: flagModel //查回来的标签
    property alias view: view //查回来的标签
    property alias messagebox: messagebox
    property int defaultImgWidth: 110
    property alias page: page
    property alias btnArea: btnArea
    property bool cadeEnabled:true //修改状况下除了在线核查按钮外其他不可用
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

    width: 1170
    height: 360
    color: "#FFFFFF"
    id: page

    ExclusiveGroup {
        id: eg
    }

    Row{
        width: 1170
        height: 80
        x:190
        y:20
        z:4
        spacing:50
//        HLK_Text {
//            textWidth: 190
//            textContent: "实有人口业务类型:"
//        }
//        HLK_ComboBox {
//            id: personType
//            model: personTypeData
//            boxWidth:330
//            boxHeight : 50
//            boxTopMargin : 12
//        }
//        ListModel {
//            id: personTypeData
//            ListElement {
//                text: "寄住人口"
//                code: "1"
//            }
//            ListElement {
//                text: "暂住人口"
//                code: "2"
//            }
//        }
//        Row{
//            width: 405
//            spacing:15
//            HLK_Text {
//                textWidth: 90
//                textContent: "证件种类:"
//            }
//            HLK_ComboBox {
//                id: idType
//                model: idTypeData
//                boxWidth:300
//                boxHeight : 50
//                boxTopMargin : 12
//                pagename: PAGENAME
//            }
//            ListModel {
//                id: idTypeData
//            }
//        }
        Row {
            width: 820
            spacing: 15
            HLK_Text {
                text: "<font color='red'>*</font>证件号码:"
                width: 90
            }
            HLK_TextEdit {
                id: cardNo
                width: 755
                textSize: defaultTextSize
                pagename: PAGENAME
            }
        }
    }


    Rectangle {
        //id: idcardImg
        anchors.left: parent.left
        anchors.leftMargin: 20
        y:60
        width: 143
        height: 183
        radius: 10
        color: "#e7e7e7"
        Image {
            id: idcardImg
            anchors.fill: parent
            anchors.centerIn: parent
            cache: false
            source: "qrc:/images/images/none_people.png"
//            onSourceSizeChanged: {
//                if (width > defaultImgWidth) {
//                    width = parent.width
//                    height = parent.height
//                }
//            }
        }
    }

    Flow {
        //身份证信息
        x: 200
        y: 90
        width: 920
        spacing: 20
        enabled: cadeEnabled

        Row {
            width: 405
            spacing: 15
            HLK_Text {
                text: "<font color='red'>*</font>姓名:"
                width: 80
            }
            HLK_TextEdit {
                id: name
                width: 300
                textSize: defaultTextSize
                pagename: PAGENAME
            }
        }

        Row {
            width: 425
            spacing: 15
            z: 1
            HLK_Text {
                text:"<font color='red'>*</font>性别:"
                width: 110
            }
            HLK_ComboBox {
                id: sex
                model: sexData
                boxWidth:300
                boxHeight : 50
                boxTopMargin : 12
                initHeight:210
                pagename: PAGENAME
            }
            ListModel {
                id: sexData
            }
        }

        Row {

            width: 395
            spacing: 15
            z: 2
            HLK_Text {
                text: "民族:"
                width: 80
            }
            HLK_ComboBox {
                id: nation
                model: nationData
                boxWidth:300
                boxHeight : 50
                boxTopMargin : 12
                pagename: PAGENAME
            }
            ListModel {
                id: nationData
            }
        }

        Row {
            width: 425
            spacing: 15
            HLK_Text {
                text:"<font color='red'>*</font>出生日期:"
                width: 120
            }
            HLK_TextEdit {
                id: birth
                width: 300
                //hintSize:defaultTextSize
                //hint: '日期:1979-01-01'
                textSize: defaultTextSize
                pagename: PAGENAME
            }
        }

        Row {
            width: 800
            spacing: 15
            HLK_Text {
                text: "<font color='red'>*</font>住址:"
                width: 80
            }
            HLK_TextEdit {
                id: address
                width: 755
                textSize: defaultTextSize
                pagename: PAGENAME
            }
        }

        Row {
            width: 900

            ListView {
                id: view
                width: 707
                height: 100 //flagModel.count>5 ? 200 : 100
                clip: true
                orientation: ListView.Horizontal
                spacing: 10
                model: ListModel {
                    id: flagModel
                    ListElement {
                        FLAGNAME: ""
                        FLAGCOLOR: ""
                    }
                }
                delegate: HLK_Label {
                    label_text: FLAGNAME
                    label_color: FLAGCOLOR
                }
            }
            HLK_Button {
                id: onLineCheckBtn
                button_text: "在线核查"
                width: 143
                visible: false
            }
        }
    }


    Rectangle {
        Column {
            x: 20
            y: 300
            id: btnArea
            spacing: 15
            enabled: cadeEnabled
//            HLK_Button {
//                id: idcardCollection
//                button_text: "二代证采集"
//                width: 143
//            }
            HLK_Button {
                id: idcardCollection
                button_text: "二代证采集"
                width: 143
//                MouseArea {
//                    anchors.fill: parent
//                }
            }
        }
    }
    HLK_MessageBox {
        id: messagebox
    }
}



//        ListView {
//            id: view
//            width: 750
//            height: 100
//            clip: true
//            orientation: ListView.Horizontal
//            spacing: 10

//            model: ListModel {
//                id: flagModel
//                ListElement {
//                    FLAGNAME: ""
//                    FLAGCOLOR: ""
//                }
//            }
//            delegate: HLK_Label {
//                label_text: FLAGNAME
//                label_color: FLAGCOLOR
//                width: 150
//            }
//        }
//    }


//    HLK_MessageBox {
//        id: messagebox
//    }
//}


import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

Item{
    //property alias newAddrType:newAddrType
    property alias newAddrName:newAddrName
    property alias addBtn:addBtn

    property bool typeChecked:false  //是否选择默认地址

    width: parent.width

    Row{
        spacing: 10
        width: parent.width

        HLK_TabHeadText{
            anchors.verticalCenter: parent.verticalCenter
            fontWidth:150
            fontText: "添加地址"
            fontColor: "red"
        }

//        HLK_TabHeadText{
//            anchors.verticalCenter: parent.verticalCenter
//            fontWidth:100
//            fontText: "地址类型:"
//        }
//        HLK_ComboBox{
//            anchors.verticalCenter: parent.verticalCenter
//            id: newAddrType
//            width: 120
//            listPosition:1 //向上增长显示
//            //model: listModel
//            currentIndex: typeChecked ? 0 : -1
//        }
        HLK_TabHeadText{
            anchors.verticalCenter: parent.verticalCenter
            fontWidth:60
            fontText: "名称:"
        }
        HLK_TextEdit{
            anchors.verticalCenter: parent.verticalCenter
            id:newAddrName
            width: 540
        }
        HLK_Button{
            anchors.verticalCenter: parent.verticalCenter
            button_text:"添加"
            id:addBtn
        }
    }
}

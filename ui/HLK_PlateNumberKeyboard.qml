import QtQuick 2.4

Item{
    width: 500
    height: 400
    property alias keyboard: keyboard
    property alias close: close

    property bool  isShowTextFirst: true

    Rectangle{
        id: keyboard
        color: "#99000000"
        width: 950
        height: 450
        x: 1280-digiKeyPage.width-300
        y: 800- digiKeyPage.height-100

        onVisibleChanged: {
            if(visible){
                emit: digiPressChanged("")
            }
        }

        Rectangle{
            width: 950
            height: 50
            color: "white"
            HLK_SimpleImageButton{
                id: close
                anchors.right: parent.right
                normal_path: "qrc:/images/images/close.png"
                checked_path: "qrc:/images/images/close_x.png"
                width: 50
                height: 50
                onClicked: {
                    keyboard.visible = false
                    palteNumberClose()
                }
            }
        }
        Flow{//数字页
            id: digiKeyPage
            width:950
            height:400
            spacing:5
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            //////////////////////////////////////////////////////////第一行
            HLK_PlateNumberKey{
                keyText: "A"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "B"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "C"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "D"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "E"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "F"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "G"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "1"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "2"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "3"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            //////////////////////////////////////////////////////////第二行
            HLK_PlateNumberKey{
                keyText: "H"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "I"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "J"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "K"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "L"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "M"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "N"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "4"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "5"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "6"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            //////////////////////////////////////////////////////////第三行
            HLK_PlateNumberKey{
                keyText: "O"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "P"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "Q"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "R"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "S"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "T"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "U"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "7"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "8"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "9"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            //////////////////////////////////////////////////////////第四行
            HLK_PlateNumberKey{
                keyText: "V"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "W"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "X"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "Y"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "Z"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
//            HLK_PlateNumberKey{
//                keyText: "<-"
//                keyEvent.onClicked: {  }
//            }
//            HLK_PlateNumberKey{
//                keyText: "->"
//                keyEvent.onClicked: {  }
//            }
            HLK_PlateNumberKey{
                keyText: "删除"
                keyEvent.onClicked: { plateNumberTextDel() }
            }           
            HLK_PlateNumberKey{
                keyText: "0"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "搜索"
                keyEvent.onClicked: { keyboard.visible = false; plateNumberSearch() }
            }
            HLK_PlateNumberKey{
               // keyText: "C/N"
                keyName.text: "中/<font color='red'>英</font>"
                keyEvent.onClicked: {digiKeyPage.visible=false; wordKeyPage.visible=true}
            }
        }

        Flow{//文字页
            id: wordKeyPage
            width:950
            height:400
            spacing:5
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            visible:isShowTextFirst

            //////////////////////////////////////////////////////////第一行
            HLK_PlateNumberKey{
                keyText: "川"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "鄂"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "甘"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "赣"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "贵"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "桂"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "黑"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "沪"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "吉"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "冀"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            //////////////////////////////////////////////////////////第二行
            HLK_PlateNumberKey{
                keyText: "津"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "晋"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "京"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "辽"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "鲁"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "蒙"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "闽"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "宁"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "青"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "琼"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            //////////////////////////////////////////////////////////第三行
            HLK_PlateNumberKey{
                keyText: "陕"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "苏"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "皖"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "湘"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "新"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "渝"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "豫"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "粤"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "云"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "藏"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            //////////////////////////////////////////////////////////第四行
            HLK_PlateNumberKey{
                keyText: "浙"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "港"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "澳"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "警"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "学"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "挂"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "使"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "领"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                keyText: "试"
                keyEvent.onClicked: { plateNumberTextChange(keyText) }
            }
            HLK_PlateNumberKey{
                //keyText: "C/N"
                keyName.text: "<font color='red'>中</font>/英"
                keyEvent.onClicked: {digiKeyPage.visible=true; wordKeyPage.visible=false}
            }
        }
    }

}

import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL
import "qrc:/base/js/theme.js" as Theme

Item{

    property int boxWidth  : 300
    property int boxHeight : 50
    property int boxRadius : 10
    property int boxTopMargin : 10
    property alias  currentText  : displayItem.text
    property alias  currentIndex : listView.currentIndex
    property alias  model        : listView.model
    property alias  items        : listView
    property string itemContent  : ""
    property string themeColor   : JSL.themeColor()
    property string defaultColor : Theme.borderColor()
    property int textSize: 20
    property alias hint: hint.text
    property int hintSize: 24

    //0：model.text  取默认键值text
    //1: modelData   单字符串列表
    //2: itemContent 外部自定义
    property int itemsType : 0

    property int listPosition : 0  //列表框位置0在文本框下方 1在文本框上方
    property int initHeight: 0  //使用默认高度
    property string pagename:""

    property bool isEnable:true

    id:main

    enabled: isEnable

    width: boxWidth
    height: boxHeight

    onFocusChanged: {
        if(!focus){
            combo_list.visible = false
            combo_text.layer.enabled = false
            combo_text.border.color = defaultColor
            z = 0
        }
    }

    Rectangle{
        id: combo_text
        width: boxWidth
        height: boxHeight
        radius: boxRadius
        border.width: 1
        border.color: defaultColor
        color: isEnable ? "#FFFFFF" : "#F2F2F4"

        layer.enabled: false
        layer.effect: DropShadow {
            transparentBorder: true
            color: themeColor
            radius:  boxRadius
            samples: 16
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(!combo_list.visible){
                    combo_list.visible = true
                    main.z = 100
                    main.focus = true
                    parent.layer.enabled = true
                    parent.border.color = themeColor
                    combo_list.bHightLight = true
                    emit:boxAreaOpend(pagename)
                }
                else{
                    combo_list.visible = false
                    main.z = 0
                    parent.layer.enabled = false
                    parent.border.color = defaultColor
                    combo_list.bHightLight = false
                }
            }
        }

        Rectangle{//向下箭头
            id: flag
            height: 15
            width: 15
            color: "#00FF00FF"
            border.color: defaultColor
            border.width: 1
            anchors.top: parent.top
            anchors.topMargin: boxTopMargin
            //anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 18
            //anchors.leftMargin: 150
            rotation: 45

        }

        Rectangle{
            id: mask
            height: 20
            width: 30
            //color: "white"
            color: isEnable ? "#FFFFFF" : "#F2F2F4"
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.top: parent.top
            anchors.topMargin: 1
            //visible: false
        }

        Text{
            width: combo_text.width-5
            id: displayItem
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 5
            clip: true
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: textSize//20
            font.family: "SimHei"
        }
        Text {
            id: hint
            anchors { fill: parent; leftMargin: 14 }
            verticalAlignment: Text.AlignVCenter
            text: ""
            font.pixelSize: hintSize
            font.family: "SimHei"
            color: "#707070"
            //opacity: inputText.length ? 0 : 1
        }
    }

    HLK_Border{
        id: combo_list
        height: {
            if(initHeight == 0){
                if(50*listView.count>=360){
                    return 200
                }
                else{
                    return 50*listView.count
                }
            }
            else{
                initHeight
            }

        }
        width: combo_text.width
        x: combo_text.x
        y: listPosition == 0 ? combo_text.y+combo_text.height : combo_text.y-combo_list.height
        //y: combo_text.y+combo_text.height-2
        //y:combo_text.y-combo_list.height
        visible: false
        bd_color: defaultColor
        bg_color: "white"
        bd_width: 1

        ListView{
            id: listView
            spacing: 15
            clip: true
            anchors.fill: parent
            anchors.margins: 5

            delegate: Text{
                id: item_text
                text: {
                    switch(itemsType){
                    case 0: return model.text //ListModel, 第一个字段默认text
                    case 1: return modelData
                    case 2: return eval(itemContent)
                    }
                }
                width: listView.width
                font.pixelSize: textSize//20
                font.family: "SimHei"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        listView.currentIndex = index
                        displayItem.text = item_text.text
                        combo_list.visible = false
                        main.z = 0
                        currentIndexChanged(index)

                        combo_text.layer.enabled = false
                        combo_text.border.color = defaultColor
                        combo_list.bHightLight = false
                    }
                }
            }

            onModelChanged: {
                if(listView.currentItem != null){
                    displayItem.text = listView.currentItem.text
                }
            }
        }
    }

    Component.onCompleted: {
        if(listView.currentItem != null){
            displayItem.text = listView.currentItem.text
        }
    }
}

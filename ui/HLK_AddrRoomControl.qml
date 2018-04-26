import QtQuick 2.4
import QtGraphicalEffects 1.0
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

//地址控件
HLK_Border{

    //小区的选择以所在区为单位，只有传入的区编码不为空的情况下才进行小区查询
    property string areaCode:""

    property alias addrText: addrText //拼接好的地址字符串
    property alias addrFinishBtn: addrFinishBtn //关闭按钮
    property string cummunityText:""   //小区
    property string cummunityCode:""
    property string buildingText:""    //栋
    property string buildingCode:""
    property string unitText:""        //单元
    property string unitCode:""
    property string roomText:""        //室
    property string roomCode:""

    property int cummunity:0   //当做枚举使用 小区Tab编号
    property int building:1
    property int unit:2
    property int room:3

    property int itemWidth:900/4
    property int itemHeight:60

    property string msgAddrTypeStr:"请选择地址类型"
    property string msgAddrNameStr:"请填写地址名称"

    width: 900
    height: 400
    color:"white"

    ExclusiveGroup { id: cummunityExclusive }
    HLK_JsonListModel {
        id: cummunityData
        //json: readDb.readAddress("cummunity", areaCode)
        //source:"http://"+goIpPort+"/searchAddr/:"+areaCode+"/:5"
        source:"http://"+goIpPort+"/searchAddr/:"+"110101"+"/:5"

    }

    ExclusiveGroup { id: buildingExclusive }
    HLK_JsonListModel {
        id: buildingData
        //json: readDb.readAddress("building", cummunityCode)
        source:"http://"+goIpPort+"/searchAddr/:"+cummunityCode+"/:6"
    }

    ExclusiveGroup { id: unitExclusive }
    HLK_JsonListModel {
        id: unitData
        //json: readDb.readAddress("unit", buildingCode)
        source:"http://"+goIpPort+"/searchAddr/:"+buildingCode+"/:7"
    }

    ExclusiveGroup { id: roomExclusive }
    HLK_JsonListModel {
        id: roomData
       // json: readDb.readAddress("room", unitCode)
        source:"http://"+goIpPort+"/searchAddr/:"+unitCode+"/:8"
    }

    function changeCurrentTabPage(index){
        switch(index){
        case cummunity:
            buildingText = ""
            buildingCode = ""
        case building:
            unitText = ""
            unitCode = ""
        case unit:
            roomText = ""
            roomCode = ""
        }

        bodyView.currentIndex = index
    }

    Column{
        width: parent.width
        height: parent.height
        spacing: 5

        Row{
            spacing: 10
            width:parent.width
            HLK_TabHeadText{
                anchors.verticalCenter: parent.verticalCenter
                fontWidth:150
                fontText: "已选择地址:"
            }
            HLK_TextEdit{
                anchors.verticalCenter: parent.verticalCenter
                id: addrText
                width: 610
                text:cummunityText+buildingText+unitText+roomText
            }
            HLK_Button{
                anchors.verticalCenter: parent.verticalCenter
                button_text:"完成"
                id:addrFinishBtn
            }
        }

        HLK_TextEdit{
            width: parent.width
            height:2
        }

        Row{//页头   小区 栋 单元 室 高60
            id:header
            width: parent.width
            height: 60
            ExclusiveGroup { id: exclusive }

            HLK_TabHeadButton{
                id: cummunityBtn
                exclusiveGroup: exclusive
                buttonWidth:itemWidth
                checked: true
                text:"小区"
                onCheckedChanged: { //切页
                    if(checked){
                        changeCurrentTabPage(cummunity)
                    }
                }
            }

            HLK_TabHeadButton{
                id: buildingBtn
                exclusiveGroup: exclusive
                buttonWidth:itemWidth
                text:"栋"
                onCheckedChanged: { //切页
                    if(checked){
                        changeCurrentTabPage(building)
                    }
                }
            }

            HLK_TabHeadButton{
                id: unitBtn
                exclusiveGroup: exclusive
                buttonWidth:itemWidth
                text:"单元"
                onCheckedChanged: { //切页
                    if(checked){
                        changeCurrentTabPage(unit)
                    }
                }
            }

            HLK_TabHeadButton{
                id: roomBtn
                exclusiveGroup: exclusive
                buttonWidth:itemWidth
                text: "室"
                onCheckedChanged: { //切页
                    if(checked){
                        changeCurrentTabPage(room)
                    }
                }
            }
        }

        TabView{// 分页显示具体信息
            id: bodyView
            width: parent.width
            height: parent.height - 140
            tabsVisible : false
            frameVisible : false

            Tab{//小区
                anchors.fill: parent
                Column{
                    width: parent.width
                    height: parent.height
                    spacing: 10

                    GridView{
                        id:cummunityView
                        model: cummunityData.model
                        width: parent.width
                        height: parent.height - 100
                        cellWidth: itemWidth
                        cellHeight:itemHeight
                        clip: true
                        delegate:HLK_TabHeadButton{
                            exclusiveGroup:cummunityExclusive
                            normalColor:"#FFFFFF"
                            checkedColor: "#9D9D9D"
                            text: model.text
                            onCheckedChanged: {
                                if(checked){
                                    cummunityCode = cummunityView.model.get(index).code
                                    cummunityText = cummunityView.model.get(index).text
                                    buildingBtn.checked = true
                                    changeCurrentTabPage(building)
                                }
                            }
                        }
                    }

                    HLK_TextEdit{
                        width: parent.width
                        height:2
                    }

                    HLK_TabAddAddress{
                        id:newCummunity
                        width: parent.width
                        y:parent.y+cummunityView.height+22

                        newAddrType.model: ListModel{
                            ListElement{text: "小区"; code: "1"}
                            ListElement{text: "大厦"; code: "2"}
                            ListElement{text: "园区"; code: "3"}
                        }
                        addBtn.onClicked: {
                            //地址类型、地址名称都不可以为空
                            if(newCummunity.newAddrType.currentText == ""){
                                msgBox.text = msgAddrTypeStr
                                msgBox.visible = true
                            }
                            else if(newCummunity.newAddrName.text == ""){
                                msgBox.text = msgAddrNameStr
                                msgBox.visible = true
                            }
                            else{
                                //var str = readDb.writeAddress("street", unitCode, newStreet.newAddrName.text+newStreet.newAddrType.currentText)
                                var obj = JSON.parse(str)
                                if(obj.ret){
                                    //cummunityData.json = readDb.readAddress("unit", unitCode)
                                    newCummunity.newAddrType.currentIndex = -1
                                    newCummunity.newAddrType.currentText = ""
                                    newCummunity.newAddrName.text = ""
                                }
                                else{
                                    msgBox.text = obj.msg
                                    msgBox.visible = true
                                }
                           }
                        }
                        //获取焦点
                        newAddrName.onCursorVisibleChanged:{
                            //小键盘出现
                            newAddrName.cursorVisible ? digiBoard.visible=true : digiBoard.visible=false
                        }
                    }
                }
            }

            Tab{//栋
                anchors.fill: parent
                Column{
                    width: parent.width
                    height: parent.height
                    spacing: 10

                    GridView{
                        id:buildingView
                        model: buildingData.model
                        width: parent.width
                        height: parent.height - 100
                        cellWidth: itemWidth
                        cellHeight:itemHeight
                        clip: true
                        delegate:HLK_TabHeadButton{
                            exclusiveGroup:buildingExclusive
                            normalColor:"#FFFFFF"
                            checkedColor: "#9D9D9D"
                            text: model.text
                            onCheckedChanged: {
                                if(checked){
                                    buildingCode = buildingView.model.get(index).code
                                    buildingText = buildingView.model.get(index).text
                                    unitBtn.checked = true
                                    changeCurrentTabPage(unit)
                                }
                            }
                        }
                    }

                    HLK_TextEdit{
                        width: parent.width
                        height:2
                    }

                    HLK_TabAddAddress{
                        id:newBuilding
                        width: parent.width
                        y:parent.y+buildingView.height+22

                        newAddrType.model: ListModel{
                            ListElement{text: "栋"; code: "1"}
                            ListElement{text: "号楼"; code: "2"}
                        }
                        addBtn.onClicked: {
                            //地址类型、地址名称都不可以为空
                            if(newBuilding.newAddrType.currentText == ""){
                                msgBox.text = msgAddrTypeStr
                                msgBox.visible = true
                            }
                            else if(newBuilding.newAddrName.text == ""){
                                msgBox.text = msgAddrNameStr
                                msgBox.visible = true
                            }
                            else{
                                //var str = readDb.writeAddress("street", unitCode, newStreet.newAddrName.text+newStreet.newAddrType.currentText)
                                var obj = JSON.parse(str)
                                if(obj.ret){
                                    //cummunityData.json = readDb.readAddress("unit", unitCode)
                                    newBuilding.newAddrType.currentIndex = -1
                                    newBuilding.newAddrType.currentText = ""
                                    newBuilding.newAddrName.text = ""
                                }
                                else{
                                    msgBox.text = obj.msg
                                    msgBox.visible = true
                                }
                           }
                        }
                        //获取焦点
                        newAddrName.onCursorVisibleChanged:{
                            //小键盘出现
                            newAddrName.cursorVisible ? digiBoard.visible=true : digiBoard.visible=false
                        }
                    }
                }
            }


            Tab{//单元
                anchors.fill: parent
                Column{
                    width: parent.width
                    height: parent.height
                    spacing: 10

                    GridView{
                        id:unitView
                        model: unitData.model
                        width: parent.width
                        height: parent.height - 100
                        cellWidth: itemWidth
                        cellHeight:itemHeight
                        clip: true
                        delegate:HLK_TabHeadButton{
                            exclusiveGroup:unitExclusive
                            normalColor:"#FFFFFF"
                            checkedColor: "#9D9D9D"
                            text: model.text
                            onCheckedChanged: {
                                if(checked){
                                    unitCode = unitView.model.get(index).code
                                    unitText = unitView.model.get(index).text
                                    roomBtn.checked = true
                                    changeCurrentTabPage(room)
                                }
                            }
                        }
                    }

                    HLK_TextEdit{
                        width: parent.width
                        height:2
                    }

                    HLK_TabAddAddress{
                        id:newUnit
                        width: parent.width
                        y:parent.y+unitView.height+22

                        newAddrType.model: ListModel{
                            ListElement{text: "单元"; code: "1"}
                        }
                        typeChecked:true
                        addBtn.onClicked: {
                            //地址类型、地址名称都不可以为空
                            if(newUnit.newAddrType.currentText == ""){
                                msgBox.text = msgAddrTypeStr
                                msgBox.visible = true
                            }
                            else if(newUnit.newAddrName.text == ""){
                                msgBox.text = msgAddrNameStr
                                msgBox.visible = true
                            }
                            else{
                                //var str = readDb.writeAddress("street", unitCode, newStreet.newAddrName.text+newStreet.newAddrType.currentText)
                                var obj = JSON.parse(str)
                                if(obj.ret){
                                    //cummunityData.json = readDb.readAddress("unit", unitCode)
                                    newUnit.newAddrType.currentIndex = -1
                                    newUnit.newAddrType.currentText = ""
                                    newUnit.newAddrName.text = ""
                                }
                                else{
                                    msgBox.text = obj.msg
                                    msgBox.visible = true
                                }
                           }
                        }
                    }
                }
            }

            Tab{//室
                anchors.fill: parent
                Column{
                    width: parent.width
                    height: parent.height
                    spacing: 10

                    GridView{
                        id:roomView
                        model: roomData.model
                        width: parent.width
                        height: parent.height - 100
                        cellWidth: itemWidth
                        cellHeight:itemHeight
                        clip: true
                        delegate:HLK_TabHeadButton{
                            exclusiveGroup:roomExclusive
                            normalColor:"#FFFFFF"
                            checkedColor: "#9D9D9D"
                            text: model.text
                            onCheckedChanged: {
                                if(checked){
                                    roomCode = streetView.model.get(index).code
                                    roomText = streetView.model.get(index).text
                                }
                            }
                        }
                    }

                    HLK_TextEdit{
                        width: parent.width
                        height:2
                    }

                    HLK_TabAddAddress{
                        id:newRoom
                        width: parent.width
                        y:parent.y+roomView.height+22

                        newAddrType.model: ListModel{
                            ListElement{text: "室"; code: "1"}
                        }
                        typeChecked:true
                        addBtn.onClicked: {
                            //地址类型、地址名称都不可以为空
                            if(newRoom.newAddrType.currentText == ""){
                                msgBox.text = msgAddrTypeStr
                                msgBox.visible = true
                            }
                            else if(newRoom.newAddrName.text == ""){
                                msgBox.text = msgAddrNameStr
                                msgBox.visible = true
                            }
                            else{
                                //var str = readDb.writeAddress("street", unitCode, newStreet.newAddrName.text+newStreet.newAddrType.currentText)
                                var obj = JSON.parse(str)
                                if(obj.ret){
                                    //roomData.json = readDb.readAddress("unit", unitCode)
                                    newRoom.newAddrType.currentIndex = -1
                                    newRoom.newAddrType.currentText = ""
                                    newRoom.newAddrName.text = ""
                                }
                                else{
                                    msgBox.text = obj.msg
                                    msgBox.visible = true
                                }
                           }
                        }
                    }
                }
            }
        }
    }

    HLK_MessageBox{
        id:msgBox
    }
}






















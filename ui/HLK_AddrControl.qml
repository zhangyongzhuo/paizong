import QtQuick 2.4
import QtGraphicalEffects 1.0
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL
import "qrc:/base/js/provinces.js" as PROVINCES
import "qrc:/base/js/cities.js" as CITIES
//import "qrc:/base/js/areas.js" as AREAS
//import "qrc:/base/js/streets.js" as STREETS
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import com.hylink.fmcp.ctrl 2.0

//地址控件
HLK_Border{
    property alias addrText: addrText //拼接好的地址字符串
    property alias addrFinishBtn: addrFinishBtn //关闭按钮
    property string provinceText:""   //省
    property string provinceCode:""
    property string cityText:""       //市
    property string cityCode:""
    property string areaText:""       //区
    property string areaCode:""
    property string streetText:""     //街
    property string streetCode:""
    property string otherText:""      //其他
    property string otherCode:""
    property string tempCityText:""       //直辖市特备行政区时为空

    property int province:0   //当做枚举使用 省Tab编号
    property int city:1
    property int area:2
    property int street:3
    property int other:4
    property int itemWidth:900/5
    property int itemHeight:60
    property string saveDetailsUuid:""
    property alias otherData:otherData
    //property alias newother: newother

    property string msgAddrNameStr:"请填写地址名称"

    width: 904
    height: 400
    color:'white'
    bd_color:'#9D9D9D'

    ExclusiveGroup { id: provinceExclusive }
    HLK_JsonListModel {
        id: provinceData
        json: JSON.stringify(PROVINCES.ynProvinces)
    }

    ExclusiveGroup { id: cityExclusive }
    HLK_JsonListModel {
        id: cityData
        json: JSON.stringify(CITIES.searchCities(provinceCode))
    }

    ExclusiveGroup { id: areaExclusive }
    HLK_JsonListModel {
        id: areaData
        //source:"http://"+goIpPort+"/searchAddr/"+cityCode+"/2" //{cityCode != "" ? "http://"+goIpPort+"/searchAddr/"+cityCode+"/2" : ""}
        source:{cityCode != "" ? "http://"+goIpPort+"/searchAddr/"+cityCode+"/2" : "http://"+goIpPort+"/searchAddr/"+""+"/2"}
    }

    ExclusiveGroup { id: streetExclusive }
    HLK_JsonListModel {
        id: streetData
        source:{ areaCode != "" ? "http://"+goIpPort+"/searchAddr/"+areaCode+"/3" :  "http://"+goIpPort+"/searchAddr/"+""+"/3"}
    }

    ExclusiveGroup { id: otherExclusive }
    //    HLK_JsonListModel {
    //        id: otherData
    //        source:{streetCode != "" ? "http://"+goIpPort+"/searchAddr/"+streetCode+"/4" : ""}
    //        appendOrInsert:'insert'
    //    }

    ListModel{//M
        id: otherData
        ListElement{
            strText:""
            strCode:""
            strchecked:false
        }
    }

    function updateModel() {
        var url ="http://"+goIpPort+"/searchAddr/"+streetCode+"/4"
        operatehttp.get(url, function(code, data){
            if(code == 200){
                if(data != "" && data != 'null'){
                    var obj=JSON.parse(data)
                    otherData.clear()
                    for(var i=obj.length-1; i>=0; i--){
                        if(i==obj.length-1){
                            otherText=obj[i].text
                            otherCode=obj[i].code
                            otherData.append({strText:obj[i].text,strchecked:true,strCode:obj[i].code})
                        }else{
                            otherData.append({strText:obj[i].text,strchecked:false,strCode:obj[i].code})
                        }
                    }
                }

            }else{
                console.log("获取本地街号列表失败")
            }
        })
    }

    function getModelData(){
        //console.log("-----进入获取本地街号列表")
        otherData.clear()
        var url ="http://"+goIpPort+"/searchAddr/"+streetCode+"/4"
        operatehttp.get(url, function(code, data){
            if(code == 200){
                if(data != "" && data != 'null'){
                    var obj=JSON.parse(data)
                    for(var i=obj.length-1; i>=0; i--){

                        otherData.append({strText:obj[i].text,strchecked:false,strCode:obj[i].code})
                    }
                }
            }else{
                console.log("获取本地街号列表失败")
            }
        })
    }
    function changeCurrentTabPage(index){
        switch(index){
        case province:
            cityText = ""
            cityCode = ""
            tempCityText = ""
        case city:
            areaText = ""
            areaCode = ""
        case area:
            streetText = ""
            streetCode = ""
        case street:            
            otherText = ""
            otherCode = ""
        }

        bodyView.currentIndex = index
    }
    function compareOtherData(addressNumberName){//比对其他地址信息 true 存在， false 不存在
        for(var i=0; i<otherData.count; i++){
            if(addressNumberName===otherData.get(i).strText)
                return true
        }
        return false
    }
    function deleteAddressNumber(addressNumberCode){//删除街道号
        var url="http://"+goIpPort+"/clearNumbers/" +addressNumberCode
        operatehttp.get(url, function(code, data){
            if(code == 200){
                if(addressNumberCode==otherCode)
                    otherCode = otherText = ''
                console.log("删除街道号成功")
            }else{
                console.log("删除街道号失败")
            }
        })
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
                text:provinceText+tempCityText+areaText+streetText+otherText
                textMode: TextInput.NoWrap
                onlyRead: true
            }
            HLK_Button{
                anchors.verticalCenter: parent.verticalCenter
                button_text:"完成"
                id:addrFinishBtn
            }
            //            HLK_Button{
            //                anchors.verticalCenter: parent.verticalCenter
            //                button_text:"关闭"
            //                onClicked: {

            //                }
            //            }
        }

        HLK_TextEdit{
            width: parent.width
            height:2
        }

        Row{//页头   省 市 区 街 号 高60
            id:header
            width: parent.width
            height: 60
            ExclusiveGroup { id: exclusive }

            HLK_TabHeadButton{
                id: provinceBtn
                exclusiveGroup: exclusive
                checked: true
                text:"省"
                buttonBorder:1
                onCheckedChanged: { //切页
                    if(checked){
                        changeCurrentTabPage(province)
                    }
                }
            }

            HLK_TabHeadButton{
                id: cityBtn
                exclusiveGroup: exclusive
                text:"市"
                buttonBorder:1
                onCheckedChanged: { //切页
                    if(checked){
                        changeCurrentTabPage(city)
                    }
                }
            }

            HLK_TabHeadButton{
                id: areaBtn
                exclusiveGroup: exclusive
                text:"区"
                buttonBorder:1
                onCheckedChanged: { //切页
                    if(checked){
                        changeCurrentTabPage(area)
                    }
                }
            }

            HLK_TabHeadButton{
                id: streetBtn
                exclusiveGroup: exclusive
                text: "街"
                buttonBorder:1
                onCheckedChanged: { //切页
                    if(checked){
                        changeCurrentTabPage(street)
                    }
                }
            }

            HLK_TabHeadButton{
                id: otherBtn
                exclusiveGroup: exclusive
                text: "详细信息"
                buttonBorder:1
                onCheckedChanged: { //切页
                    if(checked){
                        changeCurrentTabPage(other)
                        otherData.clear()
                        getModelData()
                    }
                }
            }
        }

        TabView{// 分页显示具体信息
            id: bodyView
            x:2
            width: parent.width
            height: parent.height - 140
            tabsVisible : false
            frameVisible : false

            Tab{//省信息显示
                //anchors.fill: parent
                GridView{
                    id:provinceView
                    model: provinceData.model
                    cellWidth: itemWidth
                    cellHeight:itemHeight
                    clip: true
                    delegate:HLK_TabHeadButton{
                        exclusiveGroup:provinceExclusive
                        normalColor:"#FFFFFF"
                        checkedColor: "#9D9D9D"
                        text: model.name
                        onClicked: {
                            if(checked){
                                provinceText = ''
                                provinceCode = provinceView.model.get(index).code
                                provinceText = provinceView.model.get(index).name
                                cityBtn.checked = true

                            }
                        }
                    }
                }
            }

            Tab{//市
                GridView{

                    id:cityView
                    model: cityData.model
                    cellWidth: itemWidth
                    cellHeight:itemHeight
                    clip: true
                    delegate:HLK_TabHeadButton{
                        exclusiveGroup:cityExclusive
                        normalColor:"#FFFFFF"
                        checkedColor: "#9D9D9D"
                        text: model.name
                        onClicked:  {
                            if(checked){
                                cityText = ''
                                cityCode = cityView.model.get(index).code
                                cityText = cityView.model.get(index).name
                                tempCityText = cityText
                                if(cityText == "市辖区" || cityText == "省直辖县级行政区划" || cityText == "自治区直辖县级行政区划"){
                                    cityText=provinceText
                                    tempCityText=""
                                }
                                //console.log("cityCode:"+cityCode)

                                areaBtn.checked = true
                            }
                        }
                    }
                }
            }

            Tab{//区
                GridView{
                    id:areaView
                    model: areaData.model
                    cellWidth: itemWidth
                    cellHeight:itemHeight
                    clip: true
                    delegate:HLK_TabHeadButton{
                        exclusiveGroup:areaExclusive
                        normalColor:"#FFFFFF"
                        checkedColor: "#9D9D9D"
                        text: model.text
                        onClicked: {
                            if(checked){
                                areaText = ''
                                areaCode = areaView.model.get(index).code
                                areaText = areaView.model.get(index).text
                                streetBtn.checked = true
                            }
                        }
                    }
                }
            }

            Tab{//街
                GridView{

                    id:streetView
                    model: streetData.model
                    cellWidth: itemWidth
                    cellHeight:itemHeight
                    clip: true
                    delegate:HLK_TabHeadButton{
                        exclusiveGroup:streetExclusive
                        normalColor:"#FFFFFF"
                        checkedColor: "#9D9D9D"
                        text: model.text
                        onClicked:  {
                            if(checked){
                                streetText = ''
                                streetCode = streetView.model.get(index).code
                                streetText = streetView.model.get(index).text
                                if(streetText == "暂不选择"){
                                    streetText=""
                                }
                                otherBtn.checked = true
                                //getModelData()
                                //                                otherData.source = ""
                                //                                otherData.source = streetCode != "" ? "http://"+goIpPort+"/searchAddr/"+streetCode+"/4" : ""
                            }
                        }
                    }
                }
            }

            Tab{//号
                anchors.fill: parent
                Component.onCompleted: {
                    otherData.clear()
                }

                Column{

                    width: parent.width
                    height: parent.height
                    spacing: 10

                    GridView{
                        id:otherView
                        model: otherData
                        width: parent.width
                        height: parent.height - 100
                        cellWidth: itemWidth
                        cellHeight:itemHeight
                        clip: true
                        delegate:HLK_TabHeadButton{
                            exclusiveGroup:otherExclusive
                            normalColor:"#FFFFFF"
                            checkedColor: "#9D9D9D"
                            text:otherView.model.get(index).strText
                            checked:otherView.model.get(index).strchecked
                            delEnable: true
                            onTextChanged: {
                                text = text//getStr(text)
                            }
                            onClicked:  {
                                if(checked){
                                    otherText = ''
                                    otherCode = otherView.model.get(index).strCode
                                    otherText = otherView.model.get(index).strText
                                }
                            }
                            onDeleteButtonClicked: {
                                deleteAddressNumber(otherView.model.get(index).strCode)
                                otherView.model.remove(index)
                            }
                        }
                    }

                    HLK_TextEdit{
                        width: parent.width
                        height:2
                    }

                    HLK_TabAddAddress{
                        id:newother
                        width: parent.width
                        y:parent.y+otherView.height+22

                        addBtn.onClicked: {
                            if(provinceCode!='' && cityCode!='' && areaCode!='' && streetCode!=''){
                                if(JSL.trimAll(newother.newAddrName.text) == ""){
                                    msgBox.text = msgAddrNameStr
                                    msgBox.visible = true
                                }
                                else{
                                    if(compareOtherData(newother.newAddrName.text)){
                                        msgBox.text = '当前添加的详细信息已存在'
                                        msgBox.visible = true
                                        return
                                    }
                                    var addrTemp = JSL.trimAll(newother.newAddrName.text)
                                    var url ="http://"+goIpPort+"/saveAddr/"+streetCode+"/4/"+addrTemp
                                    saveDetailsUuid=JSL.makeuuid()
                                    operatehttp.get(saveDetailsUuid,url)
                                    newother.newAddrName.text = ""
                                }
                            }else{
                                msgBox.text = '请添加<省-市-区-街>后再添加此项'
                                msgBox.visible = true
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
    Connections{
        target: operatehttp
        onHttpDone: {
            if(saveDetailsUuid==id){ //
                if(data!==""){
                    updateModel()
                }
                else{
                    msgBox.text = obj.msg
                    msgBox.visible = true
                }
            }
        }
    }
    function getStr(str){
        if(JSL.strRealLength(str) > 15){
            if(!JSL.isChinese(str)){
                return JSL.subStringFromTo(str, 0, 20)+'...'
            }
            else{
                return JSL.subStringFromTo(str, 0, 13)+'...'
            }
        }else{
            return str
        }
    }
}






















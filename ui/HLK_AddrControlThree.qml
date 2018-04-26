import QtQuick 2.4
import QtGraphicalEffects 1.0
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL
import "qrc:/base/js/provinces.js" as PROVINCES
import "qrc:/base/js/cities.js" as CITIES
import "qrc:/base/js/areas.js" as AREAS
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
    property string tempCityText:""       //直辖市特备行政区时为空

    property int province:0   //当做枚举使用 省Tab编号
    property int city:1
    property int area:2
    property int itemWidth:720/4
    property int itemHeight:50

    property string msgAddrNameStr:"请填写地址名称"

    width: 544
    height: 330
    color:"white"
    bd_color:'#9D9D9D'
    //bd_width:5

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
        source:{cityCode != "" ? "http://"+goIpPort+"/searchAddr/"+cityCode+"/2" : ""}
        //json: JSON.stringify(AREAS.searchAreas(cityCode))
    }

    function changeCurrentTabPage(index){
        switch(index){
        case province:
            cityText = ""
            cityCode = ""
            tempCityText=""
        case city:
            areaText = ""
            areaCode = ""
        }

        bodyView.currentIndex = index
    }

    Column{
        x:2
        width: parent.width
        height: parent.height
        spacing: 5

        Row{
            spacing: 10
            width:parent.width
            HLK_TabHeadText{
                anchors.verticalCenter: parent.verticalCenter
                fontWidth:60
                fontText: "已选:"
            }
            HLK_TextEdit{
                anchors.verticalCenter: parent.verticalCenter
                id: addrText
                width: 350
                text:provinceText+tempCityText+areaText
                textMode: TextInput.NoWrap
            }
            HLK_Button{
                anchors.verticalCenter: parent.verticalCenter
                button_text:"完成"
                id:addrFinishBtn
            }
        }

        HLK_TextEdit{
            width: parent.width
            height:1
        }

        Row{//页头   省 市 区 街 号 高60
            id:header
            width: parent.width
            height: 40
            ExclusiveGroup { id: exclusive }

            HLK_TabHeadButton{
                id: provinceBtn
                exclusiveGroup: exclusive
                checked: true
                text:"省"
                buttonHeigh:40
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
                buttonHeigh:40
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
                buttonHeigh:40
                buttonBorder:1
                onCheckedChanged: { //切页
                    if(checked){
                        changeCurrentTabPage(area)
                    }
                }
            }
        }

        TabView{// 分页显示具体信息
            id: bodyView
            width: parent.width
            height: parent.height - 130
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
                        buttonHeigh:40
                        exclusiveGroup:provinceExclusive
                        normalColor:"#FFFFFF"
                        checkedColor: "#9D9D9D"
                        text: model.name
                        onClicked: {
                            if(checked){
                                provinceCode = provinceView.model.get(index).code
                                provinceText = provinceView.model.get(index).name
                                cityBtn.checked = true
                                //changeCurrentTabPage(city)
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
                        buttonHeigh:40
                        exclusiveGroup:cityExclusive
                        normalColor:"#FFFFFF"
                        checkedColor: "#9D9D9D"
                        text: model.name
                        onClicked: {
                            if(checked){
                                cityCode = cityView.model.get(index).code
                                cityText = cityView.model.get(index).name
                                tempCityText = cityText
                                if(cityText == "市辖区" || cityText == "省直辖县级行政区划" || cityText == "自治区直辖县级行政区划"){
                                    cityText=provinceText
                                    tempCityText=""
                                }
                                areaBtn.checked = true
                                //changeCurrentTabPage(area)
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
                        buttonHeigh:40
                        exclusiveGroup:areaExclusive
                        normalColor:"#FFFFFF"
                        checkedColor: "#9D9D9D"
                        text: model.text
                        onClicked:  {
                            if(checked){
                                areaCode = areaView.model.get(index).code
                                areaText = areaView.model.get(index).text
                            }
                        }
                    }
                }
            }
        }
    }
}






















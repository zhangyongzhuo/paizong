import QtQuick 2.4
import "qrc:/controls/ui"
import QtQuick.Controls 1.2
import QtMultimedia 5.4

import "qrc:/base/js/QChart.js" as Charts
import "qrc:/base/js/QChartGallery.js" as ChartsData

Item{
    property alias wenben: wenben //文本框
    property alias xiala : xiala  //下拉框
    property alias xialaData:xialaData //下拉框里内容
    property alias getF:getF

    height: wenbenHeight
    width: wenbenWidth

    HLK_JsonListModel {           //下拉框里内容
        id: xialaData

    }

    Column{
        HLK_TextEdit{       //文本框
            id: wenben
            width : wenbenWidth
            height : wenbenHeight
            inputSize:wenbenTextSize
            pagename: wenbenPagename
        }

        HLK_Border {        //下拉框
            id: xiala
            radius: 10
            width: wenbenWidth
            height: xialaHeight
            color: "white"
            visible: false
            ListView {
                id:xialaList
                anchors.fill: parent
                anchors.topMargin: 5
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                clip: true
                model: xialaData.model
                highlight: Rectangle{
                       color:"#BFEFFF"
                       radius: 3
                }
                highlightFollowsCurrentItem: true
                focus: true

                delegate: Text{
                    width:parent.width
                    font.pixelSize: 20
                    height:35
                    verticalAlignment: Text.AlignVCenter
                    font.family: "黑体"
                    color: "#000000"
                    text: model.text == undefined ? "" : model.text

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            isMouseAreaClicked = true
                            wenben.text = xialaList.model.get(index).text
                            xiala.visible = false
                            getF.focus = true
                        }
                    }
                }
            }
        }
    }

    TextEdit {
        id:getF
        visible: false
    }

}


//HLK_BasePage{
//    pageTitle: "统计汇总"



//    Image {
//        id: name
//        source: "qrc:/images/images/X3.jpg"
//        y:80
//        width: parent.width-8
//        height: parent.height-80
//    }

//    //柱状图数据
//    property var myBarData : {
//        "labels"  : ["暂住","寄住","境外","未落户","实有房屋","实有单位"],
//        "datasets": [{
//              "fillColor": "rgba(220,220,220,0.5)",
//            "strokeColor": "rgba(220,220,220,1)",
//                   "data": [10,2,29,81,56,55]
//        }, {
//              "fillColor": "rgba(151,187,205,0.5)",
//            "strokeColor": "rgba(151,187,205,1)",
//                   "data": [5,18,10,19,96,27]
//        }]
//    }

//    Column{
//        y:80
//        width: parent.width
//        height: parent.height-80
//        spacing: 20
//        //搜索条件
//        Item{
//            width: parent.width
//            height: 70
//            Row{
//                spacing: 20
//                anchors.top: parent.top
//                anchors.topMargin: 20
//                anchors.left: parent.left
//                anchors.leftMargin: 30

//                HLK_NormalText {
//                    y:15
//                    text: "时间:"
//                    width: 50
//                }

//                HLK_TextEdit {
//                    id: startData
//                    width: 300
//                    textSize: 20
//                }

//                HLK_NormalText {
//                    y:15
//                    text: "至:"
//                    width: 35
//                }

//                HLK_TextEdit {
//                    id: endData
//                    width: 300
//                    textSize: 20
//                }

//                HLK_Button {
//                    y:5
//                    id: searchBtn
//                    width: 98
//                    button_text: "搜索"
//                }
//            }
//        }
//        //柱状图
//        Item{
//            width: parent.width
//            height: 300

//            Row{
//                spacing: 20
//                anchors.left: parent.left
//                anchors.leftMargin: 50
//                width: parent.width-50
//                height: 300

//                //柱状图
//                HLK_Chart {
//                  id: chart_bar
//                  width: parent.width -200
//                  height: parent.height
//                  chartAnimated: true
//                  chartAnimationEasing: Easing.OutBounce
//                  chartAnimationDuration: 2000
//                  chartData: myBarData
//                  chartType: Charts.ChartType.BAR
//                }

//                //标识
//                Flow{
//                    width:100
//                    height: 100
//                    Rectangle{
//                        width: 20
//                        height: 20
//                        radius: 45
//                        color: "#dcdcdc"
//                    }
//                    HLK_NormalText {
//                        text: "移动端"
//                        width: 80
//                        height: 50
//                        horizontalAlignment: Text.AlignHCenter
//                    }
//                    Rectangle{
//                        width: 20
//                        height: 20
//                        radius: 45
//                        color: "#97bbcd"
//                    }
//                    HLK_NormalText {
//                        text: "电脑端"
//                        width: 80
//                        horizontalAlignment: Text.AlignHCenter
//                    }
//                }
//            }

//        }
//        //表格
//        Item{
//            width: parent.width
//            height: 220
//            TableView {
//                anchors.left: parent.left
//                anchors.leftMargin: 50
//                width: parent.width-300
//                height: 220

//                  TableViewColumn {
//                      role: "title"
//                      title: "条目"
//                      width: 100
//                  }
//                  TableViewColumn {
//                      role: "author"
//                      title: "Author"
//                      width: 200
//                  }
//                  model: libraryModel
//              }
//        }
//    }

//    ListModel {
//        id: libraryModel
//        ListElement {
//            title: "A Masterpiece"
//            author: "Gabriel"
//        }
//        ListElement {
//            title: "Brilliance"
//            author: "Jens"
//        }
//        ListElement {
//            title: "Outstanding"
//            author: "Frederik"
//        }
//    }







//    property int chart_width: 300
//    property int chart_height: 300
//    property int chart_spacing: 20
//    property int text_height: 80
//    property int row_height: 8

//    HLK_Button{
//        id: button
//        anchors.top:  parent.top
//        anchors.right: parent.right
//        anchors.topMargin: 100
//        anchors.rightMargin: 20
//        button_text:"刷新"

//        onClicked: {
//            chart_bar.repaint()
//            chart_doughnut.repaint()
//            chart_line.repaint()
//            chart_pie.repaint()
//            chart_polar.repaint()
//            chart_radar.repaint()
//        }
//    }

//    //线性图标数据
//    property var myLineData : {
//        "labels": ["一月","二月","三月","四月","五月","六月","七月"],
//        "datasets": [{
//                   "fillColor": "#e8e8e8", //填充颜色
//                 "strokeColor": "rgba(220,220,220,1)", //折线颜色
//                  "pointColor": "rgba(220,220,220,1)", //拐点颜色
//            "pointStrokeColor": "#FFFFFF",             //拐点外圈颜色
//                        "data": [65,59,90,81,56,55,40] //对应1234567月的具体数值
//        }, {
//                   "fillColor": "rgba(151,187,205,0.5)",
//                 "strokeColor": "rgba(151,187,205,1)",
//                  "pointColor": "rgba(151,187,205,1)",
//            "pointStrokeColor": "#ffffff",
//                        "data": [28,48,40,19,96,27,100]
//        }]
//    }

//    ///////////////////////////////////////////////////////////////////
//    // 主体：6个图表，数据由QChartGallery.js提供
//    ///////////////////////////////////////////////////////////////////
//    Grid {
//        id: layout
//        x: 140
//        y: 2*row_height + text_height
//        width: parent.width
//        height: parent.height - 2*row_height - text_height
//        columns: 3
//        spacing: chart_spacing

//        HLK_Chart {
//          id: chart_line
//          width: chart_width
//          height: chart_height
//          chartAnimated: true //动画
//          chartAnimationEasing: Easing.InOutElastic //动画效果 弹性
//          chartAnimationDuration: 2000              //动画持续时间（毫秒）
//          chartData: myLineData//ChartsData.ChartLineData //表格数据
//          chartType: Charts.ChartType.LINE          //统计样式（折线）
//        }

//        HLK_Chart {
//          id: chart_polar;
//          width: chart_width;
//          height: chart_height;
//          chartAnimated: true;
//          chartAnimationEasing: Easing.InBounce;
//          chartAnimationDuration: 2000;
//          chartData: ChartsData.ChartPolarData;
//          chartType: Charts.ChartType.POLAR;  //（极地）
//        }

//        HLK_Chart {
//          id: chart_radar;
//          width: chart_width;
//          height: chart_height;
//          chartAnimated: true;
//          chartAnimationEasing: Easing.OutBounce;
//          chartAnimationDuration: 2000;
//          chartData: ChartsData.ChartRadarData;
//          chartType: Charts.ChartType.RADAR;
//        }

//        HLK_Chart {
//          id: chart_pie;
//          width: chart_width;
//          height: chart_height;
//          chartAnimated: true;
//          chartAnimationEasing: Easing.Linear;
//          chartAnimationDuration: 2000;
//          chartData: ChartsData.ChartPieData;
//          chartType: Charts.ChartType.PIE;
//        }

//        HLK_Chart {
//          id: chart_bar;
//          width: chart_width;
//          height: chart_height;
//          chartAnimated: true;
//          chartAnimationEasing: Easing.OutBounce;
//          chartAnimationDuration: 2000;
//          chartData: ChartsData.ChartBarData;
//          chartType: Charts.ChartType.BAR;
//        }

//        HLK_Chart {
//          id: chart_doughnut;
//          width: chart_width;
//          height: chart_height;
//          chartAnimated: true;
//          chartAnimationEasing: Easing.OutElastic;
//          chartAnimationDuration: 2000;
//          chartData: ChartsData.ChartDoughnutData;
//          chartType: Charts.ChartType.DOUGHNUT;
//        }
//    }

//    HLK_MessageBox{
//        id: messagebox
//    }
//}

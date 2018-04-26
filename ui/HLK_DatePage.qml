import QtQuick 2.0

//import "qrc:/common/util.js" as Util
//import "qrc:/common/"
//import "qrc:/timeControl/"
import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL

Item {
    id:root

    property int dateModelIndex : 0
    property int monthMaxDay : 30
    property int year: 0
    property int month: 1
    property int day: 0
    property int lockday: 0

    property string textColor:"white"
    property string highlightColor:"#0099ff"
    property int fontSize:30
    property string themeColor: JSL.themeColor()


    signal returnPage(bool ok,int year,int month,int day)

    Component.onCompleted: {
        initTime()
        monthMaxDay = currentMonthMaxDay(year,month)
    }

    Rectangle{
        anchors.fill: parent
        color:"#000000"
        opacity:0.6//透明度为0.5
        //color:"#989898"
    }

    onYearChanged: {
        monthMaxDay = currentMonthMaxDay(year,month)
    }
    onMonthChanged: {
        monthMaxDay = currentMonthMaxDay(year,month)
        day = 1
//        lockday = day;
//        dayPathView.initIndex = lockday -1;

    }
    Rectangle {
        id: mainUI;

        color: "#FEFEFE" //"#989898";
        anchors.centerIn: parent;
        width:600 //G.Tools.width(650);
        height:400// G.Tools.height(610);
        border.width: 1
        border.color: "#989898"
        radius: 10

    HLK_TimePathView{
        id:yearPathView
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -200
        y:20//100
        width:200
        height:300
        order:true
        orderStartNum: 1970
        initIndex:year - 1970
        unitText:"年"//Util.lang(qsTr("年"))
        unitLeftMargin:-50
        model:130//yearModel
        onValueChanged: {
            year = value
        }
    }
    HLK_TimePathView{
        id:monthPathView
        anchors.horizontalCenter: parent.horizontalCenter
       // anchors.horizontalCenterOffset: 100
        y:20//50//100
        width:200
        height:300
        order:true
        orderStartNum: 1
        initIndex:month - 1
        unitText:"月" //Util.lang(qsTr("月"))
        unitLeftMargin:-70
        model:12
        onValueChanged: {
            month = value
        }

    }
    HLK_TimePathView{
        id:dayPathView
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 200
        y:20//50//100
        width:200
        height:300
        order:true
        orderStartNum: 1
        initIndex:day - 1
        unitText:"日"//Util.lang(qsTr("日"))
        unitLeftMargin:-70
        model:
        monthMaxDay ===28?28:
        monthMaxDay ===29?29:
        monthMaxDay ===30?30:
        monthMaxDay ===31?31:0

        onValueChanged: {
            day = value
        }
    }

    //---按钮
//    Rectangle {
//        anchors {
//            left: parent.left;
//            right: parent.right;
//            bottom: parent.bottom;
//        }
//        color: "#1890CF";
//        height: 106//G.Tools.height(106);
//    }

    Row{
        id:timeSettingColumn

        anchors.top: dayPathView.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10//20
        spacing: 100

        HLK_Button2 {
            id: btnTime
            width: 130
            button_text: "确定"
            onClicked: {
                returnPage(true,year,month,day)
            }
        }
//        HLK_Button{
//            id:btnTime
//            text:"确定"//Util.lang(qsTr("确定"))
//            //pressedSource:  Util.fromTheme("Settings/setting_choose2.png")
//            //normalSource: Util.fromTheme("Settings/setting_choose.png")
//            onClicked: {
//                returnPage(true,year,month,day)
//            }
//        }
        HLK_Button2 {
            id: btnDate
            width: 130
            button_text: "取消"
            onClicked: {
                returnPage(false,year,month,day)
            }
        }
//        HLK_Button{
//            id:btnDate
//            text:"取消"//Util.lang(qsTr("取消"))
//            //pressedSource:  Util.fromTheme("Settings/setting_choose2.png")
//            //normalSource: Util.fromTheme("Settings/setting_choose.png")
//            onClicked: {
//               returnPage(false,year,month,day)
//            }
//        }
    }
    }

//    //--初始化
//    onShowChanged:  {
//        if(show)
//        {
//            initTime()
//            monthMaxDay = currentMonthMaxDay(year,month)
//        }
//    }

    function initTime(){
        var date = new Date;
        year = date.getFullYear()
        month = date.getMonth()+1
        day = date.getDate()

    }

    //--判断是否闰年
    function isLeapYear(year){
        var leap = false
        if(year%400==0||year%4==0&&year%100!=0)
            leap = true //是闰年
        else
            leap = false //不是闰年
        //console.log(year,"is leap year:",leap)
        return leap
    }

    //--判断大小月，2月不在判断范围内
    function isBigMonth(month){
        var bigMonth = false
        if(month !==4&&month !==6&&month !==9&&month !==11){
            bigMonth = true
        }else{
            bigMonth = false
        }
        //console.log("month is bigMonth:",bigMonth)
        return bigMonth
    }

    //--依据年、月判断最大日
    function currentMonthMaxDay(year,month){
        //是否2月?(闰年29，非闰28):(小月？30天:31天)
        var maxDay = 0
        if(month === 2){
            if(isLeapYear(year)){
                maxDay = 29
            }else{
                maxDay = 28
            }
        }else{
            if(isBigMonth(month)){
                maxDay = 31
            } else {
                maxDay = 30
            }
        }
        return maxDay
    }

}

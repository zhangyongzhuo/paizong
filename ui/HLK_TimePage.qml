//import QtQuick 2.0

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

    property bool  isAm:hour<12 //am pm
    property bool  hourModel24 : true
    property int hour: 0
    property int minute: 0
    property string textColor:"white"
    property string highlightColor:"#0099ff"
    property int fontSize:30
    property string themeColor: JSL.themeColor()

    signal returnPage(bool ok)

    Component.onCompleted: {
        initTime()
    }

    Rectangle
    {
        anchors.fill: parent
        color:"#000000"
        opacity:0.6//透明度为0.5
    }

    Button{
        id:btntimeModel
        visible: !hourModel24
        anchors{
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -20
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: -300
        }

        text: isAm?"上午":"下午"//Util.lang(qsTr("上午")):
                  // Util.lang(qsTr("下午"))
       // pressedSource:  Util.fromTheme("Settings/setting_choose2.png")
       // normalSource: Util.fromTheme("Settings/setting_choose.png")
        onClicked: {
            // hour : 1 - 24
            var isAmValue =!isAm?0:1;
            hour = hourModel24?hour:(hour%12+isAmValue*12)
        }
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
        id:hourPathView
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -100
        y:20//100
        width:200
        height:300
        order:true
        orderStartNum: hourModel24?0:1
        initIndex: hourModel24?hour:(hour%12!==0?(hour%12 - 1):11)
        unitText:"时" //Util.lang(qsTr("时"))
        unitLeftMargin:-70
        model:  hourModel24?24:12
        onValueChanged: {
            var isAmValue =isAm?0:1;
            hour = hourModel24?value:(value%12+isAmValue*12)
        }
    }
    HLK_TimePathView{
        id:minutePathView
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 100
        y:20//100
        width:200
        height:300
        order:true
        orderStartNum: 0
        initIndex:minute
        unitText:"分"// Util.lang(qsTr("分"))
        unitLeftMargin:-70
        model:60
        onValueChanged: {
            minute = value
        }
    }

    //---按钮
    Row{
        id:timeSettingColumn
        anchors.top: hourPathView.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10//30
        spacing: 100

        HLK_Button2 {
            id: btnTime
            width: 130
            button_text: "确定"
            onClicked: {
                returnPage(true);
            }
        }
        HLK_Button2 {
            id: btnDate
            width: 130
            button_text: "取消"
            onClicked: {
               returnPage(false)
            }
        }
    }
    }

//    onShowChanged:  {
//        if(show)
//        {
//            initTime()
//        }
//    }

    function fix(num) {
        if ( num < 10) {
            return "0" + num;
        }else{
            return num;
        }
    }
    //初始化时间，控件跟随时间变化
    function initTime(){
        var currentDate = new Date()
        hour = currentDate.getHours()
        minute = currentDate.getMinutes()
        console.log(currentDate)

    }

}

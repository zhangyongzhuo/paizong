import QtQuick 2.4
import QtGraphicalEffects 1.0
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import com.hylink.fmcp.ctrl 2.0

Item {
    property string themeColor: JSL.themeColor()
    property string titleText: "历史盘查"
    property alias backBtn: backBtn
    property alias searchCondition: searchCondition
    property alias searchBtn: searchBtn
    property alias infoModel: infoModel
    property alias busyIndicator: busyIndicator
    property alias messagebox: messagebox
    property alias edit_button: edit_button
    property alias select_button: select_button
    property alias export_button: export_button
    property alias delete_button: delete_button
    property alias isDeleteBtn: isDeleteBtn
    property alias noDeleteBtn: noDeleteBtn
    property alias popWindowDelete: popWindowDelete
    property alias detailInfo: detailInfo
    property bool checkVisible: false
    property alias statusText:statusText
    property alias status:status
    property alias timeText:timeText
    property alias toTimeText:toTimeText
    property alias startDataTime:startDataTime
    property alias endDataTime:endDataTime
    property alias statusData:statusData
    property int inventoryTotal:0
    property int inventoryToday:0
    property int abnormalNumber:0
    property int abnormalToday:0
    property int matchNumber:0
    property string startTimeStr: "" //开始时间
    property string startDateStr: ""//开始时间
    property string endTimeStr:   ""   //结束时间
    property string endDateStr:  ""  //结束时间
    property string nextYear:  ""  //
    property string nextMonth:  ""  //
    property string nextDay:  ""  //




    //待删除元素列表
    //property var deleteList: []
    signal informationDetailsItemClicked(int index)

    signal informationDetailsDeleteCheckedChange

    //删除选中状态发生变化
    width: 1280
    height: 768

    Rectangle {
        //页头
        width: parent.width
        height: 80
        color: themeColor

        HLK_ToolButton {
            id: backBtn
            x: 10
            anchors.verticalCenter: parent.verticalCenter
            imgPath: "qrc:/images/images/back.png"
            btnText: "返回"
        }

        Text {
            //标题
            id: title
            color: "white"
            text: titleText
            font.pixelSize: 26
            font.family: "SimHei"
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    HLK_TextEdit {
        id: searchCondition
        width: 320
        leftMargin: 55
        x: 20
        y: 100
        Image {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 25
            height: 25
            source: "qrc:/images/images/search.png"
        }
    }
    HLK_NormalText {
        id: statusText
        x:searchCondition.x+searchCondition.width+20
        y:searchCondition.y+15
        text: "状态:"
        width: 60
        visible: nPageSerialNumber ==17||nPageSerialNumber ==18||nPageSerialNumber ==20 ? false:true
    }
    HLK_ComboBox {
        id: status
        x:searchCondition.x+searchCondition.width+80
        y:searchCondition.y
        boxWidth:80
        model: statusData
        currentIndex:0
        visible: nPageSerialNumber ==17||nPageSerialNumber ==18||nPageSerialNumber ==20 ? false:true
    }
    ListModel {
        id: statusData
        ListElement {
            text: "全部"
            code: "-1"
        }
        ListElement {
            text: "正常"
            code: "0"
        }
        ListElement {
            text: "异常"
            code: "1"
        }
    }
    HLK_NormalText {
        id: timeText
        x:status.x+status.width+20
        y:searchCondition.y+15
        text: "时间:"
        width: 60
    }
    HLK_TextEditDouble{
        id:startDataTime
        width:190
        textSizeLeft:20
        textSizeRight:20
        x:timeText.x+timeText.width
        y:searchCondition.y
        onDataChanged:{
            if(status == true){
                if(textLeft==""){
                    datePage.year= yearCurrent
                    datePage.month= monthCurrent
                    datePage.day= dayCurrent
                }
                else{
                    datePage.year= qmlData.cutStr(JSL.getDate(textLeft),0,4)
                    datePage.month= qmlData.cutStr(JSL.getDate(textLeft),4,2)
                    datePage.day=qmlData.cutStr(JSL.getDate(textLeft),6,2)
                }
                datePage.visible=true
                startorEnd=true
            }
        }
        onTimeChanged:{
            if(status== true){
                if(textLeft==""){
                    messagebox.text = '请先选择开始日期再选择开始时间'
                    messagebox.visible = true
                }
                else{
                    if(textRight==""){
                        timePage.hour= hourCurrent
                        timePage.minute= minuteCurrent
                    }
                    else{
                        timePage.hour=qmlData.cutStr(JSL.getTime(textRight),0,2)
                        timePage.minute=qmlData.cutStr(JSL.getTime(textRight),2,2)
                    }
                    timePage.visible=true
                    startorEndTime=true
                }
            }
        }
    }
    HLK_NormalText {
        id: toTimeText
        x:startDataTime.x+startDataTime.width+10
        y:searchCondition.y+15
        text: "至:"
        width: 35
    }
    HLK_TextEditDouble{
        id:endDataTime
        x:toTimeText.x+toTimeText.width
        y:searchCondition.y
        width:190
        textSizeLeft:20
        textSizeRight:20
        onDataChanged:{
            if(status == true){
                if(startDataTime.textLeft==""){
                    messagebox.text = '请先选择开始日期再选择结束日期'
                    messagebox.visible = true
                    return true
                }
                if(startDataTime.textRight==""){
                    messagebox.text = '请先选择开始时间再选择结束日期'
                    messagebox.visible = true
                    return true
                }
                if(textLeft==""){
                    datePage.year= yearCurrent
                    datePage.month= monthCurrent
                    datePage.day= dayCurrent
                }else{
                    datePage.year= qmlData.cutStr(JSL.getDate(textLeft),0,4)
                    datePage.month= qmlData.cutStr(JSL.getDate(textLeft),4,2)
                    datePage.day= qmlData.cutStr(JSL.getDate(textLeft),6,2)
                }
                datePage.visible=true
                startorEnd=false
            }
        }
        onTimeChanged:{
            if(status == true){
                if(startDataTime.textLeft==""){
                    messagebox.text = '请先选择开始日期再选择结束时间'
                    messagebox.visible = true
                    return true
                }
                if(startDataTime.textRight==""){
                    messagebox.text = '请先选择开始时间再选择结束时间'
                    messagebox.visible = true
                    return true
                }
                if(textLeft==""){
                    messagebox.text = '请先选择结束日期再选择结束时间'
                    messagebox.visible = true
                    return true
                }
                if(textRight==""){
                    timePage.hour= hourCurrent
                    timePage.minute= minuteCurrent
                }
                else{
                    timePage.hour=qmlData.cutStr(JSL.getTime(textRight),0,2)
                    timePage.minute=qmlData.cutStr(JSL.getTime(textRight),2,2)
                }
                timePage.visible=true
                startorEndTime=false
            }
        }
    }
    HLK_Button {
        id: searchBtn
        anchors.right: edit_button.left
        anchors.rightMargin: 30
        y: searchCondition.y+5
        width: 98
        button_text: "搜索"
        visible: !checkVisible
    }
    HLK_Checkbox {
        id: select_button
        anchors.right: edit_button.left
        //anchors.rightMargin:nPageSerialNumber==QmlData.INTO_TYPE_AQT_PERSION||nPageSerialNumber==QmlData.INTO_TYPE_AQT_CAR?158:30
        anchors.rightMargin: 30
        y: searchBtn.y + 8
        width: 88
        text: "全选"
        visible: false
    }
    HLK_Button {
        id: export_button
        anchors.right: edit_button.left
        anchors.rightMargin: 30
        y: searchBtn.y
        width: 98
        button_text: "导出"
        visible: false
    }
    HLK_Button {
        id: edit_button
        anchors.right: parent.right
        anchors.rightMargin: 25
        y: searchBtn.y
        width: 98
        button_text: "删除"
    }
    HLK_Button {
        id: delete_button
        x: edit_button.x
        y: edit_button.y
        width: 98
        button_text: "确认"
        visible: false
    }
    Rectangle {
        width: 1220
        height: 1
        color: "#DCDCDC"
        y: 170
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Item {
        id: detailInfo
        anchors.horizontalCenter: parent.horizontalCenter
        y: 200
        width: 1240
        height: 460
        clip: true

        ListModel {
            id: infoModel
            ListElement {
                IMG: ""
                ROW1: ""
                ROW2: ""
                ROW3: ""
                ROW4: ""
                JSON: ""
                SHOWTEXT: ""
                SHOWTEXTTITLE: ""
                ISSHOWTEXT: false
                ISSHOWUPLOAD: 1
                OptargetId: ""
                ISCHECK: false
                GLOBALTASK:false
                //BORDERCOLOR: "#E4E4E4"
            }
        }

        GridView {
            id: view
            anchors.fill: parent
            anchors.margins: 5

            //cacheBuffer: 3000
            width: 1220
            height: 360
            cellWidth: 390 + 20
            cellHeight: 136 + 20
            HLK_RectangleButton {
                id: addBtn
                visible: false
                width: 390
                height: 136
                imgPath: "qrc:/images/images/rzbd_add2.png"
            }
            model: infoModel

            //            highlight: Item {
            //                Rectangle {
            //                    width: 390 + 5
            //                    height: 136 + 5
            //                    color: "#00000000"
            //                    border.width: 1
            //                    border.color: themeColor
            //                    anchors.horizontalCenter: parent.horizontalCenter
            //                    anchors.verticalCenter: parent.verticalCenter
            //                    layer.enabled: true
            //                    layer.effect: DropShadow {
            //                        transparentBorder: true
            //                        color: themeColor
            //                        radius: 8
            //                        samples: 16
            //                    }
            //                }
            //            }
            delegate: HLK_NoramlCard {
                id: deleteid
                backgroundColor:ROW4
                //borderColor:BORDERCOLOR
                isShowText: ISSHOWTEXT
                showText: SHOWTEXT
                showTextTitle: typeof (SHOWTEXTTITLE) == 'undefined' ? '' : SHOWTEXTTITLE
                isShowUpload: ISSHOWUPLOAD
                image: IMG
                row1: ROW1
                row2: ROW2
                row3: ROW3
                globalTask:GLOBALTASK
                onClicked: {
                    view.currentIndex = index
                    emit: informationDetailsItemClicked(index)
                }
                deletecheck.checked: ISCHECK
                deletecheck.visible: checkVisible
                deletecheck.onCheckedChanged: {
                    //                    if (deletecheck.checked) {
                    //                        deleteList.push(infoModel.get(index).OptargetId)
                    //                    } else {
                    //                        deleteList.remove(infoModel.get(index).OptargetId)
                    //                    }
                    ISCHECK = deletecheck.checked
                    emit: informationDetailsDeleteCheckedChange()
                    tm.start()
                }

                //进行绑定
                Timer {
                    id: tm
                    repeat: false
                    triggeredOnStart: false
                    interval: 200

                    onTriggered: {
                        deletecheck.checked = Qt.binding(function () {
                            return ISCHECK
                        })
                    }
                }
            }
        }
    }
    Row{
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        spacing: 40
        width: parent.width
        Text{
           text:"盘查总数："+inventoryTotal
           font.pixelSize: 20
           font.family: "SimHei"
           color: "#474747"
           width:180
        }
        Text{
           text:"今日盘查总数："+inventoryToday
           font.pixelSize: 20
           font.family: "SimHei"
           color: "#474747"
           width:200
        }
        Text{
           text:"历史异常数："+abnormalNumber
           font.pixelSize: 20
           font.family: "SimHei"
           color: "#474747"
           width: 190
           visible: nPageSerialNumber ==17||nPageSerialNumber ==18||nPageSerialNumber ==20 ? false:true
        }
        Text{
           text:"今日异常数："+abnormalToday
           font.pixelSize: 20
           font.family: "SimHei"
           color: "#474747"
           width:250
           visible: nPageSerialNumber ==17||nPageSerialNumber ==18 ||nPageSerialNumber ==20? false:true
        }
        Text{
           text:"匹配数量："+matchNumber
           font.pixelSize: 20
           font.family: "SimHei"
           color: themeColor
           width:250
        }
    }

    HLK_DatePage {
           id: datePage
           anchors.fill: parent
           visible:false
           //month:month+1
           onReturnPage:{
               if(ok){
                   if(startorEnd){
                       var str
                       if(day<10){
                            if(month<10){
                                str=year+"-"+0+month+"-"+0+day
                            }else{
                                str=year+"-"+month+"-"+0+day
                            }
                       }else{
                            if(month<10){
                                str=year+"-"+0+month+"-"+day
                            }else{
                                str=year+"-"+month+"-"+day
                            }
                       }
                       if(endDataTime.textLeft!=""){
                           if(JSL.getDate(endDataTime.textLeft)-JSL.getDate(str)<0){
                               messagebox.text = '开始时间不能大于结束时间'
                               messagebox.visible = true
                               return true
                           }
                       }
                       startDataTime.textLeft=str
                       startDateStr=startDataTime.textLeft
                       /*if(day<10){
                           startDataTime.textLeft=year+"-"+month+"-"+0+day
                           startDateStr=startDataTime.textLeft//year+month+0+day
                       }else{
                           startDataTime.textLeft=year+"-"+month+"-"+day
                           startDateStr=startDataTime.textLeft
                       }*/
                   }else{
                       var str
                       if(day<10){
                            if(month<10){
                                str=year+"-"+0+month+"-"+0+day
                            }else{
                                str=year+"-"+month+"-"+0+day
                            }
                       }else{
                            if(month<10){
                                str=year+"-"+0+month+"-"+day
                            }else{
                                str=year+"-"+month+"-"+day
                            }
                       }
                       console.log(str)
                       console.log(JSL.getDate(str))
                       console.log(JSL.getDate(JSL.getStart()))
                       if(JSL.getDate(str)-JSL.getDate(startDataTime.textLeft)<0){
                           messagebox.text = '结束时间不能小于开始时间'
                           messagebox.visible = true
                           return true
                       }
                       if(day<10){
                            if(month<10){
                                endDataTime.textLeft=year+"-"+0+month+"-"+0+day
                                endDateStr=endDataTime.textLeft
                            }else{
                                endDataTime.textLeft=year+"-"+month+"-"+0+day
                                endDateStr=endDataTime.textLeft
                            }

                       }else{
                            if(month<10){
                                endDataTime.textLeft=year+"-"+0+month+"-"+day
                                endDateStr=endDataTime.textLeft
                            }else{
                                endDataTime.textLeft=year+"-"+month+"-"+day
                                endDateStr=endDataTime.textLeft
                            }

                       }
                   }
                   datePage.visible=false
                   getFocus.focus = true
                   nextYear=year
                   nextMonth=month
                   nextDay=day
               }else{
                   datePage.visible=false
                   getFocus.focus = true
               }
           }
       }
    HLK_TimePage {
        id: timePage
        anchors.fill: parent
        visible:false
        hourModel24: true//24小时制度
        onReturnPage:{
            if(ok){
                if(startorEndTime){
                    if(minute<10){
                        if(hour<10){
                            startDataTime.textRight="0"+hour+":"+0+minute
                            startTimeStr=startDataTime.textRight
                        }else{
                            startDataTime.textRight=hour+":"+0+minute
                            startTimeStr=startDataTime.textRight
                        }
                    }else{
                         if(hour<10){
                             startDataTime.textRight="0"+hour+":"+minute
                             startTimeStr=startDataTime.textRight
                         }else{
                            startDataTime.textRight=hour+":"+minute
                            startTimeStr=startDataTime.textRight
                        }
                    }
                }else{
                    var str
                    if(minute<10){
                        if(hour<10){
                            str="0"+hour+":"+0+minute
                        }else{
                            str=hour+":"+0+minute
                        }
                    }else{
                        if(hour<10){
                            str="0"+hour+":"+minute
                        }else{
                            str=hour+":"+minute
                        }
                    }
                    if(startDataTime.textLeft!='' && endDataTime.textLeft!='' && (JSL.getDate(startDataTime.textLeft)-JSL.getDate(endDataTime.textLeft)==0)){
                        if(startDataTime.textRight!=''&& (JSL.getTime(startDataTime.textRight)-JSL.getTime(str))>=0){
                            messagebox.text = '结束时间不能小于或等于开始时间'
                            messagebox.visible = true
                            return true
                        }

                    }
                    if(minute<10){
                        if(hour<10){
                            endDataTime.textRight="0"+hour+":"+0+minute
                            endTimeStr=endDataTime.textRight
                        }else{
                             endDataTime.textRight=hour+":"+0+minute
                             endTimeStr=endDataTime.textRight
                         }

                    }else{
                        if(hour<10){
                            endDataTime.textRight="0"+hour+":"+minute
                            endTimeStr=endDataTime.textRight
                        }else{
                            endDataTime.textRight=hour+":"+minute
                            endTimeStr=endDataTime.textRight
                        }
                    }
                }
               timePage.visible=false
               getFocus.focus = true
            }else{
               timePage.visible=false
               getFocus.focus = true
            }
        }
    }


    HLK_PopupWindow {
        id: popWindowDelete
        visible: false
        anchors.fill: parent
        popupWindowTitle: ""
        Row {
            spacing: 100
            anchors.horizontalCenter: parent.horizontalCenter
            y: 400
            HLK_Button {
                id: isDeleteBtn
                width: 130
                button_text: "是"
            }
            HLK_Button {
                id: noDeleteBtn
                width: 130
                button_text: "否"
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter
        running: false
    }

    HLK_MessageBox {
        id: messagebox
    }
}

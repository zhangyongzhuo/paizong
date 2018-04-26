import QtQuick 2.4
import QtGraphicalEffects 1.0
import "qrc:/controls/ui"
import "qrc:/base/js/common.js" as JSL
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4

//工作报备界面
HLK_BasePage{
    pageTitle: "工作报备"
    property alias workReport:workReport
    property alias startTime: startTime //开始时间
    property alias startDate: startDate //开始时间
    property alias endTime:   endTime   //结束时间
    property alias endDate:   endDate   //结束时间
    property alias goOut:goOut
    property alias outOver:outOver
    property alias inOver:inOver
    property alias leave:leave
    property alias realistictext:realistictext //事由内容
    property alias takephoto: takephoto //拍照按钮
    property alias photoDisplyView: photoDisplyView           //照片显示view
    property alias photoDisplyViewModel: photoDisplyViewModel //照片显示model
    property alias datePage: datePage
    property alias timePage:timePage
    property alias popWindowOff:popWindowOff
    property alias approverPer:approverPer
    property alias place:place
    property alias messagebox: messagebox
    property alias approverData: approverData              //下拉框数据
    property alias approverDataArea:approverDataArea       //下拉框区域

    property string startTimeStr: "" //开始时间
    property string startDateStr: ""//开始时间
    property string endTimeStr:   ""   //结束时间
    property string endDateStr:  ""  //结束时间
    property string nextYear:  ""  //
    property string nextMonth:  ""  //
    property string nextDay:  ""  //
    property string duration: "168"     //时长
    property var modelRe: ["病假"]     //事由标签
    property bool delvisible: true                            //是否显示照片删除按钮
    property int viewCurrentIndex: -1                         //当前选中的照片
    property string beginTime: "168"     //时长
    property string preTypeCode: ""                           //报备类型记录code
    property string preTypeText: ""                           //报备类型记录text
    property string themeColor: JSL.themeColor()
    property int approverIndex: -1                         //审批人index
    property int whetherOff: 0                         //审批人index
    property alias busying: busying

    signal changeUserName(string name)
    MouseArea {
        x:0
        y:100
        width: parent.width
        height: parent.height - 130
        onClicked: {
            if (approverDataArea.visible == true){
                approverDataArea.visible = false
            }
            getFocus.focus = true
        }
    }

    Rectangle {
        y:100
        width: parent.width-40
        height: parent.height - 130
        color: "#FFFFFF"
        id:workReport
        anchors.horizontalCenter: parent.horizontalCenter

        Column{
            width: parent.width-40
            anchors.horizontalCenter: parent.horizontalCenter
            spacing:20
            //时间
            Rectangle {
                width: parent.width
                height: 75
                Row{
                    y:20
//                    anchors.top: parent.top
//                    anchors.topMargin: 15
                    spacing: 20
                    z: 1
                    ExclusiveGroup {
                        id: eg
                    }
                    HLK_NormalText {
                        id:preparationType
                        y:13
                        text:"<font color='red'>*</font>报备类型:"   //"*报备类型:"
                        width: 90
                    }
                    HLK_NormalRadioButton {
                        id: goOut
                        y: preparationType.y
                        width: 180
                        text: "外出"
                        exclusiveGroup: eg
                        onCheckedChanged: {
                            if(goOut.checked){
                                preTypeCode='400102'
                                preTypeText="外出"
                            }
                        }
                        //visible: false
                    }

                    HLK_NormalRadioButton {
                        id: outOver
                        y: preparationType.y
                        width: 230
                        text: "辖区加班"
                        exclusiveGroup: eg                        
                        onCheckedChanged: {
                            if(outOver.checked){
                                preTypeCode='400103'
                                preTypeText="辖区加班"
                            }
                        }
                       // visible: false
                    }
                    HLK_NormalRadioButton {
                        id: inOver
                        y: preparationType.y
                        width: 230
                        text: "外出加班"
                        exclusiveGroup: eg
                        onCheckedChanged: {
                            if(inOver.checked){
                                preTypeCode='400104'
                                preTypeText="外出加班"
                            }
                        }

                       // visible: false
                    }
                    HLK_NormalRadioButton {
                        id: leave
                        y: preparationType.y
                        width:230
                        text: "请假"
                        exclusiveGroup: eg
                        onCheckedChanged: {
                            if(leave.checked){
                                preTypeCode='400101'
                                preTypeText="请假"
                            }
                        }

                       // visible: false
                    }
                }

            }
            Rectangle {
                width: parent.width
                height: 65
                Row{
//                   anchors.top: parent.top
//                   anchors.topMargin: 15
                   spacing: 20
                   HLK_NormalText {
                       y: startTime.y + 13
                       text:"<font color='red'>*</font>开始时间:"
                       width: 90
                   }
                   HLK_TextEdit {
                       id: startDate
                       //hint: '2017-05-20'
                       width: 200
                   }
                   HLK_TextEdit {
                       id: startTime
                       //hint: '03:04'
                       width: 200
                   }
                   HLK_NormalText {
                       y: endTime.y + 13
                       text: "<font color='red'>*</font>结束时间:"
                       width: 90
                   }
                   HLK_TextEdit {
                       id: endDate
                       //hint:'2017-05-21'
                       width: 200
                   }
                   HLK_TextEdit {
                       id: endTime
                       //hint:'05:06'
                       width: 200
                   }

                   HLK_NormalText {
                       y: startTime.y + 13
                       text: "时长:"
                       width: 40
                       visible: false
                   }
                   HLK_NormalText {
                       y: startTime.y + 13
                       text: duration
                       width: 80
                       visible: false
                   }
               }
            }
            Rectangle {
                width: parent.width
                height: 65
                Row{
                   spacing: 20
                   HLK_NormalText {
                       text: " 地    点:"
                       y:place.y+13
                       width: 90
                   }
                   HLK_TextEdit {
                       id:place
                       width: 1080
                       maxLength:128
                   }
                }

            }

            //事由及照片
            Rectangle {
                width: parent.width
                height: 285
                Column {
                    spacing: 25
                    Row {
                        spacing: 20
                        HLK_NormalText {
                            y:realistictext.y+10
                            text:"<font color='red'>*</font>报备事由:"
                            width: 90
                        }
//                        Flow {
//                            //动态加载标签
//                            id: grid
//                            width: 1120
//                            spacing: 20
//                            Repeater {
//                                model: modelRe
//                                HLK_MarkButton {
//                                    button_text: modelData
//                                    //markEnable: PAGEMODE == QmlData.VISIT_TYPE_SEE ? false : true
//                                    onClicked: {
//                                        realistictext.text = realistictext.text + button_text + ";"
//                                    }
//                                }
//                            }
//                        }

                    HLK_MultilineTextEdit {
                        //x: grid.x
                        id: realistictext
                        modehint: ""
                        maxLength:200
                        width: 1080
                        height:100
                    }
                    }

                    Row {
                        spacing: 20
                        HLK_NormalText {
                            text: " 照    片:"
                            y:takephoto.y+13
                            width: 90
                        }

                        HLK_AddButton {
                            id: takephoto
                            width: 200
                            height: 151
                            imgPath: "qrc:/images/images/zhaopian.png"
                        }

                        Rectangle {
                            //多张照片显示区域
                            width: 850
                            height: 151
                            //color: 'black'
                            ListView {
                                id: photoDisplyView
                                visible: false
                                width: 850
                                height: 151
                                clip: true
                                spacing: 18
                                highlightMoveDuration: 1
                                orientation: ListView.Horizontal
                                snapMode: ListView.SnapOneItem
                                model: ListModel {
                                    id: photoDisplyViewModel
                                    ListElement {
                                        photopath: ""
                                    }
                                }
                                delegate: Image {
                                    width: 200
                                    height: 151
                                    cache: false
                                    source: photopath

                                    MouseArea{//放大所点击的图片
                                        anchors.fill: parent
                                        onClicked: {
                                            var path = photoDisplyViewModel.get(index).photopath
                                            doubleMax.imgPath= path
                                            doubleMax.maxVisble = true
                                            doubleMax.bgVisble = true

                                        }
                                    }

                                    Image {
                                        id: selected
                                        source: "qrc:/images/images/tb002-2.png"
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        visible: delvisible

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                viewCurrentIndex = index
                                                popWindow.visible = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            //审批
            Rectangle {
                y:20
                width: parent.width
                height: 65
                Row {
                    spacing: 20
                    ExclusiveGroup {
                        id: cg
                    }
                    HLK_NormalText {
                        text:"<font color='red'>*</font>"+"审批领导:"
                        width: 90
                        y:approverPer.y+13
                    }
                    HLK_TextEdit {
                        id: approverPer
                        width: 1080
                    }

                }
            }
        }


    }
    HLK_DatePage {
           id: datePage
           anchors.fill: parent
           visible:false
           //show: true
           //showPropertyChangesY:0
           //hidePropertyChangesY:0
           onReturnPage:{
               if(ok){                  
                   if(startorEnd){
                       var str
                       if(day<10){
                            str=year+"-"+month+"-"+0+day
                       }else{
                            str=year+"-"+month+"-"+day
                       }
                       if(JSL.getDate(str)-JSL.getDate(JSL.getStart())<0){
                           messagebox.text = '开始时间只能选择本周及以后日期，请重新选择开始时间'
                           messagebox.visible = true
                           return true
                       }
                       if(day<10){
                           startDate.text=year+"-"+month+"-"+0+day
                           startDateStr=JSL.getDate(startDate.text)//year+month+0+day
                       }else{
                           startDate.text=year+"-"+month+"-"+day
                           startDateStr=JSL.getDate(startDate.text)
                       }
                   }else{
                       var str
                       if(day<10){
                            str=year+"-"+month+"-"+0+day
                       }else{
                            str=year+"-"+month+"-"+day
                       }
                       console.log(str)
                       console.log(JSL.getDate(str))
                       console.log(JSL.getDate(JSL.getStart()))
                       if (JSL.getDate(str)-JSL.getDate(JSL.getStart())<0){
                           messagebox.text = '结束时间只能选择本周及以后日期，请重新选择结束时间'
                           messagebox.visible = true
                           return true
                       }
                       if(JSL.getDate(str)-JSL.getDate(startDate.text)<0){
                           messagebox.text = '结束时间不能小于开始时间'
                           messagebox.visible = true
                           return true
                       }
                       if(day<10){
                        endDate.text=year+"-"+month+"-"+0+day
                        endDateStr=JSL.getDate(endDate.text)
                       }else{
                        endDate.text=year+"-"+month+"-"+day
                        endDateStr=JSL.getDate(endDate.text)
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
//            show: true
//            showPropertyChangesY:0
//            hidePropertyChangesY:0
        hourModel24: true//24小时制度
        onReturnPage:{
            if(ok){
//                    var currentDate = new Date()
//                    var hour = currentDate.getHours()
//                    var minute = currentDate.getMinutes()
                //console.log(year,month+1,day,hour,minute)
                if(startorEndTime){
                    if(minute<10){
                        startTime.text=hour+":"+0+minute
                        startTimeStr=JSL.getTime(startTime.text)
                    }else{
                        startTime.text=hour+":"+minute
                        startTimeStr=JSL.getTime(startTime.text)
                    }
                }else{
                    var str
                    if(minute<10){
                         str=hour+":"+0+minute
                    }else{
                         str=hour+":"+minute
                    }
                    if(startDate.text!='' && endDate.text!='' && (JSL.getDate(startDate.text)-JSL.getDate(endDate.text)==0)){
                        if(startTime.text!=''&& (JSL.getTime(startTime.text)-JSL.getTime(str))>=0){
                            messagebox.text = '结束时间不能小于或等于开始时间'
                            messagebox.visible = true
                            return true
                        }

                    }
                    if(minute<10){
                         endTime.text=hour+":"+0+minute
                         endTimeStr=JSL.getTime(endTime.text)

                    }else{
                        endTime.text=hour+":"+minute
                        endTimeStr=JSL.getTime(endTime.text)
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
        id: popWindowOff
        visible: false
        anchors.fill: parent
        popupWindowTitle: "是否调休？"
        Row {
            spacing: 30
            anchors.horizontalCenter: parent.horizontalCenter
            y: 370
            ExclusiveGroup {
                id: ag
            }
            HLK_NormalRadioButton {
                id:halfDayOff
                text: "半天调休"
                width: 120
                exclusiveGroup: ag
                isChecked:true
                onCheckedChanged: {
                    if(halfDayOff.checked){
                        whetherOff=0
                    }
                }
            }
            HLK_NormalRadioButton {
                id: oneDayOff
                width: 120
                text: "一天调休"
                exclusiveGroup: ag
                visible:true
                onCheckedChanged: {
                    if(oneDayOff.checked){
                        whetherOff=1
                    }
                }
            }

            HLK_NormalRadioButton {
                id: noOff
                width: 120
                text: "不调休"
                exclusiveGroup: ag
                onCheckedChanged: {
                    if(noOff.checked){
                         whetherOff=2
                    }
                }
            }

        }
        Row {
            spacing: 50
            anchors.horizontalCenter: parent.horizontalCenter
            y: 430
            width:300
            HLK_Button {
                width: 130
                button_text: "提交"
                onClicked: {
                    sumbitLeave()
                }
            }
            HLK_Button {
                width: 130
                button_text: "取消"
                onClicked: {
                    popWindowOff.visible=false
                    workReport.enabled=true
                }
            }
        }
    }
    HLK_PopupWindow {
        id: popWindow
        visible: false
        anchors.fill: parent
        popupWindowTitle: "是否要删除此图片？"
        Row {
            spacing: 100
            anchors.horizontalCenter: parent.horizontalCenter
            y: 400
            HLK_Button {
                width: 130
                button_text: "是"
                onClicked: {
                    var delImgPath = photoDisplyViewModel.get(
                                viewCurrentIndex).photopath
                    var tempImgpath = qmlData.cutStr(delImgPath, 8, 0)
                    photoDisplyViewModel.remove(viewCurrentIndex) //删除列表中的图片
                    qmlData.deleteFile(tempImgpath) //删除本地图片

                    popWindow.visible = false
                }
            }
            HLK_Button {
                width: 130
                button_text: "否"
                onClicked: {
                    popWindow.visible = false
                }
            }
        }
    }

    HLK_MessageBox{
        id: messagebox
    }
    HLK_JsonListModel {
        id: approverData
    }
    HLK_Border{
        id: approverDataArea
//        anchors.bottom: approverPer.bottom
//        anchors.bottomMargin: 10
        radius: 10
        width: 1080
        height: approverData.model.count>10?305:approverData.model.count*30+5
        x: 150
        y: approverData.model.count>10?365:670-approverData.model.count*30-5
        color:"white"
        visible: false
        ListView {
            anchors.fill: parent
            anchors.topMargin: 5
            anchors.leftMargin: 5
            clip:true
            model: approverData.model
            delegate: Text {
                font.pixelSize: 28
                font.family: "黑体"
                color: "#000000"
                text : model.leader
                width:parent.width
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        var kkdata = approverData.model.get(index).leader
                        approverPer.text = kkdata                       
                        //approverIdcard=approverData.model.get(index).name//idCard
                        approverDataArea.visible = false
                        getFocus.focus = true
                        emit: changeUserName(kkdata)//审批人变化单位等级变化信号
                    }
                }
            }
        }
    }
    BusyIndicator{
        id: busying
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        running: false
    }

}

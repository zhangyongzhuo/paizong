import QtQuick 2.4
import "qrc:/base/js/jsonpath.js" as JSONPath
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL

Rectangle {
    id:reportShow
    property string preparationText:""   //报备类型
    property string startTimeStr:""      //开始时间
    property string endTimeStr:""        //结束时间
    property double timeLong:0          //时长
    property string placeStr:""         //地点
    property string reason:""           //原因
    property string approverPer:""      //审批人
    property string approverOpi:""      //审批意见
    property bool waitApprover:true     //等待审批矩形
    property bool approval:false        //审批通过和审批驳回矩形
    property string examineApproval:"400201" //0等待审批//1审批通过//2审批驳回
    property string imageSource:"qrc:/images/images/ddsp.png"//照片默认等待审批
    property string appendOrInsert: 'append'
    property bool load: false

    property alias reportReason:reportReason
    property alias place:place
    property alias zpRet:zpRet
    property alias approverOpinion:approverOpinion
    property alias approverRect:approverRect
    property string modeStr:""  //json数组字符串
    property string query: ""
    property ListModel model : ListModel { id: jsonModel }

    signal revokeAction()


    width:  1240
    height: examineApproval=="400201"?222+place.height+reportReason.height+20+zpRet.height:152+place.height+reportReason.height+20+zpRet.height+approverRect.height
    color:"#f2f2f4"

    Component.onCompleted: {
        if(examineApproval=="400201"){//等待审批
            waitApprover=true
            approval=false
            imageSource="qrc:/images/images/ddsp.png"
        }else if(examineApproval=="400203"){//审批通过
            waitApprover=false
            approval=true
            imageSource="qrc:/images/images/sptg.png"
        }else if(examineApproval=="400202"){//审批驳回
            waitApprover=false
            approval=true
            imageSource="qrc:/images/images/spbh.png"
        }
        //将modeStr转换成jsonModel
        jsonModel.clear()
        if(modeStr != ""){
            var obj = JSON.parse(modeStr)
            for(var i=0; i<obj.length; i++){
                console.log("-----------:"+obj[i])
                jsonModel.append({photopath:obj[i]})
            }
        }
    }

    Rectangle {
        x:0
        y:0
        width:  1240        
        height: examineApproval=="400201"?222+place.height+reportReason.height+zpRet.height:152+place.height+reportReason.height+zpRet.height+approverRect.height
        color:"#ffffff"
        Flow{
            x:20
            y:20
            spacing:15
            width: parent.width
            Text{
                id:preparationType
                text:"报备类型："+ preparationText  //"*报备类型:"
                font.pixelSize: 20
                font.family: "SimHei"
                color: "#00aecc"
                width: parent.width
            }
            Row{
                spacing: 40
                width: parent.width
                Text{
                   text:"开始时间："+startTimeStr
                   font.pixelSize: 20
                   font.family: "SimHei"
                   color: "#474747"
                   width:268
                }
                Text{
                   text:"结束时间："+endTimeStr
                   font.pixelSize: 20
                   font.family: "SimHei"
                   color: "#474747"
                   width:268
                }
                Text{
                   text:"时长："+timeLong+" 小时"
                   font.pixelSize: 20
                   font.family: "SimHei"
                   color: "#474747"
                   width: 200
                }
            }
            Text{
               id:place
               text: "地    点："+placeStr
               font.pixelSize: 20
               font.family: "SimHei"
               color: "#474747"
               width: 1200
               wrapMode: Text.WrapAnywhere
               elide: Text.ElideLeft
            }
            Text{
               id:reportReason
               text:"报备事由："+reason
               font.pixelSize: 20
               font.family: "SimHei"
               color: "#474747"
               width: 1200
               wrapMode: Text.WrapAnywhere
               elide: Text.ElideLeft
            }
            Row{
                spacing: 20
                width: parent.width
                height:photoDisplyView.visible ? 122 : 20// 121
                Text{
                   text: "照    片："
                   font.pixelSize: 20
                   font.family: "SimHei"
                   color: "#474747"
                   width:80
                }
                Rectangle {
                    //多张照片显示区域
                    id:zpRet
                    width: 900
                    height:photoDisplyView.visible ? 122 : 20
                    //color: 'black'
                    ListView {
                        id: photoDisplyView
                        visible: jsonModel.count>0 ? true : false
                        width: 880
                        height: 122
                        clip: true
                        spacing: 18
                        highlightMoveDuration: 1
                        orientation: ListView.Horizontal
                        snapMode: ListView.SnapOneItem
                        model: jsonModel
//                            ListModel {
//                            id: photoDisplyViewModel
//                            ListElement {
//                                photopath: ""
//                            }
//                        }
                        delegate:HLK_RadiusImage {
                            width:160
                            height: 121
                            imgSource:photopath

                            MouseArea{//放大所点击的图片
                                anchors.fill: parent
                                onClicked: {
                                    var path = photoDisplyViewModel.get(index).photopath
                                    doubleMax.imgPath= path
                                    doubleMax.maxVisble = true
                                    doubleMax.bgVisble = true

                                }
                            }
                        }
                    }
                    Text{
                       text: "无"
                       font.pixelSize: 20
                       font.family: "SimHei"
                       color: "#474747"
                       width:80
                       visible: !photoDisplyView.visible
                    }
                }
             }
            //审批
            Rectangle{
                height: 1
                width: 1200
                color: "#DCDCDC"
            }
            Rectangle {
                width: 1200
                id:approverRect
                height:55+approverOpinion.height
                visible:approval
               // color: "#00aecc"
                Text{
                   id:approverPerson
                   text:"审批人："+approverPer
                   font.pixelSize: 20
                   font.family: "SimHei"
                   color: "#474747"
                   width:1200
                   wrapMode: Text.WrapAnywhere
                   elide: Text.ElideLeft
                }

                Text{
                    y:40
                    id:approverOpinion
                    text:"审批意见："+approverOpi
                    font.pixelSize: 20
                    font.family: "SimHei"
                    color: "#474747"
                    width: 1200
                    wrapMode: Text.WrapAnywhere
                    elide: Text.ElideLeft
               }
             }
            Rectangle {
                width: 1200
                height:70
                visible:waitApprover
               // color: "#00aecc"
                Text{
                   y:20
                   text:"审批人："+approverPer
                   font.pixelSize: 20
                   font.family: "SimHei"
                   color: "#474747"
                   width:1000
                   wrapMode: Text.WrapAnywhere
                   elide: Text.ElideLeft
                }
                HLK_Button{
                       x:1088
                       y:12
                       width: 90
                       height:40
                       button_text: "撤回"
                       onClicked: {
                           emite:revokeAction()
                       }
                   }
             }
    }

}
    Image{
        x:1090
        y:20
        source:imageSource
    }
}

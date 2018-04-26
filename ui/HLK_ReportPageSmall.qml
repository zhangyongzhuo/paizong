import QtQuick 2.0

Rectangle {
    ///////////需要传参部分///////////////////////
    property string preparationText:""   //报备类型
    property string startTimeStr:""      //开始时间
    property string endTimeStr:""        //结束时间
    property string timeLong:""          //时长
    property string placeStr:""         //地点
    property string reason:""           //原因
    property string approverPer:""      //审批人
    property string approverOpi:"无"      //审批意见
    property string examineApproval:"400201"  //400201等待审批//400203审批通过//400202审批驳回
    property string modeStr:""  //json数组字符串
    property alias  withdraw:withdraw   //撤回按钮

    ////////////不需要传参部分/////////////////////
    property bool waitApprover:true     //等待审批矩形
    property bool approval:false        //审批通过和审批驳回矩形
    property string imageSource:"qrc:/images/images/ddsp.png"//照片默认等待审批
    property ListModel jsonModel : ListModel { ListElement{photopath:""} }
    width:  552
    height: 71+reportArea.height+approverArea.height

    Component.onCompleted: {
        if(examineApproval=='400201'){//等待审批
            waitApprover=true
            approval=false
            imageSource="qrc:/images/images/ddsp.png"
        }else if(examineApproval=='400203'){//审批通过
            waitApprover=false
            approval=true
            imageSource="qrc:/images/images/sptg.png"
        }else if(examineApproval=='400202'){//审批驳回
            waitApprover=false
            approval=true
            imageSource="qrc:/images/images/spbh.png"
        }

        //将modeStr转换成jsonModel
        jsonModel.clear()
        if(modeStr != ""){
            var obj = JSON.parse(modeStr)
            for(var i=0; i<obj.length; i++){
                jsonModel.append({photopath:obj[i]})
            }
        }
    }

    Rectangle {
        width:  552
        //首20+末20+分割线1+列布局两个间隔30=71
        //总高度=71+报备信息区+审批人信息区
        height: 71+reportArea.height+approverArea.height

        Rectangle{
            height: 1
            width: 552
            color: "#DCDCDC"
        }

        Column{
            y:20
            spacing: 15
            //报备信息显示区
            Flow{
                id:reportArea
                x:20
                spacing:15
                width: parent.width
                //前三行固定60+六个间隔90=150
                //总高度=150+报备地点高度+报备事由高度+照片高度
                height: 135+place.height+reportReason.height+photoView.height
                Text{
                    id:preparationType
                    text:"报备类型:"+ preparationText
                    font.pixelSize: 20
                    font.family: "SimHei"
                    color: "#00aecc"
                    width: 200
                }
                Text{
                    visible: false
                    text:"时长："+timeLong+" 小时"
                    font.pixelSize: 20
                    font.family: "SimHei"
                    color: "#474747"
                    width: 200
                }
                Text{
                    text:"开始时间:"+startTimeStr
                    font.pixelSize: 20
                    font.family: "SimHei"
                    color: "#474747"
                    width:parent.width
                }
                Text{
                    text:"结束时间:"+endTimeStr
                    font.pixelSize: 20
                    font.family: "SimHei"
                    color: "#474747"
                    width:parent.width
                }
                Text{
                    id:place
                    text: "地    点:"+placeStr
                    font.pixelSize: 20
                    font.family: "SimHei"
                    color: "#474747"
                    width: parent.width
                    wrapMode: Text.WrapAnywhere
                    elide: Text.ElideLeft
                }
                Text{
                    id:reportReason
                    text:"报备事由:"+reason
                    font.pixelSize: 20
                    font.family: "SimHei"
                    color: "#474747"
                    width: parent.width
                    wrapMode: Text.WrapAnywhere
                    elide: Text.ElideLeft
                }
                Text{
                   text: "照    片:"
                   font.pixelSize: 20
                   font.family: "SimHei"
                   color: "#474747"
                   width:80
                }
                Rectangle {
                    //多张照片显示区域
                    id:photoView
                    width: parent.width-100
                    height: photoDisplyView.visible ? 120 : 20
                    ListView {
                        id: photoDisplyView
                        visible: jsonModel.count>0 ? true : false
                        width: parent.width
                        height: 120
                        clip: true
                        spacing: 10
                        highlightMoveDuration: 1
                        orientation: ListView.Horizontal
                        snapMode: ListView.SnapOneItem
                        model: jsonModel
                        delegate:HLK_RadiusImage {
                            width:160
                            height: 120
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
            //报备与审批分割线
            Rectangle{
                height: 1
                width: 552-40
                color: "#EEEEEE"
                x:20
            }
            //审批人
            Rectangle{
                id:approverArea
                x:20
                width: parent.width
                height:approval ? 40+approverOpinion.height : 40
                Rectangle {
                    width: parent.width
                    visible:approval
                    Text{
                       text:"审 批 人:"+approverPer
                       font.pixelSize: 20
                       font.family: "SimHei"
                       color: "#474747"
                       width:parent.width
                       wrapMode: Text.WrapAnywhere
                       elide: Text.ElideLeft
                    }

                    Text{
                        y:40
                        id:approverOpinion
                        text:"审批意见:"+approverOpi
                        font.pixelSize: 20
                        font.family: "SimHei"
                        color: "#474747"
                        width:parent.width
                        wrapMode: Text.WrapAnywhere
                        elide: Text.ElideLeft
                   }
                }

                Rectangle {
                    width: parent.width
                    visible:waitApprover
                    Text{
                       y:8
                       text:"审批人："+approverPer
                       font.pixelSize: 20
                       font.family: "SimHei"
                       color: "#474747"
                       width:410
                       wrapMode: Text.WrapAnywhere
                       elide: Text.ElideLeft
                    }
                    HLK_Button{
                        id:withdraw
                        x:420
                        width: 90
                        height:40
                        button_text: "撤回"
                    }
                }
            }
        }
    }
    Image{
        x:410
        y:10
        source:imageSource
    }
}



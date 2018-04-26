import QtQuick 2.4
import QtMultimedia 5.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0


//添加子户页
Item {
    width: 1070
    height: 90+wholeRoomView.height
    property alias wholeRoomView:wholeRoomView
   // property alias model_t:model_t
    property alias addRoom:addRoom
    property alias wholeRoomModel:wholeRoomModel
    property alias messagebox: messagebox

   /* MouseArea {
        anchors.fill: parent
        onClicked: {
            emit: componentRecovery()
        }
    }*/

 Rectangle {
     anchors.fill: parent
     color: "#FFFFFF"
    HLK_Button{
        id:addRoom
        x:20
        y:20
        button_text:"+ 添加户"
        width:143
        height:50
        enabled: PAGEMODE == QmlData.VISIT_TYPE_SEE?false:true
    }

    ListView {
        id: wholeRoomView
        x: 0
        y: 90
        width: 1070
        height: 0
        clip: true
        //orientation: ListView.vertical
        spacing:0
        model: wholeRoomModel
        delegate:HLK_WholeRoom{
            textOne:"户"+index
            textTwo:"整户离住"
            json:roomJson
            roomDelVisible:PAGEMODE == QmlData.VISIT_TYPE_SEE?false:true
            isvisible:PAGEMODE == QmlData.VISIT_TYPE_SEE?false:true
            addButtonEnable: PAGEMODE == QmlData.VISIT_TYPE_SEE?false:true
            imageButtonEnable:PAGEMODE == QmlData.VISIT_TYPE_SEE?false:true
            onDeleteWholeRoom: {
                wholeRoomModel.remove(index)
                var temp=wholeRoomModel.count*270
                if(wholeRoomModel.count<3){
                    if(wholeRoomModel.count==0){
                     //emit:roomLoadFinish(90)
                     PAGEHEIGHT=90
                     wholeRoomView.height=0
                    }else{
                        wholeRoomView.height=temp
                        PAGEHEIGHT=temp+90
                    }
                }
            }
            onAddRoomPerson: {
                relationship="户"+index
                emit: addBtnClicked(PAGENAME)
                //emit: roomAddBtnClicked(index,PAGENAME)
                console.log(index + "--------------------")
            }
            onDeleteEveryPerson:{
                var tempList=[]
                var oldlist=[]
                if(index==0){
                    oldlist=JSON.parse(wholeRoomModel.get(0).roomJson)
                    for(var i=0;i<oldlist.length;i++){
                        if(dex!=i){
                            tempList.push(oldlist[i])
                        }
                    }
                    wholeRoomModel.get(0).roomJson=JSON.stringify(tempList)
                }else if(index==1){
                    oldlist=JSON.parse(wholeRoomModel.get(1).roomJson)
                    for(var i=0;i<oldlist.length;i++){
                        if(dex!=i){
                            tempList.push(oldlist[i])
                        }
                    }
                    wholeRoomModel.get(1).roomJson=JSON.stringify(tempList)
                }
                else if(index==2){
                    oldlist=JSON.parse(wholeRoomModel.get(2).roomJson)
                    for(var i=0;i<oldlist.length;i++){
                        if(dex!=i){
                            tempList.push(oldlist[i])
                        }
                    }
                    wholeRoomModel.get(2).roomJson=JSON.stringify(tempList)
                }else if(index==3){
                    oldlist=JSON.parse(wholeRoomModel.get(3).roomJson)
                    for(var i=0;i<oldlist.length;i++){
                        if(dex!=i){
                            tempList.push(oldlist[i])
                        }
                    }
                    wholeRoomModel.get(3).roomJson=JSON.stringify(tempList)
            }else if(index==4){
                oldlist=JSON.parse(wholeRoomModel.get(4).roomJson)
                for(var i=0;i<oldlist.length;i++){
                    if(dex!=i){
                        tempList.push(oldlist[i])
                    }
                }
                wholeRoomModel.get(4).roomJson=JSON.stringify(tempList)
                }
            }
        }
      }
    }

    //戶
    ListModel {
        id: wholeRoomModel
        ListElement {
            WholeRoomJson:""
            roomJson:""
        }
    }

    //人
    /*ListModel {
         id: model_t
         ListElement {
             IMG: ""
             ROW1: ""
             ROW2: ""
             ROW3: ""
             relationJson: ""
         }
     }*/

     HLK_MessageBox {
         id: messagebox
     }
}

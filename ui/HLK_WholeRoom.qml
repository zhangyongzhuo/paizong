import QtQuick 2.4
import "qrc:/base/js/jsonpath.js" as JSONPath
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL

Rectangle{
    property bool addButtonEnable: true
    property bool imageButtonEnable:true
    property string textOne: ""
    property string textTwo: ""
    property string appendOrInsert: 'append'
    property string json: ""
    property string query: ""
    //数据装载完成事件
    property bool load: false
    property bool isvisible:true
    property bool roomDelVisible:true
    property ListModel model : ListModel { id: jsonModel }
   // property var  roomModel
    signal deleteWholeRoom()
    signal deleteEveryPerson(int dex)
    //signal deleteWholeRoom()
    signal addRoomPerson()

    width: 1070
    height: 270
    color: "#FFFFFF"
    Component.onCompleted: {
        jsonModel.clear()
    }
    onJsonChanged: updateJSONModel()
    onQueryChanged: updateJSONModel()

    function updateJSONModel() {
        jsonModel.clear();

        if ( json === "" )
            return;

        var objectArray = parseJSONString(json, query);

        if(objectArray != null){
            if(appendOrInsert == 'append'){
                //console.log(objectArray.length)
                for ( var i=0; i<objectArray.length; i++ ) {
                    //console.log(JSON.stringify(objectArray[i]))
                    jsonModel.append( objectArray[i] );
                }
            }
            else if(appendOrInsert == 'insert'){
                for ( i=objectArray.length-1; i>=0; i-- ) {
                    jsonModel.append( objectArray[i] );
                }
            }

            load = true
        }
    }
    function parseJSONString(jsonString, jsonPathQuery) {
        var objectArray = JSON.parse(jsonString);

        if ( jsonPathQuery !== "" )
            objectArray = JSONPath.jsonPath(objectArray, jsonPathQuery);

        return objectArray;
    }

    Rectangle {
        x:20
        y:0
        width: 1130
        height: 30
        color: "#e5e5e5"
    }
    Rectangle{
        x:20
        y:1
        width:1050
        height:70

        Text {
            font.family: "SimHei"
            font.pixelSize: 20
            color: "#a1a1a1"
            text:textOne
            anchors.verticalCenter: parent.verticalCenter
        }
        /*Text {
            anchors.right: deleteBtn.left
            anchors.rightMargin: 10
            font.family: "SimHei"
            font.pixelSize: 20
            color: "#474747"
            text:textTwo
            anchors.verticalCenter: parent.verticalCenter
        }
        HLK_ImageButton{
            id:deleteBtn
            anchors.right:parent.right
            anchors.rightMargin: 20
            imagePath: "qrc:/images/images/zhlz.png"
            imagePressePath:"qrc:/images/images/zhlz.png"
            button_width:20
            button_height:20
            enabled:imageButtonEnable
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                emit: deleteWholeRoom()
            }
        }*/
        HLK_ImageTextBtn{
             id:deleteBtn
             anchors.right:parent.right
             anchors.rightMargin: 20
             anchors.verticalCenter: parent.verticalCenter
             visible: roomDelVisible
             onClicked: {
                 emit: deleteWholeRoom()
             }
        }

    }
    Rectangle {
        id: roomInfo
        x: 20
        y: 71
        width:1050
        height:180
        color: "#FFFFFF"
        HLK_AddButton {
            id: addRoomInfoBtn
            width: 143
            height: 180
            imgPath: "qrc:/images/images/renyuan.png"
            enabled:addButtonEnable
            onClicked: {
                emit: addRoomPerson()               
            }

        }
        ListView {
            id: roomInfoView
            x: addRoomInfoBtn.x + addRoomInfoBtn.width + 20
            y: addRoomInfoBtn.y
            clip: true
            width: 870
            height: 180 //flagModel.count>4 ? 200 : 100
            orientation: ListView.Horizontal
            spacing: 20
            visible: true
            highlightMoveDuration: 1
            snapMode: ListView.SnapOneItem
            model: jsonModel
            delegate: HLK_NormalInfo {
                image:roomInfoView.model.get(index).IMG
                row1: roomInfoView.model.get(index).ROW1
                row2: roomInfoView.model.get(index).ROW2
                row3: roomInfoView.model.get(index).ROW3
                //model: infoModel
                delvisible: isvisible
                enabled: true//isEnabled
                lineSpacing: 25
                onDeleteButtonClicked:{
                     //jsonModel.remove(index)
                     emit: deleteEveryPerson(index)
                }
            }
        }

    }
//        ListModel {
//             id: jsonModel
//             ListElement {
//                 IMG: ""
//                 ROW1: ""
//                 ROW2: ""
//                 ROW3: ""
//                 relationJson: ""
//             }
//        }

}

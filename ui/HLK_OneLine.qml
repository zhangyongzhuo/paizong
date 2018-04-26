import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL
Button{
    width:320
    height: 100
    property string image: ""
    property string row1: ""
    property string row2: ""
    property bool   isShowText:false
    property int imgwidth: 100
    property int imgheight:100
    property int topdistance:0
    property bool columnOne:true
    property bool columnTwo:false
    property string faceRecognitionUrl:""
    property bool isexit:true

    Component.onCompleted: {
        var text=row1       
       // console.log("============"+text)
        if(JSL.getByteLen(text)>16){
         //   console.log("============"+text.substring(0,7))
         //   console.log("============"+text.substring(8,text.length-1))
            columnOne=false
            columnTwo=true
            for(var i=0;i<text.length;i++){
                var tmp=text.substring(0,i)
                if(JSL.getByteLen(tmp)>16&&isexit){
                    row1=text.substring(0,i-1)
                    row2=text.substring(i-1,text.length)
                    isexit=false
                }
            }
        }else{
            columnOne=true
            columnTwo=false
        }
    }
    style: ButtonStyle{
        background:
            Rectangle{
            color:"#ededee"
            radius: 10
            Image {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: topdistance
                width: imgwidth
                height: imgheight
                cache: false
                source:image
                visible: !isShowText
                verticalAlignment:Image.AlignVCenter
            }
            Column {
                //id:columnOne
                visible:columnOne
                anchors.top: parent.top
                anchors.topMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 120
//                spacing: lineSpacing
                Text{
                   // anchors.horizontalCenter: parent.horizontalCenter
                    width:200
                    height: 100
                    font.family: "SimHei"
                    font.pixelSize: 22
                    color: "#474747"
                    text: row1
                }
            }
            Column {
               // id:columnTwo
                visible:columnTwo
                anchors.top: parent.top
                anchors.topMargin: 25
                anchors.left: parent.left
                anchors.leftMargin: 120
                spacing: 10
//                spacing: lineSpacing
                Text{
                   // anchors.horizontalCenter: parent.horizontalCenter
                    width:200
                  //  height: 50
                    font.family: "SimHei"
                    font.pixelSize: 22
                    color: "#474747"
                    text: row1
                }
                Text{
                   // anchors.horizontalCenter: parent.horizontalCenter
                    width:200
                   // height: 50
                    font.family: "SimHei"
                    font.pixelSize: 22
                    color: "#474747"
                    text: row2
                }
            }
         }
    }
    onClicked: {
        //faceRecognitionUrl = operateconfigfile.getUrlOne()
        Qt.openUrlExternally(faceRecognitionUrl)
    }

}

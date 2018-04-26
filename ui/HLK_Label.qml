import QtQuick 2.4
import QtMultimedia 5.4
import "qrc:/controls/ui"
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Image {
    property string label_text: ""
    property string label_color: "#F8A053"
    property int btnWidth: 180//max width
    width: getFlagWidth()
    height: 40
    source: label_color=="#F8A053" ? "qrc:/images/images/biaoqian.png" : "qrc:/images/images/biaoqian2.png"
    Text{
        color: label_color
        text: getFlagText()
        font.pixelSize: 20
        font.family: "黑体"
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
    function getFlagWidth(){
        switch(label_text.length){
        case 0:
        case 1:
        case 2:
        case 3: return 120
        case 4: return 140
        case 5: return 160
        case 6: return 180
        default: return 180
        }
    }
    function getFlagText(){
        if(label_text.length>6){
            return label_text.substring(0,6)
        }else{
            return label_text
        }
    }
}


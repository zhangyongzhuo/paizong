import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL

Item {
    property string progress_text:""//文字可设置
    property int height_length:0 //竖条长度及最右侧扩容图标长度可设置
    property bool topimgvisible:true//上半部分竖条隐藏或显示可设置
    property bool bottomimgvisible: true
    property int imgnum:0//圆形图标可设置
    //0完成 1未完成 2当前 3不是当前 4是图标1 5是图标2 6是图标3 7是图标4 8是图标5 9是图标6 10是图标7

    property string current_color: "#F8A053"
    property string unfinish_color: "#9D9D9D"
    property string themeColor: JSL.themeColor()
    Rectangle {
        id:prorectangle
        width: 120
        height: height_length
        color:"#00000000"
        Text{
            x:prorectangle.x+5
            wrapMode: Text.WordWrap
            width:5
            color:{
                switch(imgnum)
                {
                case 0:
                    themeColor
                    break;
                case 2:
                    current_color
                    break;
                default:
                    unfinish_color
                    return;
                }
            }
            text:progress_text
            font.pixelSize: 20
            font.family: "黑体"
            anchors.verticalCenter: prorectangle.verticalCenter
        }


        Rectangle{
            id:topimg
            x:prorectangle.x+50
            y:prorectangle.y
            width:5
            visible: topimgvisible
            color:{
                switch(imgnum)
                {
                case 0:
                    themeColor
                    break;
                case 2:
                    themeColor
                    break;
                default:
                    unfinish_color
                    return;
                }
            }

            height:(height_length-20)/2-22
        }
        Image{
            id:centerimg
            x:prorectangle.x+34
            y:topimg.y+topimg.height+3
            source: {
                switch(imgnum)
                {
                case 0:
                    "qrc:/images/images/center_right.png"
                    break;
                case 2:
                    "qrc:/images/images/center_current.png"
                    break;
                case 5:
                    "qrc:/images/images/center_2.png"
                    break;
                case 6:
                    "qrc:/images/images/center_3.png"
                    break;
                case 7:
                    "qrc:/images/images/center_4.png"
                    break;
                case 8:
                    "qrc:/images/images/center_5.png"
                    break;
                case 9:
                    "qrc:/images/images/center_6.png"
                    break;
                case 10:
                    "qrc:/images/images/center_7.png"
                    break;
                default:
                    return;
                }
            }

        }

        Rectangle{
            id:bottomimg
            x:prorectangle.x+50
            y:centerimg.y+40
            visible: bottomimgvisible
            width:5
            color:{
                switch(imgnum)
                {
                case 0:
                    themeColor
                    break;
                default:
                    unfinish_color
                    return;
                }
            }
            height:(height_length-20)/2-2
        }

        Rectangle{
            id:expansiontop
            x:prorectangle.x+92
            y:prorectangle.y+10
            width:2
            color:{
                switch(imgnum)
                {
                case 0:
                    themeColor
                    break;
                case 2:
                    current_color
                    break;
                default:
                    unfinish_color
                    return;
                }
            }
            height:(height_length-20)/2-22
        }
        Image{
            id:expansioncenter
            x:prorectangle.x+75
            y:topimg.y+topimg.height+3
            source:{
                switch(imgnum)
                {
                case 0:
                    "qrc:/images/images/blue.png"
                    break;
                case 1:
                    "qrc:/images/images/gray.png"
                    break;
                case 2:
                    "qrc:/images/images/orange.png"
                    break;
                default:
                    "qrc:/images/images/gray.png"
                    return;
                }
            }
        }

        Rectangle{
            id:expansionbottom
            x:prorectangle.x+92
            y:centerimg.y+35
            width:2
            color:{
                switch(imgnum)
                {
                case 0:
                    themeColor
                    break;
                case 2:
                    current_color
                    break;
                default:
                    unfinish_color
                    return;
                }
            }
            height:(height_length-20)/2-22
        }
    }

}


import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import "qrc:/base/js/common.js" as JSL

Item {
    property int    ctrlHeight:10                    //进度条高度
    property string ctrlText: ""                    //进度条标题
    property int    ctrlIcon: 1                    //进度条图标   0完成 1未完成; 2-10代表图标2-10，依次类推
    property bool   ctrlTopLine:   false            //进度条粗线上半部分
    property bool   ctrlBottomLine: false           //进度条粗线下半部分
    property string finishColor: JSL.themeColor()   //完成颜色
    property string currentColor: "#F8A053"         //当前颜色
    property string unusedColor:  "#D6D6D6"         //未使用颜色

    Rectangle{
        height: ctrlHeight
        width: 120
        color: "#00000000"

        Text{ //标题
            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.verticalCenter: parent.verticalCenter
            wrapMode: Text.WordWrap
            width: 5
            text: ctrlText
            font.pixelSize: 20
            font.family: "SimHei"
            color:{
                switch(ctrlIcon)
                {
                case 0:
                    finishColor
                    break;
                case 1:
                    currentColor
                    break;
                default:
                    unusedColor
                    return;
                }
            }
        }

        Rectangle{ //粗线上半部分
            anchors.left: parent.left
            anchors.leftMargin: 45
            width: 5
            height:(ctrlHeight-20)/2-2
            visible: ctrlTopLine
            color:{
                switch(ctrlIcon)
                {
                case 0:
                    finishColor
                    break;
                case 1:
                    currentColor
                    break;
                default:
                    unusedColor
                    return;
                }
            }
        }

        Image{ //圆
            id: circleImg
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.verticalCenter: parent.verticalCenter
            source: {
                switch(ctrlIcon)
                {
                case 0:
                    "qrc:/images/images/center_right.png"
                    break
                case 1:
                    "qrc:/images/images/center_current.png"
                    break
                case 2:
                    "qrc:/images/images/center_2.png"
                    break
                case 3:
                    "qrc:/images/images/center_3.png"
                    break
                case 4:
                    "qrc:/images/images/center_4.png"
                    break
                case 5:
                    "qrc:/images/images/center_5.png"
                    break
                case 6:
                    "qrc:/images/images/center_6.png"
                    break
                case 7:
                    "qrc:/images/images/center_7.png"
                    break
                default:
                    return
                }
            }

        }

        Rectangle{//粗线下半部分
            anchors.left: parent.left
            anchors.leftMargin: 45
            y: (ctrlHeight-20)/2+circleImg.height-10
            visible: ctrlBottomLine
            height:(ctrlHeight-20)/2-2+20
            width: 5
            color:{
                switch(ctrlIcon)
                {
                case 0:
                    finishColor
                    break;
                case 1:
                    currentColor
                    break;
                default:
                    unusedColor
                    return;
                }
            }
        }

        Rectangle{//细线上半部分
            anchors.right: parent.right
            anchors.rightMargin: 25
            width:2
            height:(ctrlHeight-20)/2-5
            color:{
                switch(ctrlIcon)
                {
                case 0:
                    finishColor
                    break;
                case 1:
                    currentColor
                    break;
                default:
                    unusedColor
                    return;
                }
            }
        }
        Image{//三角
            id: triangleImg
            anchors.right: parent.right
            anchors.rightMargin: 25
            anchors.verticalCenter: parent.verticalCenter
            source:{
                switch(ctrlIcon)
                {
                case 0:
                    "qrc:/images/images/blue.png"
                    break
                case 1:
                    "qrc:/images/images/orange.png"
                    break
                default:
                    "qrc:/images/images/gray.png"
                    return
                }
            }
        }

        Rectangle{////细线下半部分
            anchors.right: parent.right
            anchors.rightMargin: 25
            y: (ctrlHeight-20)/2+triangleImg.height-10
            width: 2
            height: (ctrlHeight-20)/2-5
            color:{
                switch(ctrlIcon)
                {
                case 0:
                    finishColor
                    break;
                case 1:
                    currentColor
                    break;
                default:
                    unusedColor
                    return;
                }
            }
        }
    }
}




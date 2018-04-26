import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL

Item {
    id: root

    property bool order: false//数字顺序列表
    property int orderStartNum: 1

    property int initIndex:0

    property alias model: myPathView.model
    property alias count: myPathView.count
    property alias unitText:unit.text

    signal valueChanged(var index,var value)
    property string themeColor: JSL.themeColor()
    property int fontSize:30
    property string textColor:"#3e6792"//"white"
    property string highlightColor:themeColor//"#0099ff"
    property int unitLeftMargin:-50


    PathView{
        id:myPathView
        anchors.fill: parent
        currentIndex:initIndex
        delegate:HLK_TimePathItem{
            width:root.width/2
            height:root.height/myPathView.pathItemCount
            onSelected: {
                //--执行内部算法，寻找最短路径（时间开销依据处理器性能）
                //--在此过程中 currentIndex 值不确定，不可以用作处理
                myPathView.currentIndex = index

                //--发出信号
                var outValue = order?orderStartNum+index:
                                      myPathView.model[index];
                valueChanged(index,outValue);
            }
        }

        pathItemCount: 5;
        preferredHighlightBegin: 0.5;
        preferredHighlightEnd: 0.5;
        highlightMoveDuration:1
        highlightRangeMode: PathView.StrictlyEnforceRange;
        //flicking:true
        //moving : true

        //交互属性，支持拖动等……
        interactive: true
        //滑动速度
        maximumFlickVelocity:1000

        onMovementEnded: {
            //--发出信号
            //console.log("Math.cos(1/4) = "+Math.cos(1/4));
            var outValue = order?orderStartNum+myPathView.currentIndex:
                                  myPathView.model[myPathView.currentIndex];
            valueChanged(myPathView.currentIndex,outValue)
            //console.log("onMovementEnded ",myPathView.currentIndex)
            positionViewAtIndex(myPathView.currentIndex, PathView.Center)
        }

        path :pathVertical

        Path{//------------垂直变化------------
            id:pathVertical
            property int height: root.height
            startX: root.width/2

            PathLine { x: pathVertical.startX; y: pathVertical.startY; }
            PathAttribute { name: "iconZ"; value: 1 }
            PathAttribute { name: "iconScale"; value: 0.6 }
            PathAttribute { name: "iconOpacity"; value: 0.3 }
            PathAttribute { name: "iconAngle"; value: 80  }
            PathPercent { value: 0 }

            // start scaling up
            PathLine { x: pathVertical.startX; y: pathVertical.startY+ pathVertical.height * Math.cos(1/4); }
            PathAttribute { name: "iconZ"; value: 2 }
            PathAttribute { name: "iconScale"; value: 0.8 }
            PathAttribute { name: "iconOpacity"; value: 0.4 }
            PathAttribute { name: "iconAngle"; value: 50  }
            PathPercent { value: 1/8 }

            // middle point
            PathLine {
                x: pathVertical.startX;
                y: pathVertical.startY + pathVertical.height * Math.cos(1/4) ; }
            PathAttribute { name: "iconZ"; value: 5 }
            PathAttribute { name: "iconScale"; value: 1.0 }
            PathAttribute { name: "iconOpacity"; value:1.0 }
            PathAttribute { name: "iconAngle"; value: 0  }
            PathPercent { value: 4/8}

            // start scaling down
            PathLine { x:pathVertical.startX; y: pathVertical.startY + pathVertical.height *Math.cos(1/4); }
            PathAttribute { name: "iconZ"; value: 2 }
            PathAttribute { name: "iconScale"; value: 0.8}
            PathAttribute { name: "iconOpacity"; value: 0.4 }
            PathAttribute { name: "iconAngle"; value: -50  }
            PathPercent { value: 7/8 }

            // last point
            PathLine { x:  pathVertical.startX; y: pathVertical.startY + pathVertical.height*Math.cos(1/4); }
            PathAttribute { name: "iconZ"; value: 1 }
            PathAttribute { name: "iconScale"; value: 0.6 }
            PathAttribute { name: "iconOpacity"; value:0.3 }
            PathAttribute { name: "iconAngle"; value: -80  }
            PathPercent { value: 1}
            }

    }//PathView

    Text{
        id:unit
        anchors.verticalCenter: myPathView.verticalCenter
        anchors.verticalCenterOffset: -5
        anchors.left: myPathView.right
        anchors.leftMargin:unitLeftMargin
        //text:qsTr("年")
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 32
        color:highlightColor
        font.bold: true
    }


}

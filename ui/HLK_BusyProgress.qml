import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

    ProgressBar {
        x: 10
        y: 100
        property string rectangle:""
        id:progressBar4
        width: 850;
        height: 50;
        value: 0;
        property color colorValue: Qt.rgba(37/255, 177/255, 232/255, 1);
        style: ProgressBarStyle{
            id:progressBar4Style
            background: Rectangle{
                border.width: 1;
                border.color: "#00000000"
                //border.color: "#25b1e8"
                //border.color: control.hovered?"green":"#25b1e8";
                //border.color: control.hovered?JSL.themeColor():"#00000000"
            }
            progress: Rectangle{
                color:JSL.themeColor()
                onColorChanged: {
                    console.log("onColorChanged")
                }
            }
            panel: Item{
                implicitHeight: 20;
                implicitWidth: 200;
                Loader{
                    anchors.fill: parent;
                    sourceComponent: background;
                }
               Loader{
                   anchors.top: parent.top;
                   anchors.left: parent.left;
                   anchors.bottom: parent.bottom;
                   anchors.margins: 2;
                   width: currentProgress * (parent.width - 4)
                   sourceComponent: progressBar4Style.progress;
                       onWidthChanged: {
                           console.log("onWidthChanged")
                           progressBar4.colorValue = Qt.rgba(1-currentProgress, 1-currentProgress, 1-currentProgress, 1)
                       }
                }
               Text {
                   anchors.right: parent.right;
                   anchors.rightMargin: 5;
                   anchors.verticalCenter: parent.verticalCenter;
                   text: rectangle=Math.round(currentProgress*100) + "%";
                   color: "#25b1e8"
                   visible: false
               }

            }
        }
    }



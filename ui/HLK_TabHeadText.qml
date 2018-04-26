import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL

Text {
    property string fontText: ""          //显示文字
    property int    fontSize: 22          //字号
    property string fontColor:"#9D9D9D"   //颜色
    property int    fontWidth: 180        //长
    property int    fontHeight: 60        //

    width: fontWidth
    height: fontHeight

    text: fontText
    color: fontColor
    font.pixelSize: fontSize

    wrapMode: Text.Wrap

    font.family: "SimHei"
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
}

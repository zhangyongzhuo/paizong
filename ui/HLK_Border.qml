import QtQuick 2.0
import QtGraphicalEffects 1.0
import "qrc:/base/js/common.js" as JSL

Rectangle {
    property string bg_color: "#99ffffff"
    property string bd_color: "#ffffff"
    property int    bd_width: 2
    property string themeColor: JSL.themeColor()
    property bool   bHightLight: false
    width: 470
    height: 300
    color: bg_color
    border.color: bHightLight ? themeColor : bd_color
    border.width: bd_width
    radius: 10
    layer.enabled: bHightLight
    layer.effect: DropShadow {
        transparentBorder: true
        color: themeColor
        radius:  8
        samples: 16
    }
}

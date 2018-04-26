import QtQuick 2.0

//通用字体组件
Text {
    property int textHeight: 50
    property int textWidth: 100
    property int textSize: 20
    property string textContent: ''
    property string textColor: '#343434'
    property string textFamily: 'SimHei'

    width: textWidth
    height: textHeight
    font.family: textFamily
    font.pixelSize: textSize
    color: textColor
    text: textContent
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
}

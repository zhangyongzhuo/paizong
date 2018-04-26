import QtQuick 2.4
import "qrc:/controls/ui/"
import QtQuick.Controls 1.2
import QtMultimedia 5.4
import QtQuick.Controls.Styles 1.2
import QtGraphicalEffects 1.0

Rectangle{
    property int imgWidth: 160
    property int imgHeight: 121
    property int imgRadius: 10
    property bool imgVisible: true
    //property int imgColor: '#FFFFFF'
    property string imgSource: 'qrc:/images/images/zhaopian.png'

    width:imgWidth
    height:imgHeight
    radius: imgRadius
    visible: imgVisible
    Image {
        id:_image
        visible: false
        smooth: true
        anchors.fill: parent
        sourceSize: Qt.size(parent.size, parent.size)
        cache: false
        source: imgSource
    }

    Rectangle {
        id: _mask
        color: "black"
        anchors.fill: parent
        radius: 10
        visible: false
        smooth: true
    }

    OpacityMask {
        id: mask_image
        cached : true
        anchors.fill: _image
        source: _image
        maskSource: _mask
        visible: true
        antialiasing: true
    }
}

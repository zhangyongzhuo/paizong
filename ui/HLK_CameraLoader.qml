import QtQuick 2.4
import QtQuick.Controls 1.4
import QtMultimedia 5.4

Loader {
    id: loader
    width: 640 // --sunpeng
    height: 480 // --sunpeng

    property int initCamera:0

    signal itemLoaded(Camera cam)

    Component.onCompleted: {
        tm.start()
    }

    BusyIndicator{
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        running: loader.status != Loader.Ready
    }

    asynchronous: true

    onLoaded: {
        item.initCamera = loader.initCamera
        itemLoaded(item.camera)

    }

    Timer{
        id: tm
        interval: 400
        onTriggered: {
            loader.source = "qrc:/controls/ui/HLK_Camera.qml"
        }
    }    
}

import QtQuick 2.4
import QtQuick.Controls 1.4
import QtMultimedia 5.4

Loader {
    id: loader
    width: 640
    height: 480
    asynchronous: true

    property int initCamera:0
    signal itemLoaded(Camera cam)

    Component.onCompleted: {
        tm.start()
    }

    onLoaded: {
        item.initCamera = loader.initCamera
        emit: itemLoaded(item.camera)
    }

    BusyIndicator{
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        running: loader.status != Loader.Ready
    }

    Timer{
        id: tm
        interval: 400
        onTriggered: {
            loader.source = "qrc:/controls/ui/HLK_CameraVideo.qml"
        }
    }
}

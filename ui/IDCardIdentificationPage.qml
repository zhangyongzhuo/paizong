import QtQuick 2.4
import QtMultimedia 5.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/singleFunction/ui"
import "qrc:/base/js/common.js" as JSL
import "qrc:/collectJson/js/PublicDataJson.js" as PublicDataJson

IDCardIdentificationPageForm {
    property var pageDataJsonObject:PublicDataJson.getIdcardJson()

    property bool bCameraPreview: true;
    property Camera camera: null


    Audio{
        id: readCardSound
        source: "qrc:/sounds/sounds/readCard.wav"
    }

    Component.onCompleted: {
        shot.visible = true
        //将配置文件中的默认摄像头传给loader
        cameraLoader.initCamera=operateconfigfile.getCameraInitNum()
    }

    cameraLoader.onItemLoaded: {
        camera = cam
        //加载完摄像头后 将其切换到默认摄像头
        camera.deviceId=QtMultimedia.availableCameras[cameraLoader.initCamera].deviceId
        startCam()
        //startShot()

    }
    back.onClicked: {
        getFocus.focus = true
        if(back.enabled==false){
            messagebox.text = "正在识别，请稍候..."
            messagebox.visible = true
        }        
    }
    finish.onClicked:{
        getFocus.focus = true
        if(!JSL.isCardNo(cardInfo_idcard.text)){
            messagebox.visible = true
            messagebox.text = "身份证号格式不正确"
            return
        }

        pageDataJsonObject.photo  = faceImg.source.toString()
        pageDataJsonObject.idcard = cardInfo_idcard.text
        pageDataJsonObject.name   = cardInfo_name.text
        pageDataJsonObject.sex    = cardInfo_sex.text
        pageDataJsonObject.nation = cardInfo_nation.text
        pageDataJsonObject.birth  = cardInfo_birth.text
        pageDataJsonObject.address= cardInfo_address.text

        console.log('---二代证OCR界面:'+pageDataJsonObject.photo)

        emit: idcardDentificationFinish(pageDataJsonObject) //身份证信息采集成功
        stackView.pop()
    }

    Connections{
        target: camera.imageCapture
        onImageSaved: {
            back.enabled = false
            idcardIndicator.running = true
            var blur = operateconfigfile.getCameraBlur()        // --sunpeng
            ocrdectect.startOcrIdcardOrBlurDetect(OcrIdcardOrBlurDetect.EOPERATE_TYPE_ALL, path, path, blur)    // --sunpeng
        }
    }

    //拍照按钮点击
    shot.onClicked: {
        getFocus.focus = true

        if(bCameraPreview){
            startShot()
        }
        else{
            startCam()
            startShot()
        }
    }
    //唤醒摄像头
    function startCam(){
        bCameraPreview = true
        camera.start()
    }

    //执行拍照动作
    function startShot(){
        cardInfo_name.text =""
        cardInfo_birth.text = ""
        cardInfo_address.text =""
        cardInfo_idcard.text =""
        cardInfo_nation.text = ""
        cardInfo_sex.text = ""
        faceImg.source = "qrc:/images/images/sfzn.png"
        //camera.imageCapture.captureToLocation(qmlData.makeRootDir()+"/../app-data/CollectData"+"/idcard")
        camera.imageCapture.captureToLocation(documentDir+"/idcard")
        bCameraPreview = false
    }

    Connections{
        target: ocrdectect
        onOcrIdcardOrBlurDetectFinished:{
            back.enabled = true
            idcardIndicator.running = false
            shot.visible = true
            if(ret== OcrIdcardOrBlurDetect.EFACE_RET_SUCCESS ){
                readCardSound.play()
                var TemJson = JSON.parse(ocrIdInfo);
                //qmlData.copyFileToPath(qmlData.makeRootDir()+"/../app-data/CollectData"+"/idcard.jpg",documentDir+"/idcard.jpg",true)
                if(TemJson.name != undefined){
                    cardInfo_name.text =TemJson.name
                    cardInfo_birth.text = TemJson.birth
                    cardInfo_address.text =TemJson.address
                    cardInfo_idcard.text =TemJson.idcard
                    cardInfo_nation.text = TemJson.nation
                    cardInfo_sex.text = TemJson.sex
                }

                if(TemJson.photopath != undefined){
                    //console.log('识别到的身份证照片:'+TemJson.photopath)
                    faceImg.source = ""
                    faceImg.source = "file:///" + TemJson.photopath
                    //faceImg.source ="file:///"+documentDir+"/idcard.jpg"
                }
                else{
                    //console.log('识别到的身份证照片：undefined')
                }

            }else if(ret==OcrIdcardOrBlurDetect.EFACE_RET_ERROR){
                readCardSound.play()
                messagebox.text = "身份证识别错误"
                messagebox.visible = true
            }else if(ret==OcrIdcardOrBlurDetect.EFACE_RET_BLUR){
                startShot()
            }
        }
    }

    cardInfo_idcard.onCursorVisibleChanged: {
        if(!isX6){
            cardInfo_idcard.cursorVisible ? digiBoard.visible=true : digiBoard.visible=false
        }
    }

    Connections{
        target: mainQml

        onDigiTextChange: {
            if(cardInfo_idcard.cursorVisible){
                cardInfo_idcard.text += text
            }
        }
        onDigiTextDel: {
            if(cardInfo_idcard.cursorVisible){
                cardInfo_idcard.text = cardInfo_idcard.text.substring(0, cardInfo_idcard.text.length-1)
            }
        }
    }
}

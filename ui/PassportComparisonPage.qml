import QtQuick 2.4
import "qrc:/base/js/common.js" as JSL
import com.hylink.fmcp.ctrl 2.0
import "qrc:/collectJson/js/PublicDataJson.js" as PublicJson
//import "qrc:/cascade/uiX6"

/*****************该页面为护照比对界面****************************/
//反恐利剑中使用
//passportphoto  护照头像
//face_preview   人脸
    PassportComparisonPageForm {
        property var pageDataJsonObject:PublicJson.getFaceInfoJson()
        property string passportphoto:""
        property string idcardphoto:""
        property string savePath: "" // 照片存储路径

        Component.onCompleted: {
            //瀑布流传递过来的初始化值
            if(PAGEDATA != undefined){
//                console.log("护照瀑布流"+PAGEDATA)
                pageDataJsonObject=JSON.parse(PAGEDATA)
                 face_preview.source=getPhotoPath(pageDataJsonObject.photoPath)
                 var ret = pageDataJsonObject.cardCompareResults
                 if(ret == CompareOrDetectFace.EFACE_RET_PASS){
                     isShowRowone = true
                     rowone = "身份证比对通过"
                     cardCompare.source="qrc:/images/images/yes.png"
                     cardColor = "green"
                 }
                 else if(ret == CompareOrDetectFace.EFACE_RET_NOPASS){
                     isShowRowone = true
                     rowone="身份证比对不通过"
                     cardCompare.source="qrc:/images/images/no.png"
                     cardColor = "red"
                 }
                 else if(ret == CompareOrDetectFace.EFACE_RET_ERROR){
                     isShowRowone = true
                     rowone="身份证比对错误"
                     cardCompare.source="qrc:/images/images/no.png"
                     cardColor = "red"
                 }
                 else{
                     //未比对
                     isShowRowone = false
                     console.log('身份证未比对')
                 }

                 ret = pageDataJsonObject.passportCompareResults
                 if(ret == CompareOrDetectFace.EFACE_RET_PASS){
                     isShowRowtwo = true
                     rowtwo="护照比对通过"
                     passportCompare.source="qrc:/images/images/yes.png"
                     passportColor = "green"
                 }else if(ret == CompareOrDetectFace.EFACE_RET_NOPASS){
                     isShowRowtwo = true
                     rowtwo="护照比对不通过"
                     passportCompare.source="qrc:/images/images/no.png"
                     passportColor = "red"
                 }
                 else if(ret == CompareOrDetectFace.EFACE_RET_ERROR){
                     isShowRowtwo = true
                     rowtwo="护照比对错误"
                     passportCompare.source="qrc:/images/images/no.png"
                     passportColor = "red"
                 }
                 else{
                     isShowRowtwo = false
                    console.log('护照未比对')
                 }
            }
            if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
                shotBtn.enabled=false
            }
        }

        shotBtn.onClicked: {
            getFocus.focus = true
             stackView.push({item: "qrc:/singleFunction/ui/MultiPhotosShootPage.qml",
                                properties:{photocount: 1,receivePageName:"AddPhotosPage",
                                            savePath:savePath}})
        }

        Connections{
            target: mainQml
            onInitInfoMsg:{
                if(casecadeName == "PassportComparisonPage") {
                    console.log("人证比对--二代证传过来的照片:"+initInfo.cardComparePhoto)
                    pageDataJsonObject.cardComparePhoto = initInfo.cardComparePhoto
                    savePath = initInfo.tempDir
                }
            }

            onMultiPhotosShotFinished:{
                if(receivePageName=="PassportCollectionPage" ){
                    console.log("----护照拍照界面传递过来的照片:"+result[0])
                    var tempPhotoPath = qmlData.cutStr(result[0], 8, 0)
                    var passportphotoPath =  tempPhotoPath+'.jpg'
                    qmlData.copyFileToPath(tempPhotoPath, passportphotoPath, true)

                    compareface.startFaceCompareOrDetect(CompareOrDetectFace.EOPERATE_TYPE_DETECT,
                                    passportphotoPath,
                                    "" ,
                                    0,
                                    "passportPhotoDetect")
                }
                else if(receivePageName=="AddPhotosPage"){ //本界面拍摄的人脸近照
                    //发送到瀑布流用于其加入写实中
                    emit: faceCardComparePhotoToRealism(result[0])

                    //清空原有比对结果
                    rowone=""
                    cardCompare.source=""
                    rowtwo=""
                    passportCompare.source=""
                    //1.显示到界面
                    console.log("----人脸近照:"+result[0]) //带file:///
                    isdisplay=true
                    face_preview.source = ""
                    face_preview.source = result[0]
                    pageDataJsonObject.photoPath[0] = qmlData.cutStr(face_preview.source, 8, 0)

                    //2.人脸近照裁剪
                    compareface.startFaceCompareOrDetect(CompareOrDetectFace.EOPERATE_TYPE_DETECT,
                                    pageDataJsonObject.photoPath[0],
                                    "" ,
                                    0,
                                    "facePhotoDetect")
                    indicator.running = true
               }
            }
            onFillInfoMsg:{
                    var imagePath =face_preview.source
                    if(imagePath != "qrc:/images/imagesX6/txrxx.png"&&imagePath != "qrc:/images/images/renyuan.png"){
                         imagePath = qmlData.cutStr(face_preview.source, 8, 0)
                    }else{
                        imagePath=""
                    }

                    if(imagePath != ""){//有照片
                        pageDataJsonObject.photoPath[0] = imagePath
                    }
                    PAGEDATA = JSON.stringify(pageDataJsonObject)
            }

            //清空原有数据
            onClearAllData:{
                pageDataJsonObject = PublicJson.getFaceInfoJson()

                isdisplay = false
                face_preview.source = isX6 ? 'qrc:/images/imagesX6/txrxx.png': 'qrc:/images/images/renyuan.png'
                isShowRowone = false
                isShowRowtwo = false
                rowone       = ""
                rowtwo       = ""
            }
            onSendBackLoadData:{
                if(receivePageName=="PassportComparisonPage"){
                    if(backData==""){
                        isdisplay=false
                        isShowRowone= false
                        isShowRowtwo=false
                    }else{
                        if(backData != undefined){
            //                console.log("护照瀑布流"+PAGEDATA)
                            pageDataJsonObject=JSON.parse(backData)
                             face_preview.source=getPhotoPath(pageDataJsonObject.photoPath)
                             var ret = pageDataJsonObject.cardCompareResults
                             if(ret == CompareOrDetectFace.EFACE_RET_PASS){
                                 isShowRowone = true
                                 rowone = "身份证比对通过"
                                 cardCompare.source="qrc:/images/images/yes.png"
                                 cardColor = "green"
                             }
                             else if(ret == CompareOrDetectFace.EFACE_RET_NOPASS){
                                 isShowRowone = true
                                 rowone="身份证比对不通过"
                                 cardCompare.source="qrc:/images/images/no.png"
                                 cardColor = "red"
                             }
                             else if(ret == CompareOrDetectFace.EFACE_RET_ERROR){
                                 isShowRowone = true
                                 rowone="身份证比对错误"
                                 cardCompare.source="qrc:/images/images/no.png"
                                 cardColor = "red"
                             }
                             else{
                                 //未比对
                                 isShowRowone = false
                                 console.log('身份证未比对')
                             }

                             ret = pageDataJsonObject.passportCompareResults
                             if(ret == CompareOrDetectFace.EFACE_RET_PASS){
                                 isShowRowtwo = true
                                 rowtwo="护照比对通过"
                                 passportCompare.source="qrc:/images/images/yes.png"
                                 passportColor = "green"
                             }else if(ret == CompareOrDetectFace.EFACE_RET_NOPASS){
                                 isShowRowtwo = true
                                 rowtwo="护照比对不通过"
                                 passportCompare.source="qrc:/images/images/no.png"
                                 passportColor = "red"
                             }
                             else if(ret == CompareOrDetectFace.EFACE_RET_ERROR){
                                 isShowRowtwo = true
                                 rowtwo="护照比对错误"
                                 passportCompare.source="qrc:/images/images/no.png"
                                 passportColor = "red"
                             }
                             else{
                                 isShowRowtwo = false
                                console.log('护照未比对')
                             }
                        }
                    }
                }
            }
        }

        Connections{
            target: compareface
            onCompareOrDetectFinished:{
                if(taskName == 'passportPhotoDetect'){ //护照照片裁剪
                    pageDataJsonObject.passportComparePhoto = detectImagPath
                    console.log("----护照裁剪后的照片:"+pageDataJsonObject.passportComparePhoto)
                }
                else if(taskName == 'facePhotoDetect'){//人脸近照裁剪
                    face_preview.source = ""
                    face_preview.source = "file:///"+detectImagPath
                    pageDataJsonObject.photoPath[0] = detectImagPath

                    console.log("----人脸近照裁剪后的照片:"+pageDataJsonObject.photoPath[0])
                    //进行二代证比对
                    console.log("----现在存储的身份证路径:"+pageDataJsonObject.cardComparePhoto)
                    if(pageDataJsonObject.cardComparePhoto != "qrc:/images/images/sfz.png" &&
                       pageDataJsonObject.cardComparePhoto != ''){
                        isShowRowone = true
                        //console.log("进行二代证比对")
                        compareface.startFaceCompareOrDetect(CompareOrDetectFace.EOPERATE_TYPE_COMPARE,
                        pageDataJsonObject.photoPath[0],
                        pageDataJsonObject.cardComparePhoto,
                        operateconfigfile.getFaceCompareBoundaryValue(),
                        'cardCompare')
                   }
                   else{
                        isShowRowone = false
                        cnpTimer.start()
                        console.log("不进行二代证比对")
                   }
                }
                else if(taskName == 'cardCompare'){
                    pageDataJsonObject.cardCompareResults = ret
                    if(ret == CompareOrDetectFace.EFACE_RET_PASS)
                    {
                        console.log("身份证-通过")
                        rowone="身份证比对通过"
                        cardCompare.source="qrc:/images/images/yes.png"
                        cardColor = "green"
                    }
                    else if(ret==CompareOrDetectFace.EFACE_RET_NOPASS)
                    {
                        console.log("身份证-不通过")
                        rowone="身份证比对不通过"
                        cardCompare.source="qrc:/images/images/no.png"
                        cardColor = "red"
                    }
                    else if(ret==CompareOrDetectFace.EFACE_RET_ERROR)
                    {
                        console.log("身份证-错误")
                        rowone="身份证比对错误"
                        cardCompare.source="qrc:/images/images/no.png"
                        cardColor = "red"
                    }
                    cnpTimer.start()
                }
                else if(taskName == 'passportCompare'){
                    indicator.running = false
                    console.log("----人脸近照-裁剪-护照比对:"+detectImagPath)
                    pageDataJsonObject.passportCompareResults = ret
                    if(ret == CompareOrDetectFace.EFACE_RET_PASS)
                    {
                        console.log("护照-通过")
                        rowtwo="护照比对通过"
                        passportCompare.source="qrc:/images/images/yes.png"
                        passportColor = "green"
                    }
                    else if(ret==CompareOrDetectFace.EFACE_RET_NOPASS)
                    {
                        console.log("护照-不通过")
                        rowtwo="护照比对不通过"
                        passportCompare.source="qrc:/images/images/no.png"
                        passportColor = "red"
                    }
                    else if(ret==CompareOrDetectFace.EFACE_RET_ERROR)
                    {
                        console.log("护照-错误")
                        rowtwo="护照比对错误"
                        passportCompare.source="qrc:/images/images/no.png"
                        passportColor = "red"
                    }
                }
            }
        }

        Timer{
            id: cnpTimer
            interval: 1000
            repeat: false
            triggeredOnStart: true
            onTriggered: {
                cnpTimer.stop()
                //3.判断护照照片有无   有比对
                console.log("----当前存储的护照照片路径:"+pageDataJsonObject.passportComparePhoto)
                if(pageDataJsonObject.passportComparePhoto != "qrc:/images/images/sfz.png" &&
                   pageDataJsonObject.passportComparePhoto != ''){
                    isShowRowtwo = true
                    indicator.running = true
                    console.log("进行护照比对")
                    compareface.startFaceCompareOrDetect(CompareOrDetectFace.EOPERATE_TYPE_COMPARE,
                    pageDataJsonObject.photoPath[0],
                    pageDataJsonObject.passportComparePhoto,
                    operateconfigfile.getFaceCompareBoundaryValue(),
                    'passportCompare')
               }
               else{
                    isShowRowtwo = false
                    indicator.running = false
                    console.log("不进行护照比对")
               }
            }
        }
        function getPhotoPath(photoPathList){
            var tempPhotoPath = ''
            if(photoPathList.length > 0 && photoPathList[0] != ''){
                isdisplay=true
                if(qmlData.isContains(photoPathList[0], 'http')){ //网络路径
                    tempPhotoPath = photoPathList[0]
                }else{
                    tempPhotoPath = 'file:///' + photoPathList[0]
                }
            }else{
                tempPhotoPath = isX6 ? 'qrc:/images/imagesX6/txrxx.png': 'qrc:/images/images/renyuan.png'
            }
            //console.log('照片路径', tempPhotoPath)
            return tempPhotoPath
        }

    }

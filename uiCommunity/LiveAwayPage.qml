import QtQuick 2.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL
import "qrc:/collectJson/js/ThreeRealJson.js"  as ThreeRealJson

//实有人员界面---寄住人口信息使用

LiveAwayPageForm {
//    property var pageDataJsonObject:ThreeRealJson.getBuildingInfo()

//    Component.onCompleted: {
//        //瀑布流传递过来的初始化值
//        if(PAGEDATA != undefined){
//            //console.log("瀑布流传递过来的初始化值"+PAGEDATA)
//            initInfo(JSON.parse(PAGEDATA))
//        }
//        if(PAGEMODE == QmlData.VISIT_TYPE_SEE){

//        }
//    }

//    //信息填充消息响应事件
//    Connections{
//        target: mainQml
//        onFillInfoMsg:{//信息填充消息响应事件
//            if(wholeFunctionName == 'ThreeRealRoomPage'){
//                fillInfo()
//                PAGEDATA = JSON.stringify(pageDataJsonObject)
//            }
//        }

//        onComponentRecovery:{
//            getFocus.focus = true
//        }
//    }

//    //向界面添加信息
//    function initInfo( initObject ){
//        rentSituation.currentText = initObject.rentPurposes          //出租情况
//        rentPurposes.currentText  = initObject.rentPurposes          //租房用途
//        rentType.currentText      = initObject.rentType              //租住类型
//        rentPathway.currentText   = initObject.rentPathway           //承租途径
//        expirationDate.text       = initObject.expirationDate        //到期时间
//        ownerRelationship.text    = initObject.ownerRelationship     //与房主关系
//        ownerName.text            = initObject.ownerName             //房主姓名
//        ownerIdcard.text          = initObject.ownerIdcard           //房主身份证号
//        ownerTel.text             = initObject.ownerTel              //房主电话
//        ownerCurrentAdd.text      = initObject.ownerCurrentAdd       //房主现住址
//        qq.text                   = initObject.qq                    //qq号
//        weChat.text               = initObject.weChat                //微信号
//        wifi.text                 = initObject.wifi                  //WiFi名称
//        roomRate.text             = initObject.roomRate              //房费
//    }

//    //向瀑布流发送信息
//    function fillInfo(){
//        pageDataJsonObject.rentPurposes = rentSituation.currentText     //出租情况
//        pageDataJsonObject.rentPurposes = rentPurposes.currentText      //租房用途
//        pageDataJsonObject.rentType     = rentType.currentText          //租住类型
//        pageDataJsonObject.rentPathway  = rentPathway.currentText       //承租途径
//        pageDataJsonObject.expirationDate = expirationDate.text         //到期时间
//        pageDataJsonObject.ownerRelationship = ownerRelationship.text   //与房主关系
//        pageDataJsonObject.ownerName         = ownerName.text           //房主姓名
//        pageDataJsonObject.ownerIdcard       = ownerIdcard.text         //房主身份证号
//        pageDataJsonObject.ownerTel          = ownerTel.text            //房主电话
//        pageDataJsonObject.ownerCurrentAdd   = ownerCurrentAdd.text     //房主现住址
//        pageDataJsonObject.qq = qq.text
//        pageDataJsonObject.weChat = weChat.text
//        pageDataJsonObject.wifi = wifi.text
//        pageDataJsonObject.roomRate = roomRate.text
//    }
}

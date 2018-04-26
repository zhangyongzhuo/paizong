.pragma library

//二代证Json
function getIdcardJson(){
    return {
        "name":"",
        "sex":"",
        "nation":"",
        "idcard":"",
        "address":"",
        "birth":"",
        "photo":""
    }
}

//人脸比对
function getFaceInfoJson (){
    return {   //护照与人脸比对结果 可以使用PublicDataJson.js中faceInfo
        "photoPath":[],             //人脸近照
        "cardCompareResults":4,     //二代证比对结果
        "passportCompareResults":4, //护照比对结果
        "cardComparePhoto":"",      //二代证比对图片
        "passportComparePhoto":""   //护照比对图片
    }
}
////护照比对
//function getPassportFaceInfoJson (){
//     return {   //护照与人脸比对结果 可以使用PublicDataJson.js中faceInfo
//        "photoPath":[],             //人脸近照
//        "cardCompareResults":4,     //二代证比对结果
//        "passportCompareResults":4, //护照比对结果
//        "cardComparePhoto":"",      //二代证比对图片
//        "passportComparePhoto":""   //护照比对图片
//    }
//}
//写实
function getPaintRealInfo(){
    return{
        "text":"",
        "photoPath":[],
        "videoPath":[]
    }
}

//车辆信息Json
function getCarJson(){
    return {
        "licensePlateType": "",  //号牌种类
        "licensePlateNo": "",    //车牌号码
        "color": "",             //车身颜色
        "model": "",             //型号
        "brand": "",             //品牌
        "vinCode": "",           //VIN码
        "owner": "",             //车辆所有人
        "ownerTel": "",          //所有人联系方式
        "performState": "",      //执行状态
        "abnormalState": false,  //是否异常
        "photoPath": [],         //车辆照片
        "remark":"",             //备注信息
        "engineNumber":""        //发动机号
    }
}

//护照信息
function getPassportInfo(){
    return {
        "passportNO":"",   //护照号
        "name":"",         //姓名
        "sex":"",          //性别
        "passportType":"", //护照类型
        "birth":"",        //出生
        "countryCode":"",  //国家码
        "expiryDate":"",   //有效期
        "authority":"",     //签发机关
        "photo":""          //护照照片
    }
}


//手机信息
function getPhoneInfo(){
    return {
        "dbPath":"",
        "deviceId":"",
        "btaddr":"",   //蓝牙地址
        "imei":"",     //手机串号
        "macaddr":"",  //无线网卡地址
        "os":"",       //手机系统
        "product":"",  //手机型号
        "phoneBrand":"",//品牌
        "compareResults":{
            "isSmsException":false,
            "isCallException":false,
            "isContactException":false,
            "isAppException":false,
            "isPhoneNumberException":false,
            "isHaveTerrVideo":false
        },
        "SIMInfo":[],
        "smsInfo":[],
        "callInfo":[],
        "contactInfo":[],
        "appInfo":[],

        "smsNum":0,     //手机短信数量
        "callNum":0,    //手机通话数量
        "conNum":0,     //手机联系人数量
        "appNum":0,     //手机app数量
        "err": false,   //是否异常
        "des": "",      //描述
        "emptyNumber": false,//空号码
        "turn": true
    }
}

//手机SIM卡信息
function getPhoneSIMInfo(){
    return {
        "iccid":"",  //SIM卡串号
        "imsi":"",   //SIM卡号
        "msisdn":""  //手机号码
    }
}

//新疆务工人员-基础信息
var BaseInfoJson = {
    "passportNo":"",
    "politicalStatus":"",
    "qqId":"",
    "weChatId":"",
    "phoneNumber":[],
    "toLocalTime":"",
    "marriageStatus":"",
    "unitName":"",
    "income":"",
    "unitAddr":{
        "provincesCode":"",
        "provincesText":"",
        "cityCode":"",
        "cityText":"",
        "areaCode":"",
        "areaText":"",
        "streetCode":"",
        "streetText":"",
        "otherCode":"",
        "otherText":""
    },
    "currentAddr":{
        "provincesCode":"",
        "provincesText":"",
        "cityCode":"",
        "cityText":"",
        "areaCode":"",
        "areaText":"",
        "streetCode":"",
        "streetText":"",
        "otherCode":"",
        "otherText":""
    }
}

//其他信息界面Json
var OtherInfo = {
    "opinion":"",
    "isPunished":false,
    "station":"",
    "policeName":"",
    "policeTel":"",
    "note":""
}


//通联信息核查
var ContactInfo = {
    "code":"",
    "text":"",
    "number":"",
    "photo":""
}

//暂住信息
var rentingInfoJson = {
    "ownerName":"",
    "ownerIdcard":"",
    "ownerTel":"",
    "expirationDate":"",
    "provincesCode":"",
    "provincesText":"",
    "cityCode":"",
    "cityText":"",
    "areaCode":"",
    "areaText":"",
    "streetCode":"",
    "streetText":"",
    "otherCode":"",
    "otherText":""
}

//亲属关系信息Json
function getshipInfo(){
    return {
        "location":"",
        "relationship":"",
        "name":"",
        "idcard":"",
        "phoneNumber":[],
        "unitName":"",
        "unitAddr":{
            "provincesCode":"",
            "provincesText":"",
            "cityCode":"",
            "cityText":"",
            "areaCode":"",
            "areaText":"",
            "streetCode":"",
            "streetText":"",
            "otherCode":"",
            "otherText":""
        },
        "currentAddr":{
            "provincesCode":"",
            "provincesText":"",
            "cityCode":"",
            "cityText":"",
            "areaCode":"",
            "areaText":"",
            "streetCode":"",
            "streetText":"",
            "otherCode":"",
            "otherText":""
        }
    }
}

function getRelationObj(){
    return {
        "idcard":"",
        "relationId":""
    }
}

//V2手机采集返回数据
function getV2PhoneInfo(){
    return {
        "deviceId":"", //设备ID
        "btaddr":"",   //蓝牙地址
        "imei":"",     //手机串号
        "macaddr":"",  //无线网卡地址
        "os":"",       //手机系统
        "product":"",  //手机型号
        "SIMInfo":[],  //sim卡信息
        "phoneBrand":"",//品牌
        "smsNum":0,     //手机短信数量
        "callNum":0,    //手机通话数量
        "conNum":0,     //手机联系人数量
        "appNum":0,     //手机app数量
        "appList":[],   //手机所安装的软件名称
        "smsErr": false, //短信异常
        "callErr": false, //通话记录异常
        "conErr": false, //通讯录异常
        "appErr": false, //App异常
        "terrErr":false,  //是否有涉恐聊天软件
        "fearAV":false,  //是否有暴恐音视频
        "err": false,       //是否异常
        "des": "",          //描述
        "emptyNumber": false,//空号码
        "turn": true
    }
}

//核查结果信息
function getCheckInfo(){
    return{
        "disMeasures":"",                   //处置措施： 抓捕01 存疑02 拦截03 通过04
        "disMeasuresCode":"",               //处置代码： 抓捕01 存疑02 拦截03 通过04
        "disRequirements":"",               //处置要求
        "ctrlConPer":"",					//管控联络人
        "ctrlConPerAlarm":"",				//管控联络人警号
        "ctrlConPerConWay":"",              //管控联络人联系方式
        "disResult":"",						//处置结果
        "disResultAll":[]                   //处置结果列表
    }
}
//物品信息
function getCheckInfo(){
    return{
        "articleCode":"",                   //物品代码
        "articleName":"",                   //物品名称
        "articleNumber":""                  //物品数量
    }
}

//人车标签
function getFlagInfo(){
    return{
        "reason": null,
        "result": [
            {
                "property":"",
                "code": "",
                "text": "",
                "errorCode": null,
                "errorText": null,
                "target": true,
                "checked": true
            }
        ]
    }
}

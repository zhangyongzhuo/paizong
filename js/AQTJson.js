.pragma library

function getJsonObject(){
    return {
        "OptargetId":"",
        "PoliceIdcard":"",
        "IsUpload":0,
        "DataType":0,
        "RelationId":"",
        "Data":{
            "optargetId":"",
            "dataType":0,
            "locationInfo":{     //基本信息
                "latitude":0.0,
                "longitude":0.0,
                "checkTime":0,
                "policeName":"",
                "policeIdcard":"",
                "policeCode":"",
                "policeUnitCode":"",
                "policeArea":"",
                "locationName":"",
                "imei":"",
                "cid":""
            },
            "idcardInfo":{       //身份证信息 PublicDataJson.js中有定义
                "name":"",
                "sex":"",
                "nation":"",
                "idcard":"",
                "address":"",
                "birth":"",
                "photo":""
            },
            "passportInfo":{       //护照信息 PublicDataJson.js中有定义
                "passportNO":"",   //护照号
                "name":"",         //姓名
                "sex":"",          //性别
                "passportType":"", //护照类型
                "birth":"",        //出生
                "countryCode":"",  //国家码
                "expiryDate":"",   //有效期
                "authority":"" ,    //签发机关
                "photo":""          //护照照片
            },
            "faceInfo":{   //护照与人脸比对结果 可以使用PublicDataJson.js中faceInfo
                "photoPath":[],             //人脸近照
                "cardCompareResults":4,     //二代证比对结果
                "passportCompareResults":4, //护照比对结果
                "cardComparePhoto":"",      //二代证比对图片
                "passportComparePhoto":""   //护照比对图片
            },
            "visaInfo":{   //签证信息 数组元素为图片路径
                "photoPath":[]
            },
            "phoneInfo":{          //手机信息 PublicDataJson.js中有定义
                "isCollect":false,
                "notCollectReason":"",
                "detailData":[]    //手机详细信息
            },
            "scrutinyInfo":[],   //人工核查结果
            "paintRealInfo":{    //写实信息  PublicDataJson.js中有定义
                "text":"",
                "photoPath":[],
                "videoPath":[]
            },
            "carInfo":{          //车辆信息  PublicDataJson.js中有定义
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
                "remark":""              //备注信息
            },
            "carRelateds":[]             //人车关系
        }
    }
}

function getCarRelateds(){
    return {
        "relationship":"",              //人车关系（驾驶员、乘客）
        "optargetId":""                 //驾驶员或乘客对应的档案编号
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
        "SIMInfo":[],
        "smsInfo":[],
        "callInfo":[],
        "contactInfo":[],
        "appInfo":[],
        "qqInfo":[],
        "wechatInfo":[],
        "compareResults":{
            "isSmsException":false,
            "isCallException":false,
            "isContactException":false,
            "isAppException":false,
            "isPhoneNumberException":false,
            "isHaveTerrVideo":false
        }
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





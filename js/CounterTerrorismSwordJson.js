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
            "relationId":"",       //任务ID
            "checkException":false,    //true 异常， false 正常
            "locationInfo":{
                "latitude":0.0,
                "longitude":0.0,
                "checkTime":0,
                "policeName":"",   //警员姓名
                "policeIdcard":"", //警员身份证号
                "policeCode":"",   //警员编号
                "policeUnitCode":"",//单位编码
                "policeUnit":"",    //单位名称（中文）
                "policeAreaCode":"",//行政区划编码
                "policeArea":"",    //行政区划名称（中文）
                "locationName":"",  //采集地点（中文）
                "imei":"",          //移动设备识别码
                "cid":""            //设备编码（海邻科设备识别码）
            },
            "idcardInfo":{
                "name":"",  //姓名
                "sex":"",   //性别
                "nation":"",//民族
                "idcard":"",//身份证号
                "address":"",//户籍地址
                "birth":"",  //出生日期
                "photo":""   //相片（身份证上照片 网络路径）
            },
            "idcardCompareInfo":{},
            "phoneInfo":{
                "isCollect":false,      //是否采集手机  没有false 有true
                "notCollectReason":"",  //未采集手机原因
                "isHaveTerrVideo":false,//是否有暴恐音视频
                "detailData":[]         //手机详细信息
            },
            "scrutinyInfo":[],
            "domicileInfo":{         //户籍地信息
                "checkedType":"",    //核查类型
                "station":"",        //户籍地派出所
                "stationPerson":"",  //户籍地警员
                "stationTel":"",     //户籍地派出所电话
                "checkedTime":"",    // 户籍地核查时间
                "checkedRes":false,  //户籍地核查结果（已核查true/未核查false）
                "checkedMark":[],    //户籍地核查结果备注（数组）
                "remark":""          //备注
            },
            "destinationInfo":{         //流入地信息
                "fromProvincesCode":"", //从何处来（省编码）
                "fromProvincesText":"", //从何处来（省中文）
                "fromCityCode":"",      //从何处来（市编码）
                "fromCityText":"",      //从何处来（市中文）
                "fromAreaCode":"",      //从何处来（区编码）
                "fromAreaText":"",      //从何处来（区中文）
                "toProvincesCode":"",   //到何处去（省编码）
                "toProvincesText":"",   //到何处去（省中文）
                "toCityCode":"",        //到何处去（市编码）
                "toCityText":"",        //到何处去（市中文）
                "toAreaCode":"",        //到何处去（区编码）
                "toAreaText":"",        //到何处去（区中文）
                "tripMode":{            //出行方式
                    "code":"",          //出行方式编号
                    "text":"",          //出行方式文字
                    "trainNumber":"",   //车次
                    "driverTel":"",     //司乘人员电话
                    "licensePlateNumber":"", //车牌号码
                    "carriageNumber":"",//车厢号
                    "seatNumber":""     //座位号
                },
                "tripPurpCode":"", //出行目的编号
                "tripPurpText":"", //出行目的文字
                "travelDate":"",   //出行日期
                "visitorName":"",  //投奔人姓名
                "visitorTel":"",   //投奔人电话
                "liaisonName":"",  //联络员姓名
                "liaisonTel":"",   //联络员电话
                "partnerCount":0   //同行人数
            },
            "baseInfo":{           //基础信息
                "attribute":"",    //人员属性
                "state":"",        //人员状态
                "type":"",         //人员类型
                "residenceType":"",//住所类型
                "toType":"",       //到达本辖区方式
                "liveType":"",     //居住状态（在住 离开）
                "whereabouts":""   //离住去向
            },
            "contactWayInfo":[],   //通联信息（数组）
            "paintRealInfo":{      //写实信息
                "text":"",         //文字描述
                "photoPath":[],    //写实照片 数组
                "videoPath":[]     //写实录像
            },
            "rentingInfo":{        //租房信息
                "ownerName":"",    //房东姓名
                "ownerIdcard":"",  //房东身份证号
                "ownerTel":"",     //房东联系电话
                "expirationDate":"",//到期时间
                "provincesCode":"", //省编码
                "provincesText":"", //省名称
                "cityCode":"",      //市编码
                "cityText":"",      //市名称
                "areaCode":"",      //区编码
                "areaText":"",      //区名称
                "streetCode":"",    //街编码
                "streetText":"",    //街名称
                "otherCode":"",     //详细信息编码
                "otherText":"",     //详细信息名称
                "address":"",       //地址中文 暂时不用
                "buildingId":""     //房屋ID
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
            }
        }
    }
}

function getDomicileInfo(){
    return {
        "checkedType":"",
        "station":"",
        "stationTel":"",
        "checkedTime":"",
        "checkedRes":false,
        "checkedMark":[],
        "remark":""
        }
}

function getBaseInfoObject(){
    return {
        "attribute":"",
        "state":"",
        "type":"",
        "residenceType":"",
        "toType":"",
        "liveType":"",
        "whereabouts":""
    }
}

//流入地模块
function getDestinationJson(){
    return {
        "fromProvincesCode":"",
        "fromProvincesText":"",
        "fromCityCode":"",
        "fromCityText":"",
        "fromAreaCode":"",
        "fromAreaText":"",
        "toProvincesCode":"",
        "toProvincesText":"",
        "toCityCode":"",
        "toCityText":"",
        "toAreaCode":"",
        "toAreaText":"",
        "tripMode":{
            "code":"",
            "text":"",
            "trainNumber":"",
            "driverTel":"",
            "licensePlateNumber":"",
            "carriageNumber":"",
            "seatNumber":""
        },
        "tripPurpCode":"",
        "tripPurpText":"",
        "travelDate":"",
        "visitorName":"",
        "visitorTel":"",
        "liaisonName":"",
        "liaisonTel":"",
        "partnerCount":0
    }
}





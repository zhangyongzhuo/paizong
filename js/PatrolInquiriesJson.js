.pragma library

function getPatrolInquiriesJson(){
    return {
        "OptargetId":"",
        "PoliceIdcard":"",
        "IsUpload":0,
        "DataType":0,
        "RelationId":"",           //任务ID
        "Data":{
            "optargetId":"",                     //
            "dataType":0,
            "relationId":"",       //任务ID
            "checkId":"",         //核录ID
            "checkException":false,    //true 异常， false 正常
            "locationInfo":{
                "latitude":0.0,
                "longitude":0.0,
                "checkTime":0,
                "policeName":"",
                "policeIdcard":"",
                "policeCode":"",
                "policeUnitCode":"",
                "policeUnit":"",
                "policeAreaCode":"",
                "policeArea":"",
                "locationId":"",    //卡口编号
                "locationName":"",  //卡口名称
                "imei":"",
                "cid":""
            },
            "idcardInfo":{
                "name":"",
                "sex":"",
                "nation":"",
                "idcard":"",
                "address":"",
                "birth":"",
                "photo":""
            },
            "idcardCompareInfo":{},
            "faceInfo":{
                "photoPath":[],             //人脸近照
                "cardCompareResults":4,     //二代证比对结果
                "passportCompareResults":4, //护照比对结果
                "cardComparePhoto":"",      //二代证比对图片
                "passportComparePhoto":""   //护照比对图片
            },
            "carInfo":{                
                "licensePlateType": "",  //号牌种类
                "licensePlateTypeCode": "",  //号牌种类编码
                "licensePlateNo": "",    //车牌号码
                "color": "",             //车身颜色
                "colorCode": "",             //车身颜色编码
                "model": "",             //型号
                "brand": "",             //品牌
                "vinCode": "",           //VIN码
                "owner": "",             //车辆所有人
                "ownerTel": "",          //所有人联系方式
                "performState": "",      //执行状态
                "isRoadside":false,
                "abnormalState": false,  //是否异常
                "photoPath": [],         //车辆照片
                "remark":"",             //备注信息
                "engineNumber":""        //发动机号
            },
            "carCompareInfo":{},
            "carRelateds":[],             //人车关系
            "paintRealInfo":{             //写实信息
                "text":"",
                "photoPath":[],
                "videoPath":[]
            },
            "checkInfo":{                           //核查结果
                "disMeasures":"",                   //处置措施： 抓捕01 存疑02 拦截03 通过04
                "disMeasuresCode":"",               //处置代码： 抓捕01 存疑02 拦截03 通过04
                "disRequirements":"",               //处置要求
                "ctrlConPer":"",					//管控联络人
                "ctrlConPerAlarm":"",				//管控联络人警号
                "ctrlConPerConWay":"",              //管控联络人联系方式
                "disResult":"",						//处置结果
                "disResultAll":[]                   //处置结果列表
            },
            "articleInfo":[],                       //物品信息
            "contactWayInfo":[]                     //通联信息（数组）
        }
    }
}

function getCarRelateds(){
    return {
        "relationship":"",
        "optargetId":""
    }
}





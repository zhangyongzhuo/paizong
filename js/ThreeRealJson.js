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
            "relationId":"",           //任务ID
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
            "addressInfo":{  //地址信息
                "address":"",       //地址中文 暂时不用
                "buildingId":""     //房屋ID
            },
            "idcardInfo":{
                "name":"",   //姓名
                "sex":"",    //性别
                "nation":"", //民族
                "idcard":"", //身份证号
                "address":"",//户籍地址
                "birth":"",  //出生日期
                "photo":""   //相片（身份证上照片 网络路径）
            },
            "idcardCompareInfo":{}, //人员比对结果
            "baseInfo":{            //基础信息
                "attribute":"",     //人员属性
                "familyRelationships":"", //家庭关系
                "maritalStatus":"", //婚姻状况
                "educationLevel":"",//文化程度
                "height":"",        //身高
                "weight":"",        //体重
                "serviceSpace":"",  //服务处所
                "specialty":"",     //特长
                "accent":"",        //口音
                "bloodType":"",     //血型
                "religious":"",     //宗教信仰
                "state":"",         //人员状态
                "livingReasons":"", //居住原因
                "livingDate":"",    //居住时间    -----change(入住时间)
                "leaveDate":"",     //离开时间    -----new
                "licensePlateNo":"",//车辆号码    -----new（空就算没有时间）
                "station":"",       //管辖单位
                "policeName":""     //民警姓名
            },
            "leaveReasons":{        //离住信息
                "leaveReasons":"",  //离住原因
                "leaveDate":"",     //离住时间
                "leaveRemark":"",   //离住说明
            },
            "contactWayInfo":[],    //通联信息
            "paintRealInfo":{       //写实信息
                "text":"",          //写实文字
                "photoPath":[],     //写实照片
                "videoPath":[]      //写实视频
            },
            "buildingInfo":{        //房屋信息
                "rentSituation":"", //出租情况
                "rentPurposes":"",  //租房用途
                "rentType":"",      //租住类型
                "rentPathway":"",   //承租途径
                "expirationDate":"",//到期时间
                "ownerRelationship":"",//与房主关系
                "ownerName":"",     //房主姓名
                "ownerIdcard":"",   //房主身份证号
                "ownerTel":"",      //房主电话
                "ownerCurrentAdd":"",//房主现住址
                "QQ":"",             //QQ号       ----new
                "weChat":"",         //微信号      ----new
                "wifi":"",           //网络情况    ----new（wifi名称）
                "roomRate":""        //房费       ----new
            },
            "buildingRelateds":[],  //人房关系
            "unitInfo":{            //单位信息
                "unitName":"",          //单位名称
                "unitType":"",          //单位分类
                "legalPersonName":"",   //法人姓名
                "legalPersonIdcard":"", //法人身份证
                "legalPersonTel":"",    //法人电话
                "unitState":"",         //单位状态
                "operatorName":"",      //经营者姓名
                "operatorIdcard":"",    //经营者身份证号
                "peaceOfficerName":"",  //治安员姓名
                "peaceOfficerIdcard":"",//治安员身份证号
                "businessLicenseNum":"",//营业执照号
                "organizationCode":"",  //组织机构代码
                "registerDate":"",      //注册日期
                "expiryDate":"",        //有效日期
                "economicNature":"",    //经济性质
                "fireRating":"",        //消防等级
                "businessArea":"",      //经营面积
                "openingDate":"",       //开业时间
                "mainProducts":"",      //主营
                "sideline":""           //兼营
            }
        }
    }
}

function getBuildingRelateds(){ //人房关系
    return {
        "relationship":"",  //主户 子户
        "optargetId":""     //档案编号
    }
}

function getBuildingInfo(){ //房屋信息
    return {
        "rentSituation":"", //出租情况
        "rentPurposes":"",  //租房用途
        "rentType":"",      //租住类型
        "rentPathway":"",   //承租途径
        "expirationDate":"",//到期时间
        "ownerRelationship":"",//与房主关系
        "ownerName":"",     //房主姓名
        "ownerIdcard":"",   //房主身份证号
        "ownerTel":"",      //房主电话
        "ownerCurrentAdd":""//房主现住址
    }
}

function getAddressInfo(){ //地址信息
    return {
        "address":"",       //地址中文 暂时不用
        "buildingId":""     //房屋ID
    }
}








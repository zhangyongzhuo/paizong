.pragma library

function getJsonObject(){
    return {
        "OptargetId":"",
        "PoliceIdcard":"",
        "IsUpload":0,
        "DataType":0,
        "RelationId":"",
        "Data":{
            "userid":"",               //登陆用户
            "orgjb":"",                //登陆用户所属组织机构级别
            "orgid":"",                //登陆用户所属组织机构ID
            "menuname":"",             //登陆用户所含菜单权限
            "dwjbxxb":{
                "dwmc":"",//单位名称
                "dwywm":"",//单位英文名
                "dwywsx":"",//单位英文缩写
                "gllxdm":"",//管理类型：1、治安 2、内保 3、保安 4、技防 5、消防
                "dwlbdm":"",//单位类别>>zdbh: BD_D_DWLXDM
                "lxdh":"",//联系电话 11位手机号码
                "dz_dwdzmlpxz":"",//单位标准地址：门楼牌详址对应地址接口获取的mlpxz
                "dz_dwdzmlpdm":"",//单位标准地址：门楼牌代码对应地址接口获取的mldzid
                "dz_dwdzdm":"",//单位标准地址：地址代码对应地址接口获取的chdzid
                "dz_dwdzssxdm":"",//单位标准地址：行政区划代码对应地址接口获取的xzqhdm
                "dz_dwdzxz":"",//单位标准地址：地址详址对应地址接口获取的dzxz
                "dz_dwzbx":"",//单位标准地址：坐标X对应地址接口获取的zbx
                "dz_dwzby":"",//单位标准地址：坐标Y对应地址接口获取的zby
                "hylbdm":"",//行业类别>>zdbh: D_DW_HYLB
                "sfwzdwdm":"",//是否外资单位>>zdbh: D_GG_SF
                "sfswdwdm":"",//是否涉外单位>>zdbh: D_GG_SF
                "czhm":"",//传真号码
                "wz":"",//网址
                "sfazzaglxxxt":"",//是否安装治安管理信息系统>>zdbh: D_GG_SF
                "sfyxfjddm":"",//是否经消防安全验收合格>>zdbh: D_GG_SF
                "bz":"",//备注
                "xp":"",//照片(BASE64编码后的字符串)
                "dwbm":""//单位别名
            }
//            ,
//            "Echo":{//存储回显
//                "dwlbdm":""      //单位类别
//                //"dz_dwdzxz":""     //单位标准地址
//            }
        }
    }
}

function getDwjbxxb(){
    return {
        "dwmc":"",//单位名称
        "dwywm":"",//单位英文名
        "dwywsx":"",//单位英文缩写
        "gllxdm":"",//管理类型：1、治安 2、内保 3、保安 4、技防 5、消防
        "dwlbdm":"",//单位类别>>zdbh: BD_D_DWLXDM
        "lxdh":"",//联系电话 11位手机号码
        "dz_dwdzmlpxz":"",//单位标准地址：门楼牌详址对应地址接口获取的mlpxz
        "dz_dwdzmlpdm":"",//单位标准地址：门楼牌代码对应地址接口获取的mldzid
        "dz_dwdzdm":"",//单位标准地址：地址代码对应地址接口获取的chdzid
        "dz_dwdzssxdm":"",//单位标准地址：行政区划代码对应地址接口获取的xzqhdm
        "dz_dwdzxz":"",//单位标准地址：地址详址对应地址接口获取的dzxz
        "dz_dwzbx":"",//单位标准地址：坐标X对应地址接口获取的zbx
        "dz_dwzby":"",//单位标准地址：坐标Y对应地址接口获取的zby
        "hylbdm":"",//行业类别>>zdbh: D_DW_HYLB
        "sfwzdwdm":"",//是否外资单位>>zdbh: D_GG_SF
        "sfswdwdm":"",//是否涉外单位>>zdbh: D_GG_SF
        "czhm":"",//传真号码
        "wz":"",//网址
        "sfazzaglxxxt":"",//是否安装治安管理信息系统>>zdbh: D_GG_SF
        "sfyxfjddm":"",//是否经消防安全验收合格>>zdbh: D_GG_SF
        "bz":"",//备注
        "xp":"",//照片(BASE64编码后的字符串)
        "dwbm":""//单位别名
    }
}

//function getEcho(){
//     return {
//        "dwlbdm":""       //单位类别
//        //"dz_dwdzxz":""     //单位标准地址
//    }
//}

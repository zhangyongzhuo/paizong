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
            "jbxx":{
                "syrkywlxdm":"",//业务类型
                "cyzjdm":"",//证件种类
                "zjhm":"",//证件号码
                "xm":"",   //姓名
                "xbdm":"",    //性别
                "csrq":"",  //出生日期
                "mzdm":"", //民族
                "lxdh":"",    //联系电话
                "csdgjhdqdm":"",   //出生国家
                "csdssxdm":"",      //出生地
                "jggjdqdm":"",   //籍贯国家
                "jgssxdm":"",     //籍贯
                "cym":"",      //曾用名
                "xldm":"",   //学历
                "hyzkdm":"", //婚姻状况
                "zzmmdm":"",       //政治面貌
                "zjxydm":"",       //宗教信仰
                "byzkdm":"",       //兵役状况
                "xxdm":"",     //血型
                "zylbdm":"",       //职业类别
                "zy":"",       //职业
                "gzdw":"",       //工作单位
                "hjd_dzms":""       //户籍地址
            },
            "ldrk":{
                "jzd_mlpdm":"",    //居住地门楼牌代码对应地址接口获取的mldzid
                "jzd_mlpxz":"",    //居住地门楼牌详址对应地址接口获取的mlpxz
                "jzd_dzid":"",    //居住地地址代码对应地址接口获取的chdzid
                "jzd_xzqhdm":"",    //居住地行政区划代码对应地址接口获取的xzqhdm
                "jzd_dzxz":"",    //居住地地址详址对应地址接口获取的dzxz
                "jzd_zbx":"",    //居住地地址坐标X对应地址接口获取的zbx
                "jzd_zby":"",    //居住地地址坐标Y对应地址接口获取的zby
                "zjzsydm":"",    //暂住事由
                "hkszdlxdm":"",    //户口所在地类型
                "lbsqk_qlrrq":"",    //暂住日期
                "lbsqk_qyldyydm":"",    //迁移原因
                "lzd_gjhdqdm":"",    //来自国家
                "qyfwdm":"",    //区域范围
                "lzd_xzqhdm":"",    //来自地行政区划
                "lzd_dzxz":"" ,   //来自地描述
                "zjzcsfldm":"",  //居住处所
                "cxfldm":"",  //来自地城乡分类
                "fwczqkdm":"",  //房屋承租情况
                "chzr_yfzgx_rygxdm":"",//与房主关系
                "qzrq":"",//起租日期
                "nzrq":"",//拟停租日期
                "bz":""//备注

            },
            "jzrk":{
                "jzd_mlpdm":"",    //居住地门楼牌代码对应地址接口获取的mldzid
                "jzd_mlpxz":"",    //居住地门楼牌详址对应地址接口获取的mlpxz
                "jzd_dzid":"",    //居住地地址代码对应地址接口获取的chdzid
                "jzd_xzqhdm":"",    //居住地行政区划代码对应地址接口获取的xzqhdm
                "jzd_dzxz":"",    //居住地地址详址对应地址接口获取的dzxz
                "jzd_zbx":"",    //居住地地址坐标X对应地址接口获取的zbx
                "jzd_zby":"",    //居住地地址坐标Y对应地址接口获取的zby
                "jzlbdm":"",    //寄住类别
                "jzyydm":"",    //寄住原因
                "jz_ksrq01":"",    //寄住开始时间
                "yj_lksj":"",    //寄住离开时间
                "zjzcsfldm":"",  //居住处所
                "fwczqkdm":"",  //房屋承租情况
                "chzr_yfzgx_rygxdm":"",//与房主关系
                "qzrq":"",//起租日期
                "nzrq":"",//拟停租日期
                "bz":""//备注
            },
            "jwry":{
                "gjdm":"",    //国籍(地区)
                "wwx":"",    //外文姓
                "wwm":"",    //外文名
                "xbdm":"",    //性别代码
                "csrq":"",    //出生日期
                "qt_sfzhm":"",    //身份证号码
                "lxdh":"",    //联系电话
                "qzjlxkzldm":"",    //签证（注）种类
                "qzjlxkh":"",    //签证（注）号码
                "rjrq":"",    //入境日期
                "qztjl_jzrq":"",    //停留有效日期
                "jzd_mlpdm":"",    //居住地门楼牌代码对应地址接口获取的mldzid
                "jzd_mlpxz":"",    //居住地门楼牌详址对应地址接口获取的mlpxz
                "jzd_dzid":"",    //居住地地址代码对应地址接口获取的chdzid
                "jzd_xzqhdm":"",    //居住地行政区划代码对应地址接口获取的xzqhdm
                "jzd_dzxz":"",    //居住地地址详址对应地址接口获取的dzxz
                "jzd_zbx":"",    //居住地地址坐标X对应地址接口获取的zbx
                "jzd_zby":"",    //居住地地址坐标Y对应地址接口获取的zby	
                "zsrq":"",    //入宿日期
                "nlkrq":"",    //拟离开日期
                "fz_sflb":"",    //房主身份类别
                "zjzcsfldm":"",    //住房种类
                "rydylb":"",    //人员地域类别
                "qzrq":"",    //起租日期
                "nzrq":"",    //拟停租日期
                "fz_gjdm":"",    //房主国籍
                "fz_xbdm":"",    //房主性别
                "fz_wwx":"",    //房主外文姓
                "fz_wwm":"",    //房主外文名
                "fz_csrq":"",    //房主出生日期
                "lsdw_dwmc":"",    //留宿单位
                "jddw_dwmc":"",    //接待单位
                "lsdw_lxdh":"",    //留宿单位联系电话
                "jddw_lxdh":"",    //接待单位联系电话
                "lxr_xm":"",    //紧急情况联系人
                "lxr_lxdh":"",    //紧急情况联系电话
                "bz":""        //备注
            },
         "wlrk":{
                "jzd_mlpdm":"",    //居住地门楼牌代码对应地址接口获取的mldzid
                "jzd_mlpxz":"",    //居住地门楼牌详址对应地址接口获取的mlpxz
                "jzd_dzid":"",    //居住地地址代码对应地址接口获取的chdzid
                "jzd_xzqhdm":"",    //居住地行政区划代码对应地址接口获取的xzqhdm
                "jzd_dzxz":"",    //居住地地址详址对应地址接口获取的dzxz
                "jzd_zbx":"",    //居住地地址坐标X对应地址接口获取的zbx
                "jzd_zby":"",    //居住地地址坐标Y对应地址接口获取的zby
                "qtcyzjdm":"",    //其他常用证件
                "qtzjhm":"",    //其他常用证件号码
                "wlhyydm":"",    //未落户原因
                "zjzcsfldm":"",  //居住处所
                "fwczqkdm":"",  //房屋承租情况
                "chzr_yfzgx_rygxdm":"",//与房主关系
                "qzrq":"",//起租日期
                "nzrq":"",//拟停租日期
                "bz":""//备注
            },
            "xp":{
                "photo":""//照片
            }
        }
    }
}

function getJbxx(){ //
    return {
        "syrkywlxdm":"",//业务类型
        "cyzjdm":"",//证件种类
        "zjhm":"",//证件号码
        "xm":"",   //姓名
        "xbdm":"",    //性别
        "csrq":"",  //出生日期
        "mzdm":"", //民族
        "lxdh":"",    //联系电话
        "csdgjhdqdm":"",   //出生国家
        "csdssxdm":"",      //出生地
        "jggjdqdm":"",   //籍贯国家
        "jgssxdm":"",     //籍贯
        "cym":"",      //曾用名
        "xldm":"",   //学历
        "hyzkdm":"", //婚姻状况
        "zzmmdm":"",       //政治面貌
        "zjxydm":"",       //宗教信仰
        "byzkdm ":"",       //兵役状况
        "xxdm":"",     //血型
        "zylbdm":"",       //职业类别
        "zy":"",       //职业
        "gzdw":"",       //工作单位
        "hjd_dzms":""       //户籍地址
    }
}

function getLdrk(){ //
    return {
        "jzd_mlpdm":"",    //居住地门楼牌代码对应地址接口获取的mldzid
        "jzd_mlpxz":"",    //居住地门楼牌详址对应地址接口获取的mlpxz
        "jzd_dzid":"",    //居住地地址代码对应地址接口获取的chdzid
        "jzd_xzqhdm":"",    //居住地行政区划代码对应地址接口获取的xzqhdm
        "jzd_dzxz":"",    //居住地地址详址对应地址接口获取的dzxz
        "jzd_zbx":"",    //居住地地址坐标X对应地址接口获取的zbx
        "jzd_zby":"",    //居住地地址坐标Y对应地址接口获取的zby
        "zjzsydm":"",    //暂住事由
        "hkszdlxdm":"",    //户口所在地类型
        "lbsqk_qlrrq":"",    //暂住日期
        "lbsqk_qyldyydm":"",    //迁移原因
        "lzd_gjhdqdm":"",    //来自国家
        "qyfwdm":"",    //区域范围
        "lzd_xzqhdm":"",    //来自地行政区划
        "lzd_dzxz":"" ,   //来自地描述
        "zjzcsfldm":"",  //居住处所
        "cxfldm":"",  //来自地城乡分类
        "fwczqkdm":"",  //房屋承租情况
        "chzr_yfzgx_rygxdm":"",//与房主关系
        "qzrq":"",//起租日期
        "nzrq":"",//拟停租日期
        "bz":""//备注
    }
}

function getJzrk(){
    return {
        "jzd_mlpdm":"",    //居住地门楼牌代码对应地址接口获取的mldzid
        "jzd_mlpxz":"",    //居住地门楼牌详址对应地址接口获取的mlpxz
        "jzd_dzid":"",    //居住地地址代码对应地址接口获取的chdzid
        "jzd_xzqhdm":"",    //居住地行政区划代码对应地址接口获取的xzqhdm
        "jzd_dzxz":"",    //居住地地址详址对应地址接口获取的dzxz
        "jzd_zbx":"",    //居住地地址坐标X对应地址接口获取的zbx
        "jzd_zby":"",    //居住地地址坐标Y对应地址接口获取的zby
        "jzlbdm":"",    //寄住类别
        "jzyydm":"",    //寄住原因
        "jz_ksrq01":"",    //寄住开始时间
        "yj_lksj":"",    //寄住离开时间
        "zjzcsfldm":"",  //居住处所
        "fwczqkdm":"",  //房屋承租情况
        "chzr_yfzgx_rygxdm":"",//与房主关系
        "qzrq":"",//起租日期
        "nzrq":"",//拟停租日期
        "bz":""//备注
    }
}

function getXp(){
    return {
        "photo":""//照片
    }
}







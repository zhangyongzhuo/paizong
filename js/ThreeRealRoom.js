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
            "fwjbxxb":{//基本信息、房主信息、托管人信息
                "fwdz_mlpxz":"",//房屋标准地址：门楼牌详址对应地址接口获取的mlpxz
                "fwdz_mlpdm":"",//房屋标准地址：门楼牌代码对应地址接口获取的mldzid
                "fwdz_dzid":"",//房屋标准地址：地址代码对应地址接口获取的chdzid
                "fwdz_xzqhdm":"",//房屋标准地址：行政区划代码对应地址接口获取的xzqhdm
                "fwdz_dzxz":"",//房屋标准地址：地址详址对应地址接口获取的dzxz
                "fwdz_zbx":"",//房屋标准地址：坐标X对应地址接口获取的zbx
                "fwdz_zby":"",//房屋标准地址：坐标Y对应地址接口获取的zby
                "fwcqxzzldm":"",//房屋性质>>zdbh: ZA_D_FWCQXZZLDM
                "fwcqzh":"",//产权证号
                "fwlbdm":"",//房屋类别
                "fwytdm":"",//房屋用途
                "fwjs":"",//房屋间数
                "fwmj_mjpfm":"",//房屋面积
                "sfczfw":"",//是否出租房屋>>zdbh: D_GG_SF
                "fwssdw_dwmc":"",//所属单位
                "bz":"",//备注
                "fz_cyzjdm":"",//房主证件种类 >>zdbh: KX_D_CYZJDM *只允许证件种类代码为111,112,335,414,784,511,512,552,114,115,123
                "fz_zjhm":"",//房主证件号码
                "fz_xm":"",//房主姓名
                "fz_lxdh":"",//房主联系电话
                "fz_wwx":"",//房主外文姓
                "fz_wwm":"",//房主外文名
                "tgr_cyzjdm":"",//房屋托管人证件种类>>zdbh: KX_D_CYZJDM
                "tgr_zjhm":"",//当tgr_cyzjdm不为空时必填	房屋托管人证件号码
                "tgr_xm":"",//当tgr_cyzjdm不为空时必填	房屋托管人姓名
                "tgr_lxdh":"",//当tgr_cyzjdm不为空时必填	房屋托管人联系电话
                "tgr_wwx":"",//房屋托管人外文姓
                "tgr_wwm":"",//房屋托管人外文名
                "tgr_yfzgx_rygxdm":""//房屋托管人与房主关系>>zdbh: XZ_D_RYGXDM
            },
            "czfwxxb":{//出租信息、出租人信息
                "cz_fjs":"",    //出租房间数(不能大于房屋间数)
                "cz_mjpfm":"",    //出租面积(不能大于房屋面积)
                "cz_rq":"",    //出租日期 格式：1990-02-02
                "zj":"",    //租金(元/月)
                "fwdjdm":"",    //房屋等级>>zdbh: BD_D_FWDJDM
                "zazrr_id":"",    //当sfczfw为1时该项必填	治安责任人id 对应userid
                "zazrr_xm":"",    //当sfczfw为1时该项必填	治安责任人姓名对应username
                "zrs_qd_rq":"",    //当sfczfw为1时该项必填	责任书签订日期 格式：1990-02-02
                "bz":"",    //	备注
                "czur_yfzgx_rygxdm":"",    //当sfczfw为1时该项必填	出租人与房主关系>>zdbh: XZ_D_CZFWRYGXDM
                "czur_cyzjdm":"",    //当sfczfw为1时该项必填	出租人证件种类>>zdbh: KX_D_CYZJDM
                "czur_zjhm":"",    //当sfczfw为1时该项必填	出租人证件号码
                "czur_xm":"",    //当sfczfw为1时该项必填	出租人姓名
                "czur_lxdh":"",    //当sfczfw为1时该项必填	出租人联系电话
                "czur_wwx":"",    //出租人外文姓
                "czur_wwm":""    //出租人外文名
            }
        }
    }
}
function getFwjbxxb(){
    return {
        "fwdz_mlpxz":"",//房屋标准地址：门楼牌详址对应地址接口获取的mlpxz
        "fwdz_mlpdm":"",//房屋标准地址：门楼牌代码对应地址接口获取的mldzid
        "fwdz_dzid":"",//房屋标准地址：地址代码对应地址接口获取的chdzid
        "fwdz_xzqhdm":"",//房屋标准地址：行政区划代码对应地址接口获取的xzqhdm
        "fwdz_dzxz":"",//房屋标准地址：地址详址对应地址接口获取的dzxz
        "fwdz_zbx":"",//房屋标准地址：坐标X对应地址接口获取的zbx
        "fwdz_zby":"",//房屋标准地址：坐标Y对应地址接口获取的zby
        "fwcqxzzldm":"",//房屋性质>>zdbh: ZA_D_FWCQXZZLDM
        "fwcqzh":"",//产权证号
        "fwlbdm":"",//房屋类别
        "fwytdm":"",//房屋用途
        "fwjs":"",//房屋间数
        "fwmj_mjpfm":"",//房屋面积
        "sfczfw":"",//是否出租房屋>>zdbh: D_GG_SF
        "fwssdw_dwmc":"",//所属单位
        "bz":"",//备注
        "fz_cyzjdm":"",//房主证件种类 >>zdbh: KX_D_CYZJDM *只允许证件种类代码为111,112,335,414,784,511,512,552,114,115,123
        "fz_zjhm":"",//房主证件号码
        "fz_xm":"",//房主姓名
        "fz_lxdh":"",//房主联系电话
        "fz_wwx":"",//房主外文姓
        "fz_wwm":"",//房主外文名
        "tgr_cyzjdm":"",//房屋托管人证件种类>>zdbh: KX_D_CYZJDM
        "tgr_zjhm":"",//当tgr_cyzjdm不为空时必填	房屋托管人证件号码
        "tgr_xm":"",//当tgr_cyzjdm不为空时必填	房屋托管人姓名
        "tgr_lxdh":"",//当tgr_cyzjdm不为空时必填	房屋托管人联系电话
        "tgr_wwx":"",//房屋托管人外文姓
        "tgr_wwm":"",//房屋托管人外文名
        "tgr_yfzgx_rygxdm":""//房屋托管人与房主关系>>zdbh: XZ_D_RYGXDM
    }
}
function getCzfwxxb(){
    return {
        "cz_fjs":"",    //出租房间数(不能大于房屋间数)
        "cz_mjpfm":"",    //出租面积(不能大于房屋面积)
        "cz_rq":"",    //出租日期 格式：1990-02-02
        "zj":"",    //租金(元/月)
        "fwdjdm":"",    //房屋等级>>zdbh: BD_D_FWDJDM
        "zazrr_id":"",    //当sfczfw为1时该项必填	治安责任人id 对应userid
        "zazrr_xm":"",    //当sfczfw为1时该项必填	治安责任人姓名对应username
        "zrs_qd_rq":"",    //当sfczfw为1时该项必填	责任书签订日期 格式：1990-02-02
        "bz":"",    //	备注
        "czur_yfzgx_rygxdm":"",    //当sfczfw为1时该项必填	出租人与房主关系>>zdbh: XZ_D_CZFWRYGXDM
        "czur_cyzjdm":"",    //当sfczfw为1时该项必填	出租人证件种类>>zdbh: KX_D_CYZJDM
        "czur_zjhm":"",    //当sfczfw为1时该项必填	出租人证件号码
        "czur_xm":"",    //当sfczfw为1时该项必填	出租人姓名
        "czur_lxdh":"",    //当sfczfw为1时该项必填	出租人联系电话
        "czur_wwx":"",    //出租人外文姓
        "czur_wwm":""    //出租人外文名
    }
}

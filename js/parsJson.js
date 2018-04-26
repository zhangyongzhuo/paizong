.pragma library

//解析运通JSON
function yuntongJson(str)
{
    //str = str.replace(/\'/g,"\"")//将单引号替换为双引号
    var objYT = JSON.parse(str); //将运通的json字符串转成json对象
    var objHC = {};              //定义汇创的json对象

    objHC.code=objYT.code;
    objHC.desc=objYT.desc;

    if(objYT.hasOwnProperty("data")) //有data字段
    {
        objHC.data=[];
        for(var i=0; i<objYT.data.length; i++) //遍历第一层data数组
        {
            var j=0;
            objHC.data[i]={}
            if(objYT.data[i].hasOwnProperty("tlinfo")) //有tlinfo字段
            {
                objHC.data[i].railwayInfo=[]
                for(j=0; j<objYT.data[i].tlinfo.length; j++)//遍历铁路信息数组
                {
                    objHC.data[i].railwayInfo[j]={}
                    objHC.data[i].railwayInfo[j].id           =objYT.data[i].tlinfo[j].ID
                    objHC.data[i].railwayInfo[j].name         =objYT.data[i].tlinfo[j].NAME
                    objHC.data[i].railwayInfo[j].idcard       =objYT.data[i].tlinfo[j].IDCARD
                    objHC.data[i].railwayInfo[j].trianNo      =objYT.data[i].tlinfo[j].TRIAN_NO   //车次
                    objHC.data[i].railwayInfo[j].trianData    =objYT.data[i].tlinfo[j].TRAIN_DATE //乘车日期
                    objHC.data[i].railwayInfo[j].startStation =objYT.data[i].tlinfo[j].CF_STATION //出发站
                    objHC.data[i].railwayInfo[j].arriveStation=objYT.data[i].tlinfo[j].DD_STATION //到达站
                    objHC.data[i].railwayInfo[j].coachNo      =objYT.data[i].tlinfo[j].COACH_NO   //车厢号
                    objHC.data[i].railwayInfo[j].seatNo       =objYT.data[i].tlinfo[j].SEAT_NO    //座位号
                }
            }
            if(objYT.data[i].hasOwnProperty("ldinfo")) //有ldinfo字段
            {
                objHC.data[i].hotelInfo=[]
                for(j=0; j<objYT.data[i].ldinfo.length; j++)//遍历旅店信息数组
                {
                    objHC.data[i].hotelInfo[j]={}
                    objHC.data[i].hotelInfo[j].hotelCode      =objYT.data[i].ldinfo[j].qiyebianma  //旅店编码
                    objHC.data[i].hotelInfo[j].hotelName      =objYT.data[i].ldinfo[j].qiyemc      //旅店名称
                    objHC.data[i].hotelInfo[j].hotelAddr      =objYT.data[i].ldinfo[j].xiangxidizhi//旅店详细地址
                    objHC.data[i].hotelInfo[j].name           =objYT.data[i].ldinfo[j].xingming    //姓名
                    objHC.data[i].hotelInfo[j].idcard         =objYT.data[i].ldinfo[j].zhengjianhm //身份证号码
                    objHC.data[i].hotelInfo[j].manageUnitCode =objYT.data[i].ldinfo[j].gxdwbm      //管辖单位编码
                    objHC.data[i].hotelInfo[j].lastEditTime   =objYT.data[i].ldinfo[j].lastedittime//最后编辑时间
                    objHC.data[i].hotelInfo[j].nation         =objYT.data[i].ldinfo[j].mz          //民族
                    objHC.data[i].hotelInfo[j].sex            =objYT.data[i].ldinfo[j].xb          //性别
                    objHC.data[i].hotelInfo[j].checkInTime    =objYT.data[i].ldinfo[j].ruzhusj     //入住时间
                    objHC.data[i].hotelInfo[j].checkOutTime   =objYT.data[i].ldinfo[j].tuifangsj   //退房时间
                }
            }

            if(objYT.data[i].hasOwnProperty("bskzdr")) //有bskzdr字段
            {
                objHC.data[i].terroristPersonInfo=[]
                for(j=0; j<objYT.data[i].bskzdr.length; j++)//遍历部涉恐重点人信息数组
                {
                    objHC.data[i].terroristPersonInfo[j]={}
                    objHC.data[i].terroristPersonInfo[j].id                       =objYT.data[i].bskzdr[j].BJZDRYBH//人员编号
                    objHC.data[i].terroristPersonInfo[j].name                     =objYT.data[i].bskzdr[j].XM      //姓名
                    objHC.data[i].terroristPersonInfo[j].sex                      =objYT.data[i].bskzdr[j].XB      //性别
                    objHC.data[i].terroristPersonInfo[j].namePinyin               =objYT.data[i].bskzdr[j].XMPY    //姓名拼音
                    objHC.data[i].terroristPersonInfo[j].idcard                   =objYT.data[i].bskzdr[j].SFZH    //身份证号码
                    objHC.data[i].terroristPersonInfo[j].birth                    =objYT.data[i].bskzdr[j].CSRQ    //出生日期
                    objHC.data[i].terroristPersonInfo[j].domicileArea             =objYT.data[i].bskzdr[j].HJDQH   //户籍地区划
                    objHC.data[i].terroristPersonInfo[j].domicilePoliceStation    =objYT.data[i].bskzdr[j].HJDPCS  //户籍地派出所
                    objHC.data[i].terroristPersonInfo[j].domicileAddr             =objYT.data[i].bskzdr[j].HJDXZ   //户籍地现址
                    objHC.data[i].terroristPersonInfo[j].currentLiveArea          =objYT.data[i].bskzdr[j].XZDQH   //现居地区划
                    objHC.data[i].terroristPersonInfo[j].currentLivePoliceStation =objYT.data[i].bskzdr[j].XZDPCS  //现居地派出所
                    objHC.data[i].terroristPersonInfo[j].currentLiveAddr          =objYT.data[i].bskzdr[j].XZDXZ   //现居地地址
                    objHC.data[i].terroristPersonInfo[j].manageUnit               =objYT.data[i].bskzdr[j].GXDW    //管辖单位
                    objHC.data[i].terroristPersonInfo[j].recordUnit               =objYT.data[i].bskzdr[j].LADW    //立案单位
                    objHC.data[i].terroristPersonInfo[j].recordTime               =objYT.data[i].bskzdr[j].ZJLASJ  //立案时间
                }
            }
            if(objYT.data[i].hasOwnProperty("mhinfo")) //有mhinfo字段
            {
                objHC.data[i].flightInfo=[]
                for(j=0; j<objYT.data[i].mhinfo.length; j++)//遍历民航信息信息数组
                {
                    objHC.data[i].flightInfo[j]={}
                    objHC.data[i].flightInfo[j].id                      =objYT.data[i].mhinfo[j].ID           //编号
                    objHC.data[i].flightInfo[j].name                    =objYT.data[i].mhinfo[j].NAME         //姓名
                    objHC.data[i].flightInfo[j].idcard                  =objYT.data[i].mhinfo[j].IDCARD       //身份证号码
                    objHC.data[i].flightInfo[j].flightNo                =objYT.data[i].mhinfo[j].HBH          //航班号
                    objHC.data[i].flightInfo[j].seatNo                  =objYT.data[i].mhinfo[j].SEATNO       //座位号
                    objHC.data[i].flightInfo[j].startData               =objYT.data[i].mhinfo[j].CFDATE       //计划出发日期
                    objHC.data[i].flightInfo[j].startTime               =objYT.data[i].mhinfo[j].CFTIME       //计划出发时间
                    objHC.data[i].flightInfo[j].arriveData              =objYT.data[i].mhinfo[j].DDDATE       //计划到达日期
                    objHC.data[i].flightInfo[j].arriveTime              =objYT.data[i].mhinfo[j].DDTIME       //计划到达时间
                    objHC.data[i].flightInfo[j].startStationThreeCode   =objYT.data[i].mhinfo[j].CFSTATION_SZM//出发机场三字码
                    objHC.data[i].flightInfo[j].startStation            =objYT.data[i].mhinfo[j].CFSTATION    //出发机场
                    objHC.data[i].flightInfo[j].arriveStationThreeCode  =objYT.data[i].mhinfo[j].DDSTATION_SZM//到达机场三字码
                    objHC.data[i].flightInfo[j].arriveStation           =objYT.data[i].mhinfo[j].DDSTATION    //到达机场
                    objHC.data[i].flightInfo[j].importanceTravellerName =objYT.data[i].mhinfo[j].ZDLK_NAME    //重点旅客姓名
                    objHC.data[i].flightInfo[j].isImportanceTravellerDel=objYT.data[i].mhinfo[j].ZDLK_DELFLAG //重点旅客是否删除
                    objHC.data[i].flightInfo[j].status                  =objYT.data[i].mhinfo[j].STATUS       //状态
                }
            }
            if(objYT.data[i].hasOwnProperty("wbinfo")) //有wbinfo字段
            {
                objHC.data[i].netBarInfo=[]
                for(j=0; j<objYT.data[i].wbinfo.length; j++)//遍历网吧信息数组
                {
                    objHC.data[i].netBarInfo[j]={}
                    objHC.data[i].netBarInfo[j].netBarId    =objYT.data[i].wbinfo[j].yycsdm//网吧场所编码
                    objHC.data[i].netBarInfo[j].name        =objYT.data[i].wbinfo[j].swryxm//上网人姓名
                    objHC.data[i].netBarInfo[j].idcard      =objYT.data[i].wbinfo[j].zjhm  //身份证号码
                    objHC.data[i].netBarInfo[j].netBarName  =objYT.data[i].wbinfo[j].yycsmc//网吧场所名称
                    objHC.data[i].netBarInfo[j].nation      =objYT.data[i].wbinfo[j].mz    //民族
                    objHC.data[i].netBarInfo[j].addrAreaCode=objYT.data[i].wbinfo[j].dzqh  //地址区划
                    objHC.data[i].netBarInfo[j].addr        =objYT.data[i].wbinfo[j].dz    //地址
                    objHC.data[i].netBarInfo[j].startTime   =objYT.data[i].wbinfo[j].swkssj//上网开始时间
                    objHC.data[i].netBarInfo[j].endTime     =objYT.data[i].wbinfo[j].xwsj  //下网时间
                }
            }
            if(objYT.data[i].hasOwnProperty("sjszstu")) //有sjszstu字段
            {
                objHC.data[i].xinZangStuInfo=[]
                for(j=0; j<objYT.data[i].sjszstu.length; j++)//遍历涉疆涉藏学生信息数组
                {
                    objHC.data[i].xinZangStuInfo[j]={}
                    objHC.data[i].xinZangStuInfo[j].name          =objYT.data[i].sjszstu[j].xm  //姓名
                    objHC.data[i].xinZangStuInfo[j].sex           =objYT.data[i].sjszstu[j].xb  //性别
                    objHC.data[i].xinZangStuInfo[j].idcard        =objYT.data[i].sjszstu[j].sfzh//身份证号码
                    objHC.data[i].xinZangStuInfo[j].politicsStatus=objYT.data[i].sjszstu[j].zzmm//政治面貌
                    objHC.data[i].xinZangStuInfo[j].nation        =objYT.data[i].sjszstu[j].mz  //民族
                    objHC.data[i].xinZangStuInfo[j].universityName=objYT.data[i].sjszstu[j].yxmc//学校名称
                    objHC.data[i].xinZangStuInfo[j].specialtyName =objYT.data[i].sjszstu[j].zymc//专业名称
                    objHC.data[i].xinZangStuInfo[j].entranceData  =objYT.data[i].sjszstu[j].rxrq//入校日期
                }
            }
            if(objYT.data[i].hasOwnProperty("baseinfo")) //有baseinfo字段
            {
                objHC.data[i].temporaryInfo=[]
                for(j=0; j<objYT.data[i].baseinfo.length; j++)//遍历暂住信息数组
                {
                    objHC.data[i].temporaryInfo[j]={}
                    objHC.data[i].temporaryInfo[j].name         =objYT.data[i].baseinfo[j].NAME       //姓名
                    objHC.data[i].temporaryInfo[j].otherName    =objYT.data[i].baseinfo[j].OTHERNAME  //别名
                    objHC.data[i].temporaryInfo[j].sex          =objYT.data[i].baseinfo[j].SEX        //性别
                    objHC.data[i].temporaryInfo[j].idcard       =objYT.data[i].baseinfo[j].IDCARD     //身份证号码
                    objHC.data[i].temporaryInfo[j].birth        =objYT.data[i].baseinfo[j].BIRTH      //出生日期yyyy-MM-dd
                    objHC.data[i].temporaryInfo[j].relation     =objYT.data[i].baseinfo[j].RELATION   //人员关系
                    objHC.data[i].temporaryInfo[j].nation       =objYT.data[i].baseinfo[j].NATION     //民族
                    objHC.data[i].temporaryInfo[j].maritalStatus=objYT.data[i].baseinfo[j].HYQK       //婚姻情况
                    objHC.data[i].temporaryInfo[j].nativePlace  =objYT.data[i].baseinfo[j].JG         //籍贯
                    objHC.data[i].temporaryInfo[j].domicilePlace=objYT.data[i].baseinfo[j].HKSZD      //户口所在地
                    objHC.data[i].temporaryInfo[j].height       =objYT.data[i].baseinfo[j].HEIGHT     //身高
                    objHC.data[i].temporaryInfo[j].bloodType    =objYT.data[i].baseinfo[j].BLOODTYPE  //血型
                    objHC.data[i].temporaryInfo[j].weight       =objYT.data[i].baseinfo[j].WEIGHT     //体重
                    objHC.data[i].temporaryInfo[j].speciallity  =objYT.data[i].baseinfo[j].SPECIALLITY//特长
                    objHC.data[i].temporaryInfo[j].education    =objYT.data[i].baseinfo[j].EDUCATION  //文化程度
                    objHC.data[i].temporaryInfo[j].work         =objYT.data[i].baseinfo[j].WORK       //职业
                    objHC.data[i].temporaryInfo[j].religion     =objYT.data[i].baseinfo[j].RELIGION   //宗教信仰
                    objHC.data[i].temporaryInfo[j].workUnit     =objYT.data[i].baseinfo[j].WORKUINT   //工作单位
                    objHC.data[i].temporaryInfo[j].addr         =objYT.data[i].baseinfo[j].ADDRESS    //住址
                    objHC.data[i].temporaryInfo[j].tel          =objYT.data[i].baseinfo[j].TEL        //联系方式
                    objHC.data[i].temporaryInfo[j].comeTime     =objYT.data[i].baseinfo[j].JZSJ       //来本辖区居住时间
                    var temp = objYT.data[i].baseinfo[j].ISJZ //是否久住，1久住0非久住
                    if(temp === 1)
                    {
                        objHC.data[i].temporaryInfo[j].foreverLive  ="久住";
                    }
                    else
                    {
                        objHC.data[i].temporaryInfo[j].foreverLive  ="非久住";
                    }
                    objHC.data[i].temporaryInfo[j].haveDrivingLicense= objYT.data[i].baseinfo[j].JZ//是否有驾照
                    /*
                    temp = objYT.data[i].baseinfo[j].JZ//是否有驾照
                    if(temp === 1)
                    {
                        objHC.data[i].temporaryInfo[j].haveDrivingLicense  ="有驾照";
                    }
                    else
                    {
                        objHC.data[i].temporaryInfo[j].haveDrivingLicense  ="无驾照";
                    }*/
                    objHC.data[i].temporaryInfo[j].haveCar= objYT.data[i].baseinfo[j].ISCL//是否有车辆
                    /*temp = objYT.data[i].baseinfo[j].ISCL//是否有车辆
                    if(temp === 1)
                    {
                        objHC.data[i].temporaryInfo[j].haveCar  ="有车辆";
                    }
                    else
                    {
                        objHC.data[i].temporaryInfo[j].haveCar  ="无车辆";
                    }*/
                    objHC.data[i].temporaryInfo[j].carNo  =objYT.data[i].baseinfo[j].CLHM//车牌号码
                    objHC.data[i].temporaryInfo[j].havePassport  = objYT.data[i].baseinfo[j].ISHZ//是否有护照
                    /*temp = objYT.data[i].baseinfo[j].ISHZ//是否有护照
                    if(temp === 1)
                    {
                        objHC.data[i].temporaryInfo[j].havePassport  ="有护照";
                    }
                    else
                    {
                        objHC.data[i].temporaryInfo[j].havePassport  ="无护照";
                    }*/
                    objHC.data[i].temporaryInfo[j].passportNo    =objYT.data[i].baseinfo[j].HZHM      //护照号码
                    objHC.data[i].temporaryInfo[j].policeName    =objYT.data[i].baseinfo[j].C_NAME    //录入人姓名
                    objHC.data[i].temporaryInfo[j].policeIdCard  =objYT.data[i].baseinfo[j].C_IDCARD  //录入人身份证号码
                    objHC.data[i].temporaryInfo[j].policeId      =objYT.data[i].baseinfo[j].C_POLICEID//录入人警号
                    objHC.data[i].temporaryInfo[j].policeUnit    =objYT.data[i].baseinfo[j].C_DWNAME  //录入人单位名称
                    objHC.data[i].temporaryInfo[j].policeAreaCode=objYT.data[i].baseinfo[j].C_XZQH    //录入人行政区划
                    objHC.data[i].temporaryInfo[j].policeUnitCode=objYT.data[i].baseinfo[j].C_DWBM    //录入人单位编码
                    objHC.data[i].temporaryInfo[j].collectAddr   =objYT.data[i].baseinfo[j].CJDZ      //采集地址
                }
            }
            if(objYT.data[i].hasOwnProperty("ztinfo")) //有ztinfo字段
            {
                objHC.data[i].escapeInfo=[]
                for(j=0; j<objYT.data[i].ztinfo.length; j++)//遍历在逃信息数组
                {
                    objHC.data[i].escapeInfo[j]={}
                    objHC.data[i].escapeInfo[j].id  =objYT.data[i].ztinfo[j].RYBH//人员编号
                    objHC.data[i].escapeInfo[j].name=objYT.data[i].ztinfo[j].XM  //姓名
                    temp = objYT.data[i].ztinfo[j].XB_DM  //性别
                    if(temp === 1)
                    {
                        objHC.data[i].escapeInfo[j].sex="男";
                    }
                    else
                    {
                        objHC.data[i].escapeInfo[j].sex="女";
                    }
                    objHC.data[i].escapeInfo[j].birth          =objYT.data[i].ztinfo[j].CSRQ_SX//出生日期yyyy-MM-dd
                    objHC.data[i].escapeInfo[j].idcard         =objYT.data[i].ztinfo[j].SFZH  //身份证号码
                    objHC.data[i].escapeInfo[j].nation         =objYT.data[i].ztinfo[j].mz    //民族
                    objHC.data[i].escapeInfo[j].height         =objYT.data[i].ztinfo[j].sg    //身高
                    objHC.data[i].escapeInfo[j].accent         =objYT.data[i].ztinfo[j].ky    //口音
                    objHC.data[i].escapeInfo[j].work           =objYT.data[i].ztinfo[j].zy    //职业
                    objHC.data[i].escapeInfo[j].domicile       =objYT.data[i].ztinfo[j].HJD_XZ//户籍地详址
                    objHC.data[i].escapeInfo[j].currentLive    =objYT.data[i].ztinfo[j].XZD_XZ//现住地详址
                    objHC.data[i].escapeInfo[j].fingerprintCode=objYT.data[i].ztinfo[j].ZWBH  //指纹编号
                    objHC.data[i].escapeInfo[j].DNA            =objYT.data[i].ztinfo[j].DNA   //DNA
                    objHC.data[i].escapeInfo[j].caseCode       =objYT.data[i].ztinfo[j].AJBH  //案件编号
                    objHC.data[i].escapeInfo[j].caseType       =objYT.data[i].ztinfo[j].ajlb  //案件类别
                    objHC.data[i].escapeInfo[j].escapeType     =objYT.data[i].ztinfo[j].ztlx  //在逃类型
                    objHC.data[i].escapeInfo[j].caseAbout      =objYT.data[i].ztinfo[j].JYAQ  //简要案情
                    objHC.data[i].escapeInfo[j].escapeData     =objYT.data[i].ztinfo[j].TPRQ  //逃跑日期
                    objHC.data[i].escapeInfo[j].recordTime     =objYT.data[i].ztinfo[j].LASJ  //立案时间
                    objHC.data[i].escapeInfo[j].recordUnit     =objYT.data[i].ztinfo[j].LA_DWXC//立案单位
                }
            }
            if(objYT.data[i].hasOwnProperty("wffzinfo")) //有wffzinfo字段
            {
                objHC.data[i].illegalInfo=[]
                for(j=0; j<objYT.data[i].wffzinfo.length; j++)//遍历违法犯罪信息数组
                {
                    objHC.data[i].illegalInfo[j]={}
                    objHC.data[i].illegalInfo[j].id  =objYT.data[i].wffzinfo[j].xyrbh//人员编号
                    objHC.data[i].illegalInfo[j].name=objYT.data[i].wffzinfo[j].XM  //姓名
                    objHC.data[i].illegalInfo[j].sex =objYT.data[i].wffzinfo[j].XBZW  //性别
                    /*temp = objYT.data[i].wffzinfo[j].XB_DM  //性别
                    if(temp === 1)
                    {
                        objHC.data[i].illegalInfo[j].sex="男";
                    }
                    else
                    {
                        objHC.data[i].illegalInfo[j].sex="女";
                    }*/
                    objHC.data[i].illegalInfo[j].idcard   =objYT.data[i].wffzinfo[j].sfzh //身份证号码
                    objHC.data[i].illegalInfo[j].domicile =objYT.data[i].wffzinfo[j].hjszd//户籍所在地
                    objHC.data[i].illegalInfo[j].tel      =objYT.data[i].wffzinfo[j].lxfs //联系方式
                    objHC.data[i].illegalInfo[j].otherName=objYT.data[i].wffzinfo[j].cym //曾用名
                    objHC.data[i].illegalInfo[j].birth    =objYT.data[i].wffzinfo[j].csrq    //出生日期
                    temp=objYT.data[i].wffzinfo[j].sfjwry//是否境外人员 1是 0不是
                    if(temp === 1)
                    {
                        objHC.data[i].illegalInfo[j].outsideEmployment="是";
                    }
                    else
                    {
                        objHC.data[i].illegalInfo[j].outsideEmployment="不是";
                    }
                    objHC.data[i].illegalInfo[j].nation      =objYT.data[i].wffzinfo[j].mzzw    //民族
                    objHC.data[i].illegalInfo[j].nationality =objYT.data[i].wffzinfo[j].gjzw    //国籍
                    objHC.data[i].illegalInfo[j].domicileType=objYT.data[i].wffzinfo[j].hjlxzw  //户籍类型
                    objHC.data[i].illegalInfo[j].domicileArea=objYT.data[i].wffzinfo[j].hjdqh   //户籍地区划
                    objHC.data[i].illegalInfo[j].domicileAddr=objYT.data[i].wffzinfo[j].hjszd   //户籍所在地
                    objHC.data[i].illegalInfo[j].currentArea =objYT.data[i].wffzinfo[j].sjdqh   //实际地区划
                    objHC.data[i].illegalInfo[j].currentAddr =objYT.data[i].wffzinfo[j].sjjzd   //实际居住地
                    objHC.data[i].illegalInfo[j].workUnit    =objYT.data[i].wffzinfo[j].gzdw    //工作单位
                    objHC.data[i].illegalInfo[j].work        =objYT.data[i].wffzinfo[j].zyzw    //职业
                    objHC.data[i].illegalInfo[j].duty        =objYT.data[i].wffzinfo[j].zwzw    //职务
                    objHC.data[i].illegalInfo[j].mainPoliceIdCard=objYT.data[i].wffzinfo[j].zbzcysfzh//主办侦查员身份证号码
                    objHC.data[i].illegalInfo[j].mainPoliceName  =objYT.data[i].wffzinfo[j].zbzcyxm  //主办侦查员姓名
                    objHC.data[i].illegalInfo[j].policeIdCard    =objYT.data[i].wffzinfo[j].zcysfzh  //侦查员身份证号码
                    objHC.data[i].illegalInfo[j].policeName      =objYT.data[i].wffzinfo[j].zcyxm    //侦查员姓名
                    objHC.data[i].illegalInfo[j].transferUnit    =objYT.data[i].wffzinfo[j].ysdwzw   //移送单位
                    objHC.data[i].illegalInfo[j].manageCause     =objYT.data[i].wffzinfo[j].clyydlzw //处理原因
                    temp=objYT.data[i].wffzinfo[j].sfqkfz//是否前科犯罪 1是 0不是
                    if(temp === 1)
                    {
                        objHC.data[i].illegalInfo[j].illegal="是前科犯罪";
                    }
                    else
                    {
                        objHC.data[i].illegalInfo[j].illegal="不是前科犯罪";
                    }
                    temp=objYT.data[i].wffzinfo[j].sfzzry//是否暂住人口 1是 0不是
                    if(temp === 1)
                    {
                        objHC.data[i].illegalInfo[j].temporaryPeople="是暂住人口";
                    }
                    else
                    {
                        objHC.data[i].illegalInfo[j].temporaryPeople="不是暂住人口";
                    }
                    temp=objYT.data[i].wffzinfo[j].sflcza//是否流窜作案 1是 0不是
                    if(temp === 1)
                    {
                        objHC.data[i].illegalInfo[j].vagabondCrimes="是流窜作案";
                    }
                    else
                    {
                        objHC.data[i].illegalInfo[j].vagabondCrimes="不是流窜作案";
                    }
                }
            }
        }
    }
    return objHC;
}

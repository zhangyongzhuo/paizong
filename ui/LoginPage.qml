import QtQuick 2.4
import QtMultimedia 5.4
import "qrc:/base/js/common.js" as JSL
import com.hylink.fmcp.ctrl 2.0
LoginPageForm {

    property string policejson: ""  //原始的警員數據
    property var policelist: []     //临时警员身份证号list
    property var policeLoginList: []


    Audio{
        id: readCardSound
        source: "qrc:/sounds/sounds/readCard.wav"
    }

    Component.onCompleted:  {
        version="2.0.0.2"

        //初始化配置信息
        goIpPort = operateconfigfile.getGoServiceIP() +":"+ operateconfigfile.getGoServicePort()
        remoteIpPort = operateconfigfile.getRemoteIP() +":"+ operateconfigfile.getRemotePort()
        uid = qmlData.GetDeviceId()
        mainPageTitle = operateconfigfile.getShowTextMainPageTitle()//设置主页标题
        englishTitle = operateconfigfile.getShowTextEnglishTitle()//设置主页标题英文
        companyName =  operateconfigfile.getShowTextCompanyName()  //设置公司 名称
        approverIdcard= operateconfigfile.getApproverIdcard()  //报备界面审批人
        approverLeader= operateconfigfile.getApproverLeader()  //报备界面审批人

        //查找本地警员列表
        getPoliceIdcardList()

        //初始化设置界面
        getSetInfo()
        //获取当前使用模式
    }

    //退出按钮点击事件
    exitBtn.onClicked: {
        popWindowExit.visible = true
        mainPage.enabled = false
    }
    //退出系统-是 点击事件
    isExitBtn.onClicked: {
        monitorProcess.stopProcessIdentification()
        Qt.quit()
    }
    //退出系统-否 点击事件
    noExitBtn.onClicked: {
        popWindowExit.visible = false
        mainPage.enabled = true
    }
    //登录按钮点击事件
    loginBtn.onClicked: {
        getFocus.focus = true

        if(0){

        }
        else{
            //目前只对空值情况做校验 之后加上对警号及身份证号格式校验
            if(idcard.text == ''){
                messagebox.text = "用户名不可为空"
                messagebox.visible = true
                return
            }
            if(!JSL.isContainSpace(idcard.text)){
                messagebox.text = "用户名不可包含空格"
                messagebox.visible = true
                return
            }

            //进行登录验证操作
            busyIndicator.running = true
            var url ="http://"+goIpPort+"/sy/loginPassword"
            //var url ="http://"+goIpPort+"/loginPassword"
            var datajson = {
                "password": password.text,
                "username": idcard.text,
                "cid"     : uid,
                "isRemeber": rememberPassword.checked ? 1 : 0
            }
            console.log("登录接口入参URL:"+url)
            console.log("登录接口入参:"+JSON.stringify(datajson))
            operatehttp.post(url,function(code, data){

                //data="{\"dyOrganization\":[{\"id\":\"88736864\",\"orgcode\":\"210105150000\",\"orgname\":\"沈阳市公安局皇姑分局国内安全保卫大队哇哈哈哈11112aa\",\"orgjb\":\"31\"},{\"id\":\"4297\",\"orgcode\":\"210102350002\",\"orgname\":\"正大社区第二责任区\",\"orgjb\":\"50\"},{\"id\":\"3980\",\"orgcode\":\"210102350010\",\"orgname\":\"五环社区第一责任区\",\"orgjb\":\"50\"},{\"id\":\"88729321\",\"orgcode\":\"210102350000\",\"orgname\":\"沈阳市公安局和平分局太原街派出所\",\"orgjb\":\"32\"},{\"id\":\"4292\",\"orgcode\":\"210102350001\",\"orgname\":\"正大社区第一责任区\",\"orgjb\":\"50\"},{\"id\":\"4301\",\"orgcode\":\"210102350006\",\"orgname\":\"正大社区第三责任区\",\"orgjb\":\"50\"},{\"id\":\"4058\",\"orgcode\":\"210102350003\",\"orgname\":\"洪福社区第一责任区\",\"orgjb\":\"50\"},{\"id\":\"4357\",\"orgcode\":\"210102350007\",\"orgname\":\"环宇社区第一责任区\",\"orgjb\":\"50\"},{\"id\":\"88729321\",\"orgcode\":\"210102350000\",\"orgname\":\"沈阳市公安局和平分局太原街派出所\",\"orgjb\":\"32\"},{\"id\":\"4104\",\"orgcode\":\"210102350009\",\"orgname\":\"五环社区第二责任区\",\"orgjb\":\"50\"}],\"status\":\"登录成功!\",\"dict_edition\":\"v1.0\",\"success\":\"1\",\"dyYdjworgmenu\":[{\"id\":\"01\",\"menuname\":\"标准地址管理\"},{\"id\":\"02\",\"menuname\":\"实有人口管理\"},{\"id\":\"03\",\"menuname\":\"实有房屋管理\"},{\"id\":\"04\",\"menuname\":\"实有单位管理\"},{\"id\":\"06\",\"menuname\":\"实有人口查询\"},{\"id\":\"07\",\"menuname\":\"实有房屋查询\"},{\"id\":\"08\",\"menuname\":\"实有单位查询\"}]}"

                console.log("登录接口回参code:"+code)
                console.log("登录接口回参data:"+data)

                busyIndicator.running = false
                if(code==200){
                    if(data!=="")
                    {
                        var tempObj = JSON.parse(data)
                        var policeObj = JSON.parse(tempObj)
                        //var policeObj = JSON.parse(data)

                        if(policeObj.success == "1"){
                            //存储管辖区域列表
                            if(policeObj.dyOrganization != undefined
                               && policeObj.dyOrganization.length > 0){

                                orgList = policeObj.dyOrganization

                                for(var i=0; i<orgList.length; i++){
                                    if(orgList[i].orgcode == operateconfigfile.getOrgCode()){
                                        break; //在返回的列表中找到了目前配置文件中存储的管辖区域
                                    }
                                }

                                //if(operateconfigfile.getOrgName() == "") //配置文件中未存有任何管辖区域 默认存储第一个
                                if(i >= orgList.length) //配置文件中存储的管辖区域不在获取到的管辖区域列表内 默认存储第一个
                                {
                                    operateconfigfile.setOrgId(policeObj.dyOrganization[0].id)
                                    operateconfigfile.setOrgName(policeObj.dyOrganization[0].orgname)
                                    operateconfigfile.setOrgCode(policeObj.dyOrganization[0].orgcode)
                                    operateconfigfile.setOrgJb(policeObj.dyOrganization[0].orgjb)
                                }

                            }


                            token = '123'
                            userName = idcard.text

                            //留着用来保存警员姓名
                            policeName = policeObj.username
                            policeIdCard = idcard.text
                            loginpassword = password.text

                            qmlData.setPoliceIdcard(policeIdCard)

                            stackView.push({item: "qrc:/base/ui/MainPage.qml", properties:{policeIdcard: idcard.text}})
                        }
                        else{
                            messagebox.text = policeObj.status
                            messagebox.visible = true
                            getFocus.focus = true
                        }
                    }
                    else{
                        messagebox.text = "登陆失败"
                        messagebox.visible = true
                        getFocus.focus = true
                    }

                }
                else{
                    if(data!==""){//失败时如果回复数据不为空 提取msg显示在提示框中  如果恢复数据为空 提示框显示登陆异常
                        tempObj = JSON.parse(data)
                        policeObj = JSON.parse(tempObj)

                        //policeObj = JSON.parse(data)

                        console.log(policeObj)
                        token = '123'
                        messagebox.text = policeObj.status
                        messagebox.visible = true;
                        getFocus.focus = true
                    }else{
                        messagebox.text = "登陆异常"
                        messagebox.visible = true;
                        getFocus.focus = true
                    }
                    return
                }
            },"(0)="+JSON.stringify(datajson))
        }
    }

    //用户名文本框光标改变事件
    idcard.onCursorVisibleChanged: {
        idcard.cursorVisible ? digiBoard.visible=true : digiBoard.visible=false

        if(policelist.length <= 0){
            policeDataArea.visible = false
            return;
        }

        if(idcard.cursorVisible){
            idcard.hint=''
            policeDataArea.visible = true
            policeDataArea.bHightLight = true
        }else{
            policeDataArea.visible = false
            idcard.hint='身份证号/警号'
        }
    }

    //用户名文本框字符改变事件
    idcard.onTextChanged: {
        if(idcard.cursorVisible == true){
            policeDataArea.visible = true
            policeDataArea.bHightLight = true
        }else{
            policeDataArea.visible = false
        }

        if(idcard.text != ""){
            policeData.json = ""
            policelist = []
            //到原始Json中查找符合項
            if(policejson == ""){
                policeDataArea.visible = false
            }
            else{
                var obj = JSON.parse(policejson)
                for (var i=0;i<obj.length;i++) {
                    if(obj[i].PoliceIdcard.indexOf(idcard.text)>=0){
                        policelist.push(obj[i])
                    }
                }
                //有符合項
                if(policelist.length > 0){
                    policeData.json = JSON.stringify(policelist)
                }
                else{
                    policeDataArea.visible = false
                }
            }
        }
        else{
            if(policejson != ""){
                policeData.json = policejson
            }
            else{
                policeDataArea.visible = false
            }
        }

        for(var j=0; j<policeLoginList.length; j++){
            if(idcard.text == policeLoginList[j].userName){
                if(policeLoginList[j].rememberPassword){
                    password.text = policeLoginList[j].password
                    rememberPassword.checked = true
                }else{
                    password.text = ''
                    rememberPassword.checked = false
                }
            }else{
                password.text = ''
                rememberPassword.checked = false
            }
        }
    }

    //密码文本框光标改变事件
    password.onCursorVisibleChanged: {
        password.cursorVisible ? digiBoard.visible=true : digiBoard.visible=false
    }

    //二代证键盘输入事件
    Connections{
        target: mainQml

        onDigiTextChange: {
            if(idcard.cursorVisible){
                idcard.text += text
            }else if(password.cursorVisible){
                password.text += text
            }
        }
        onDigiTextDel: {
            if(idcard.cursorVisible){
                idcard.text = idcard.text.substring(0, idcard.text.length-1)
            }else if(password.cursorVisible){
                password.text = password.text.substring(0, password.text.length-1)
            }
        }
    }
    //查找本地警员列表
    function getPoliceIdcardList(){
        //查詢本地已有所有警員身份證號  返回json 接口已验证通过
        var url ="http://"+goIpPort+"/policeIdcardList"
        operatehttp.get(url, function(code, data){
            if(code == 200){
                if(data != "" && data != 'null'){
                    policejson = data
                    policeData.json = policejson

                    var policeList = JSON.parse(policeData.json)
                    for(var i=0;i<policeList.length;i++){
                        var temp = {}
                        temp.userName = policeList[i].PoliceIdcard
                        temp.password = policeList[i].Password
                        temp.rememberPassword = policeList[i].isRemeber
                        policeLoginList.push(temp)
                    }
                }
                else{
                    policejson = ''
                }
            }else{
                policeDataArea.visible = false
                console.log("获取本地警员列表失败:"+code)
            }

            policelist = JSON.parse(policejson)
        })
    }

    //设置界面初始化
    function getSetInfo(){
        //代理信息
        proxyEnable = operateconfigfile.getProxyHttpsEnable()
        if(proxyEnable){
            proxySwitch.currentIndex = 0
            proxySwitch.currentText = '使用代理'
        }else{
            proxySwitch.currentIndex = 1
            proxySwitch.currentText = '不使用代理'
        }
        proxyIP.text = operateconfigfile.getProxyHttpsIP()
        proxyPort.text = operateconfigfile.getProxyHttpsPort()
        proxyUser.text = operateconfigfile.getProxyUsreName()
        proxyPassword.text = operateconfigfile.getProxyPassword()
        //登录服务器
        loginServerIP.text = operateconfigfile.getRemoteIP()
        loginServerPort.text = operateconfigfile.getRemotePort()
    }

    //通知go服务当前设置发生变化
    function tellProxyInfoToGo(){
        var url ="http://"+goIpPort+"/proxy"
        var proxyJson = {
            "isUseProxy": proxyEnable,
            "proxyIP": proxyIP.text,
            "proxyPort": proxyPort.text,
            "username": proxyUser.text,
            "password": proxyPassword.text,
            "serverIP": loginServerIP.text,
            "serverPort": loginServerPort.text
        }
        operatehttp.post(url,function(code, data){
            if(code==200){
                console.log("向Go告知代理信息成功")
            }else{
                messagebox.text = "连接Go服务失败，请确认Go服务是否正在运行"
                messagebox.visible = true
                messagebox.nIntervalTime = 5000
                console.log("向Go告知代理信息失败："+code)
            }
        },"(0)="+JSON.stringify(proxyJson))
    }

    setBtn.onClicked: {
        loginArea.visible = false
        setArea.visible = true
        getFocus.focus = true
        getSetInfo()
    }

    setMakesure.onClicked: {
        loginArea.visible = true
        setArea.visible = false
        getFocus.focus = true

        if(proxySwitch.currentIndex==0){
            proxyEnable = true
        }else{
            proxyEnable = false
        }
        operateconfigfile.setProxyHttpsEnable(proxyEnable)
        operateconfigfile.setProxyHttpsIP(proxyIP.text)
        operateconfigfile.setProxyHttpsPort(proxyPort.text)
        operateconfigfile.setProxyUserName(proxyUser.text)
        operateconfigfile.setProxyPassword(proxyPassword.text)
        operateconfigfile.setRemoteIP(loginServerIP.text)
        operateconfigfile.setRemotePort(loginServerPort.text)

        tellProxyInfoToGo()

        remoteIpPort = operateconfigfile.getRemoteIP() +":"+ operateconfigfile.getRemotePort()
    }
    setCancle.onClicked: {
        loginArea.visible = true
        setArea.visible = false
        getFocus.focus = true
    }

    onChangeUserName:{//用户名切换
        for(var j=0; j<policeLoginList.length; j++){
            if(userName == policeLoginList[j].userName){
                if(policeLoginList[j].rememberPassword){
                    password.text = policeLoginList[j].password
                    rememberPassword.checked = true
                }else{
                    password.text = ''
                    rememberPassword.checked = false
                }
            }
        }
    }


}

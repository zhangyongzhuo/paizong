import QtQuick 2.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/base/js/common.js" as JSL
import "qrc:/collectJson/js/ThreeRealPerson.js"  as ThreeRealPerson

//实有人员界面---基本信息使用

BaseInfoPersonPageForm {
    property var pageDataJsonObject:ThreeRealPerson.getJbxx()
    property int entryPageMode: 0    //进入方式增删改查
    property string initJson:""      //初始化Json
    property var  objT:[]     //初始化Json

    property var birthCountryList: []   //出生国家数据列表
    property var birthAreaList: []      //出生地数据列表
    property var nativeCountryList: []  //籍贯国家数据列表
    property var nativePlaceList: []    //籍贯数据列表
    property var educationList: []      //学历数据列表
    property var politicalList: []      //政治面貌数据列表
    property var tradeClassList: []     //职业类别数据列表


    Component.onCompleted:{
        if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
            if(PAGEDATA != undefined){//传过来的是个数组
                objT=JSON.parse(PAGEDATA)
                telephone.text=objT.lxdh
                beforeName.text=objT.cym
                occupational.text=objT.zy
                workUnit.text=objT.gzdw
            }
        }

        var url = 'http://'+goIpPort+'/sy/syTypeDict/[GB_D_GJHDQDM,GB_D_XZQHDM,GB_D_HYZKDM,GB_D_XLDM,GB_D_ZZMMDM,ZA_D_XXDM,ZA_D_ZJXYDM,ZA_D_BYQKDM,GB_D_ZYFLYDM]'
         //console.log("url:"+url)
         operatehttp.get(url, function(code, data){
             if(code == 200){
                 if(data != ""){
                     var obj = JSON.parse(data)
                     //console.log("基础信息数据"+obj.length+data)
                     //birthCountry.model.clear()     //出生国家
                     //nativeCountry.model.clear()    //籍贯国家
                     //birthArea.model.clear()     //出生地
                     //nativePlace.model.clear()      //籍贯
                     marriage.model.clear()       //婚姻状况
                     //education.model.clear()        //学历代码
                     //political.model.clear()      //政治面貌
                     bloodType.model.clear()       //血型
                     religion.model.clear()     //宗教信仰
                     militaryService.model.clear()     //兵役状况
                     //tradeClass.model.clear()      //职业类别

                     birthCountryList=[]      //出生国家
                     birthAreaList = []       //出生地
                     nativeCountryList = []   //籍贯国家
                     nativePlaceList = []     //籍贯
                     educationList = []       //学历代码
                     politicalList = []       //政治面貌
                     tradeClassList = []      //职业类别

                     for(var i=0;i<obj.length;i++){
                         var tempItem = {}
                         tempItem.text = obj[i].ct
                         tempItem.code = obj[i].dm
                         if (obj[i].zdbh == "GB_D_GJHDQDM")//出生国家和籍贯国家
                         {                                                         
                             birthCountryList.push(tempItem)
                             nativeCountryList.push(tempItem)
                             //birthCountry.model.append({text:obj[i].ct, code:obj[i].dm})
                             //nativeCountry.model.append({text:obj[i].ct, code:obj[i].dm})
                             if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
                                 if(PAGEDATA != undefined){
                                     if(obj[i].dm==objT.csdgjhdqdm){
                                         birthCountry.wenben.text = obj[i].ct
                                         birthCountry.chooseItem = tempItem
                                         //birthCountry.currentIndex = i
                                         //birthCountry.currentText = obj[i].ct
                                     }
                                     if(obj[i].dm==objT.jggjdqdm){
                                         nativeCountry.wenben.text = obj[i].ct
                                         nativeCountry.chooseItem = tempItem
                                         //nativeCountry.currentIndex = i
                                         //nativeCountry.currentText = obj[i].ct
                                     }
                                 }
                             }
                         }
                         if (obj[i].zdbh == "GB_D_XZQHDM")//出生地和籍贯
                         {
                             birthAreaList.push(tempItem)
                             nativePlaceList.push(tempItem)
                             //birthArea.model.append({text:obj[i].ct, code:obj[i].dm})
                             //nativePlace.model.append({text:obj[i].ct, code:obj[i].dm})
                             if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
                                if(PAGEDATA != undefined){
                                    if(obj[i].dm==objT.csdssxdm){
                                        //birthArea.currentIndex = i
                                        //birthArea.currentText = obj[i].ct
                                        birthArea.wenben.text = obj[i].ct
                                        birthArea.chooseItem = tempItem
                                    }
                                     if(obj[i].dm==objT.jgssxdm){
                                         //nativePlace.currentIndex = i
                                         //nativePlace.currentText = obj[i].ct
                                         nativePlace.wenben.text = obj[i].ct
                                         nativePlace.chooseItem = tempItem
                                     }
                                }
                             }
                         }
                         if (obj[i].zdbh == "GB_D_HYZKDM")//婚姻状况
                         {
                             marriage.model.append({text:obj[i].ct, code:obj[i].dm})
                             if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
                                if(PAGEDATA != undefined){
                                    if(obj[i].dm==objT.hyzkdm){
                                        marriage.currentIndex = i
                                        marriage.currentText = obj[i].ct
                                    }
                                }
                            }
                         }
                         if (obj[i].zdbh == "GB_D_XLDM")//学历代码
                         {
                             educationList.push(tempItem)
                             //education.model.append({text:obj[i].ct, code:obj[i].dm})
                             if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
                                 if(PAGEDATA != undefined){
                                     if(obj[i].dm==objT.xldm){
                                         education.wenben.text = obj[i].ct
                                         education.chooseItem = tempItem
                                         //housePurpose.currentIndex = i
                                         //housePurpose.currentText = obj[i].ct
                                     }
                                 }

                             }
                         }
                         if (obj[i].zdbh == "GB_D_ZZMMDM")//政治面貌
                         {
                             politicalList.push(tempItem)
                             //political.model.append({text:obj[i].ct, code:obj[i].dm})
                             if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
                                if(PAGEDATA != undefined){//传过来的是个数组
                                    if(obj[i].dm==objT.zzmmdm){
                                        political.wenben.text = obj[i].ct
                                        political.chooseItem = tempItem
                                        //political.currentIndex = i
                                        //political.currentText = obj[i].ct
                                    }
                                }
                            }
                         }
                         if (obj[i].zdbh == "ZA_D_XXDM")//血型
                         {
                             bloodType.model.append({text:obj[i].ct, code:obj[i].dm})
                             if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
                                 if(PAGEDATA != undefined){//传过来的是个数组
                                     if(obj[i].dm==objT.xxdm){
                                         bloodType.currentIndex = i
                                         bloodType.currentText = obj[i].ct
                                     }
                                 }
                             }
                         }
                         if (obj[i].zdbh == "ZA_D_ZJXYDM")//宗教信仰
                         {
                             religion.model.append({text:obj[i].ct, code:obj[i].dm})
                             if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
                                   if(PAGEDATA != undefined){//传过来的是个数组
                                       if(obj[i].dm==objT.zjxydm){
                                           religion.currentIndex = i
                                           religion.currentText = obj[i].ct
                                       }
                                   }
                               }
                         }
                         if (obj[i].zdbh == "ZA_D_BYQKDM")//兵役状况
                         {
                             militaryService.model.append({text:obj[i].ct, code:obj[i].dm})
                             if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
                                 if(PAGEDATA != undefined){//传过来的是个数组
                                     if(obj[i].dm==objT.byzkdm){
                                         militaryService.currentIndex = i
                                         militaryService.currentText = obj[i].ct
                                     }
                                 }
                             }
                         }
                         if (obj[i].zdbh == "GB_D_ZYFLYDM")//职业类别
                         {
                             tradeClassList.push(tempItem)
                             //tradeClass.model.append({text:obj[i].ct, code:obj[i].dm})
                             if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
                                 if(PAGEDATA != undefined){//传过来的是个数组
                                     if(obj[i].dm==objT.zylbdm){
                                         //tradeClass.currentIndex = i
                                         //tradeClass.currentText = obj[i].ct
                                         tradeClass.wenben.text = obj[i].ct
                                         tradeClass.chooseItem = tempItem
                                     }
                                 }
                             }
                         }
                     }
                    birthCountry.yuanshiList  = birthCountryList
                    birthArea.yuanshiList     = birthAreaList
                    nativeCountry.yuanshiList = nativeCountryList
                    nativePlace.yuanshiList   = nativePlaceList
                    education.yuanshiList     = educationList
                    political.yuanshiList     = politicalList
                    tradeClass.yuanshiList    = tradeClassList

                     //nativeCountry.currentIndex =-1
                     //nativeCountry.currentText = ""

                     //birthArea.currentIndex =-1
                     //birthArea.currentText = ""

                     //nativePlace.currentIndex =-1
                     //nativePlace.currentText = ""

                     marriage.currentIndex =-1
                     marriage.currentText = ""

                     //education.currentIndex =-1
                     //education.currentText = ""

                     //political.currentIndex = -1
                     //political.currentText = ""

                     bloodType.currentIndex = -1
                     bloodType.currentText = ""

                     religion.currentIndex = -1
                     religion.currentText = ""

                     militaryService.currentIndex = -1
                     militaryService.currentText = ""

                     //tradeClass.currentIndex = -1
                     //tradeClass.currentText = ""
                 }
             }else{
                     console.log("查询实有人员_基本信息数据失败："+code)
             }
         })
    }
    //小键盘调用************************
    //联系电话
    telephone.onCursorVisibleChanged:{
        if(telephone.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
    //职业
    occupational.onCursorVisibleChanged:{
        if(occupational.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }

    //工作单位
    workUnit.onCursorVisibleChanged:{
        if(workUnit.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }

    //telephone
    beforeName.onCursorVisibleChanged:{
        if(beforeName.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }else{
            getFocus.focus = true
        }
    }
    birthCountry.wenben.onCursorVisibleChanged: {
         if( birthCountry.wenben.cursorVisible){
            if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
                qmlData.startVkeyBoard()
            }
        }
        else{
             getFocus.focus = true
        }
    }
    birthArea.wenben.onCursorVisibleChanged: {
        if(birthArea.wenben.cursorVisible){
           if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
               qmlData.startVkeyBoard()
           }
       }
       else{
            getFocus.focus = true
       }
    }
    nativeCountry.wenben.onCursorVisibleChanged: {
        if(nativeCountry.wenben.cursorVisible){
           if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
               qmlData.startVkeyBoard()
           }
       }
       else{
            getFocus.focus = true
       }
    }
    nativePlace.wenben.onCursorVisibleChanged: {
        if(nativePlace.wenben.cursorVisible){
           if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
               qmlData.startVkeyBoard()
           }
       }
       else{
            getFocus.focus = true
       }
    }
    education.wenben.onCursorVisibleChanged: {
        if(education.wenben.cursorVisible){
           if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
               qmlData.startVkeyBoard()
           }
       }
       else{
            getFocus.focus = true
       }
    }
    political.wenben.onCursorVisibleChanged: {
        if(political.wenben.cursorVisible){
           if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
               qmlData.startVkeyBoard()
           }
       }
       else{
            getFocus.focus = true
       }
    }
    tradeClass.wenben.onCursorVisibleChanged: {
        if(tradeClass.wenben.cursorVisible){
           if(qmlData.GetProcessidFromName("VkeyBoard.exe") !== 1){
               qmlData.startVkeyBoard()
           }
       }
       else{
            getFocus.focus = true
       }
    }
    Connections{
        target: mainQml
        onFillInfoMsg:{//信息填充消息响应事件
            //联系电话
            pageDataJsonObject.lxdh =telephone.text
            //出生国家
            //if(birthCountry.currentIndex!=-1)
            //pageDataJsonObject.csdgjhdqdm = birthCountryData.get(birthCountry.currentIndex).code

            if(birthCountry.chooseItem != undefined  && birthCountry.chooseItem.code != undefined){
                pageDataJsonObject.csdgjhdqdm = birthCountry.chooseItem.code
                //console.log("---666:"+pageDataJsonObject.csdgjhdqdm)
            }

            //出生地
            //if(birthArea.currentIndex!=-1)
            //pageDataJsonObject.csdssxdm =birthAreaData.get(birthArea.currentIndex).code
            if(birthArea.chooseItem != undefined  && birthArea.chooseItem.code != undefined){
                pageDataJsonObject.csdgjhdqdm = birthArea.chooseItem.code
            }

            //籍贯国家
            //if(nativeCountry.currentIndex!=-1)
            //pageDataJsonObject.jggjdqdm =nativeCountryData.get(nativeCountry.currentIndex).code
            if(nativeCountry.chooseItem != undefined  && nativeCountry.chooseItem.code != undefined){
                pageDataJsonObject.jggjdqdm = nativeCountry.chooseItem.code
            }

            //籍贯
            //if(nativePlace.currentIndex!=-1)
            //pageDataJsonObject.jgssxdm =nativePlaceData.get(nativePlace.currentIndex).code
            if(nativePlace.chooseItem != undefined  && nativePlace.chooseItem.code != undefined){
                pageDataJsonObject.jgssxdm = nativePlace.chooseItem.code
            }

            //曾用名
            pageDataJsonObject.cym =beforeName.text
            //学历
            //if(education.currentIndex!=-1)
            //pageDataJsonObject.xldm =educationData.get(education.currentIndex).code
            if(education.chooseItem != undefined  && education.chooseItem.code != undefined){
                pageDataJsonObject.xldm = education.chooseItem.code
            }

            //婚姻状况
            if(marriage.currentIndex!=-1)
            pageDataJsonObject.hyzkdm =marriageData.get(marriage.currentIndex).code
            //政治面貌
            //if(political.currentIndex!=-1)
            //pageDataJsonObject.zzmmdm =politicalData.get(political.currentIndex).code
            if(political.chooseItem != undefined  && political.chooseItem.code != undefined){
                pageDataJsonObject.zzmmdm = political.chooseItem.code
            }

            //宗教信仰
            if(religion.currentIndex!=-1)
            pageDataJsonObject.zjxydm =religionData.get(religion.currentIndex).code
            //兵役状况
            if(militaryService.currentIndex!=-1)
            pageDataJsonObject.byzkdm =militaryServiceData.get(militaryService.currentIndex).code
            //血型
            if(bloodType.currentIndex!=-1)
            pageDataJsonObject.xxdm =bloodTypeData.get(bloodType.currentIndex).code
            //职业类别
            //if(tradeClass.currentIndex!=-1)
            //pageDataJsonObject.zylbdm =tradeClassData.get(tradeClass.currentIndex).code
            if(tradeClass.chooseItem != undefined  && tradeClass.chooseItem.code != undefined){
                pageDataJsonObject.zylbdm = tradeClass.chooseItem.code
            }

            //职业
            pageDataJsonObject.zy =occupational.text
            //工作单位
            pageDataJsonObject.gzdw =workUnit.text           

            PAGEDATA = JSON.stringify(pageDataJsonObject)
        }
        //点空白区域 所有下拉框回收
        onComponentRecovery:{
            getFocusComboBox.focus = true
        }

        //其他模块获取到了焦点 本模块下拉框消失
        onBoxAreaOpend:{
            if(page_name!=PAGENAME){
                 getFocusComboBox.focus = true
            }
        }
        onAddressTogether:{
            nativePlaceDesc.text=name
        }

        onFinishToEveryControl:{//清空所有
             telephone.text=""
             beforeName.text=""
             beforeName.cursorVisible=false
             occupational.text=""
             occupational.cursorVisible=false
             workUnit.text=""
             workUnit.cursorVisible=false

            birthCountry.chooseItem={}
            birthCountry.wenben.text = ""
             //birthCountry.currentIndex = -1
             //birthCountry.currentText = ""

            nativeCountry.chooseItem={}
            nativeCountry.wenben.text = ""
             //nativeCountry.currentIndex = -1
             //nativeCountry.currentText = ""

            birthArea.chooseItem={}
            birthArea.wenben.text = ""
             //birthArea.currentIndex = -1
             //birthArea.currentText = ""

            nativePlace.chooseItem={}
            nativePlace.wenben.text = ""
             //nativePlace.currentIndex =-1
             //nativePlace.currentText = ""

             marriage.currentIndex = -1
             marriage.currentText = ""

            education.chooseItem={}
            education.wenben.text = ""
             //education.currentIndex =-1
             //education.currentText = ""

            political.chooseItem={}
            political.wenben.text = ""
             //political.currentIndex = -1
             //political.currentText = ""

             bloodType.currentIndex = -1
             bloodType.currentText = ""

             religion.currentIndex = -1
             religion.currentText = ""

             militaryService.currentIndex = -1
             militaryService.currentText = ""

            tradeClass.chooseItem={}
            tradeClass.wenben.text = ""
             //tradeClass.currentIndex = -1
             //tradeClass.currentText = ""
        }
    }
}
//////////////////////////////////////////////////////////
//var GJHDQDM_Url = 'http://'+goIpPort+'/sy/zdbh/GB_D_GJHDQDM'
//operatehttp.get(GJHDQDM_Url, function(code, data){
//    if(code == 200){
//        if(data != ""){
//            var obj = JSON.parse(data)
//            if (obj.length > 0){
//                 //(出生国家)
//                birthCountry.model.clear()
//                for(var i=0;i<obj.length;i++){
//                    //console.log("obj[i].zdmc, obj[i].dm}"+obj[i].zdmc, obj[i].dm)
//                     birthCountry.model.append({text:obj[i].ct, code:obj[i].dm})
//                    if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
//                        if(PAGEDATA != undefined){//传过来的是个数组
//                            var obj1=JSON.parse(PAGEDATA)
//                            if(obj[i].dm==obj1.csdgjhdqdm){
//                                birthCountry.currentIndex = i
//                                birthCountry.currentText = obj[i].ct
//                            }
//                        }
//                    }
//                }
//                 if(PAGEMODE != QmlData.VISIT_TYPE_SEE){
//                    birthCountry.currentIndex = 0
//                    birthCountry.currentText = obj[0].ct
//                 }
//                 //(籍贯国家)
//                nativeCountry.model.clear()
//                for(var i=0;i<obj.length;i++){
//                    //console.log("obj[i].zdmc, obj[i].dm}"+obj[i].zdmc, obj[i].dm)
//                     nativeCountry.model.append({text:obj[i].ct, code:obj[i].dm})
//                    if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
//                        if(PAGEDATA != undefined){//传过来的是个数组
//                            var obj1=JSON.parse(PAGEDATA)
//                            if(obj[i].dm==obj1.jggjdqdm){
//                                nativeCountry.currentIndex = i
//                                nativeCountry.currentText = obj[i].ct
//                            }
//                        }
//                    }
//                }
//                if(PAGEMODE != QmlData.VISIT_TYPE_SEE){
//                    nativeCountry.currentIndex = 0
//                    nativeCountry.currentText = obj[0].ct
//                }
//            }
//        }
//    }else{
//        console.log('查询国家和地区代码失败')
//    }
//})

//var XZQHDM_Url = 'http://'+goIpPort+'/sy/zdbh/GB_D_XZQHDM'
//operatehttp.get(XZQHDM_Url, function(code, data){
//    if(code == 200){
//        if(data != ""){
//            var obj = JSON.parse(data)
//            if (obj.length > 0){
//                 //(出生地)
//                birthArea.model.clear()
//                for(var i=0;i<obj.length;i++){
//                    //console.log("obj[i].zdmc, obj[i].dm}"+obj[i].zdmc, obj[i].dm)
//                     birthArea.model.append({text:obj[i].ct, code:obj[i].dm})
//                    if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
//                        if(PAGEDATA != undefined){//传过来的是个数组
//                            var obj1=JSON.parse(PAGEDATA)
//                            if(obj[i].dm==obj1.csdssxdm){
//                                birthArea.currentIndex = i
//                                birthArea.currentText = obj[i].ct
//                            }
//                        }
//                    }
//                }
//                 if(PAGEMODE != QmlData.VISIT_TYPE_SEE){
//                    birthArea.currentIndex = 0
//                    birthArea.currentText = obj[0].ct
//                 }
//                 //(籍贯)
//                nativePlace.model.clear()
//                for(var i=0;i<obj.length;i++){
//                   // console.log("obj[i].zdmc, obj[i].dm}"+obj[i].zdmc, obj[i].dm)
//                     nativePlace.model.append({text:obj[i].ct, code:obj[i].dm})
//                    if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
//                        if(PAGEDATA != undefined){//传过来的是个数组
//                            var obj1=JSON.parse(PAGEDATA)
//                            if(obj[i].dm==obj1.jgssxdm){
//                                nativePlace.currentIndex = i
//                                nativePlace.currentText = obj[i].ct
//                            }
//                        }
//                    }
//                }
//                if(PAGEMODE != QmlData.VISIT_TYPE_SEE){
//                    nativePlace.currentIndex = 0
//                    nativePlace.currentText = obj[0].ct
//                }
//            }
//        }
//    }else{
//        console.log('查询行政区划代码失败')
//    }
//})

//var HYZKDM_Url = 'http://'+goIpPort+'/sy/zdbh/GB_D_HYZKDM'          //(婚姻状况)
//operatehttp.get(HYZKDM_Url, function(code, data){
//    if(code == 200){
//        if(data != ""){
//            var obj = JSON.parse(data)
//            if (obj.length > 0){
//                marriage.model.clear()
//                for(var i=0;i<obj.length;i++){
//                    //console.log("obj[i].zdmc, obj[i].dm}"+obj[i].zdmc, obj[i].dm)
//                     marriage.model.append({text:obj[i].ct, code:obj[i].dm})
//                    if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
//                        if(PAGEDATA != undefined){//传过来的是个数组
//                            var obj1=JSON.parse(PAGEDATA)
//                            if(obj[i].dm==obj1.hyzkdm){
//                                marriage.currentIndex = i
//                                marriage.currentText = obj[i].ct
//                            }
//                        }
//                    }
//                }
//                if(PAGEMODE != QmlData.VISIT_TYPE_SEE){
//                    marriage.currentIndex = 0
//                    marriage.currentText = obj[0].ct
//                }
//            }
//        }
//    }else{
//        console.log('查询婚姻状况失败')
//    }
//})

//var XLDM_Url = 'http://'+goIpPort+'/sy/zdbh/GB_D_XLDM'          //(学历代码)
//operatehttp.get(XLDM_Url, function(code, data){
//    if(code == 200){
//        if(data != ""){
//            var obj = JSON.parse(data)
//            if (obj.length > 0){
//                education.model.clear()
//                for(var i=0;i<obj.length;i++){
//                    //console.log("obj[i].zdmc, obj[i].dm}"+obj[i].zdmc, obj[i].dm)
//                     education.model.append({text:obj[i].ct, code:obj[i].dm})
//                    if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
//                        if(PAGEDATA != undefined){//传过来的是个数组
//                            var obj1=JSON.parse(PAGEDATA)
//                            if(obj[i].dm==obj1.xldm){
//                                housePurpose.currentIndex = i
//                                housePurpose.currentText = obj[i].ct
//                            }
//                        }
//                    }
//                }
//                 if(PAGEMODE != QmlData.VISIT_TYPE_SEE){
//                    housePurpose.currentIndex = 0
//                    housePurpose.currentText = obj[0].ct
//                 }
//            }
//        }
//    }else{
//        console.log('查询学历代码失败')
//    }
//})

//var ZZMMDM_Url = 'http://'+goIpPort+'/sy/zdbh/GB_D_ZZMMDM'          //(政治面貌)
//operatehttp.get(ZZMMDM_Url, function(code, data){
//    if(code == 200){
//        if(data != ""){
//            var obj = JSON.parse(data)
//            if (obj.length > 0){
//                political.model.clear()
//                for(var i=0;i<obj.length;i++){
//                    //console.log("obj[i].zdmc, obj[i].dm}"+obj[i].zdmc, obj[i].dm)
//                     political.model.append({text:obj[i].ct, code:obj[i].dm})
//                    if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
//                        if(PAGEDATA != undefined){//传过来的是个数组
//                            var obj1=JSON.parse(PAGEDATA)
//                            if(obj[i].dm==obj1.zzmmdm){
//                                political.currentIndex = i
//                                political.currentText = obj[i].ct
//                            }
//                        }
//                    }
//                }
//                 if(PAGEMODE != QmlData.VISIT_TYPE_SEE){
//                    political.currentIndex = 0
//                    political.currentText = obj[0].ct
//                 }
//            }
//        }
//    }else{
//        console.log('查询政治面貌失败')
//    }
//})

//var XXDM_Url = 'http://'+goIpPort+'/sy/zdbh/ZA_D_XXDM'          //(血型)
//operatehttp.get(XXDM_Url, function(code, data){
//    if(code == 200){
//        if(data != ""){
//            var obj = JSON.parse(data)
//            if (obj.length > 0){
//                bloodType.model.clear()
//                for(var i=0;i<obj.length;i++){
//                    //console.log("obj[i].zdmc, obj[i].dm}"+obj[i].zdmc, obj[i].dm)
//                     bloodType.model.append({text:obj[i].ct, code:obj[i].dm})
//                    if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
//                        if(PAGEDATA != undefined){//传过来的是个数组
//                            var obj1=JSON.parse(PAGEDATA)
//                            if(obj[i].dm==obj1.xxdm){
//                                bloodType.currentIndex = i
//                                bloodType.currentText = obj[i].ct
//                            }
//                        }
//                    }
//                }
//                 if(PAGEMODE != QmlData.VISIT_TYPE_SEE){
//                    bloodType.currentIndex = 0
//                    bloodType.currentText = obj[0].ct
//                 }
//            }
//        }
//    }else{
//        console.log('查询政治面貌失败')
//    }
//})

//var ZJXYDM_Url = 'http://'+goIpPort+'/sy/zdbh/ZA_D_ZJXYDM'          //(宗教信仰)
//operatehttp.get(ZJXYDM_Url, function(code, data){
//    if(code == 200){
//        if(data != ""){
//            var obj = JSON.parse(data)
//            if (obj.length > 0){
//                religion.model.clear()
//                for(var i=0;i<obj.length;i++){
//                    //console.log("obj[i].zdmc, obj[i].dm}"+obj[i].zdmc, obj[i].dm)
//                     religion.model.append({text:obj[i].ct, code:obj[i].dm})
//                    if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
//                        if(PAGEDATA != undefined){//传过来的是个数组
//                            var obj1=JSON.parse(PAGEDATA)
//                            if(obj[i].dm==obj1.zjxydm){
//                                religion.currentIndex = i
//                                religion.currentText = obj[i].ct
//                            }
//                        }
//                    }
//                }
//                if(PAGEMODE != QmlData.VISIT_TYPE_SEE){
//                    religion.currentIndex = 0
//                    religion.currentText = obj[0].ct
//                }
//            }
//        }
//    }else{
//        console.log('查询宗教信仰失败')
//    }
//})

//var BYQKDM_Url = 'http://'+goIpPort+'/sy/zdbh/ZA_D_BYQKDM'          //(兵役状况)
//operatehttp.get(BYQKDM_Url, function(code, data){
//    if(code == 200){
//        if(data != ""){
//            var obj = JSON.parse(data)
//            if (obj.length > 0){
//                militaryService.model.clear()
//                for(var i=0;i<obj.length;i++){
//                    //console.log("obj[i].zdmc, obj[i].dm}"+obj[i].zdmc, obj[i].dm)
//                     militaryService.model.append({text:obj[i].ct, code:obj[i].dm})
//                    if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
//                        if(PAGEDATA != undefined){//传过来的是个数组
//                            var obj1=JSON.parse(PAGEDATA)
//                            if(obj[i].dm==obj1.byzkdm){
//                                militaryService.currentIndex = i
//                                militaryService.currentText = obj[i].ct
//                            }
//                        }
//                    }
//                }
//                if(PAGEMODE != QmlData.VISIT_TYPE_SEE){
//                    militaryService.currentIndex = 0
//                    militaryService.currentText = obj[0].ct
//                }
//            }
//        }
//    }else{
//        console.log('查询兵役状况失败')
//    }
//})

//var ZYFLYDM_Url = 'http://'+goIpPort+'/sy/zdbh/GB_D_ZYFLYDM'          //(职业类别)
//operatehttp.get(ZYFLYDM_Url, function(code, data){
//    if(code == 200){
//        if(data != ""){
//            var obj = JSON.parse(data)
//            if (obj.length > 0){
//                tradeClass.model.clear()
//                for(var i=0;i<obj.length;i++){
//                    //console.log("obj[i].zdmc, obj[i].dm}"+obj[i].zdmc, obj[i].dm)
//                     tradeClass.model.append({text:obj[i].ct, code:obj[i].dm})
//                    if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
//                        if(PAGEDATA != undefined){//传过来的是个数组
//                            var obj1=JSON.parse(PAGEDATA)
//                            if(obj[i].dm==obj1.zylbdm){
//                                tradeClass.currentIndex = i
//                                tradeClass.currentText = obj[i].ct
//                            }
//                        }
//                    }
//                }
//                if(PAGEMODE != QmlData.VISIT_TYPE_SEE){
//                    tradeClass.currentIndex = 0
//                    tradeClass.currentText = obj[0].ct
//                }
//            }
//        }
//    }else{
//        console.log('查询职业类别失败')
//    }
//})
//}

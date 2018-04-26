import QtQuick 2.4

HLK_FuzzySearchComboBoxForm {
    //传进来的参数
    property int wenbenWidth: 530  //1.文本框及下拉框的宽
    property int wenbenHeight:50   //1.文本框的高
    property int xialaHeight:240   //1.下拉框的高
    property int wenbenTextSize:20 //1.文本框及下拉框的字体
    property string wenbenPagename:"aa"  //1.文本框所在的页面名称

    property var chooseItem         //最终选择项

    property var yuanshiList: []  //原始数据
    property var tempList: []     //临时存储符合需求的数据

    property bool isMouseAreaClicked:false  //文本框中的内容有两种更新方式 一种为主动选择 另一种为失去焦点自动填充 这两种一种生效后 另一种便不再生效了

    Component.onCompleted: {
        tempList = yuanshiList
        xialaData.json=JSON.stringify(yuanshiList)
    }

    onYuanshiListChanged: {
        tempList = yuanshiList
        xialaData.json=JSON.stringify(yuanshiList)
    }

    //文本获取焦点 下拉框显示
    wenben.onCursorVisibleChanged: {
        if(wenben.cursorVisible){
            if(yuanshiList.length <= 0){    //房屋地址第一项 原始数据
                xiala.visible = false
                //getF.focus = true
                return;
            }else{
                xiala.visible = true
                xiala.bHightLight = true
            }
        }
        else{
            xiala.visible = false

            if(isMouseAreaClicked)
            {
                console.log("------where")
                isMouseAreaClicked = false
                return
            }

            //因为左侧导航栏会抢夺当前文本框焦点 所以当文本框失去焦点时 默认选中
            if(wenben.text != ""){
                xialaData.json = ""
                tempList = []     //临时数据列表
                //到原始Json中查找符合項
                if(yuanshiList.length <= 0){
                    xiala.visible = false
                    //getF.focus = true
                }
                else{
                    for (var i=0;i<yuanshiList.length;i++) {
                        if(yuanshiList[i].text.indexOf(wenben.text)>=0){
                            tempList.push(yuanshiList[i])
                        }
                    }
                    //有符合項
                    if(tempList.length > 0){
                        xialaData.json = JSON.stringify(tempList)
                        wenben.text=tempList[0].text
                        chooseItem = tempList[0]
                    }
                    else{
                        xiala.visible = false
                        wenben.text=""
                    }
                }
            }


        }
    }

    wenben.onTextChanged: {
        if(wenben.cursorVisible == true){
            xiala.visible = true
            xiala.bHightLight = true
        }else{
            xiala.visible = false
        }

        if(isMouseAreaClicked)
        {
            console.log("----------here")
            isMouseAreaClicked = false
            return
        }

        if(wenben.text != ""){
            xialaData.json = ""
            tempList = []     //临时数据列表
            //到原始Json中查找符合項
            if(yuanshiList.length <= 0){
                xiala.visible = false
            }
            else{
                for (var i=0;i<yuanshiList.length;i++) {
                    if(yuanshiList[i].text.indexOf(wenben.text)>=0){
                        tempList.push(yuanshiList[i])
                    }
                }
                //有符合項
                if(tempList.length > 0){
                    xialaData.json = JSON.stringify(tempList)
                }
                else{
                    xiala.visible = false
                    //getF.focus = true
                }
            }
        }
        else{
            if(yuanshiList.length > 0){
               xialaData.json = JSON.stringify(yuanshiList)
               tempList=yuanshiList
            }
            else{
                xiala.visible = false
            }
        }
    }
}

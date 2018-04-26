import QtQuick 2.4
import com.hylink.fmcp.ctrl 2.0
import "qrc:/collectJson/js/PublicDataJson.js" as PublicDataJson
IDcardPageItemForm {

    Component.onCompleted: {
//        if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
//            isPageEnable = false
//        }
    }
    Connections{
        target: mainQml
        onCurrentTaskFinish:{
            if(page_name=="IDcardPage"){
                console.log("身份证采集任务完成 改变进度条")
                progressBar.ctrlIcon = PAGEICON
            }
        }
    }
}

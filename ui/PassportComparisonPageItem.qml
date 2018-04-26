import QtQuick 2.4
import com.hylink.fmcp.ctrl 2.0
//import "qrc:/item/uiX6"
import "qrc:/collectJson/js/PublicDataJson.js" as PublicDataJson

PassportComparisonPageItemForm {
    Component.onCompleted: {
        /*if(PAGEMODE == QmlData.VISIT_TYPE_SEE){
            isPageEnable = false
        }*/
    }
    Connections{
        target: mainQml
        onCurrentTaskFinish:{
            if(page_name=="PassportComparisonPage"){
                progressBar.ctrlIcon = PAGEICON
            }
        }
    }
}

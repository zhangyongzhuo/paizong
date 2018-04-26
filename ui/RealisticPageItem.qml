import QtQuick 2.4

RealisticPageItemForm {
    Connections{
        target: mainQml
        onCurrentTaskFinish:{
            if(page_name=="RealisticPage"){
                progressBar.ctrlIcon = PAGEICON
            }
        }
    }
}

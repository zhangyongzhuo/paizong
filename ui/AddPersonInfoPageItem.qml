import QtQuick 2.4

AddPersonInfoPageItemForm {
    Connections{
        target: mainQml
        onCurrentTaskFinish:{
            if(page_name=="AddPersonInfoPage"){
                progressBar.ctrlIcon = PAGEICON
            }
        }
    }
}

/* JSONListModel - a QML ListModel with JSON and JSONPath support
 *
 * Copyright (c) 2012 Romain Pokrzywka (KDAB) (romain@kdab.com)
 * Licensed under the MIT licence (http://opensource.org/licenses/mit-license.php)
 */

import QtQuick 2.4
import "qrc:/base/js/jsonpath.js" as JSONPath

Item {
    property string appendOrInsert: 'append'

    property string source: ""
    property string json: ""
    property string query: ""
    property string error: ""

    property ListModel model : ListModel { id: jsonModel }
    property alias count: jsonModel.count

    //数据装载完成事件
    property bool load: false

    onSourceChanged: {
        //console.log("goto url:", source)

        var xhr = new XMLHttpRequest;
        xhr.open("GET", source);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE){
                if(xhr.status===200){
                    json = xhr.responseText;
                    //console.log("========"+json)
                }
                else if(xhr.status!=0){
                    error = xhr.responseText
                    load = true
                    //console.log("========tttttttttt")
                }
                else {
                    error = '连接超时'
                    load = true
                    //console.log("========连接超时")
                }
            }
            else{
                //console.log("========uuuuuuuuuu")
            }

        }
        //error = ""
        xhr.send();
    }

    onJsonChanged: updateJSONModel()
    onQueryChanged: updateJSONModel()

    function updateJSONModel() {
        jsonModel.clear();

        if ( json === "" )
            return;

        var objectArray = parseJSONString(json, query);

        if(objectArray != null){
            if(appendOrInsert == 'append'){
                for ( var i=0; i<objectArray.length; i++ ) {
                    jsonModel.append( objectArray[i] );
                }
            }
            else if(appendOrInsert == 'insert'){
                for ( i=objectArray.length-1; i>=0; i-- ) {
                    jsonModel.append( objectArray[i] );
                }
            }

            load = true
        }
    }

    function parseJSONString(jsonString, jsonPathQuery) {
        var objectArray = JSON.parse(jsonString);

        if ( jsonPathQuery !== "" )
            objectArray = JSONPath.jsonPath(objectArray, jsonPathQuery);

        return objectArray;
    }
}

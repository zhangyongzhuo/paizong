.pragma library

//获取主题色
function themeColor(){
    return "#00AECC"
}

//车牌校验
function isVehicleNumber(vehicleNumber) {
    var result = false;
    if (vehicleNumber.length == 7){
        var express = /^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$/;
        result = express.test(vehicleNumber);
    }
    return result;
}

//是否是数字
function isNumber(value){
    return /^[(-?\d+\.\d+)|(-?\d+)|(-?\.\d+)]+$/.test(value + '')
}

////验证手机号码正则
//function checkMobile(str) {
//    var re = /^1[34578]\d{9}$/  ///^1\d{10}$/
//    if (re.test(str)) {
//        return true
//    } else {
//        return false
//    }
//}

//验证手机号码长度
function checkMobile(str) {
    if (str.length==11) {
        return true
    } else {
        return false
    }
}

//截取首尾空格
function trimStr(str){
    return str.replace(/(^\s*)|(\s*$)/g,"");
}

//截取全部空格
function trimAll(str){
    var result;
    result = str.replace(/(^\s+)|(\s+$)/g,"");
    return result.replace(/\s/g,"");
}

//姓名校验
function isChineseName(name){
    var reg1 = /^[\u4e00-\u9fa5.·]{2,20}$/
    var reg2 = /^[a-zA-Z\/ ]{2,20}$/
    return reg1.test(name) || reg2.test(name)
}

//身份证校验
function isCardNo(card){
    // 身份证号码为15位或者18位，15位时全为数字，18位前17位为数字，最后一位是校验位，可能为数字或字符X
    var reg = /^(^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$)|(^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])((\d{4})|\d{3}[Xx])$)$/;
    return reg.test(card)
}

//异步网络请求
function ajax(method, url, callback){

    var request=new XMLHttpRequest();
    request.onreadystatechange=function(){
        if(request.readyState===request.DONE){ //数据请求处理完成
            callback(request.status, request.responseText.toString())
        }else{
            console.log("request.readyState: ",request.readyState);
        }
    }
    request.open(method, url)
    request.send()
}

//异步GET请求
function get(url, callback){
    var request=new XMLHttpRequest();
    request.onreadystatechange=function(){
        if(request.readyState===request.DONE){ //数据请求处理完成
            callback(request.status, request.responseText.toString())
        }else{
            console.log("request.readyState: ",request.readyState);
        }
    }
    request.open("GET", url)
    request.send()

    //    net.CurlGetFunction(url);
    //    net.onRurlGetFunctionFinished{
    //        callback(status, responseText.toString())
    //    }
}

//Map对象到表单数据
function convertMapToForm(map){
    var str = "";
    for(var key in map){
        str += key + "=" + map[key] + "&"
    }
    return str;
}

//异步网络请求
function ajaxWithForm(method, url, params, callback){
    var request=new XMLHttpRequest();
    request.onreadystatechange=function(){
        if(request.readyState===request.DONE){
            callback(request.status, request.responseText.toString())
        }
    }
    request.open(method, url)
    request.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    request.send(params)
}

//移除数组中指定的元素
Array.prototype.remove = function(val) {
    var index = this.indexOf(val);
    if (index > -1) {
        this.splice(index, 1);
    }
};

//布尔值转字符串‘是’或‘否’
function boolToString(b){
    return b? "是" : "否"
}

//字符串格式化
String.prototype.format = function()
{
    var args = arguments;
    return this.replace(/\{(\d+)\}/g,
                        function(m,i){
                            return args[i];
                        });
}

//生成网络请求参数唯一uuid
function makeuuid()
{
    var s = [];
    var hexDigits = "0123456789abcdef";
    for (var i = 0; i < 36; i++) {
        s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
    }
    s[14] = "4";  // bits 12-15 of the time_hi_and_version field to 0010
    s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1);  // bits 6-7 of the clock_seq_hi_and_reserved to 01
    s[8] = s[13] = s[18] = s[23] = "-";
    var uuid = s.join("");
    return uuid;

}
//检查密码是否同时包含数字、大写字母、小写字母
function checkPass(pass){
    if(pass.length < 6){  return 0; }
    var ls = 0;
    if(pass.match(/([a-z])+/)){  ls++; }
    if(pass.match(/([0-9])+/)){  ls++; }
    if(pass.match(/([A-Z])+/)){   ls++; }
    if(pass.match(/[^a-zA-Z0-9]+/)){ ls++;}
    return ls;
}

//获取当前的日期时间 格式“yyyy-MM-dd HH:MM:SS”
function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
            + " " + date.getHours() + seperator2 + date.getMinutes()
            + seperator2 + date.getSeconds() ;
    return currentdate;
}
//获取当前的日期时间 格式“yyyyMMddHHMMSS”
function getNowFormatDate2() {
    var date = new Date();
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    var strHours = date.getHours();
    var strMinutes = date.getMinutes()
    var strSecondes = date.getSeconds()
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    if (strHours >= 0 && strHours <=9 ){
        strHours="0"+strHours;
    }
    if (strMinutes >= 0 && strMinutes <= 9){
        strMinutes="0"+strMinutes;
    }
    if (strSecondes >= 0 && strSecondes <= 9){
        strSecondes="0"+strSecondes;
    }
    var currentdate = date.getFullYear() + month + strDate + strHours + strMinutes + strSecondes;
    return currentdate;
}

//获取当前的日期时间 格式时间戳
function getNowFormatDateValue() {
    return (new Date()).valueOf()
}

//获取UNIX时间戳
function getUnixDateValue(){
    var timestamp = Date.parse(new Date());
    timestamp = timestamp / 1000;
    return timestamp
}

function dataValueToData(dataValue){
    var newDate = new Date();
    newDate.setTime(dataValue);
    return newDate.toLocaleString()
}

//移除空格
function Trim(str,is_global){
    var result;
    result = str.replace(/(^\s+)|(\s+$)/g,"");
    if(is_global.toLowerCase()=="g")
    {
        result = result.replace(/\s/g,"");
    }
    return result;
}

//是否包含特殊字符
function isContainSpecialCharacter(str){//true 包含， false不包含
    var reg = /((?=[\x21-\x7e]+)[^A-Za-z0-9])/
    return reg.test(str)
}

//是否包含连字符&
function isContainHyphen(str) {
    var re =/[&]/
    return re.test(str)
}
//是否包含所有类型的空格 false包含, true 不包含
function isContainSpace(str){
    var re = /^[^\s]+$/
    return re.test(str)
}

function subStringFromTo(str, from, to){
    return str.substring(from, to)
}

//将str中的arg1替换为arg2
function repelaceChar(str, arg1, arg2){
    return str.replace(new RegExp(arg1, 'g'), arg2)
}

function strRealLength(str){
    var len = 0;
    for (var i=0; i<str.length; i++) {
        var c = str.charCodeAt(i);
        //单字节加1
        if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {
            len++;
        }
        else {
            len+=2;
        }
    }
    return len;
}

//是否包含中文
function isChinese(str){
    if(/.*[\u4e00-\u9fa5]+.*$/.test(str)) {
        return true
    }
    else{
        return false
    }
}

function colorTrans(colorCode,obj){
    for(var i=0; i<obj.length; i++){
        if(colorCode.indexOf(obj[i].typeValue) != -1){
            colorCode = colorCode.replace(obj[i].typeValue, obj[i].typeValueBase);
        }
    }
    return colorCode
}
//获取日期
function fun_date_other(aa){
        var date1 = new Date(),
        time1=date1.getFullYear()+"-"+(date1.getMonth()+1)+"-"+date1.getDate();//time1表示当前时间
        var date2 = new Date(date1);
        date2.setDate(date1.getDate()+aa);
        var time2 = date2.getFullYear()+"-"+(date2.getMonth()+1)+"-"+date2.getDate();
     return time2
    }

function fun_date_now(){
    var date1 = new Date(),
    time1=date1.getFullYear()+"-"+(date1.getMonth()+1)+"-"+date1.getDate();//time1表示当前时间
     return time1
    }
//汉字占两个字符 字母数字占一个字符
function getByteLen(val) {
      var len = 0;
      for (var i = 0; i < val.length; i++) {
          var a = val.charAt(i);
          if (a.match(/[^\x00-\xff]/ig) != null) {
              len += 2;
          }
          else {
              len += 1;
          }
      }
      return len;
  }

function getDate(date){
  var dates = date.split("-");
  var dateReturn = '';


  for(var i=0; i<dates.length; i++){
       if(dates[i].length<2){
          dateReturn+='0'+dates[i]
      }else{
             dateReturn+=dates[i];
       }
  }
  return dateReturn;
 }
function getTime(time){
  var dates = time.split(":");
  var dateReturn = '';

  for(var i=0; i<dates.length; i++){
      if(dates[i].length<2){
         dateReturn+='0'+dates[i]
     }else{
         dateReturn+=dates[i];
      }
  }
  return dateReturn;
 }

function getSystemTime(strDate){
    var myDate = new Date(strDate)
    var myTime = {"dateString":"", "hours":0, "minutes":0, "seconds":0}
    myTime.dateString = myDate.toLocaleDateString()
    myTime.hours = myDate.getHours()
    myTime.minutes = myDate.getMinutes()
    myTime.seconds = myDate.getSeconds()
    return myTime;
}

function getStart(){
  var now = new Date();
  var nowTime = now.getTime() ;
  var day = now.getDay();
  var oneDayLong = 24*60*60*1000 ;

  var MondayTime = nowTime - (day-1)*oneDayLong  ;

  var monday = new Date(MondayTime);
  var year = monday.getFullYear();
  var month = monday.getMonth()+1;
  var day =  monday.getDate();
  var day2 = monday.getDate()+5;
  var startTime = year + '-' + month +'-'+day;

  return startTime;
}

function getEnd(){
  var now = new Date();
  var nowTime = now.getTime() ;
  var day = now.getDay();
  var oneDayLong = 24*60*60*1000 ;

  var MondayTime = nowTime - (day-1)*oneDayLong  ;

  var monday = new Date(MondayTime);
  var year = monday.getFullYear();
  var month = monday.getMonth()+1;
  var day =  monday.getDate();
  var day2 = monday.getDate()+5;
  var endTime = year + '-' + month +'-'+day2;

  return endTime;
}

function getSystemDay(strDate){
    var myDate = new Date(strDate)
    return myDate.getDay();
}

function getMonthBetween(start,end){
    var result = [];
    //var resultMap={"text":"","code":""}
    var s = start.split("-");
    var e = end.split("-");
    var min = new Date();
    var max = new Date();
    min.setFullYear(s[0],s[1]-1);
    max.setFullYear(e[0],e[1]-1);

    var curr = min;
    while(curr <= max){
        var month = curr.getMonth()+1;
        var resultMap = {}
        resultMap.text = curr.getFullYear()+"年"+month+"月"
        resultMap.code = curr.getFullYear()+""+(month<10?("0"+month):month)
        result.push(resultMap)
        curr.setMonth(month);
    }
    return result;
 }


# cookie跨域读写

## 一、SSO原理

>* 1.业务资源请求，判断Token是否存在，如果存在这判断Token是否有效。有效者访问业务系统。
>* 2.Token不存在或者Token失效。**1** 提供登录页面 **2** 用户登录通过后，生成Token **3** 将token<->user 存入redis **4** 将token写入所有域的Cookie中 5.页面重定向回原始请求URL
>* 3.Token 验证时从redis中获取判断token是否有效。

其中跨域读写cookie是最重要的环节。

## 要实现的内容简单描述。

![image](https://github.com/csy512889371/reactLearn/blob/master/img/learn/ss0_cookie.jpeg)

页面结构
>* www.a.com/sso/index.jsp 是登录后才能看的到的页面.内嵌跨域<iframe src="www.b.com/sso/uc.jsp">
>* www.a.com/sso/login.jsp 登录页面.内嵌跨域<iframe src="www.b.com/sso/uc.jsp">

>* 访问index.jsp 时候，通过html5跨域通讯postMessage，读取b域uc.jsp 中的cookie.并判断cookie是否存在，不存在者跳转到登录页面。
>* login.jsp 用户登录页面，登录后会将cookie写入b域下的uc.jsp （postMessage协议）
>* 这样将cookie统一的放在uc.jsp中统一验证。如果还有www.b.com域 等系统也可以嵌入uc.jsp来获取用户cookie实现用户登录


## 二、环境准备

### 设置hosts 方便跨域测试
```javascript
C:\Windows\System32\drivers\etc

127.0.0.1 www.a.com
127.0.0.1 sub.a.com
127.0.0.1 www.b.com
127.0.0.1 www.c.com

```javascript

## 三、代码

### post_msg.js 工具类封装跨域代码

```javascript
/**
 * 封装postMessage方法，使发出的信息能被通用的message listener处理
 * @param {Window} targetWindow 目标框架窗口
 * @param {String} cmd  在目标窗口window空间中存在的方法名，消息发送后，目标窗口执行此名称的方法
 * @param {Array} args cmd方法需要的参数，多个参数时使用数组
 * @param {Function} callback 可选的参数，如果希望获得目标窗口的执行结果，使用此参数，结果返回后自动以返回结果为参数调用此回调方法
 */
function sendFrmMsg(targetWindow, cmd, args, callback) {
    var fname;
    if (callback) {
        fname = "uuid" + new Date().getTime(); //生成唯一编码
        window[fname] = callback;
    }

    args = (args instanceof Array) ? args : [args];

    var msg = {
        cmd: cmd,
        args: args,
        returnCmd: fname
    }


    targetWindow.postMessage(JSON.stringify(msg), "*");
}

/**
 * 获取另一个跨域窗口上的变量值
 * @param {Window} targetWindow 目标框架窗口
 * @param {String} varName 待获取值的变量名称
 * @param {Function} callback 获取成功后调用此回调方法处理变量值
 */
function getFrmVarValue(targetWindow, varName, callback) {
    sendFrmMsg(targetWindow, "getOtherFrameVarValue", [varName], callback);
}

/**
 * 给另一窗口设置变量值
 * @param {Window} targetWindow 目标框架窗口
 * @param {String} varName 待设置变量名
 * @param {Object} value 待设置变量值
 */
function setFrmVarValue(targetWindow, varName, value) {
    sendFrmMsg(targetWindow, "setOtherFrameVarValue", [varName, value]);
}

/**
 * 获取窗口变量值
 * @param {String} varName 变量名称
 */
function getOtherFrameVarValue(varName) {
    try {
        eval("var ret = " + varName);
        return ret;
    } catch (e) {
        console.log(e);
    }
}

/**
 * 设置变量值
 * @param {String} varName 变量名称
 * @param {Object} value 变量值
 */
function setOtherFrameVarValue(varName, value) {
    try {
        if (typeof value === "string") { // 字符串类型在拼接表达式时需要加引号
            value = "'" + value + "'";
        }
        eval(varName + "=" + value);
    } catch (e) {
        console.log(e);
    }
}

/**
 * message 事件监听器，自动根据cmd执行
 * @param {Object} evt
 * obj 形式：
 * ｛
 *     cmd: "目标窗口的function引用名",
 *     args: "参数列表" , 数组形式,
 *     [returnCmd]: "可选的，表示双向调用的回调function引用名，在回调时"
 *  ｝
 */
window.onmessage = function (evt) {

    evt = evt || event;

    var source = evt.origin;

    try {
        var obj = JSON.parse(evt.data);
        console.log(obj);
    } catch (e) {
        console.log(e);
    }

    if (obj.cmd) {
        // 拼成：setVal(obj.arg0, obj.arg1);
        var cmd = obj.cmd + "(";

        if (obj.args) { //拼接参数
            for (var i = 0; i < obj.args.length; i++) {
                obj["arg" + i] = obj.args[i];
                if (i > 0) {
                    cmd += ",";
                }
                cmd += "obj.arg" + i;
            }
        }

        cmd += ")";
        // 以上代码完成后，如obj.cmd="fun"，则拼接字符串如下：fun(obj.arg1, obj.arg2);
        // 在通过eval执行时，各参数即obj.arg1等已绑定到obj对象上，所以取的是传递过来的参数数组值
        try {
            var ret = eval(cmd);
            if (obj.returnCmd) { //把结果返回给源
                evt.source.postMessage(JSON.stringify({
                    cmd: obj.returnCmd,
                    args: [ret]
                }), evt.origin);
            }
        } catch (e) {
            if (console) console.log(e);
        }
    }
}
```


### index.jsp

```javascript
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>首页index</title>
    <script type="text/javascript" src="../resources/admin/js/jquery-1.11.3.min.js"></script>
    <script src="../resources/admin/js/cookie/jquery.cookie.js"></script>
    <script type="text/javascript" src="../post_msg.js"></script>

</head>
<body>

<p style="font-weight:bold;" id="sub_title">
    1.从uc.com 中获取是否登录信息
    2.未登录跳转到login页面
</p>

<iframe width="500" height="300" id="frame" src="http://www.b.com:8080/sso/uc.jsp"></iframe>

<p>
    <%--登录--%>
    <input type="button" onclick="logout()" value="logout"></input>
</p>

<script type="text/javascript">

    var subWin;

    $(function () {
        //获取子窗口的window对象
        var ofrm1 = window.frames[0].document;
        subWin = ofrm1 == undefined ? window.frames[0].contentWindow : window.frames[0];
        var $frame = $("#frame");
        $frame.one("load", function () {
            sendFrmMsg(subWin, "getUserInfo", null, getUserInfoCallback);
        });
    });

    function getUserInfoCallback(userInfo) {
        if (userInfo === undefined || userInfo === null || userInfo === "null") {
            parent.window.location.href = 'http://www.a.com:8080/sso/login.jsp';
        } else {

        }
    }

    function logoutCallback() {
        parent.window.location.href = 'http://www.a.com:8080/sso/login.jsp';
    }

    function logout() {
        $.cookie('userInfo',null,{expires:-1,path: '/'});
        sendFrmMsg(subWin, "logout", null, logoutCallback);
    }

</script>
</body>
</html>
```

### login.jsp

```javascript
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>登录页 login</title>
    <script type="text/javascript" src="../resources/admin/js/jquery-1.11.3.min.js"></script>
    <script src="../resources/admin/js/cookie/jquery.cookie.js"></script>
    <script type="text/javascript" src="../post_msg.js"></script>
    <script>

    </script>
</head>
<body>

<p style="font-weight:bold;" id="sub_title">
    1. 登录页面,内嵌iframe到不同域页面(www.b.com:8080/sso/uc.jsp）。此页面用户存放用户登录的cookie </br>
    2. 用户登录，登录成功后将cookie 保存在自己的域。</br>
    3. 将Cookie存储转存uc.jsp</br>
</p>

<iframe width="500" height="300" id="frame" src="http://www.b.com:8080/sso/uc.jsp"></iframe>

<p>
    <%--登录--%>
    <input type="button" onclick="dologin()" value="dologin"></input>
</p>


<script type="text/javascript">

    function setCookieCallback(userInfo) {
        //1. 这里可以获取来源url然后做重定向
        //getFromUrl();
        //2. 或者系统进入login的jsp时候，把url 传到login.jsp方便登录成功redirect
        parent.window.location.href='http://www.a.com:8080/sso/index.jsp';
    }


    function getFromUrl() {
        var ref = '';
        if (document.referrer.length > 0) {
            ref = document.referrer;
        }
        try {
            if (ref.length == 0 && opener.location.href.length > 0) {
                ref = opener.location.href;
            }
        } catch (e) {}

        return ref;
    }

    var subWin ;
    $(function () {
        var ofrm1 = window.frames[0].document;
        //var subWin = ofrm1 == undefined ? window.frames[0].contentWindow : window.frames[0];
        if (ofrm1 == undefined) {
            subWin = window.frames[0].contentWindow;
        } else {
            subWin = window.frames[0];
        }
    });

    function dologin() {
        //1. 登录请求
        var userInfo = ajaxLogin();
        var userInfoStr = JSON.stringify(userInfo);

        //2. 创建一个cookie并设置有效时间为 7天:
        $.cookie('userInfo', userInfoStr, {expires:7 ,path: '/'});
        //var value = JSON.parse($.cookie('userInfo'));

        //3. 将cookie保存的uc.jsp
        sendFrmMsg(subWin, "setUserInfo", userInfoStr, setCookieCallback);
    }

    function ajaxLogin() {

        //伪代码 请求登录
        console.log("do ajax begin");

        console.log("do ajax end");
        var userInfo = {
            id: 123,
            name: "nick",
            tocken: "99999999"
        };

        return userInfo;
    }

</script>
</body>
</html>
```
### uc.jsp
```javascript
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>uc 存储cookie的页面</title>
    <script type="text/javascript" src="../resources/admin/js/jquery-1.11.3.min.js"></script>
    <script src="../resources/admin/js/cookie/jquery.cookie.js"></script>
    <script type="text/javascript" src="../post_msg.js"></script>
</head>
<body>
<div>uc.jsp</div>

<script type="text/javascript">

    function logout() {
        $.cookie('userInfo',null,{expires:-1});
    }

    function setUserInfo(userInfo) {
        $.cookie('userInfo', userInfo, {expires:7 });
        var temp = $.cookie('userInfo');
        return "success";
    }
    function getUserInfo() {
        var userInfo =  $.cookie('userInfo');
        return userInfo;
    }

</script>
</body>
</html>
```



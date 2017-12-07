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
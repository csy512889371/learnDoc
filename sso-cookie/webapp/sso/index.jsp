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
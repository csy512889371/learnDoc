<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>存储cookie的页面</title>
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
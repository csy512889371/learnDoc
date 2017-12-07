<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>这是第一个子页面的标题</title>
    <script type="text/javascript" src="resources/admin/js/jquery-1.11.3.min.js"></script>
    <script type="text/javascript" src="post_msg.js"></script>
</head>
<body>

<script type="text/javascript">

    function callback1(data) {
        alert(data + "....");
    }

    $(function () {

        //window.parent是父页面的window对象
        //window.parent.postMessage(document.title,"*");
        sendFrmMsg(window.parent, "setTitleVal", document.title, callback1);
    });
</script>
</body>
</html>
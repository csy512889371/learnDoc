<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我是主页标题</title>
    <script type="text/javascript" src="resources/admin/js/jquery-1.11.3.min.js"></script>
    <script type="text/javascript" src="post_msg.js"></script>
    <script>

    </script>
</head>
<body>

<p style="font-weight:bold;" id="sub_title">子页面加载完成后，将在此处显示子页面title</p>

<iframe width="500" height="300" id="frame"></iframe>

<p>
    <%--跨全域访问--%>
    <button onclick="loadFrame('http://www.b.com:8080/sub_3.jsp');">load sub page</button>
</p>

<script type="text/javascript">

    function loadFrame(page) {
        var $frame = $("#frame");
        $frame.attr("src", page); //加载页面
    }

    function setTitleVal(text) {
        $("#sub_title").html(text);
    }


</script>
</body>
</html>
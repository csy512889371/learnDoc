<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>sub_1_title：这是第一个子页面的标题</title>
    <script type="text/javascript" src="resources/admin/js/jquery-1.11.3.min.js"></script>
</head>
<body>
这是第一个子页面
<button onclick="callparent();">调用父页面方法</button>

<div>
    父页面的标题是：<span id="parent_title"></span>
</div>

<script type="text/javascript">
    /**
     * 调用父页面的fun方法
     * @param arg
     */
    function callparent() {
        var pwin = window.parent; //获取父页面的window对象
//        var pwin = window.top; //获取顶层父页面的window对象
        pwin.funParent(123456)
    }

    /**
     * 供父页面调用
     */
    function funSub() {
        console.log("子页面的方法fun()被调用了。")
    }

    $(function () {
        //把父页面的title设置到p标签

        var pwin = window.parent; //获取父页面的window对象

        $('#parent_title').html(pwin.document.title)
    });
</script>
</body>
</html>
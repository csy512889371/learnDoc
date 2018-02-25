# 跨域技术
>* 跨域SSO原理
>* 跨域读写Cookie
>* 跨域AJAX请求

## SSO 原理
>* 业务资源请求，判断Token是否存在，如果存在这判断Token是否有效。有效者访问业务系统。
>* Token不存在或者Token失效。1。提供登录页面 2.用户登录通过后，生成Token 3.将token<->user 存入redis 4.将token写入所有域的Cookie中 5.页面重定向回原始请求URL
>* Token 验证时从redis中获取判断token是否有效。



# 设置hosts 方便跨域测试
```javascript
C:\Windows\System32\drivers\etc

127.0.0.1 www.a.com
127.0.0.1 sub.a.com
127.0.0.1 www.b.com
127.0.0.1 www.c.com
```

# Window 对象
>* 所有浏览器都支持 window 对象
>* 所有 JavaScript 全局对象、函数以及变量均自动成为 window 对象的成员
>* 全局变量是 window 对象的属性
>* 全局函数是 window 对象的方法
>* HTML DOM 的 document 也是 window 对象的属性之一


## js中Window 对象及其的方法

### window.location 对象
>* window.location 对象用于获得当前页面的地址 (URL)，并把浏览器重定向到新的页面
>* window.location 对象在编写时可不使用 window 这个前缀


>* location.hostname 返回 web 主机的域名
>* location.pathname 返回当前页面的路径和文件名
>* location.port 返回 web 主机的端口 （80 或 443）
>* location.protocol 返回所使用的 web 协议（http:// 或 https://）
>* window.location.reload( ); 刷新当前页面.
>* parent.location.reload( ); 刷新父亲对象（用于框架）
>* opener.location.reload( ); 刷新父窗口对象（用于单开窗口）
>* top.location.reload( ); 刷新最顶端对象（用于多开窗口）

### window.history 对象
>* window.history 对象包含浏览器的历史。window.history对象在编写时可不使用 window 这个前缀。
>* window.history.back() - 加载历史列表中的前一个 URL，与在浏览器点击后退按钮相同，
>* window.history.forward() -加载历史列表中的下一个 URL。 与在浏览器中点击按钮向前相同

### window.navigator 对象
>* window.navigator 对象包含有关访问者浏览器的信息，来自 navigator 对象的信息具有误导性，不应该被用于检测浏览器版本

### window对象的一些其它方法
>* setInterval() 和 setTimeout() 是 HTML DOM Window对象的两个方法
>* window.setInterval() - 间隔指定的毫秒数不停地执行指定的代码。
>* window.setTimeout() - 暂停指定的毫秒数后执行指定的代码
>* window.clearInterval() 方法用于停止 setInterval() 方法执行的函数代码。
>* window.clearTimeout() 方法用于停止执行setTimeout()方法的函数代码。
>* window.alert()- 警告框经常用于确保用户可以得到某些信息。当警告框出现后，用户需要点击确定按钮才能继续进行操作。
>* window.prompt()- 确认框用于使用户可以验证或者接受某些信息。当确认框出现后，用户需要点击确定或者取消按钮才能继续进行操作。如果用户点击确认，那么返回值为 true。如果用户点击取消，那么返回值为 false。
>* window.confirm()- 提示框经常用于提示用户在进入页面前输入某个值。当提示框出现后，用户需要输入某个值，然后点击确认或取消按钮才能继续操纵。如果用户点击确认，那么返回值为输入的值。如果用户点击取消，那么返回值为 null。

# 跨域写Cookie

## 利用HTML Script标签域写Cookie

```javascript
<script type="text/javascript" src="http://www.b.com/setCookie?cname=token"/>
```
## P3P协议 

>* 对应第三放cookie 浏览器 是有隐私策略协议。如IE 不允许 A页面向B页面写cookie. 如何突破，通过策略的设置告知浏览器是否允许访问第三方cookie.
>* Safari浏览器比较早的版本不支持P3P
>* 也不保证新的浏览器对P3P协议是否支持
```javascript
response.addHeader('P3P: CP="CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR"');
```
## URL参数实现跨域信息传递
>* www.a.com 生成cookie。 redirect 跳转的www.b.com?token=1231 
>* www.b.com 获取参数 并写入cookie

缺点:只能把cookie分享给另外的一个域。
优点：支持任何浏览器

# 跨域读Cookie

```javascript
<script type="text/javascript" src="http://www.b.com/read_cookies"/>

```
read_cookies:
```javascript
1. 读取中cookie 值 并拼接成：
   var token = '1234';
   var userName = 'nick';
   
2. 并将生成的代码返回
```


# ajax 跨域请求


## 通过jsonp 实现跨域请求 

### 原理
>* 先定义回调函数

```javascript
function showResult(ret) {
	console.log(ret);
	$("#container").html(ret.name);
}
```
> 通过script 标签生成 js代码
```javascript
<script type="text/javascript" src="http://www.b.com/user_info_2"/>

response.setContentType("application/javascript")
String userInfo="{id:1,name:'nick'}"
showResult("+userInfo+")
```
### 改进动态生成script标签

```javascript
var script = document.createElement("script");
script.src ="http://www.b.com/user_info_2?callback=showResult"
document.body.appendChild(script);

script.onload =  function(){
	document.body.removeChild(script)

```

### 公共方法

```javascript
 function myCallback(data) {
    console.log(data)
  }

  function jsonp(url, data, callback) {
    if (typeof data == 'string') {
      callback = data
      data = {}
    }
    var hasParams = url.indexOf('?')
    url += hasParams ? '&' : '?' + 'callback=' + callback
    var params
    for (var i in data) {
      params += '&' + i + '=' + data[i]
    }
    url += params

    var script = document.createElement('script')
    script.setAttribute('src', url)
    document.querySelector('head').appendChild(script)

  }

  jsonp('http://baidu.com',{id:34},'myCallback')
```
### jquery $.ajax本身就支持jsonp

```javascript
		$.ajax({
             type: "get",
             async: false,
             url: "http://flightQuery.com/jsonp/flightResult.aspx?code=CA1998",
             dataType: "jsonp",
             jsonp: "callback",//传递给请求处理程序或页面的，用以获得jsonp回调函数名的参数名(一般默认为:callback)
             jsonpCallback:"flightHandler",//自定义的jsonp回调函数名称，默认为jQuery自动生成的随机函数名，也可以写"?"，jQuery会自动为你处理数据
             success: function(json){
                 alert('您查询到航班信息：票价： ' + json.price + ' 元，余票： ' + json.tickets + ' 张。');
             },
             error: function(){
                 alert('fail');
             }
         });
```


## CORS 跨域资源共享

>* 是在html协议的标准之上，如何支持ajax跨域请求
>* 只要在相应头加入 以下。浏览器就可以正确接收并处理
```javascript
public static function setCrossDomain()
{
	header('Access-Control-Allow-Origin: *');//来源
	header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");
	header('Access-Control-Allow-Methods: GET, POST, PUT');
	
	//正确设置相应类型，避免IE出现下载
	response.setContentType("application/json");
}
```
如果是get请求只需要发送一次请求。

如果是post请求，或者 header 中增加了额外的属性则发起两次请求。

>* 发送两次请求，第一次是预检请求，查询是否支持跨域
>* 第二次才是真正的post提交


# 跨域访问-iframe 跨域读、写

> 在项目中，经常会使用到 iframe，把其它域名的内容嵌入到页面中，这对于我们来说是个很方便的方法，但是，有时候，无可避免需要多个iframe间或者iframe与主页面之间进行通信，比如交换数据或者触发一系列事件。

## frame同域通信

main.jsp 

>* 
```javascript
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>main_title我是主页标题</title>
    <script type="text/javascript" src="resources/admin/js/jquery-1.11.3.min.js"></script>
</head>
<body>

<p style="font-weight:bold;" id="sub_title">子页面加载完成后，将在此处显示子页面title</p>

<iframe width="500" height="300" id="frame"></iframe>

<p>
    <button onclick="loadFrame('sub_1.jsp');">load sub page</button>
</p>

<script type="text/javascript">

    function loadFrame(page) {

        var $frame = $("#frame");
		//加载页面
        $frame.attr("src", page); 

        $frame.one("load", function () {
			//获取子窗口的window对象
            var subWin = document.getElementById("frame").contentWindow; 

            $("#sub_title").html(subWin.document.title);

            subWin.funSub();
        });
    }

    /**
     * window
     * 定义在最外层 window.fun（）就可以调用
     * 提供给子页面调用的函数
     * @param arg
     */
    function funParent(arg) {
        alert("main页面的fun方法被frame页面调用，参数为： " + arg);
    }

</script>
</body>
</html>
```

sub_1.jsp

```javascript
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
//      var pwin = window.top; //获取顶层父页面的window对象
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
```

## frame跨子域通信

> sub.a.com 和 www.a.com 属于同一个域名下的子域名

main.js
```javascript
<button onclick="loadFrame('http://sub.a.com:8080/sub_2.jsp');">load sub page</button>
```

> 通过浏览器的控制台后台，可以观察到报错
```javascript
sub_2.jsp:40 Uncaught DOMException: Blocked a frame with origin "http://sub.a.com:8080" from accessing a cross-origin frame.
main.jsp:29 Uncaught DOMException: Blocked a frame with origin "http://www.a.com:8080" from accessing a cross-origin frame.
```

### 解决方法

把主页的域和子页面的域设置为同一个二级域名下，比如a.com，它们之间就可以访问了

在main.jsp \ sub_2.jsp加上js代码
```javascript
//提升为二级域名
document.domain = "a.com"; 
```

## frame跨全域通信

> html5中提供了window.postMessage这么一种用于安全的使用跨源通信的方法，可以实现跨文本档、多窗口、跨域消息传递。

postMessage(data,origin)方法接受两个参数

>* data:要传递的数据，html5规范中提到该参数可以是JavaScript的任意基本类型或可复制的对象，然而并不是所有浏览器都做到了这点儿，部分浏览器只能处理字符串参数，所以我们在传递参数的时候需要使用JSON.stringify()方法对对象参数序列化，在低版本IE中引用json2.js可以实现类似效果
>* origin：字符串参数，指明目标窗口的源，协议+主机+端口号[+URL]，URL会被忽略，所以可以不写，这个参数是为了安全考虑，postMessage()方法只会将message传递给指定窗口，当然如果愿意也可以建参数设置为"*"，这样可以传递给任意窗口，如果要指定和当前窗口同源的话设置为"/"


### 

> 父页面：http://www.a.com:8080/main.jsp  
> 子页面：http://www.b.com:8080/sub_3.jsp

main.js

```javascript
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我是主页标题</title>
    <script type="text/javascript" src="resources/admin/js/jquery-1.11.3.min.js"></script>
    <script>
        window.onmessage = function (evt) {
            evt = event || evt; //兼容性，获取事件
            console.log(evt);
            console.log(evt.origin); //打印来源
            $("#sub_title").html(evt.data);
        }
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
```
sub_3.jsp

```javascript

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>这是第一个子页面的标题</title>
    <script type="text/javascript" src="resources/admin/js/jquery-1.11.3.min.js"></script>
</head>
<body>

<script type="text/javascript">

    $(function () {
        window.parent.postMessage(document.title,"*"); //window.parent是父页面的window对象
    });
</script>
</body>
</html>
```

>* window.parent.postMessage 指定目标发送消息（子页面发送消息给main页面）
>* window.onmessage main页面监听 并接收数据。


main 监听接收的数据是MessageEvent 其中属性：

>* origin:"http://www.b.com:8080" 消息来源
>* source: Window 来源页面的window对象
>* data: 数据

### post_msg.js

抽取出来得到一个通用的模块post_msg.js

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

>* 需要在main.jsp引入post_msg.js，并且暴露etTitleVal方法
>* sub_3,jsp引入post_msg.js，调用下面代码即可。

```javascript
sendFrmMsg(window.parent, "setTitleVal", document.title);
```








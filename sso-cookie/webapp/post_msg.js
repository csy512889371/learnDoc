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
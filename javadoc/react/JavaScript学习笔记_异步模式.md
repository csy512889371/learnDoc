# 异步模式

## 1. 回调
```javascript
function f1(callback){
　　　　setTimeout(function () { 
　　　　　　// f1的任务代码 
　　　　　　callback(); 
　　　　}, 1000); 
} </br>

f1(f2);
```

## 2. 事件监听
```javascript
f1.on('done', f2);

function f1(){ 
　　setTimeout(function () { 
　　　　// f1的任务代码 
　　　　f1.trigger('done'); 
　　}, 1000); 
}
```
## 3. 发布/订阅
> * 我们假定，存在一个"信号中心"，某个任务执行完成，就向信号中心"发布"（publish）一个信号，其他任务可以向信号中心"订阅"（subscribe）这个信号，从而知道什么时候自己可以开始执行。这就叫做"发布/订阅模式"（publish-subscribe pattern），又称"观察者模式"（observer pattern）。
```javascript
jQuery.subscribe("done", f2);
function f1(){
　　　setTimeout(function () {
　　　　　// f1的任务代码 
　　　　　jQuery.publish("done");
　　　}, 1000);
}
```
## Promises对象
```javascript
f1的回调函数f2,可以写成：

f1().then(f2);

function f1(){
　　var dfd = $.Deferred();
　　setTimeout(function () {
　　　　// f1的任务代码
　　　　dfd.resolve();
　　}, 500);
　　return dfd.promise;
}
```
比如，指定多个回调函数
```javascript
f1().then(f2).then(f3);
```
再比如，指定发生错误时的回调函数

```javascript
f1().then(f2).fail(f3);
```
# 箭头函数

## 1. 一般使用箭头函数时，代码块部分只有一条语句时，不使用大括号
```javascript
var sum = (num1, num2) => num1 + num2 
```
* 同样的写法
```javascript
var sum = (num1, num2) => { return num1 + num2 }
```
* 等同于
```javascript
var sum = function(num1, num2) {
  return num1 + num2;
};

```
## 2. 如果有多条语句，使用大括号，同时使用return(否则没有返回值)
```javascript
var sum = (n1, n2) => {
  console.log(n1);
  return n1 + n2
}
```
## 3. 使用箭头函数返回对象：必须在对象外面加上括号，否则就只是个代码块，从而就不会返回对象
```javascript
var sum = () => ({name: 'a'})
```
* 等同于
```javascript
var sum = function sum() {
  return { name: 'a' };
};
```
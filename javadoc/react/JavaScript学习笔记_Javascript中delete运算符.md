# Javascript中delete运算符

Delete是Javascript语言中使用频率较低的操作之一，但是有些时候，当我们需要做delete或者清空动作时，就需要delete操作。在这篇文章中，我们将深入探讨如何使用它，以及它是如何工作的。

删除的目的，如你所想，就是要删除某些东西，更具体的说，它会删除对象的属性，如下例：

```javascript

var Benjamin = {
	"name": "zuojj",
	"url" : "http://www.zuojj.com"
};

delete Benjamin.name;

//Outputs: Object { url: "http://www.zuojj.com" }
console.log(Benjamin);
```

delete运算符将不会删除普通变量，如下例：

```javascript
var benjamin = "http://www.zuojj.com";
delete benjamin;

//Outputs: "http://www.zuojj.com"
console.log(benjamin);
```

## 一、删除“全局变量”
但是，它可以删除“全局变量”，因为它们事实上是全局对象（浏览器中是window）对象的属性

```javascript
// Because var isn't used, this is a property of window
benjamin = "zuojj";

delete window.benjamin;

// ReferenceError: benjamin is not defined
console.log(benjamin);
```

delete运算符也有一个返回值，如果删除一个属性成功了，返回true,如果不能删除属性，因为该属性是不可写，将返回false，或者如果在严格模式下会抛出一个错误。

```javascript
var benjamin = {
    "name": "zuojj",
    "url" : "http://www.zuojj.com"
};

var nameDeleted = delete benjamin.name;

// Outputs: true
console.log(nameDeleted);

"use strict";
var benjamin_02 = "zuojj";

//Outputs: Uncaught SyntaxError: Delete of an unqualified identifier in strict mode. 
delete benjamin_02;
```
## 二、如何使用

你可能不知道在什么情况下使用删除运算符。答案是，只要你真的想从对象中删除一个属性。

有的时候，Javascript开发不是删除一个属性，而是把这个属性值设置为null.像下面这样：
```javascript
var benjamin = {
    "name": "zuojj",
    "url" : "http://www.zuojj.com"
};
benjamin.name = null;
```

虽然这有效地切断从原来的值的属性，但该属性本身仍然存在的对象上，你可以看到如下：
```javascript
// Outputs: Object { name: null, url: "http://www.zuojj.com" }
console.log(benjamin);
```

同时，像in和for in 循环运算将不会报告null属性的存在，如果你使用个对象，可能使用这些方法来检查一个对象，你可能想确保你真正删除任何不需要的属性。

最后，你应该记住，删除并没有破坏属性的值，仅仅属性本身，看下面的例子
```javascript
var name     = "zuojj",
		benjamin = {};

benjamin.name = name;

delete benjamin.name;

//Outputs: "zuojj"
console.log(name);
```
这里，name和benjamin.name映射到相同的值，真如你所看到的，删除benjamin.name并不会影响name.

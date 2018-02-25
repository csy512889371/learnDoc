# es6 javascript对象的扩展运算符
目前， ES7 有一个提案，将 Rest 解构赋值 / 扩展运算符（ ... ）引入对象。 Babel 转码器已经支持这项功能。

## Rest 解构赋值
对象的 Rest 解构赋值用于从一个对象取值，相当于将所有可遍历的、但尚未被读取的属性，分配到指定的对象上面。所有的键和它们的值，都会拷贝到新对象上面。
```javascript
let { x, y, ...z } = { x: 1, y: 2, a: 3, b: 4 };
x // 1
y // 2
z // { a: 3, b: 4 }
```
上面代码中，变量z是 Rest 解构赋值所在的对象。它获取等号右边的所有尚未读取的键（a和b），将它们和它们的值拷贝过来。
由于 Rest 解构赋值要求等号右边是一个对象，所以如果等号右边是undefined或null，就会报错，因为它们无法转为对象。
```javascript
let { x, y, ...z } = null; //  运行时错误
let { x, y, ...z } = undefined; //  运行时错误
//Rest 解构赋值必须是最后一个参数，否则会报错。
let { ...x, y, z } = obj; //  句法错误
let { x, ...y, ...z } = obj; //  句法错误
```
上面代码中， Rest 解构赋值不是最后一个参数，所以会报错。
注意， Rest 解构赋值的拷贝是浅拷贝，即如果一个键的值是复合类型的值（数组、对象、函数）、那么 Rest 解构赋值拷贝的是这个值的引用，而不是这个值的副本。
```javascript
let obj = { a: { b: 1 } };
let { ...x } = obj;
obj.a.b = 2;
x.a.b // 2
```
上面代码中，x是 Rest 解构赋值所在的对象，拷贝了对象obj的a属性。a属性引用了一个对象，修改这个对象的值，会影响到 Rest 解构赋值对它的引用。
另外， Rest 解构赋值不会拷贝继承自原型对象的属性。


## 扩展运算符
扩展运算符（...）用于取出参数对象的所有可遍历属性，拷贝到当前对象之中。
```javascript
let z = { a: 3, b: 4 };
let n = { ...z };
n // { a: 3, b: 4 }
```
这等同于使用Object.assign方法。
```javascript
let aClone = { ...a };
//  等同于
let aClone = Object.assign({}, a);
```
扩展运算符可以用于合并两个对象。
```javascript
let ab = { ...a, ...b };
//  等同于
let ab = Object.assign({}, a, b);
```
如果用户自定义的属性，放在扩展运算符后面，则扩展运算符内部的同名属性会被覆盖掉。
```javascript
let aWithOverrides = { ...a, x: 1, y: 2 };
//  等同于
let aWithOverrides = { ...a, ...{ x: 1, y: 2 } };
//  等同于
let x = 1, y = 2, aWithOverrides = { ...a, x, y };
//  等同于
let aWithOverrides = Object.assign({}, a, { x: 1, y: 2 });
```

上面代码中，a对象的x属性和y属性，拷贝到新对象后会被覆盖掉。
这用来修改现有对象部分的部分属性就很方便了。

```javascript
let newVersion = {
	...previousVersion,
	name: 'New Name' // Override the name property
};
```
上面代码中，newVersion对象自定义了name属性，其他属性全部复制自previousVersion对象。
如果把自定义属性放在扩展运算符前面，就变成了设置新对象的默认属性值。
```javascript
let aWithDefaults = { x: 1, y: 2, ...a };
//  等同于
let aWithDefaults = Object.assign({}, { x: 1, y: 2 }, a);
//  等同于
let aWithDefaults = Object.assign({ x: 1, y: 2 }, a);
```
扩展运算符的参数对象之中，如果有取值函数get，这个函数是会执行的。
```javascript
//  并不会抛出错误，因为 x 属性只是被定义，但没执行
let aWithXGetter = {
	...a,
	get x() {
		throws new Error('not thrown yet');
	}
};
//  会抛出错误，因为 x 属性被执行了
let runtimeError = {
	...a,
	...{
		get x() {
			throws new Error('thrown now');
		}
	}
};
```
如果扩展运算符的参数是null或undefined，这个两个值会被忽略，不会报错。
```javascript
let emptyObject = { ...null, ...undefined }; //  不报错
```
















# Reduce 和 Transduce 的含义

## 一、reduce 的用法

reduce是一种数组运算，通常用于将数组的所有成员"累积"为一个值。

```javascript

var arr = [1, 2, 3, 4];

var sum = (a, b) => a + b;

arr.reduce(sum, 0) // 10
```

上面代码中，reduce对数组arr的每个成员执行sum函数。sum的参数a是累积变量，参数b是当前的数组成员。每次执行时，b会加到a，最后输出a。
累积变量必须有一个初始值，上例是reduce函数的第二个参数0。如果省略该参数，那么初始值默认是数组的第一个成员。

```javascript
var arr = [1, 2, 3, 4];

var sum = function (a, b) {
  console.log(a, b);
  return a + b;
};

arr.reduce(sum) // => 10
// 1 2
// 3 3
// 6 4
```

上面代码中，reduce方法省略了初始值。通过sum函数里面的打印语句，可以看到累积变量每一次的变化。
总之，reduce方法提供了一种遍历手段，对数组所有成员进行"累积"处理。

## 二、map 是 reduce 的特例

累积变量的初始值也可以是一个数组

```javascript

var arr = [1, 2, 3, 4];

var handler = function (newArr, x) {
  newArr.push(x + 1);
  return newArr;
};

arr.reduce(handler, [])
// [2, 3, 4, 5]
```
上面代码中，累积变量的初始值是一个空数组，结果reduce就返回了一个新数组，等同于执行map方法，对原数组进行一次"变形"。下面是使用map改写上面的例子。
```javascript
var arr = [1, 2, 3, 4];
var plusOne = x => x + 1;
arr.map(plusOne) // [2, 3, 4, 5]
```
事实上，所有的map方法都可以基于reduce实现。

```javascript
function map(f, arr) {
  return arr.reduce(function(result, x) {
    result.push(f(x));
    return result;
  }, []);
}
```

## 三、reduce的本质
本质上，reduce是三种运算的合成。
>* 遍历
>* 变形
>* 累积


还是来看上面的例子。
```javascript
var arr = [1, 2, 3, 4];
var handler = function (newArr, x) {
  newArr.push(x + 1);
  return newArr;
};

arr.reduce(handler, [])
// [2, 3, 4, 5]
```
上面代码中，首先，reduce遍历了原数组，这是它能够取代map方法的根本原因；其次，reduce对原数组的每个成员进行了"变形"（上例是加1）；最后，才是把它们累积起来（上例是push方法）。

## 四、transduce 的含义

reduce包含了三种运算，因此非常有用。但也带来了一个问题：代码的复用性不高。在reduce里面，变形和累积是耦合的，不太容易拆分。
每次使用reduce，开发者往往都要从头写代码，重复实现很多基本功能，很难复用别人的代码。

var handler = function (newArr, x) {
  newArr.push(x + 1);
  return newArr;
};
上面的这个处理函数，就很难用在其他场合。
有没有解决方法呢？回答是有的，就是把"变形"和"累积"这两种运算分开。如果reduce允许变形运算和累积运算分开，那么代码的复用性就会大大增加。这就是transduce方法的由来。
transduce这个名字来自 transform（变形）和 reduce 这两个单词的合成。它其实就是reduce方法的一种不那么耦合的写法。

```javascript
// 变形运算
var plusOne = x => x + 1;

// 累积运算
var append = function (newArr, x) {
  newArr.push(x);
  return newArr;
}; 

R.transduce(R.map(plusOne), append, [], arr);
// [2, 3, 4, 5]
```
上面代码中，plusOne是变形操作，append是累积操作。我使用了 Ramda 函数库的transduce实现。可以看到，transduce就是将变形和累积从reduce拆分出来，其他并无不同。

## 5、transduce 的用法
```javascript
var arr = [1, 2, 3, 4];
var append = function (newArr, x) {
  newArr.push(x);
  return newArr;
}; 

// 示例一
var plusOne = x => x + 1;
var square = x => x * x;

R.transduce(
  R.map(R.pipe(plusOne, square)), 
  append, 
  [], 
  arr
); // [4, 9, 16, 25]

// 示例二
var isOdd = x => x % 2 === 1;

R.transduce(
  R.pipe(R.filter(isOdd), R.map(square)), 
  append, 
  [], 
  arr
); // [1, 9]
```
上面代码中，示例一是两个变形操作的合成，示例二是过滤操作与变形操作的合成。这两个例子都使用了 Pointfree 风格。
可以看到，transduce非常有利于代码的复用，可以将一系列简单的、可复用的函数合成为复杂操作。作为练习，有兴趣的读者可以试试，使用reduce方法完成上面两个示例。你会发现，代码的复杂度和行数大大增加。

## 6、Transformer 对象

transduce函数的第一个参数是一个对象，称为 Transformer 对象（变形器）。前面例子中，R.map(plusOne)返回的就是一个 Transformer 对象。
事实上，任何一个对象只要遵守 Transformer 协议，就是 Transformer 对象。
```javascript
var Map = function(f, xf) {
    return {
       "@@transducer/init": function() { 
           return xf["@@transducer/init"](); 
       },
       "@@transducer/result": function(result) { 
           return xf["@@transducer/result"](result); 
       },
       "@@transducer/step": function(result, input) {
           return xf["@@transducer/step"](result, f(input)); 
       }
    };
};
```
上面代码中，Map函数返回的就是一个 Transformer 对象。它必须具有以下三个属性

```javascript
@@transducer/step：执行变形操作
@@transducer/init：返回初始值
@@transducer/result：返回变形后的最终值
```
所有符合这个协议的对象，都可以与其他 Transformer 对象合成，充当transduce函数的第一个参数。
因此，transduce函数的参数类型如下。

```javascript
transduce(
  变形器 : Object,
  累积器 : Function,
  初始值 : Any,
  原始数组 : Array
)
```

## 7、into 方法
最后，你也许发现了，前面所有示例使用的都是同一个累积器
```javascript
var append = function (newArr, x) {
  newArr.push(x);
  return newArr;
}; 
```

上面代码的append函数是一个常见累积器。因此， Ramda 函数库提供了into方法，将它内置了。也就是说，into方法相当于默认提供append的transduce函数。

```javascript
R.transduce(R.map(R.add(1)), append, [], [1,2,3,4]);
// 等同于
R.into([], R.map(R.add(1)), [1,2,3,4]);
```
上面代码中，into方法的第一个参数是初始值，第二个参数是变形器，第三个参数是原始数组，不需要提供累积器。
下面是另外一个例子。

```javascript
R.into(
  [5, 6],
  R.pipe(R.take(2), R.map(R.add(1))),
  [1, 2, 3, 4]
) // [5, 6, 2, 3]
```

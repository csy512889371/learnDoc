# React中元素与组件的区别

## 一、React 元素

React 元素（React element），它是 React 中最小基本单位，我们可以使用 JSX 语法轻松地创建一个 React 元素:
```javascript
const element = <div className="element">I'm element</div>
```
React 元素不是真实的 DOM 元素，它仅仅是 js 的普通对象（plain objects），所以也没办法直接调用 DOM 原生的 API。上面的 JSX 转译后的对象大概是这样的：

```javascript
{
    _context: Object,
    _owner: null,
    key: null,
    props: {
    className: 'element'，
    children: 'I'm element'
  },
    ref: null,
    type: "div"
}
```
只有在这个元素渲染被完成后，才能通过选择器的方式获取它对应的 DOM 元素。
不过，按照 React 有限状态机的设计思想，应该使用状态和属性来表述组件，要尽量避免 DOM 操作，即便要进行 DOM 操作，也应该使用 React 提供的接口**ref**和**getDOMNode()**。
一般使用 React 提供的接口就足以应付需要 DOM 操作的场景了，因此像 jQuery 强大的选择器在 React 中几乎没有用武之地了


除了使用 JSX 语法，我们还可以使用 React.createElement() 和 React.cloneElement() 来构建 React 元素。


### 1、React.createElement()
JSX 语法就是用React.createElement()来构建 React 元素的。它接受三个参数，第一个参数可以是一个标签名。如div、span，或者 React 组件。第二个参数为传入的属性。第三个以及之后的参数，皆作为组件的子组件。
```javascript
React.createElement(
    type,
    [props],
    [...children]
)
```

### 2、React.cloneElement()

React.cloneElement()与React.createElement()相似，不同的是它传入的第一个参数是一个 React 元素，而不是标签名或组件。新添加的属性会并入原有的属性，
传入到返回的新元素中，而旧的子元素将会替换。
```javascript
React.cloneElement(
  element,
  [props],
  [...children]
)
```

## 二、React 组件
React 中有三种构建组件的方式。React.createClass()、ES6 class和无状态函数。

### 1、React.createClass()
React.createClass()是三种方式中最早，兼容性最好的方法。在0.14版本前官方指定的组件写法

```javascript
var Greeting = React.createClass({
  render: function() {
    return <h1>Hello, {this.props.name}</h1>;
  }
});
```
### 2、ES6 class
ES6 class是目前官方推荐的使用方式，它使用了ES6标准语法来构建，但它的实现仍是调用React.createClass()来实现了，ES6 class的生命周期和自动绑定方式与React.createClass()略有不同。

```javascript
class Greeting extemds React.Component{
  render: function() {
    return <h1>Hello, {this.props.name}</h1>;
  }
};
```

### 3、无状态函数
无状态函数是使用函数构建的无状态组件，无状态组件传入props和context两个参数，它没有state，除了render()，没有其它生命周期方法。
```javascript
function Greeting (props) {
  return <h1>Hello, {props.name}</h1>;
}
```
React.createClass()和ES6 class构建的组件的数据结构是类，无状态组件数据结构是函数，它们在 React 被视为是一样的。

## 三、元素与组件的区别
组件是由元素构成的。元素数据结构是**普通对象**，而组件数据结构是**类**或**纯函数**。除此之外，还有几点区别要注意：

### 1、this.props.children
在 JSX 中，被元素嵌套的元素会以属性 children 的方式传入该元素的组件。
当仅嵌套一个元素时，children 是一个 React 元素，当嵌套多个元素时，children 是一个 React 元素的数组。
可以直接把 children 写入 JSX 的中，但如果要给它们传入新属性，就要用到React.cloneElement()来构建新的元素。**以下错误**:

```javascript
render () {
  var Child = this.props.children
  return <div><Child tip={'error!'}/><div>
}
```
因为 Child 是一个 React 元素，而不是组件，这样的写法是完全错误的，**正确的方式**应该是：
```javascript
render () {
  var child = this.props.children
  return <div>{ React.cloneElement(child, {tip: 'right way!'}) }<div>
}
```
就这样，原有属性和新添加的属性被一并传入了子元素。使用React.cloneElement()才是操作元素的正确姿势。

## 三、用户组件
有的时候，组件可以让用户以属性的方式传入自定义的组件，来提升组件的灵活性。这个属性传入的就应该是 React 元素，而非 React 组件。使用 React 元素可以让用户传入自定义组件的同时，为组件添加属性。同样，可以使用React.cloneElement()为自定义组件添加更多属性，或替换子元素。
```javascript
// 推荐
<MyComponent tick={
  <UserComponent tip="Yes"/>
} />

// 不推荐
<MyComponent tick={ UserComponent } />
```

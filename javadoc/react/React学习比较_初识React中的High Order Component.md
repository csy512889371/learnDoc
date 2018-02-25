# 初识React中的High Order Component

我们都知道，如果使用ES6 Component语法写React组件的话，mixin是不支持的。而mixin作为一种抽象和共用代码的方案，许多库（比如react-router）都依赖这一功能，自己的项目中可能都或多或少有用到mixin来尽量少写重复代码。

如果希望使用ES6 Component，有希望可以用一个像mixin一样的方案的话，可以使用react-mixin这样的库，就有种hack的感觉。这里介绍一个新的方案：High Order Component。


## 一、什么是High Order Component
High Order Component，下面统一简称为HOC。我理解的HOC实际上是这样一个函数

```javascript
hoc :: ReactComponent -> ReactComponent  
```


它接受一个ReactComponent，并返回一个新的ReactComponent，这一点颇有函数式编程的味道。由于是一个抽象和公用代码的方案，这个新的ReactComponent主要包含一些共用代码的逻辑或者是状态，用一个例子来解释更加直观

```javascript
const connect = (mapStateFromStore) => (WrappedComponent) => {  
  class InnerComponent extends Component {

    static contextTypes = {
      store: T.object
    }

    state = {
      others: {}
    }

    componentDidMount () {
      const { store } = this.context
      this.unSubscribe = store.subscribe(() => {
        this.setState({ others: mapStateFromStore(store.getState()) }
      })
    }

    componentWillUnmount () {
      this.unSubscribe()
    }

    render () {
      const { others } = this.state
      const props = {
        ...this.props,
        ...others
      }
      return <WrappedComponent {...props} />
    }
  }

  return InnerComponent
}
```
这个例子中定义的connect函数其实和react-redux中的connect差不多，我们发现它在内部定义了一个新的ReactComponent并将其返回，它的职责是在订阅store的改变，并将改变传递给子组件，在unmount的时候擦好屁股。这个case和常用的StoreMixin和类似。


## 二、始终要记住的是，HOC最终返回的是一个新的ReactComponent

要使用HOC的话可以这样：

```javascript
class MyContainer extends Component {  
  ...
}

export connect(() => ({}))(MyContainer)  
```
其实我们还发现HOC的函数类型和class decorator是一样的，所以可以这样：

```javascript
@connect(() => ({}))
class MyContainer extends Component {  
  ...
}

export MyContainer 
```
但是HOC不是decorator，不能保证decorator最终一定进入ES的规范中，然而HOC始终是那个函数

## 三、与mixin作比较

既然HOC的目的和mixin类似，那么我们来比较下这两种方案的区别：

首先，mixin是react亲生的，而HOC是社区实践的产物。其实这一点无关紧要，关键是讨论方案是否给开发带来便利，而且从趋势来看，并不看好mixin

不过我们还是先来看下mixin的使用场景

>* Lifecycle Hook
>* State Provider

第一个应用场景Lifecycle Hook通常是在React组件生命周期函数中做文章，最典型的就是对Store的监听和保证unmount时候取消监听。第二个应用场景State Provider，典型的例子就是react-router，它所提供的几个mixin都是route信息的提供者。复杂的mixin则是两者的结合了。

回到HOC，对于Lifecycle Hook而言，由于本身就返回一个新的ReactComponent，这一点毫无压力。对于State Provider而言，可以通过新的ReactComponent的state来维护。


**两者在生命周期上有差异**。这是我的测试结果，其中hoc表示HOC返回的新的ReactComponent，app表示的是WrappedComponent

```javascript
hoc componentWillMount  
app componentWillMount  
app componentDidMount  
hoc componentDidMount
```

注：这里的componentWillMount是在constructor中输出的。

然后如果在HOC返回的新组件中更新状态的话：

```javascript
hoc componentWillUpdate  
app componentWillReceiveProps  
app componentWillUpdate  
app componentDidUpdate  
hoc componentDidUpdate 
```
最后是unmount的部分

```javascript
hoc componentWillUnmount  
app componentWillUnmount 
```
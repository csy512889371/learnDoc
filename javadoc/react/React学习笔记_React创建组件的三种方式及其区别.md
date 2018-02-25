# React创建组件的三种方式及其区别

React推出后，出于不同的原因先后出现三种定义react组件的方式，殊途同归；具体的三种方式：

> 函数式定义的**无状态组件**
> es5原生方式**React.createClass**定义的组件
> es6形式的**extends React.Component**定义的组件


## 一、无状态函数式组件

创建无状态函数式组件形式是从React 0.14版本开始出现的。它是为了创建纯展示组件，这种组件只负责根据传入的props来展示，不涉及到要state状态的操作。具体的无状态函数式组件，其官方指出：

> 在大部分React代码中，大多数组件被写成无状态的组件，通过简单组合可以构建成其他的组件等；这种通过多个简单然后合并成一个大应用的设计模式被提倡。


无状态函数式组件形式上表现为一个只带有一个render方法的组件类，通过**函数形式**或者**ES6 arrow** function的形式在创建，并且该组件是无state状态的。具体的创建形式如下：

```javascript
function HelloComponent(props, /* context */) {
  return <div>Hello {props.name}</div>
}
ReactDOM.render(<HelloComponent name="Sebastian" />, mountNode)
```

```javascript
const App = ({todos, actions}) => (
  <div>
    <Header addTodo={actions.addTodo} />
    <MainSection todos={todos} actions={actions} />
  </div>
)
```
无状态组件的创建形式使代码的可读性更好，并且减少了大量冗余的代码，精简至只有一个render方法，大大的增强了编写一个组件的便利，除此之外无状态组件还有以下几个显著的特点：


### 1.组件不会被实例化，整体渲染性能得到提升
因为组件被精简成一个render方法的函数来实现的，由于是无状态组件，所以无状态组件就不会在有组件实例化的过程，无实例化过程也就不需要分配多余的内存，从而性能得到一定的提升。

### 2.组件不能访问this对象
无状态组件由于没有实例化过程，所以无法访问组件this中的对象，例如：this.ref、this.state等均不能访问。若想访问就不能使用这种形式来创建组件
### 3.组件无法访问生命周期的方法
因为无状态组件是不需要组件生命周期管理和状态管理，所以底层实现这种形式的组件时是不会实现组件的生命周期方法。所以无状态组件是不能参与组件的各个生命周期管理的。

### 4.无状态组件只能访问输入的props，同样的props会得到同样的渲染结果，不会有副作用
无状态组件被鼓励在大型项目中尽可能以简单的写法来分割原本庞大的组件，未来React也会这种面向无状态组件在譬如无意义的检查和内存分配领域进行一系列优化，所以**只要有可能，尽量使用无状态组件**。

## 二、React.createClass
> React.createClass`是react刚开始推荐的创建组件的方式，这是ES5的原生的JavaScript来实现的React组件，其形式如下：

```javascript
var InputControlES5 = React.createClass({
    propTypes: {//定义传入props中的属性各种类型
        initialValue: React.PropTypes.string
    },
    defaultProps: { //组件默认的props对象
        initialValue: ''
    },
    // 设置 initial state
    getInitialState: function() {//组件相关的状态对象
        return {
            text: this.props.initialValue || 'placeholder'
        };
    },
    handleChange: function(event) {
        this.setState({ //this represents react component instance
            text: event.target.value
        });
    },
    render: function() {
        return (
            <div>
                Type something:
                <input onChange={this.handleChange} value={this.state.text} />
            </div>
        );
    }
});
InputControlES6.propTypes = {
    initialValue: React.PropTypes.string
};
InputControlES6.defaultProps = {
    initialValue: ''
};
```

与无状态组件相比，React.createClass和后面要描述的React.Component都是创建有状态的组件，这些组件是要被实例化的，并且可以访问组件的生命周期方法。但是随着React的发展，React.createClass形式自身的问题暴露出来：
>* React.createClass会自绑定函数方法（不像React.Component只绑定需要关心的函数）导致不必要的性能开销，增加代码过时的可能性。
>* React.createClass的mixins不够自然、直观；React.Component形式非常适合高阶组件（Higher Order Components--HOC）,它以更直观的形式展示了比mixins更强大的功能，并且HOC是纯净的JavaScript，不用担心他们会被废弃。


## 三、React.Component

React.Component是以ES6的形式来创建react的组件的，是React目前极为推荐的创建有状态组件的方式，最终会取代React.createClass形式；相对于 React.createClass可以更好实现代码复用。将上面React.createClass的形式改为React.Component形式如下：
```javascript
class InputControlES6 extends React.Component {
    constructor(props) {
        super(props);

        // 设置 initial state
        this.state = {
            text: props.initialValue || 'placeholder'
        };

        // ES6 类中函数必须手动绑定
        this.handleChange = this.handleChange.bind(this);
    }

    handleChange(event) {
        this.setState({
            text: event.target.value
        });
    }

    render() {
        return (
            <div>
                Type something:
                <input onChange={this.handleChange}
               value={this.state.text} />
            </div>
        );
    }
}
InputControlES6.propTypes = {
    initialValue: React.PropTypes.string
};
InputControlES6.defaultProps = {
    initialValue: ''
};

```
## 四、React.createClass与React.Component区别
根据上面展示代码中二者定义组件的语法格式不同之外，二者还有很多重要的区别，下面就描述一下二者的主要区别。
### 1.函数this自绑定

React.createClass创建的组件，其每一个成员函数的this都有React自动绑定，任何时候使用，直接使用this.method即可，函数中的this会被正确设置。
```javascript
const Contacts = React.createClass({  
  handleClick() {
    console.log(this); // React Component instance
  },
  render() {
    return (
      <div onClick={this.handleClick}></div>
    );
  }
});
```

```javascript
Constructor {props: {…}, context: {…}, refs: {…}, updater: {…}, handleClick: ƒ, …}
context
:
{}
handleClick
:
ƒ ()
props
:
{}
refs
:
{}
state
:
null
updater
:
{isMounted: ƒ, enqueueCallback: ƒ, enqueueCallbackInternal: ƒ, enqueueForceUpdate: ƒ, enqueueReplaceState: ƒ, …}
_reactInternalInstance
:
ReactCompositeComponentWrapper {_currentElement: {…}, _rootNodeID: null, _compositeType: 0, _instance: Constructor, _hostParent: ReactDOMComponent, …}
__proto__
:
ReactClassComponent
```

React.Component创建的组件，其成员函数不会自动绑定this，需要开发者手动绑定，否则this不能获取当前组件实例对象。
```javascript

class Contacts extends Component {
    constructor(props) {
        super(props);
    }

    handleClick() {
        console.log(this); // null
    }

    render() {
        return (
            <div onClick={this.handleClick}>click me</div>
        );
    }
}
```
当然，React.Component有三种手动绑定方法：
>* 可以在构造函数中完成绑定，
>* 也可以在调用时使用method.bind(this)来完成绑定，
>* 还可以使用arrow function来绑定。拿上例的handleClick函数来说，其绑定可以有：


```javascript
    constructor(props) {
        super(props);
        this.handleClick = this.handleClick.bind(this);
        //构造函数中绑定
    }
```

```javascript
<div onClick={this.handleClick.bind(this)}></div> 
//使用bind来绑定
```
```javascript
<div onClick={()=>this.handleClick()}></div> 
//使用arrow function来绑定
```

### 2.组件属性类型propTypes及其默认props属性defaultProps配置不同

React.createClass在创建组件时，有关组件props的属性类型及组件默认的属性会作为组件实例的属性来配置，其中defaultProps是使用getDefaultProps的方法来获取默认组件属性的

```javascript
const TodoItem = React.createClass({
    propTypes: { // as an object
        name: React.PropTypes.string
    },
    getDefaultProps(){   // return a object
        return {
            name: ''    
        }
    }
    render(){
        return <div></div>
    }
})
```

React.Component在创建组件时配置这两个对应信息时，他们是作为组件类的属性，不是组件实例的属性，也就是所谓的类的静态属性来配置的。对应上面配置如下

```javascript
lass TodoItem extends React.Component {
    static propTypes = {//类的静态属性
        name: React.PropTypes.string
    };

    static defaultProps = {//类的静态属性
        name: ''
    };

    ...
}
```
组件初始状态state的配置不同

>* React.createClass创建的组件，其状态state是通过getInitialState方法来配置组件相关的状态；
>* React.Component创建的组件，其状态state是在constructor中像初始化组件属性一样声明的。

```javascript
const TodoItem = React.createClass({
    // return an object
    getInitialState(){ 
        return {
            isEditing: false
        }
    }
    render(){
        return <div></div>
    }
})
```

```javascript
class TodoItem extends React.Component{
    constructor(props){
        super(props);
        this.state = { // define this.state in constructor
            isEditing: false
        } 
    }
    render(){
        return <div></div>
    }
}
```

### 3.Mixins的支持不同

Mixins(混入)是面向对象编程OOP的一种实现，其作用是为了复用共有的代码，将共有的代码通过抽取为一个对象，然后通过Mixins进该对象来达到代码复用。

React.createClass在创建组件时可以使用mixins属性，以数组的形式来混合类的集合。

```javascript
var SomeMixin = {  
  doSomething() {

  }
};
const Contacts = React.createClass({  
  mixins: [SomeMixin],
  handleClick() {
    this.doSomething(); // use mixin
  },
  render() {
    return (
      <div onClick={this.handleClick}></div>
    );
  }
});
```

但是遗憾的是React.Component这种形式并不支持Mixins，至今React团队还没有给出一个该形式下的官方解决方案；但是React开发者社区提供一个全新的方式来取代Mixins,那就是Higher-Order Components

## 五、如何选择哪种方式创建组件

由于React团队已经声明React.createClass最终会被React.Component的类形式所取代。但是在找到Mixins替代方案之前是不会废弃掉React.createClass形式。所以：
> 能用React.Component创建的组件的就尽量不用React.createClass形式创建组件。

除此之外，创建组件的形式选择还应该根据下面来决定：
1、只要有可能，尽量使用无状态组件创建形式。
2、否则（如需要state、生命周期方法等），使用`React.Component`这种es6形式创建组件

## 六、补充一点

> 无状态组件内部其实是可以使用ref功能的，虽然不能通过this.refs访问到，但是可以通过将ref内容保存到无状态组件内部的一个本地变量中获取到。


例如下面这段代码可以使用ref来获取组件挂载到dom中后所指向的dom元素：

```javascript
function TestComp(props){
    let ref;
    return (<div>
        <div ref={(node) => ref = node}>
            ...
        </div>
    </div>)
}
```




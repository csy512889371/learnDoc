# 在react-router4中进行代码拆分（基于webpack）

## 前言

随着前端项目的不断扩大，一个原本简单的网页应用所引用的js文件可能变得越来越庞大。尤其在近期流行的单页面应用中，越来越依赖一些打包工具（例如webpack），通过这些打包工具将需要处理、相互依赖的模块直接打包成一个单独的bundle文件，在页面第一次载入时，就会将所有的js全部载入。但是，往往有许多的场景，我们并不需要在一次性将单页应用的全部依赖都载下来。例如：我们现在有一个带有权限的"订单后台管理"单页应用，普通管理员只能进入"订单管理"部分，而超级用户则可以进行"系统管理"；或者，我们有一个庞大的单页应用，用户在第一次打开页面时，需要等待较长时间加载无关资源。这些时候，我们就可以考虑进行一定的代码拆分（code splitting）。

# 实现方式

## 简单的按需加载
代码拆分的核心目的，就是实现资源的按需加载。考虑这么一个场景，在我们的网站中，右下角有一个类似聊天框的组件，当我们点击圆形按钮时，页面展示聊天组件

```javascript
btn.addEventListener('click', function(e) {
    // 在这里加载chat组件相关资源 chat.js
});
```

从这个例子中我们可以看出，通过将加载chat.js的操作绑定在btn点击事件上，可以实现点击聊天按钮后聊天组件的按需加载。而要动态加载js资源的方式也非常简单（方式类似熟悉的jsonp）。通过动态在页面中添加<scrpt>标签，并将src属性指向该资源即可。

```javascript
btn.addEventListener('click', function(e) {
    // 在这里加载chat组件相关资源 chat.js
    var ele = document.createElement('script');
    ele.setAttribute('src','/static/chat.js');
    document.getElementsByTagName('head')[0].appendChild(ele);
});

```
代码拆分就是为了要实现按需加载所做的工作。想象一下，我们使用打包工具，将所有的js全部打包到了bundle.js这个文件，这种情况下是没有办法做到上面所述的按需加载的，因此，我们需要讲按需加载的代码在打包的过程中拆分出来，这就是代码拆分。那么，对于这些资源，我们需要手动拆分么？当然不是，还是要借助打包工具。下面就来介绍webpack中的代码拆分。

## 代码拆分
这里回到应用场景，介绍如何在webpack中进行代码拆分。在webpack有多种方式来实现构建是的代码拆分。

## import()

这里的import不同于模块引入时的import，可以理解为一个动态加载的模块的函数(function-like)，传入其中的参数就是相应的模块。例如对于原有的模块引入import react from 'react'可以写为import('react')。但是需要注意的是，import()会返回一个Promise对象。因此，可以通过如下方式使用：

```javascript
btn.addEventListener('click', e => {
    // 在这里加载chat组件相关资源 chat.js
    import('/components/chart').then(mod => {
        someOperate(mod);
    });
});

```
可以看到，使用方式非常简单，和平时我们使用的Promise并没有区别。当然，也可以再加入一些异常处理：

```javascript
btn.addEventListener('click', e => {
    import('/components/chart').then(mod => {
        someOperate(mod);
    }).catch(err ＝> {
        console.log('failed');
    });
});


```
当然，由于import()会返回一个Promise对象，因此要注意一些兼容性问题。解决这个问题也不困难，可以使用一些Promise的polyfill来实现兼容。可以看到，动态import()的方式不论在语意上还是语法使用上都是比较清晰简洁的。

## require.ensure()

在webpack 2的官网上写了这么一句话：
```javascript
require.ensure() is specific to webpack and superseded by import().
```
所以，在webpack 2里面应该是不建议使用require.ensure()这个方法的。但是目前该方法仍然有效，所以可以简单介绍一下。包括在webpack 1中也是可以使用。下面是require.ensure()的语法：

```javascript

require.ensure(dependencies: String[], callback: function(require), errorCallback: function(error), chunkName: String)
```
require.ensure()接受三个参数：


>* 第一个参数dependencies是一个数组，代表了当前require进来的模块的一些依赖；
>* 第二个参数callback就是一个回调函数。其中需要注意的是，这个回调函数有一个参数require，通过这个require就可以在回调函数内动态引入其他模块。值得注意的是，虽然这个require是回调函数的参数，理论上可以换其他名称，但是实际上是不能换的，否则webpack就无法静态分析的时候处理它；
>* 第三个参数errorCallback比较好理解，就是处理error的回调；
>* 第四个参数chunkName则是指定打包的chunk名称。

因此，require.ensure()具体的用法如下：

```javascript
btn.addEventListener('click', e => {
    require.ensure([], require => {
        let chat = require('/components/chart');
        someOperate(chat);
    }, error => {
        console.log('failed');
    }, 'mychat');
});


```

## Bundle Loader
除了使用上述两种方法，还可以使用webpack的一些组件。例如使用Bundle Loader：

```javascript
npm i --save bundle-loader
```
使用require("bundle-loader!./file.js")来进行相应chunk的加载。该方法会返回一个function，这个function接受一个回调函数作为参数。

```javascript
let chatChunk = require("bundle-loader?lazy!./components/chat");
chatChunk(function(file) {
    someOperate(file);
});
```
和其他loader类似，Bundle Loader也需要在webpack的配置文件中进行相应配置。Bundle-Loader的代码也很简短，如果阅读一下可以发现，其实际上也是使用require.ensure()来实现的，通过给Bundle-Loader返回的函数中传入相应的模块处理回调函数即可在require.ensure()的中处理，代码最后也列出了相应的输出格式：

```javascript
/*
Output format:
    var cbs = [],
        data;
    module.exports = function(cb) {
        if(cbs) cbs.push(cb);
            else cb(data);
    }
    require.ensure([], function(require) {
        data = require("xxx");
        var callbacks = cbs;
        cbs = null;
        for(var i = 0, l = callbacks.length; i < l; i++) {
            callbacks[i](data);
        }
    });
*/


```
## react-router v4 中的代码拆分

最后，回到实际的工作中，基于webpack，在react-router4中实现代码拆分。react-router 4相较于react-router 3有了较大的变动。其中，在代码拆分方面，react-router 4的使用方式也与react-router 3有了较大的差别。
在react-router 3中，可以使用Route组件中getComponent这个API来进行代码拆分。getComponent是异步的，只有在路由匹配时才会调用。但是，在react-router 4中并没有找到这个API，那么如何来进行代码拆分呢？
在react-router 4官网上有一个代码拆分的例子。其中，应用了Bundle Loader来进行按需加载与动态引入

```javascript
import loadSomething from 'bundle-loader?lazy!./Something'
```
然而，在项目中使用类似的方式后，出现了这样的警告：

```javascript

Unexpected '!' in 'bundle-loader?lazy!./component/chat'. Do not use import syntax to configure webpack loaders import/no-webpack-loader-syntax
Search for the keywords to learn more about each error.


```

> 在webpack 2中已经不能使用import这样的方式来引入loader了（no-webpack-loader-syntax）</br>
> Webpack allows specifying the loaders to use in the import source string using a special syntax like this: </br>
> var moduleWithOneLoader = require("my-loader!./my-awesome-module"); </br>
> This syntax is non-standard, so it couples the code to Webpack. The recommended way to specify Webpack loader configuration is in a Webpack configuration file.

我的应用使用了create-react-app作为脚手架，屏蔽了webpack的一些配置。当然，也可以通过运行npm run eject使其暴露webpack等配置文件。然而，是否可以用其他方法呢？当然。
这里就可以使用之前说到的两种方式来处理：import()或require.ensure()。
和官方实例类似，我们首先需要一个异步加载的包装组件Bundle。Bundle的主要功能就是接收一个组件异步加载的方法，并返回相应的react组件：

```javascript
export default class Bundle extends Component {
    constructor(props) {
        super(props);
        this.state = {
            mod: null
        };
    }

    componentWillMount() {
        this.load(this.props)
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.load !== this.props.load) {
            this.load(nextProps)
        }
    }

    load(props) {
        this.setState({
            mod: null
        });
        props.load((mod) => {
            this.setState({
                mod: mod.default ? mod.default : mod
            });
        });
    }

    render() {
        return this.state.mod ? this.props.children(this.state.mod) : null;
    }
}


```
在原有的例子中，通过Bundle Loader来引入模块：
```javascript
import loadSomething from 'bundle-loader?lazy!./About'

const About = (props) => (
    <Bundle load={loadAbout}>
        {(About) => <About {...props}/>}
    </Bundle>
)


```
由于不再使用Bundle Loader，我们可以使用import()对该段代码进行改写：

```javascript
const Chat = (props) => (
    <Bundle load={() => import('./component/chat')}>
        {(Chat) => <Chat {...props}/>}
    </Bundle>
);
```
需要注意的是，由于import()会返回一个Promise对象，因此Bundle组件中的代码也需要相应进行调整
```javascript
export default class Bundle extends Component {
    constructor(props) {
        super(props);
        this.state = {
            mod: null
        };
    }

    componentWillMount() {
        this.load(this.props)
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.load !== this.props.load) {
            this.load(nextProps)
        }
    }

    load(props) {
        this.setState({
            mod: null
        });
        //注意这里，使用Promise对象; mod.default导出默认
        props.load().then((mod) => {
            this.setState({
                mod: mod.default ? mod.default : mod
            });
        });
    }

    render() {
        return this.state.mod ? this.props.children(this.state.mod) : null;
    }
}


```
路由部分没有变化

```javascript
<Route path="/chat" component={Chat}/>
```






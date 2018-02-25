
# 常用组件

>* axios(http请求模块，可用于前端任何场景，很强大:+1:)
>* echarts-for-react(可视化图表，别人基于react对echarts的封装，足够用了)
>* recharts(另一个基于react封装的图表，个人觉得是没有echarts好用)
>* nprogress(顶部加载条，蛮好用:+1:)
>* react-draft-wysiwyg(别人基于react的富文本封装，如果找到其他更好的可以替换)
>* react-draggable(拖拽模块，找了个简单版的)
>* screenfull(全屏插件)
>* photoswipe(图片弹层查看插件，不依赖jQuery，还是蛮好用:+1:)
>* animate.css(css动画库)
>* redux Web 应用是一个状态机，视图与状态是一一对应的.所有的状态，保存在一个对象里面
>* redux-logger 日志
>* Reselect 记忆组件
>* redux-thunk 为了解决异步action的问题
>* redux-saga 为了解决异步action的问题
>* react-router-redux 保持路由与应用状态(state)同步
>* react-router-dom

等等

# 1. Reselect

>* mapStateToProps也被叫做selector，在store发生变化的时候就会被调用，而不管是不是selector关心的数据发生改变它都会被调用，所以如果selector计算量非常大，每次更新都重新计算可能会带来性能问题。
>* Reselect能帮你省去这些没必要的重新计算。
>* Reselect 提供 createSelector 函数来创建可记忆的 selector。
>* createSelector 接收一个 input-selectors 数组和一个转换函数作为参数。
>* 如果 state tree 的改变会引起 input-selector 值变化，那么 selector 会调用转换函数，传入 input-selectors 作为参数，并返回结果。
>* 如果 input-selectors 的值和前一次的一样，它将会直接返回前一次计算的数据，而不会再调用一次转换函数。
>* 这样就可以避免不必要的计算，为性能带来提升。


例子：
```shell
import {} from 'reselect';

export const getItems = (state) => state.cart.get('items');

export const getItemsWithTotals = createSelector(
	[ getItems ],
	(item) => {
		return items.map(i =>{
			return i.set('total', i.get('price', 0) * i.get('quantity');
		});
	}
)

```

>* 创建一个记忆性的selector.这个意思是getItemWithTotals在第一次函数运行的时候将会进行运算.
>* 如果同一个函数再次被调用,但是输入值(getItems的值)没有变化,函数将会返回一个缓存(cached)的计算结果.
>* 如果items被修改了(例如：item添加,数量的变化,任何事情操作了getItems的结果),函数将会再次执行.

# 2. react-router-redux

保持路由与应用状态(state)同步

```javascript
npm install --save react-router-redux@next
```

## 例子：
```javascript
import {Provider} from 'react-redux';
import LocaleProvider from 'antd/lib/locale-provider';
import createBrowserHistory from 'history/createBrowserHistory';
import { ConnectedRouter} from 'react-router-redux';

const history = createBrowserHistory();


        <LocaleProvider locale={zhCn}>
            <Provider store={store}>
                <ConnectedRouter history={history}>
                    <Switch>
                        <Route exact strict path="/" component={HomePage}/>
                        <Route path='/login' component={Login}/>
                        <Route path='/uums/' component={Uums}/>
                    </Switch>
                </ConnectedRouter>
            </Provider>
        </LocaleProvider>
```

# 3. react-router-dom

路由
```javascript
 import {Link,Route,BrowserRouter as Router} from 'react-router-dom' 
  (<Router>
  <div>
    <ul>
      <li><Link to="/">主页</Link></li>
      <li><Link to="/hot">热门</Link></li>
      <li><Link to="/zhuanlan">专栏</Link></li>
    </ul>
    <hr/>
    <Route  exact path="/" component={App}></Route>
    <Route path="/hot" component={Hot} ></Route>
    <Route path="/zhuanlan" component={Zhuanlan}></Route>
  </div>
</Router>)
```

>* 注意使用Router作为最外层标签，里面只能有一个一级子节点
>* 用Link来导航
>* to指定路径
>* Route指定要导航到的组件，这样一个路由的基本使用就成型了。
>* exact用于精准匹配路径，不用exact也会匹配到匹配的路径的子路径，这样两个路由组件都会显示。
>* 我们需要的是每次切换只会显示一个Route中指定的组件


例子：
```javascript
import {Switch, Route} from 'react-router-dom';


        <LocaleProvider locale={zhCn}>
            <Provider store={store}>
                <ConnectedRouter history={history}>
                    <Switch>
                        <Route exact strict path="/" component={HomePage}/>
                        <Route path='/login' component={Login}/>
                        <Route path='/uums/' component={Uums}/>
                    </Switch>
                </ConnectedRouter>
            </Provider>
        </LocaleProvider>
```

## switch
>* 在没有Switch 的情况下。router 4 下 如果 URL 是/ 会匹配所有的Route.
>* switch 情况，寻找匹配的，并在匹配上后停止寻找匹配并呈现匹配上的组件。

## exact
>* 当为真时，仅当位置匹配完全时才会应用对应的组件

## strict: bool
>* 当为真时，在确定位置是否与当前网址匹配时，将考虑位置路径名上的尾部斜线

## Route props 属性

>* match
>* location
>* history


# 4. Immutable 作用
 
ES6出现原生的assign方法，但它相当于是浅copy。如何用immutableJS实现深拷贝
```javascript
var  defaultConfig = Immutable.fromJS({ /* 默认值 */}); 
var config = defaultConfig.merge(initConfig); // defaultConfig不会改变，返回新值给configvar 
config = defaultConfig.mergeDeep(initConfig); // 深层merge

```
遍历对象不再用for-in，可以这样:
```javascript
Immutable.fromJS({a:1, b:2, c:3}).map(function(value, key) { /* do some thing */});
```

实现一个map-reduce:
```javascript
var o = Immutable.fromJS({a:{a:1}, b:{a:2}, c:{a:3}});
o.map(function(e){ return e.get('a'); }).reduce(function(e1, e2){ return e1 + e2; }, 0);


```
修改藏在深处的值，可以这样：
```javascript
var o = Immutable.fromJS({a:[{a1:1}, {b:[{t:1}]}, {c1:2}], b:2, c:3});
o = o.setIn(['a', 1, 'b', 0, 't'], 100);  // t赋值
o = o.updateIn(['a', 1, 'b', 0, 't'], function(e){ return e * 100; }); // t * 100

```
比较两个对象是否完全相等: o1.equals(o2)

# 5. Immutable.js fromJS()

将原生javaScript对象转成 Immutable Data


## Object to Immutable Map:

```javascript
const plainJSObject = {
      title: "Go to grocery",
      text: "I need milk and eggs",
      completed: false,
      category: {title: "House Duties", priority: 10}
    };
    
    const immutableTodo = Immutable.fromJS(plainJSObject);
    
    expect(Immutable.Map.isMap(immutableTodo)).to.be.true

```

## 使用 getIn() 获取值
```javascript

expect(immtableTodo.getIn(["category", "title"])).to.equal("House Duties");
```
## Array to Immutable List:

```javascript
 const plainJSArray = [
      "Go to grocery",
      "Buy milk and eggs",
      "Help kids with homework",
      ["Buy Lemons", "Make Lemonade"]
    ];
    
    const immutableTodoList = Immutable.fromJS(plainJSArray);
    expect(Immutable.List.isList(immutableTodoList)).to.be.true;
```

通过getin获取值

```javascript
expect(immutableTodoList.getIn([3, 1])).to.equal("Make Lemonade")
```

## 转 array为 immutable Map
```javascript
const plainJSArray = [
      "Go to grocery",
      "Buy milk and eggs",
      "Help kids with homework",
      ["Buy Lemons", "Make Lemonade"]
    ];

    const immutableTodoList = Immutable.formJS(plainJSArray, (key, value)=>{

         return value.toMap();
    });


    expect(immutableTodoList.getIn([3,1])).to.equal("Make Lemonade");
```

# 6. 使用moment.js轻松管理日期和时间

> 大家在前端Javascript开发中会遇到处理日期时间的问题，经常会拿来一大堆处理函数才能完成一个简单的日期时间显示效果。

## 格式化日期
```javascript
当前时间：

moment().format('YYYY-MM-DD HH:mm:ss'); 
今天是星期几：

moment().format('d');
转换当前时间的Unix时间戳：

moment().format('X'); 

moment(item.publishtime)

```

# 7. axios api调用

```javascript
import axios from 'axios';

export const gitOauthToken = code => axios.post('https://cors-anywhere.herokuapp.com/' + GIT_OAUTH + '/access_token', {...{client_id: '792cdcd244e98dcd2dee',
    client_secret: '81c4ff9df390d482b7c8b214a55cf24bf1f53059', redirect_uri: 'http://localhost:3006/', state: 'reactAdmin'}, code: code}, {headers: {Accept: 'application/json'}})
    .then(res => res.data).catch(err => console.log(err));
export const gitOauthInfo = access_token => axios({
    method: 'get',
    url: 'https://api.github.com/user?access_token=' + access_token,
}).then(res => res.data).catch(err => console.log(err));

```


# 8. fetch-jsonp 跨域ajax请求


# 9. React-intl 实现多语言
React 做国际化，我推荐使用 React-intl , 这个库提供了 React 组件和Api两种方式来格式化日期，数字和字符串等。知道这个库了，那让我们开始使用它

# 10. react-document-title

动态改变title

# 11. react-copy-to-clipboard
复制到剪切版

# 12. remark-react

渲染富文本页面

# 13.阿里矢量图
[阿里矢量图](http://iconfont.cn)

# Redux store 的动态注入reducer

>* 在 React + Redux + React-Router 的单页应用架构中,我们将 UI 层（ React 组件）和数据层（ Redux store ）分离开来，以做到更好地管理应用的。
>* Redux store 既是存储整个应用的数据状态，它的 state 是一个树的数据结构，可以看到如图的例子：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/injection/section-redux-async-1.png)

>* 而随着应用和业务逻辑的增大，项目中的业务组件和数据状态也会越来越多;
>* 在Router 层面可以使用 React-Router 结合 webpack 做按需加载 以减少单个 js 包的大小。bundle
>*  而在 store 层面，随着应用增大，整个结构可能会变的非常的大，应用加载初始化的时候就会去初始化定义整个应用的 store state 和 actions ，这对与内存和资源的大小都是一个比较大的占用和消耗。

因此如何做到像 Router 一样地在需要某一块业务组件的时候再去添加这部分的 Redux 相关的数据呢？

## Redux store 动态注入 的方案
>* 在 Redux 中，对于 store state 的定义是通过组合 reducer 函数来得到的，也就是说 reducer 决定了最后的整个状态的数据结构
>* 在生成的 store 中有一个 replaceReducer(nextReducer) 方法，它是 Redux 中的一个高阶 API ，该函数接收一个 nextReducer 参数
>* 用于替换 store 中原原有的 reducer ，以此可以改变 store 中原有的状态的数据结构。

> 因此，在初始化 store 的时候，我们可以只定义一些默认公用 reducer（登录状态、全局信息等等），也就是在 createStore 函数中只传入这部分相关的 reducer ，这时候其状态的数据结构如下：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/injection/section-redux-async-2.png)

> 当我们加载到某一个业务逻辑对应的页面时，比如 /home，这部分的业务代码经过 Router 中的处理是按需加载的，在其初始化该部分的组件之前，我们可以在 store 中注入该模块对应的 reducer ，这时候其整体状态的数据结构应该如下：

![image](https://github.com/csy512889371/learnDoc/blob/master/image/injection/section-redux-async-3.png)

在这里需要做的就是将新增的 reducer 与原有的 reducer 组合，然后通过 store.replaceReducer 函数更新其 reducer 来做到在 store 中的动态注入。

# 代码

## reducerUtils.js reducer工具类

```javascript
export const makeAllReducer = (asyncReducers) => combineReducers({
  ...asyncReducers
});

export const injectReducer = (store, { key, reducer }) => {
  if (Object.hasOwnProperty.call(store.asyncReducers, key)) return;

  store.asyncReducers[key] = reducer;
  store.replaceReducer(makeAllReducer(store.asyncReducers));
}

export const createReducer = (initialState, ACTION_HANDLES) => (
  (state = initialState, action) => {
    const handler = ACTION_HANDLES[action.type];
    return handler ? handler(state, action) : state;
  }
);
```

>* makeAllReducer 调用combineReducers 整合reducer
>* injectReducer 将整合的reducer 更新到 store （调用 store.replaceReducer）

## 入口

```javascript
ReactDOM.render(<Root />, document.getElementById('root'));
```



## 入口 Root 组件
```javascript
import createStore from '../store/createStore';
import reducer, { key } from './rootReducer';

export const store  = createStore({} , {
  [key]: reducer
});

const lazyLoader = (importComponent) => (
  class AsyncComponent extends Component {
    state = { C: null }

    async componentDidMount () {
      const { default: C } = await importComponent();
      this.setState({ C });
    }

    render () {
      const { C } = this.state;
      return C ? <C {...this.props} /> : null;
    }
  }
);

export default class Root extends Component {
  render () {
    return (
      <div className='root__container'>
        <Provider store={store}>
          <Router>
            <div className='root__content'>
              <Link to='/'>Home</Link>
              <br />
              <Link to='/list'>List</Link>
              <br />
              <Link to='/detail'>Detail</Link>
              <Switch>
                <Route exact path='/'
                  component={lazyLoader(() => import('./Home'))}
                />
                <Route path='/list'
                  component={lazyLoader(() => import('./List'))}
                />
                <Route path='/detail'
                  component={lazyLoader(() => import('./Detail'))}
                />
              </Switch>
            </div>
          </Router>
        </Provider>
      </div>
    );
  }
}

```
>* 创建store, 其中**rootReducer** 表示初始reducer,只包含和认证相关(全局的状态数据和处理函数)的reducer。
>* lazyLoader 函数是用来异步加载组件的，也就是通过不同的 route 来分割代码做按需加载
>* Provider 是用来连接 Redux store 和 React 组件，这里需要传入 store 对象


## 创建 STORE

```javascript
export default (initialState = {}, initialReducer = {}) => {
  const middlewares = [thunk];

  const enhancers = [];

  if (process.env.NODE_ENV === 'development') {
    const devToolsExtension = window.devToolsExtension;
    if (typeof devToolsExtension === 'function') {
      enhancers.push(devToolsExtension());
    }
  }

  const store = createStore(
    makeAllReducer(initialReducer),
    initialState,
    compose(
      applyMiddleware(...middlewares),
      ...enhancers
    )
  );

  store.asyncReducers = {
    ...initialReducer
  };

  return store;
}

```
>* createStore 初始reducer、插件、initeState



## 根据route 创建组件
```javascript
import { injectReducer } from '../../store/reducerUtils';
import { store } from '../Root';
import Detail from './index.jsx';
import reducer, { key } from './reducer';

injectReducer(store, { key, reducer });

export default Detail;


```
>* 调用 injectReducer 重新生成reducer
>* 加载 组件





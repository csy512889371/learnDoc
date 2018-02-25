# Redux-Saga 学习笔记


## 一、Redux-Saga介绍

>* redux-saga 旨在于更好、更易地解决**异步操作**（action）
>* redux-saga相当于在Redux原有数据流中多了一层，对Action进行监听，捕获到监听的Action后可以派生一个新的任务对state进行维护

## 二、于 redux-thunk 比较：

相同点： 
> 可以处理异步操作和协调复杂的dispatch


不同点：

>* Sagas 是通过 Generator 函数来创建的，意味着可以用同步的方式写异步的代码
>* Thunks 是在 action 被创建时才调用，Sagas 在应用启动时就开始调用，监听action 并做相应处理
>* 启动的任务可以在任何时候通过手动取消，也可以把任务和其他的 Effects 放到 race 方法里可以自动取消


## 三、例子 

###  关键代码

man.js
```javascript
const action = type => store.dispatch({type})

function render() {
  ReactDOM.render(
    <Counter
      value={store.getState()}
      onIncrement={() => action('INCREMENT_ASYNC')}
      onDecrement={() => action('DECREMENT')} />,
    document.getElementById('root')
  )
}
```
>* 调用一个异步函数 ；
>* 发起一个 action 到 Store (INCREMENT_ASYNC)；

sagas.js

```javascript

import { takeEvery } from 'redux-saga'
import { put } from 'redux-saga/effects'

// 一个工具函数：返回一个 Promise，这个 Promise 将在 1 秒后 resolve
export const delay = ms => new Promise(resolve => setTimeout(resolve, ms))

// Our worker Saga: 将异步执行 increment 任务
export function* incrementAsync() {
	yield delay(1000);
  	yield put({ type: 'INCREMENT' });
}

// Our watcher Saga: 在每个 INCREMENT_ASYNC action 调用后，派生一个新的 incrementAsync 任务
export default function* watchIncrementAsync() {
  	yield* takeEvery('INCREMENT_ASYNC', incrementAsync);
}

```
>* sagas创建了一个watchIncrementAsync 监听SAY_HELLO的Action
>* 派生一个新的任务——延时一秒后 dispatch('INCREMENT')

## 四、yield和yield*区别

例子一：
```javascript
function* sub() {
    for (let i = 65; i < 70; i++) {
        yield String.fromCharCode(i);
    }
}

function* main() {
    yield "begin";
    yield sub();    // 返回的是 sub() 的结果，一个对象
    yield "---------";
    yield* sub();   // 依次返回 sub() 结果的的每一项
    yield "end";
}

for (var v of main()) {
    console.log(v);
}
```

例子二：
```javascript
function* g1() {
  yield 2
  yield 3
}

function* g2() {
  yield 1
  yield g1()
  yield* g1()
  yield [4, 5]
  yield* [6, 7]
}

const iterator = g2()

console.log(iterator.next()) // { value: 1, done: false }
console.log(iterator.next()) // { value: {}, done: false }
console.log(iterator.next()) // { value: 2, done: false }
console.log(iterator.next()) // { value: 3, done: false }
console.log(iterator.next()) // { value: [4, 5], done: false }
console.log(iterator.next()) // { value: 6, done: false }
console.log(iterator.next()) // { value: 7, done: false }
console.log(iterator.next()) // { value: undefined, done: true }
```

## 五、redux-saga常用方法解释
### redux Effects

Effect 是一个 javascript 对象，可以通过 yield 传达给 sagaMiddleware 进行执行在， 如果我们应用redux-saga，所有的 Effect 都必须被 yield 才会执行。

```javascript
yield call(fetch, url)
```

### take

>* 等待 dispatch 匹配某个 action

```javascript
while (true) {
  yield take('CLICK_Action');
  yield fork(clickButtonSaga);
}
```

再举一个利用 take 实现 logMiddleware 的例子

```javascript
while (true) {
  const action = yield take('*');
  const newState = yield select();
  
  console.log('received action:', action);
  console.log('state become:', newState);
}
```

```javascript
yield takeEvery('*', function* logger(action) {
  const newState = yield select();

  console.log('received action:', action);
  console.log('state become:', newState);
});
```


### put 

触发某个action， 作用和dispatch相同

```javascript
yield put({ type: 'CLICK' });
```
具体的例子：

```javascript
import { call, put } from 'redux-saga/effects'

export function* fetchData(action) {
   try {
      const data = yield call(Api.fetchUser, action.payload.url)
      yield put({type: "FETCH_SUCCEEDED", data})
   } catch (error) {
      yield put({type: "FETCH_FAILED", error})
   }
}
```

### select

作用和 redux thunk 中的 getState 相同。通常会与reselect库配合使用

### 阻塞调用和无阻塞调用 call \ fork

>* redux-saga 可以用 fork 和 call 来调用子 saga ，其中 fork 是无阻塞型调用，call 是阻塞型调用。
>* call 有阻塞地调用 saga 或者返回 promise 的函数，只在触发某个动作


### fork 和 cancel

通常fork 和 cancel配合使用， 实现非阻塞任务，take是阻塞状态，也就是实现执行take时候，无法向下继续执行，fork是非阻塞的，同样可以使用cancel取消一个fork 任务

```javascript
function* authorize(user, password) {
  try {
    const token = yield call(Api.authorize, user, password)
    yield put({type: 'LOGIN_SUCCESS', token})
  } catch(error) {
    yield put({type: 'LOGIN_ERROR', error})
  }
}

function* loginFlow() {
  while(true) {
    const {user, password} = yield take('LOGIN_REQUEST')
    yield fork(authorize, user, password)
    yield take(['LOGOUT', 'LOGIN_ERROR'])
    yield call(Api.clearItem('token'))
  }
}
```
上面例子中，当执行
```javascript
yield fork(authorize, user, password)
```
的同时，也执行了下面代码，进行logout的监听操作
```javascript
yield take(['LOGOUT', 'LOGIN_ERROR']
```

### takeEvery

循环监听某个触发动作，我们通常会使用while循环替代
```javascript
import { takeEvery } from 'redux-saga/effects'

function* watchFetchData() {
  yield takeEvery('FETCH_REQUESTED', fetchData)
}
```

### takeLatest
对于触发多个action的时候，只执行最后一个，其他的会自动取消

```javascript
import { takeLatest } from 'redux-saga/effects'

function* watchFetchData() {
  yield takeLatest('FETCH_REQUESTED', fetchData)
}
```


## 七、Redux-Saga优点
>* 以用同步的方式写异步代码，可以做一些async 函数做不到的事情 (无阻塞并发、取消请求)
>* 可以通过监听Action 来进行前端的打点日志记录，减少侵入式打点对代码的侵入程度



## 八、带来的问题

>* 异步请求相关的问题较难调试排查





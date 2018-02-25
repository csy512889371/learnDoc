# sagas例子

## 引入sagas

```javascript
import createSagaMiddleware from 'redux-saga'
import rootSaga from './example/saga/sagas'

const sagaMiddleware = createSagaMiddleware()
const store = createStore(
    reducer,
    applyMiddleware(sagaMiddleware)
)
sagaMiddleware.run(rootSaga)
```

总代码：
```javascript
import "babel-polyfill"

import React from 'react'
import ReactDOM from 'react-dom'
import { createStore, applyMiddleware } from 'redux'
import Counter from './example/saga/Counter'
import reducer from './example/saga/reducers'

import createSagaMiddleware from 'redux-saga'
import rootSaga from './example/saga/sagas'

const sagaMiddleware = createSagaMiddleware()
const store = createStore(
    reducer,
    applyMiddleware(sagaMiddleware)
)
sagaMiddleware.run(rootSaga)

const action = type => store.dispatch({type})

function render() {
    ReactDOM.render(
        <Counter
            value={store.getState()}
            onIncrement={() => action('INCREMENT')}
            onDecrement={() => action('DECREMENT')}
            onIncrementAsync={() => action('INCREMENT_ASYNC')}/>,
        document.getElementById('root')
    )
}

render()
store.subscribe(render)


```


## 中间件代码
```javascript
import {delay} from 'redux-saga'
import {call, put, takeEvery, takeLatest} from 'redux-saga/effects'

export function* helloSaga() {
    yield console.log('Hello Saga!')
    yield call(delay, 1000)
    yield console.log('Hello Saga 1000!');
    yield put({type: 'INCREMENT'})
}


export function* incrementAsync() {
    yield call(delay, 1000)
    yield put({type: 'INCREMENT'})
}

export function* watchIncrementAsync() {
    //在任何时刻 takeLatest 只允许执行一个 fetchData 任务。并且这个任务是最后被启动的那个
    //yield takeLatest('INCREMENT_ASYNC', incrementAsync)

    //takeEvery 允许多个 fetchData 实例同时启动。在某个特定时刻，我们可以启动一个新的 fetchData 任务， 尽管之前还有一个或多个 fetchData 尚未结束
    yield takeEvery('INCREMENT_ASYNC', incrementAsync)
}

export function* dolog(action) {
    console.log('action', action)

}


export function* log() {
    yield takeEvery('*', dolog)
}

// single entry point to start all Sagas at once
export default function* rootSaga() {
    yield [helloSaga(),
        watchIncrementAsync(),
        log()
    ]
}

```

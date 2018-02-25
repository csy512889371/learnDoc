# Async/Await

> Async/Await是尚未正式公布的ES7标准新特性。简而言之，就是让你以同步方法的思维编写异步代码。对于前端，异步任务代码的编写经历了 callback 到现在流行的 Promise ，最终会进化为 Async/Await 。虽然这个特性尚未正式发布，但是利用babel polyfill我们已经可以在应用中使用它了。

## 简单的React/Redux例子。

传统方法是利用 Promise 结合 Redux-thunk 中间件实现:
```javascript
import axios from 'axios'

export default function createPost (params) {  
    const success = (result) => {
        dispatch({
            type: 'CREATE_POST_SUCCESS',
            payload: result
        })
        return result
    }

    const fail = (err) => {
        dispatch({
            type: 'CREATE_POST_FAIL',
            err
        })
        return err
    }

    return dispatch => {
        return axios.post('http://xxxxx', params)
        .then(success)
        .catch(fail)
    }
}

```

**async/await 的实现:**

```javascript

import axios from 'axios'

export default function createPost (params) {  
    const success = (result) => {
        dispatch({
            type: 'CREATE_POST_SUCCESS',
            payload: result
        })
        return result
    }

    const fail = (err) => {
        dispatch({
            type: 'CREATE_POST_FAIL',
            err
        })
        return err
    }

    return async dispatch => {
        try {
            const result = await axios.post('http://xxxxx', params)
            return success(result)
        } catch (err) {
            return fail(err)
        }
    }
}
```
async和await是成对使用的，特点是使代码看起来和同步代码类似。

## Components 组件


```javascript
import React, { Component } from 'react'  
import { connect } from 'react-redux'  
import { createPost } from '../actions/post'

class PostEditForm extends Component {  
    constructor(props) {
        super(props)
    }

    contributePost = e => {
        e.preventDefault()

        // .... get form values as params

        this.props.createPost(params)
        .then(response => {
            // show success message
        })
        .catch(err => {
            // show error tips
        })
    }

    render () {
        return (
            <form onSubmit={this.contributePost}>
                <input name="title"/>
                <textarea name="content"/>
                <button>Create</button>
            </form>
        )
    }
}

export default connect(null, dispatch => {  
    return {
        createPost: params => dispatch(createPost(params))
    }
})(PostEditForm)

```
**使用 Async/Await**

```javascript
import React, { Component } from 'react'  
import { connect } from 'react-redux'  
import { createPost } from '../actions/post'

class PostEditForm extends Component {  
    constructor(props) {
        super(props)
    }

    async contributePost = e => {
        e.preventDefault()

        // .... get form values as params

        try {
            const result = await this.props.createPost(params)
            // show success message
        } catch (err) {
            // show error tips
        }
    }

    render () {
        return (
            <form onSubmit={this.contributePost}>
                <input name="title"/>
                <textarea name="content"/>
                <button>Create</button>
            </form>
        )
    }
}

export default connect(null, dispatch => {  
    return {
        createPost: params => dispatch(createPost(params))
    }
})(PostEditForm)
```

可以见得，两种模式， **Async\Await** 的更加直观和简洁，是未来的趋势。但是目前，还需要利用babel的 
**transform-async-to-module-method** 插件来转换其成为浏览器支持的语法，虽然没有性能的提升，但对于代码编写体验要更好。
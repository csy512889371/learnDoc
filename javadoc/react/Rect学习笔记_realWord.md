## 一、normalizr 扁平化数据

保持状态扁平化 
API 经常会返回嵌套资源。这在 Flux 或基于 Redux 的架构中处理起来会非常困难。我们推荐使用 normalizr 之类的库将数据进行扁平化处理，保持状态尽可能地扁平化。


### 例子:

典型的API调用返回数据：

>* 文章信息
>* 文字信息中包含 作者信息、评论。 article: users and comments

```javascript
{
  "id": "123",
  "author": {
    "id": "1",
    "name": "Paul"
  },
  "title": "My awesome blog post",
  "comments": [
    {
      "id": "324",
      "commenter": {
        "id": "2",
        "name": "Nicole"
      }
    }
  ]
}

```

如何将其扁平化数据：

```javascript
import { normalize, schema } from 'normalizr';
 
// Define a users schema
const user = new schema.Entity('users');
 
// Define your comments schema
const comment = new schema.Entity('comments', {
  commenter: user
});
 
// Define your article 
const article = new schema.Entity('articles', { 
  author: user,
  comments: [ comment ]
});
 
const normalizedData = normalize(originalData, article);
```
扁平化后的数据如：
```javascript
{
  result: "123",
  entities: {
    "articles": { 
      "123": { 
        id: "123",
        author: "1",
        title: "My awesome blog post",
        comments: [ "324" ]
      }
    },
    "users": {
      "1": { "id": "1", "name": "Paul" },
      "2": { "id": "2", "name": "Nicole" }
    },
    "comments": {
      "324": { id: "324", "commenter": "2" }
    }
  }
}
```

### real-word 中的schema定义如下：

调用API 返回的数据有：用户信息，用户数组、仓库信息、仓库数组
```javascript

const userSchema = new schema.Entity('users', {}, {
  idAttribute: user => user.login.toLowerCase()
})

const repoSchema = new schema.Entity('repos', {
  owner: userSchema
}, {
  idAttribute: repo => repo.fullName.toLowerCase()
})


export const Schemas = {
  USER: userSchema,
  USER_ARRAY: [userSchema],
  REPO: repoSchema,
  REPO_ARRAY: [repoSchema]
}
```

## 二、humps 

转换成驼峰命名

### 使用例子：
```javascript
humps.camelize('hello_world') // 'helloWorld'
humps.decamelize('fooBar') // 'foo_bar'
humps.decamelize('fooBarBaz', { separator: '-' }) // 'foo-bar-baz'
```

转换对象
```javascript
var object = { attr_one: 'foo', attr_two: 'bar' }
humps.camelizeKeys(object); // { attrOne: 'foo', attrTwo: 'bar' }
```
转换数组
```javascript
var array = [{ attr_one: 'foo' }, { attr_one: 'bar' }]
humps.camelizeKeys(array); // [{ attrOne: 'foo' }, { attrOne: 'bar' }]
```

接受回调
```javascript
humps.camelizeKeys(obj, function (key, convert) {
  return /^[A-Z0-9_]+$/.test(key) ? key : convert(key);
});
humps.decamelizeKeys(obj, function (key, convert, options) {
  return /^[A-Z0-9_]+$/.test(key) ? key : convert(key, options);
});
```
反转
```javascript
humps.decamelizeKeys(obj, {
    separator: '-',
    process: function (key, convert, options) {
      return /^[A-Z0-9_]+$/.test(key) ? key : convert(key, options);
    }
});
```

### API：

humps.camelize(string)
```javascript
humps.camelize('hello_world-foo bar') // 'helloWorldFooBar'
```

humps.pascalize(string)
```javascript
humps.pascalize('hello_world-foo bar') // 'HelloWorldFooBar' 
```

humps.decamelize(string, options)
```javascript
humps.decamelize('helloWorldFooBar') // 'hello_world_foo_bar' 


humps.decamelize('helloWorldFooBar', { separator: '-' }) // 'hello-world-foo-bar' 


humps.decamelize('helloWorld1', { split: /(?=[A-Z0-9])/ }) // 'hello_world_1' 
```

## 三、realword action 和 state 变化
![image](https://github.com/csy512889371/reactLearn/blob/master/img/realWord1.png)

点击查询后 action 的调用顺序
> @@INIT 初始化状态

```javascript
entities:
	users:{} 0 keys
	repos:{} 0 keys
pagination:{} 2 keys
	starredByUser:{} 0 keys
	stargazersByRepo:{} 0 keys
errorMessage:null
```

------

> USER_REQUEST 请求github 用户信息

```javascript
▶state:{} 3 keys
	▶entities:{} 2 keys
		users:{} 0 keys
		repos:{} 0 keys
	▶pagination:{} 2 keys
		starredByUser:{} 0 keys
		stargazersByRepo:{} 0 keys
	errorMessage:null
```
-------

> STARRED_REQUEST 请求github 用户标星信息
```javascript
▶action:{} 1 key
login:"csy512889371"

▶state:{} 3 keys
	▶entities:{} 2 keys
		users:{} 0 keys
		repos:{} 0 keys
	▶pagination:{} 2 keys
		▶starredByUser:{} 1 key
		▶csy512889371:{} 4 keys
			isFetching:true
			nextPageUrl:undefined
			pageCount:0
			ids:[] 0 items
			stargazersByRepo:{} 0 keys
	errorMessage:null
```
------

> STARRED_SUCCESS 标星 信息返回成功

```javascript
▶action:{} 2 keys
	login:"csy512889371"
	▶response:{} 3 keys
		▶entities:{} 2 keys
			▶users:{} 12 keys
			▶repos:{} 13 keys
		▶result:[] 13 items
			nextPageUrl:null
```


```javascript

▶state:{} 3 keys
	▶entities:{} 2 keys
		▶users:{} 12 keys
		▶repos:{} 13 keys
	▶pagination:{} 2 keys
		▶starredByUser:{} 1 key
			▶csy512889371:{} 4 keys
				isFetching:false
				nextPageUrl:null
				pageCount:1
				▶ids:[] 13 items
		stargazersByRepo:{} 0 keys
	errorMessage:null
	
```

-----

> USER_SUCCESS 用户信息返回成功

```javascript
USER_SUCCESS
	▶action:{} 1 key
		▶response:{} 3 keys
			▶entities:{} 1 key
				▶users:{} 1 key
				`▶csy512889371:{} 30 keys
		result:"csy512889371"
		nextPageUrl:null
		
		
▶state:{} 3 keys
	▶entities:{} 2 keys
		▶users:{} 13 keys
		▶repos:{} 13 keys
	▶pagination:{} 2 keys
		▶starredByUser:{} 1 key
			▶csy512889371:{} 4 keys
			stargazersByRepo:{} 0 keys
	errorMessage:null
		
```

### API 代码解读

API 作为中间键使用

```javascript
const configureStore = preloadedState => createStore(
  rootReducer,
  preloadedState,
  applyMiddleware(thunk, api)
)

```

action :

```javascript
Call API
	endpoint
		"users/csy512889371"
	schema
		EntitySchema {_key: "users", _getId: ƒ, _idAttribute: ƒ, _mergeStrategy: ƒ, _processStrategy: ƒ, …}
	types
		["USER_REQUEST", "USER_SUCCESS", "USER_FAILURE"]
```

```javascript
export default store => next => action => {
  
  //判断是否是 调用API 请求
  const callAPI = action[CALL_API]
  if (typeof callAPI === 'undefined') {
    return next(action)
  }

  //获取 请求参数
  let { endpoint } = callAPI
  //schema 对请求返回数据做扁平化
  //types :对应3个action。请求前、调用api失败：调用API成功
  const { schema, types } = callAPI

  //下面是对 endpoint 、shema 、types 参数做校验
  if (typeof endpoint === 'function') {
    endpoint = endpoint(store.getState())
  }

  if (typeof endpoint !== 'string') {
    throw new Error('Specify a string endpoint URL.')
  }
  if (!schema) {
    throw new Error('Specify one of the exported Schemas.')
  }
  if (!Array.isArray(types) || types.length !== 3) {
    throw new Error('Expected an array of three action types.')
  }
  if (!types.every(type => typeof type === 'string')) {
    throw new Error('Expected action types to be strings.')
  }

  //提取 types 中的3个action。 不同阶段调用不同action
  const actionWith = data => {
    const finalAction = Object.assign({}, action, data)
    delete finalAction[CALL_API]
    return finalAction
  }

  const [ requestType, successType, failureType ] = types
  
  //调用请求前的action
  next(actionWith({ type: requestType }))

  //调用 callAPI 并设置回调，成功 、 失败
  return callApi(endpoint, schema).then(
    response => next(actionWith({
      response,
      type: successType
    })),
    error => next(actionWith({
      type: failureType,
      error: error.message || 'Something bad happened'
    }))
  )
}

```

callApi 方法：
```javascript

const callApi = (endpoint, schema) => {
	//获取url
    const fullUrl = (endpoint.indexOf(API_ROOT) === -1) ? API_ROOT + endpoint : endpoint

	//调用 post请求
    return fetch(fullUrl)
        .then(response =>
            response.json().then(json => {
				//失败
                if (!response.ok) {
                    return Promise.reject(json)
                }

                const camelizedJson = camelizeKeys(json)
                const nextPageUrl = getNextPageUrl(response)
				//成功
                return Object.assign({},
                    normalize(camelizedJson, schema),
                    { nextPageUrl }
                )
            })
        )
}
```










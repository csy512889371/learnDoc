# 异步加载数据 async

## 一、页面

![image](https://github.com/csy512889371/reactLearn/blob/master/img/sync.png)

## 二、state数据结构

state.selectedReddit
```javascript
{selectedReddit: "reactjs"}

```
请求获取数据
state.postsByReddit

```javascript
reactjs: {isFetching: false, didInvalidate: false, items: Array(26), lastUpdated: 1510757456429}
```

mapStateToProps:
```javascript
{selectedReddit: "reactjs", posts: Array(25), isFetching: false, lastUpdated: 1510757066974, dispatch: ƒ}

{selectedReddit: "frontend", posts: Array(0), isFetching: true, lastUpdated: undefined, dispatch: ƒ}
```
>* posts 代表数据
>* isFetching 是否在请求加载数据中
>* lastUpdated 最后一次加载时间
>* didInvalidate 


## 三、设置初始值

state.selectedReddit : reactjs
```javascript
const selectedReddit = (state = 'reactjs', action) => {

  switch (action.type) {
    case SELECT_REDDIT:
      return action.reddit
    default:
      return state
  }
}
```

## 四、页面构造

>* Picker select 选择加载的内容
>* Posts 展示请求返回数据
```javascript

class App extends Component {

  render() {
    const { selectedReddit, posts, isFetching, lastUpdated } = this.props
    const isEmpty = posts.length === 0
    return (
      <div>
        <Picker value={selectedReddit}
                onChange={this.handleChange}
                options={[ 'reactjs', 'frontend' ]} />
        
        <div style={{ opacity: isFetching ? 0.5 : 1 }}>
              <Posts posts={posts} />
        </div>
      </div>
    )
  }
}


```

## 四、渲染完成后开始获取数据

在 componentDidMount 中请求加载数据
```javascript
  componentDidMount() {
    const { dispatch, selectedReddit } = this.props
    dispatch(fetchPostsIfNeeded(selectedReddit))
  }
```

>* 获取数据前 先显示加载中
>* 获取数据结束后，显示数据
```javascript
export const fetchPostsIfNeeded = reddit => (dispatch, getState) => {
    if (shouldFetchPosts(getState(), reddit)) {
        return dispatch(fetchPosts(reddit))
    }
}


const fetchPosts = reddit => dispatch => {
    dispatch(requestPosts(reddit))
    return fetch(`https://www.reddit.com/r/${reddit}.json`)
        .then(response => {
            return response.json()
        })
        .then(json => {
            console.log(json);
            return dispatch(receivePosts(reddit, json))
        })
}
```

## 五、下拉菜单
```javascript
const Picker = ({ value, onChange, options }) => (
    <span>
    <h1>{value}</h1>
    <select onChange={e => onChange(e.target.value)}
            value={value}>
      {options.map(option =>
          <option value={option} key={option}>
              {option}
          </option>)
      }
    </select>
  </span>
)


export default Picker
```
## 六、下拉菜单改变后重新加载数据。

```javascript
    handleChange = nextReddit => {
        this.props.dispatch(selectReddit(nextReddit))
    }

```

action
```javascript
export const selectReddit = reddit => ({
    type: SELECT_REDDIT,
    reddit
})
```

reducer
```javascript
const selectedReddit = (state = 'reactjs', action) => {
    switch (action.type) {
        case SELECT_REDDIT:
            return action.reddit
        default:
            return state
    }
}
```

重新渲染组件,渲染完成后请求数据，加载数据
```javascript
  componentDidMount() {
    const { dispatch, selectedReddit } = this.props
    dispatch(fetchPostsIfNeeded(selectedReddit))
  }
```


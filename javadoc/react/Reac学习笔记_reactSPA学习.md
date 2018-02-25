# 后台管理系统学习笔记

## SearchBar 组件：

>* 查询字段： fields={this.searchFields()}
>* 点击查询： onSubmit={this.onSearch}


## Table 组件：

>* 操作事件 onCtrlClick={ this.tableAction }
>* 是否分页 pagination={ true }
>* 每页显示  pageSize={10}
>* 表头 header={ this.tableHeader() }
>* 数据  data={ songArray }
>* 加载中 loading={ musicList.loading }
>* 滚动 scroll={{y: 385 }}
>* 操作 
```javascript
action={row => [{
	key: 'edit',
	name: '修改',
	color: 'blue',
	icon: 'edit',
}, {
	key: 'delete',
	name: '删除',
	color: 'red',
	icon: 'delete'
}]}
```

## FormModal 弹窗组件：

>* modalKey="Edit"
>* 是否可见 visible={this.state.modalShowEdit}
>* 标题 title="修改音乐"
>* 编辑页面字段 fields={this.fieldsEdit()}
>* 保存事件: onOk={this.onOkEdit}
>* 取消事件：onCancel={this.onCancelEdit}
>* 按钮名称：okText="保存"


# 请求ajax加载数据

## 页面发起请求：
```javascript
import { fetchMusicList } from 'actions/music'

    componentDidMount() {
        fetchMusicList({  // 默认是热歌版
            method: 'baidu.ting.billboard.billList',
            size: 100,
            type: 2,
        })(this.props.dispatch)
    }

```

## music Action
>* 设置 ajaxAPI 调用：
>* 设置发送请求前的 action
>* 设置请求成功后的Ation

```javascript

import { createAction } from 'redux-actions'
import { music } from 'api'
import { createAjaxAction } from 'utils'

export const requestMusicList = createAction('request music list')
export const receiveMusicList = createAction('receive music list')
export const fetchMusicList = createAjaxAction(music.musicList, requestMusicList, receiveMusicList)
```

## utils

>* 设置API、发送请求前的 action、请求成功后的Atio
>* 请求数据、dispatch


```javascript
import * as ajaxFun from './ajax'

export const ajax = ajaxFun

export const createAjaxAction = (api, startAction, endAction) => (data, cb) =>
    (dispatch) => {
        let respon
        dispatch(startAction(data))
        return new Promise((resolve, reject) => {
            api(data)
                .then(checkStatus)
                .then(response => response.json())
                .then(response => {
                    respon = response
                    dispatch(endAction({ req: data, res: response }))
                })
                .then(() => {
                    if (respon.status === 1) {
                        cb && cb(respon)
                    }
                })
                .catch(catchError)
        })
    }

function catchError(error) {
    console.log(error)
}

function checkStatus(response) {
    if ((response.status >= 100 && response.status < 300) || response.status === 500 || response.json) {
        return response
    }
    const error = new Error(response.statusText)
    error.response = response
    throw error
}
```
## ajax.js 请求

```javascript
import fetchJsonp from 'fetch-jsonp'

export function fetchJSON(url, params) {
    params = {
        ...params,
    }
    return fetchJsonp(url, params)
}

export const fetchJSONByGet = url => query => {
    const params = {
        method: 'GET',
    }
    let getQuery = '?'
    let getUrl = ''
    if (query) {
        for(let name in query) {
            getQuery = `${getQuery}${name}=${query[name]}&`
        }
    }
    getUrl = url + (query ? getQuery.substring(0, getQuery.length - 1) : '')
    return fetchJSON(getUrl, params)
}
```





# 基于React的登录

## 第一种登录

>* Login页面提交登录 handleSubmit(), 中直接调用API请求。请求登录成功后跳转 history.push(nextPathname, null);
>* 实现方式参照 http://blog.csdn.net/qq_27384769/article/details/78775835

## 第二种登录

>* Login页面提交登录 handleSubmit() 后，通过saga发起异步请求。
>* 请求成功后 发起action 调用reducer. 重新加载Login页面。
>* 在Login页面生命周期componentWillReceiveProps 验证登录信息请求跳转。

以下是第二种登录方式的讲解

## reducer 中的数据结构

```javascript
auth:{
	type: "COMPLOGIN/RECEIVE_DATA", 
	isFetching: false, 
	data: {uid: 1, permissions: Array(5), role: "系统管理员", roleType: 1, userName: "系统管理员"}
}
```

# 代码

## login.jsx

>* componentWillReceiveProps 登录成功后 调整
>* handleSubmit 处理提交登录


```javascript

import React from 'react';
import {Form, Icon, Input, Button, Checkbox} from 'antd';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import {findData, receiveData} from '../actions';
import {selectVisibleMenuResourceTreeTable} from '../selector';

const FormItem = Form.Item;

class Login extends React.Component {
    componentWillMount() {
        const {receiveData} = this.props;
        receiveData(null, 'auth');
    }

    componentWillReceiveProps(nextProps) {
        const {auth: nextAuth = {}} = nextProps;
        if (nextAuth.data && nextAuth.data.uid) {   // 判断是否登陆
            localStorage.setItem('user', JSON.stringify(nextAuth.data));
            this.props.history.push('/', null);
        }
    }

    handleSubmit = (e) => {
        e.preventDefault();
        this.props.form.validateFields((err, values) => {
            if (!err) {
                console.log('Received values of form: ', values);
                const {findData} = this.props;
                if (values.userName === 'admin' && values.password === 'admin') findData({
                    funcName: 'admin',
                    stateName: 'auth'
                });
                if (values.userName === 'guest' && values.password === 'guest') findData({
                    funcName: 'guest',
                    stateName: 'auth'
                });
            }
        });
    };
    gitHub = () => {
        console.log("gitHub");
    };

    render() {
        const {getFieldDecorator} = this.props.form;
        return (
            <div className="login">
                <div className="login-form">
                    <div className="login-logo">
                        <span>React Admin</span>
                    </div>
                    <Form onSubmit={this.handleSubmit} style={{maxWidth: '300px'}}>
                        <FormItem>
                            {getFieldDecorator('userName', {
                                rules: [{required: true, message: '请输入用户名!'}],
                            })(
                                <Input prefix={<Icon type="user" style={{fontSize: 13}}/>}
                                       placeholder="管理员输入admin, 游客输入guest"/>
                            )}
                        </FormItem>
                        <FormItem>
                            {getFieldDecorator('password', {
                                rules: [{required: true, message: '请输入密码!'}],
                            })(
                                <Input prefix={<Icon type="lock" style={{fontSize: 13}}/>} type="password"
                                       placeholder="管理员输入admin, 游客输入guest"/>
                            )}
                        </FormItem>
                        <FormItem>
                            {getFieldDecorator('remember', {
                                valuePropName: 'checked',
                                initialValue: true,
                            })(
                                <Checkbox>记住我</Checkbox>
                            )}
                            <a className="login-form-forgot" href="" style={{float: 'right'}}>忘记密码</a>
                            <Button type="primary" htmlType="submit" className="login-form-button"
                                    style={{width: '100%'}}>
                                登录
                            </Button>
                            或 <a href="">现在就去注册!</a>
                            <p>
                                <Icon type="github" onClick={this.gitHub}/>(第三方登录)
                            </p>
                        </FormItem>
                    </Form>
                </div>
            </div>
        );
    }
}

const mapStateToPorps = state => {
    return {
        auth: selectVisibleMenuResourceTreeTable(state)
    }
};
const mapDispatchToProps = dispatch => ({
    findData: bindActionCreators(findData, dispatch),
    receiveData: bindActionCreators(receiveData, dispatch)
});

export default Form.create()(connect(mapStateToPorps, mapDispatchToProps)(Login));

```

## actions

>* findData 点击按钮发起请求
>* requestData 调用API前
>* requestData 调用API 获取到数据

```javascript
import * as type from './actionTypes';

export const findData = (data) => {
    let {funcName, stateName} = data;
    return {
        type: type.COMP_LOGIN_FIND_DATA,
        funcName,
        stateName
    }
}

export const requestData = category => ({
    type: type.COMP_LOGIN_REQUEST_DATA,
    category
});

export const receiveData = (data, category) => ({
    type: type.COMP_LOGIN_RECEIVE_DATA,
    data,
    category
});

```

## actionTypes

```javascript
export const COMP_LOGIN_FIND_DATA = 'COMPLOGIN/FIND_DATA';

export const COMP_LOGIN_REQUEST_DATA = 'COMPLOGIN/REQUEST_DATA';

export const COMP_LOGIN_RECEIVE_DATA = 'COMPLOGIN/RECEIVE_DATA';

```

## index

```javascript
import React from 'react';
import Bundle from '../../../bundle/views/bundle';
import * as actions from './actions';

const view = (props) => {
    return (
        <Bundle load={() => import("./lazy")}>
            {(View) => {
                return <View {...props}/>
            }}
        </Bundle>
    );
};

export {actions, view};

```

## lazy 异步加载

>* 根据组件加载对应的 sagas\reducer\view
>* reducer 中的数据结构：[compLoginName]: compLoginReducer

```javascript
import compLoginSagas from './sagas';
import compLoginReducer from './reducer';
import view from './views/Login';
import {UumsCompsReducerNames} from '../../constants';

const compLoginName = UumsCompsReducerNames.compLogin;

const reducer = {
    [compLoginName]: compLoginReducer
};

const sagas = {
    [compLoginName]: compLoginSagas
};

export {sagas, reducer, view};

```

## reducer

>* 纯函数

```javascript
export default (state = {}, action) => {
    const {type} = action;
    switch (type) {
        case types.COMP_LOGIN_REQUEST_DATA: {
            return {
                ...state, type: type, isFetching: true
            }
        }
        case types.COMP_LOGIN_RECEIVE_DATA:
            return {...state, type: type,isFetching: false, data: action.data};
        default:
            return {...state};
    }
}


```

## sagas 

> 异步调用
```javascript
import * as http from '../axios/index';
import {call, put, takeLatest} from 'redux-saga/effects';
import {requestData, receiveData} from './actions';
import {COMP_LOGIN_FIND_DATA} from './actionTypes';

export const fetchData = ({funcName, params}) => {
    return http[funcName](params).then(res => {
        return res;
    });
};

function* fetchLoginInfo(data) {
    try {
        let {stateName} = data;
        yield put(requestData());
        const result = yield call(fetchData, data);
        yield put(receiveData(result, stateName));
    } catch (e) {
        console.log(e);
    }
}

function* sagas() {
    yield takeLatest(COMP_LOGIN_FIND_DATA, fetchLoginInfo);
}

export default sagas;
```

## selector
记忆组件 selector
```javascript
import {createSelector} from 'reselect';

const getCompLoginData = (state) => state.compLoginData;

export const selectVisibleMenuResourceTreeTable = createSelector(
    [getCompLoginData],
    (compLoginData) => compLoginData
);

```




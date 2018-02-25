# 基于Cookie的登录认证

对于初学者来说如何实现react的登录，其实是一件非常好脑的事情。如果知道了怎么实现的话却非常简单。

如果以下对你有帮助，记得点赞哦。

## 一、加载组件时候判断用户是否已经登录

```javascript

class Home extends Component{
    componentWillMount(){
        if (!user.isLogin()) {
            this.props.history.push('/login', null);
        }
    }

    render(){
        if (user.isLogin()) {
            return (
                <Row style={{textAlign: 'center'}}>
                    <Col span={5}> 首页 </Col>
                    <Col span={14}>
                    </Col>
                </Row>
            );
        } else {
            return <div>需要登录</div>;
        }
    }
}

```
>* user.isLogin() 查询cookie中的用户信息是否存在
>* this.props.history.push('/login', null); 用户未登录跳转到登录页面

## 二、userApi

>* 包含读取cookie
>* 调用API请求服务器

```javascript

const loginUser = () => {
    return cookie.load('current-user');
};

const isLogin = () => {
    const user = loginUser();
    return typeof (user) === 'object';
};

const logout = (history, pathname) => {
    UnitConfig.logout(appSn, () => {
        history ?
            history.push('/login?returnPath=' + pathname, {nextPathname: pathname}) :
            window.location.href = '/login?returnPath=' + pathname;
    });
};

const goToLogin = (history, pathname) => {
    UnitConfig.logout(appSn, () => {
        history.push('/login?returnPath=' + pathname, {nextPathname: pathname});
    });
};

export {loginUser, isLogin, logout, goToLogin};
```

## 三、用户登录页面

login.js 中的提交登录信息
```javascript
    handleSubmit = (e) => {
        e.preventDefault();
        this.setState({showMessage: 'none', message: '', messageType: ''});
        const { location, history } = this.props;
        let nextPathname = '';
        let returnPath = Params.getQueryString('returnPath');
        if (location.state && location.state.nextPathname) {
            nextPathname = location.state.nextPathname;
        } else if (returnPath) {
            nextPathname += returnPath;
        }
        this.props.form.validateFields((err, values) => {
            if (!err) {
                this.setState({loading: true});
                UnitConfig.login(
                    {username: values.userName, password: values.password, remember: values.remember, appSn: appSn},
                    history, nextPathname, values.remember, (loginMessage) => {
                        if(loginMessage && loginMessage.err){
                            this.setState({showMessage: 'block', message: loginMessage.err, messageType: 'error', loading: false});
                        }
                    }
                );
            }
        });
    };
```

## UnitConfig 统一配置调用API

> 调用API的关键代码

```javascript

const baseQuestByPost = (basepath, data, callback) => {
    request.post(httpServer + basepath)
        .set('Content-Type', 'application/json')
        .send(data)
        .set('Accept', 'application/json')
        .end((err, res) => {
            callback && callback(err, res);
        });
};

const login = (data, history, nextPathname, remember, callback) => {
    baseQuestByPost('/user/login.do', data, (err, res) => {

        let loginMessage;

        if (err && err.status === '404') {
            loginMessage = {err: '发生404错误：' + res.body.message};
            callback && callback(loginMessage);
        } else if (res) {
            if (res.ok) {
                const result = JSON.parse(res.text);
                if (result.success) {
                    const data = result.data;
                    cookie.save('current-user', data);
                    const loginMessage = {name: 'login', value: result, remember: remember};
                    callback && callback(loginMessage);
                    history.push(nextPathname, null);
                } else {
                    const errMessage = result.errMessage;
                    loginMessage = {err: errMessage};
                    callback && callback(loginMessage);
                }
            } else {
                loginMessage = {err: '请求统一用户服务器失败！'};
                callback && callback(loginMessage);
            }
        } else {
            loginMessage = {err: '请求统一用户服务器失败！'};
            callback && callback(loginMessage);
        }
    });
}

const logout = (appSn, callback) => {
    const user = cookie.load('current-user');
    cookie.remove('current-user');
    baseQuestByPost('/user/logout.do', user ? {...user, appSn} : {appSn});
    callback && callback();
}
```

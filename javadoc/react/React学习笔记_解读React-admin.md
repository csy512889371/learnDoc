# registerServiceWorker

> service worker是在后台运行的一个线程，可以用来处理离线缓存、消息推送、后台自动更新等任务。registerServiceWorker就是为react项目注册了一个service worker，用来做资源的缓存，这样你下次访问时，就可以更快的获取资源。而且因为资源被缓存，所以即使在离线的情况下也可以访问应用（此时使用的资源是之前缓存的资源）。注意，registerServiceWorker注册的service worker 只在生产环境中生效（process.env.NODE_ENV === 'production'）

## React 与 AJAX

1.使用jQuery的Ajax方法，在一个组件的componentDidMount()中发ajax请求，拿到的数据存在组件自己的state中，并调用setState方法去更新UI。如果是异步获取数据，则在componentWillUnmount中取消发送请求。
> fetch()、fetch polyfill、axios

2. 使用Redux或Relay的情况

Redux管理状态和数据，Ajax从服务器端获取数据，所以很显然当我们使用了Redux时，应该把所有的网络请求都交给redux来解决。具体来说，应该是放在Async Actions。如果用其他类Flux库的话，解决方式都差不多，都是在actions中发送网络请求。

## 登录
点击登录时候触发提交
```javascript
    handleSubmit = (e) => {
        e.preventDefault();
        this.props.form.validateFields((err, values) => {
            if (!err) {
                console.log('Received values of form: ', values);
                const { fetchData } = this.props;
                if (values.userName === 'admin' && values.password === 'admin') fetchData({funcName: 'admin', stateName: 'auth'});
                if (values.userName === 'guest' && values.password === 'guest') fetchData({funcName: 'guest', stateName: 'auth'});
            }
        });
    };
```

>* dispatch(requestData)
>* action 中调用API
>* dispatch(receiveData)
```javascript
export const fetchData = ({funcName, params, stateName}) => dispatch => {
    !stateName && (stateName = funcName);
    dispatch(requestData(stateName));
    return http[funcName](params).then(res => dispatch(receiveData(res, stateName)));
};
```

ajax调用
```javascript
//config.js:
const EASY_MOCK = 'https://www.easy-mock.com/mock';
const MOCK_AUTH = EASY_MOCK + '/597b5ed9a1d30433d8411456/auth';         // 权限接口地址
export const MOCK_AUTH_ADMIN = MOCK_AUTH + '/admin';                           // 管理员权限接口
export const MOCK_AUTH_VISITOR = MOCK_AUTH + '/visitor';                       // 访问权限接口

//Utils.js:
// easy-mock数据交互
// 管理员权限获取
export const admin = () => get({url: config.MOCK_AUTH_ADMIN});

// 访问权限获取
export const guest = () => get({url: config.MOCK_AUTH_VISITOR});
```

reducer处理action
```javascript
const handleData = (state = {isFetching: true, data: {}}, action) => {
    switch (action.type) {
        case type.REQUEST_DATA:
            return {...state, isFetching: true};
        case type.RECEIVE_DATA:
            return {...state, isFetching: false, data: action.data};
        default:
            return {...state};
    }
};
```
>* login组件更新状态，重新渲染 调用 componentWillReceiveProps
>* 登录成功跳转到index页面。
```javascript
    componentWillReceiveProps(nextProps) {
        const { auth: nextAuth = {} } = nextProps;
        const { router } = this.props;
        if (nextAuth.data && nextAuth.data.uid) {   // 判断是否登陆
            localStorage.setItem('user', JSON.stringify(nextAuth.data));
            router.push('/');
        }
    }
```

### 请求返回的数据：
```javascript
permissions
	0:"auth"
	1:"auth/testPage"
	2:"auth/authPage"
	3:"auth/authPage/edit"
	4:"auth/authPage/visit"

role:"系统管理员"
roleType:1
uid:1
userName:"系统管理员"

```
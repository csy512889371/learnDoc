# mapStateToProps 调用
数据变化才调用
```javascript
function mapStateToProps(state) {
    console.log("get state funciton....");
    return store.getState();
}

function mapStateToProps(state, props) {
    console.log("get state funciton....");
    return store.getState();
}
```
建议和顶端 绑定 1 个store 绑定多个UI
```javascript
UI = connect(mapStateToProps, mapDispatchToProps)(UI);
```

# 初始化Redux整体状态流转，如图
![image](https://github.com/csy512889371/reactLearn/blob/master/img/initRedux.jpg)

# 进而触发初始化过程中注册的listener回调函数。如图
![image](https://github.com/csy512889371/reactLearn/blob/master/img/doRedux.jpg)

# 思维导图

> * Component like(UI) this.props.onClick  => dispatch(Action) => combineReducers(reducer) => render(component)

![image](https://github.com/csy512889371/reactLearn/blob/master/img/redux1.jpg)

> * Containers connect =>mapDispatchToprops => reducer => mapStateToProps => components
![image](https://github.com/csy512889371/reactLearn/blob/master/img/redux2.jpg)

> * store => action->despatch </br>
> * store => reducer </br>
> * store => subscribe => render =>components </br>

![image](https://github.com/csy512889371/reactLearn/blob/master/img/redux3.jpg)
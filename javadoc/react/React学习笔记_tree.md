# 树

## 一、初始化数据

generateTree.js
```javascript
export default function generateTree() {
    let tree = {
        0: {
            id: 0,
            counter: 0,
            childIds: []
        }
    }

    for (let i = 1; i < 1000; i++) {
        let parentId = Math.floor(Math.pow(Math.random(), 2) * i)
        tree[i] = {
            id: i,
            counter: 0,
            childIds: []
        }
        tree[parentId].childIds.push(i)
    }

    return tree
}
```

## 二、树页面

```javascript
const tree = generateTree()
console.log(tree);
const store = createStore(reducer, tree)
render(
    <Provider store={store}>
        <Node id={0} />
    </Provider>,
    document.getElementById('root')
)

```
Node
```javascript
export class Node extends Component {

    renderChild = childId => {
        const {id} = this.props
        return (
            <li key={childId}>
                <ConnectedNode id={childId} parentId={id}/>
            </li>
        )
    }
	
    render() {
        const {counter, parentId, childIds} = this.props
        return (
            <div>
                Counter: {counter}
                {' '}
                <ul>
                    {childIds.map(this.renderChild)}
                   
                </ul>
            </div>
        )
    }
}

function mapStateToProps(state, ownProps) {
    return state[ownProps.id]
}

const ConnectedNode = connect(mapStateToProps, actions)(Node)
export default ConnectedNode
```

## 三、点击树节点统计

```javascript
                <button onClick={this.handleIncrementClick}>
                    +
                </button>
				
				
				
    handleIncrementClick = () => {
        const { increment, id } = this.props
        increment(id)
    }
```

action
```javascript
export const increment = (nodeId) => ({
    type: INCREMENT,
    nodeId
})
```

reducer

>* 修改nodeId 的 counter

```javascript
const node = (state, action) => {
    switch (action.type) {
        case INCREMENT:
            return {
                ...state,
                counter: state.counter + 1
            }
        default:
            return state
    }
}

export default (state = {}, action) => {
    const {nodeId} = action
    return {
        ...state,
        [nodeId]: node(state[nodeId], action)
    }
}
```

## 四、删除树节点统计

页面
```javascript
	<a href="#"
	   onClick={this.handleRemoveClick}
	   style={{color: 'lightgray', textDecoration: 'none'}}>
		×
	</a>
```
事件
```javascript
    handleRemoveClick = e => {
        e.preventDefault()
        const { removeChild, deleteNode, parentId, id } = this.props
        removeChild(parentId, id)
        deleteNode(id)
    }
```
action
```javascript
export const removeChild = (nodeId, childId) => ({
    type: REMOVE_CHILD,
    nodeId,
    childId
})

export const deleteNode = (nodeId) => ({
    type: DELETE_NODE,
    nodeId
})

```

reducer
```javascript
const node = (state, action) => {
    switch (action.type) {
        case REMOVE_CHILD:
            return {
                ...state,
                childIds: childIds(state.childIds, action)
            }
        default:
            return state
    }
}

if (action.type === DELETE_NODE) {
	const descendantIds = getAllDescendantIds(state, nodeId)
	return deleteMany(state, [nodeId, ...descendantIds])
}

//遍历查找出所有子节点	
const getAllDescendantIds = (state, nodeId) => (
    state[nodeId].childIds.reduce((acc, childId) => (
        [...acc, childId, ...getAllDescendantIds(state, childId)]
    ), [])
)

//根据子节点id删除数据	
const deleteMany = (state, ids) => {
    state = { ...state }
    ids.forEach(id => delete state[id])
    return state
}	
```


## 五、新增子节点

页面
```javascript
<a href="#"
   onClick={this.handleAddChildClick}>
	Add child
</a>

handleAddChildClick = e => {
	e.preventDefault()
	const { addChild, createNode, id } = this.props
	const childId = createNode().nodeId
	addChild(id, childId)
}
```

action
```javascript
//创建子节点
let nextId = 0
export const createNode = () => ({
    type: CREATE_NODE,
    nodeId: `new_${nextId++}`
})

//关联子节点
export const addChild = (nodeId, childId) => ({
    type: ADD_CHILD,
    nodeId,
    childId
})

```

reducer
```javascript
//创建子节点
const node = (state, action) => {
    switch (action.type) {
        case CREATE_NODE:
            return {
                id: action.nodeId,
                counter: 0,
                childIds: []
            }
        default:
            return state
    }
}

//关联子节点
const childIds = (state, action) => {
    switch (action.type) {
        case ADD_CHILD:
            return [...state, action.childId]
        default:
            return state
    }
}

```







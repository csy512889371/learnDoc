# 购物车

## 一、商品列表

### 1.初始化加载商品列表
>* 异步加载 需要引入中间件 thunk
>* store.dispatch(getAllProducts())

```javascript
const middleware = [thunk];

const store = createStore(
    reducer,
    applyMiddleware(...middleware)
)

store.dispatch(getAllProducts())
render(
    <Provider store={store}>
        <App/>
    </Provider>,
    document.getElementById('root')
)

```

>* action 中调用API shop.getProducts 获取数据
>* 获取数据后回调 dispath：receiveProducts

```javascript
export const getAllProducts = () => dispatch => {
    shop.getProducts(products => {
        dispatch(receiveProducts(products))
    })
}

const receiveProducts = products => ({
    type: types.RECEIVE_PRODUCTS,
    products
})
```

API
```javascript
export default {
    getProducts: (cb, timeout) => {
        setTimeout(() => cb(_products), timeout || TIMEOUT)
    },
    buyProducts: (payload, cb, timeout) => setTimeout(() => cb(), timeout || TIMEOUT)
}

```

### 2.商品列表页面
ProductsContainer

```javascript
const App = () => (
    <div>
        <h2>购物车</h2>
        <hr/>
        <ProductsContainer/>
        <hr/>
        <CartContainer />
    </div>
)
```

```javascript
const ProductsContainer = ({products, addToCart}) => (
    <ProductsList title="商品列表">
        {products.map(product =>
            <ProductItem
                key={product.id}
                product={product}
                onAddToCartClicked={() => addToCart(product.id)}/>
        )}
    </ProductsList>
)

const mapStateToProps = state => {
    return {
        products: getVisibleProducts(state.products)
    }
}

export default connect(
    mapStateToProps,
    {addToCart}
)(ProductsContainer)
```


## 二、添加商品到购物车

action
>* 先验证商品是否库存为0。 如果不为0则发送dispatch: addToCartUnsafe

```javascript
export const addToCart = productId => (dispatch, getState) => {
    if (getState().products.byId[productId].inventory > 0) {
        dispatch(addToCartUnsafe(productId))
    }
}

const addToCartUnsafe = productId => ({
    type: types.ADD_TO_CART,
    productId
})
```

>* 商品库存减一

```javascript
const products = (state, action) => {
    switch (action.type) {
        case ADD_TO_CART:
            return {
                ...state,
                inventory: state.inventory - 1
            }
    }
}
```

>* 商品的state数据结构：products.byId   products.visibleIds

products.byId 

```javascript
{
  1: {"id": 1, "title": "iPad 4 Mini", "price": 500.01, "inventory": 2},
  2: {"id": 2, "title": "H&M T-Shirt White", "price": 10.99, "inventory": 10}
}
```

products.visibleIds
```javascript
[1,2]
```

>* 购物车添加商品

```javascript
const addedIds = (state = initialState.addedIds, action) => {
  switch (action.type) {
    case ADD_TO_CART:
      if (state.indexOf(action.productId) !== -1) {
        return state
      }
      return [ ...state, action.productId ]
    default:
      return state
  }
}

const quantityById = (state = initialState.quantityById, action) => {
  switch (action.type) {
    case ADD_TO_CART:
      const { productId } = action
      return { ...state,
        [productId]: (state[productId] || 0) + 1
      }
    default:
      return state
  }
}
```


>* 购物车 state数据结构

cart.addedIds
```javascript
[1,2]
```
cart.quantityById
```javascript
//ID:quantity 购物车中商品数量
{
	1: 1
}
```

## 三、购物车页面

显示购物车中商品列表。和“check”购买按钮
```javascript
const CartContainer = ({ products, total ,checkout}) => (
    <Cart
        products={products}
        total={total}
        onCheckoutClicked={() => checkout(products)} />
)

const mapStateToProps = (state) => ({
  products: getCartProducts(state),
  total: getTotal(state)
})

export default connect(
  mapStateToProps,
    { checkout }
)(CartContainer)

```

```javascript
const Cart = ({products, total, onCheckoutClicked}) => {
    const hasProducts = products.length > 0
    const nodes = hasProducts ? (
        products.map(product =>
            <Product
                title={product.title}
                price={product.price}
                quantity={product.quantity}
                key={product.id}
            />
        )
    ) : (
        <em>Please add some products to cart.</em>
    )

    return (
        <div>
            <h3>Your Cart</h3>
            <div>{nodes}</div>
            <p>Total: &#36;{total}</p>
            <button onClick={onCheckoutClicked}
                    disabled={hasProducts ? '' : 'disabled'}>
                Checkout
            </button>
        </div>
    )
}


export default Cart

```
## 四、购买

>* 用户点击购买按钮：dispatch(action): check
>* 先清空购物车 发送dispath:CHECKOUT_REQUEST
>* 异步调用API 购买商品。回调函数：如果购买成功则dispatch:CHECKOUT_SUCCESS. 如果失败：types.CHECKOUT_FAILURE 恢复购物车中数据

```javascript
export const checkout = products => (dispatch, getState) => {
    const { cart } = getState()

    dispatch({
        type: types.CHECKOUT_REQUEST
    })
    shop.buyProducts(products, () => {
        dispatch({
            type: types.CHECKOUT_SUCCESS,
            cart
        })
        // Replace the line above with line below to rollback on failure:
        // dispatch({ type: types.CHECKOUT_FAILURE, cart })
    })
}
```
shop.buyProducts
```javascript
    buyProducts: (payload, cb, timeout) => setTimeout(() => cb(), timeout || TIMEOUT)
```



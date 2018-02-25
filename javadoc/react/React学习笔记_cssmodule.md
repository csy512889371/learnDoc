# 让react antd 支持 css module 和 less moduel
>* 问题配置了less module 会和 antd 的less 冲突。
>* 解决方式 使用module的less 文件命名规则。index.module.less


## 一、配置css 支持 css module

设置css-loader的options

>* importLoaders: 1,
>* modules: true,   // 新增对css modules的支持

```javascript
import styles from './index.css';
```

```javascript
{
                test: /\.css$/,
                use: [
                    require.resolve('style-loader'),
                    {
                        loader: require.resolve('css-loader'),
                        options: {
                            importLoaders: 1,
                            modules: true,   // 新增对css modules的支持
                        },
                    },
                    {
                        loader: require.resolve('postcss-loader'),
                        options: {
                            // Necessary for external CSS imports to work
                            // https://github.com/facebookincubator/create-react-app/issues/2677
                            ident: 'postcss',
                            plugins: () => [
                                require('postcss-flexbugs-fixes'),
                                autoprefixer({
                                    browsers: [
                                        '>1%',
                                        'last 4 versions',
                                        'Firefox ESR',
                                        'not ie < 9', // React doesn't support IE8 anyway
                                    ],
                                    flexbox: 'no-2009',
                                }),
                            ],
                        },
                    },
                ],
            },
```

# 二、让 less 支持less module

>* 为了解决和antd的配置冲突。文件命名增加module
>* 对less 结尾的文件的 css-loader 的options 进行设置。

```javascript
import styles from './index.module.less';
```
> 注意 less 文件的命名为 index.module.less

```javascript

{
                test: /\.less$/,
                use: [
                    require.resolve('style-loader'),
                    ({ resource }) => ({
                        loader: 'css-loader',
                        options: {
                            importLoaders: 1,
                            modules: /\.module\.less/.test(resource),
                            localIdentName: '[name]__[local]___[hash:base64:5]',
                        },
                    }),
                    {
                        loader: require.resolve('postcss-loader'),
                        options: {
                            ident: 'postcss', // https://webpack.js.org/guides/migrating/#complex-options
                            plugins: () => [
                                require('postcss-flexbugs-fixes'),
                                autoprefixer({
                                    browsers: [
                                        '>1%',
                                        'last 4 versions',
                                        'Firefox ESR',
                                        'not ie < 9', // React doesn't support IE8 anyway
                                    ],
                                    flexbox: 'no-2009',
                                }),
                            ],
                        },
                    },
                    {
                        loader: require.resolve('less-loader'),
                        options: {
                            modifyVars: {"@primary-color": "#404040"},
                        },
                    },
                ],
            }
```


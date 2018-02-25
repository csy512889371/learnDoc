# 从create-react-app学习webpack

## 1.没有配置的现代化构建
> Create React App is a new officially supported way to create single-page React applications. It offers a modern build setup with no configuration.

[链接地址：create-apps-with-no-configuration](https://facebook.github.io/react/blog/2016/07/22/create-apps-with-no-configuration.html)

利用create-react-app很快搭建出来了自己的项目,可以通过create-react-app来深入了解webpack

## 2.创建一个webpack的项目
如何用create-react-app构建一个webpack的项目

```javascript
npm install -g create-react-app
//切记项目名称不能大写
create-react-app firstapp
cd firstapp
npm run start
```

## 3.查看create-react-app的配置文件
创建完一个项目之后,你会发现为什么没有配置文件呢.
这是需要运行

npm run eject复制出相关的配置文件 so,why is that?
来看一下官方的文档,

**`npm run eject`**
**Note: this is a one-way operation. Once you `eject`, you can’t go back!**
If you aren’t satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.
Instead, it will copy all the configuration files and the transitive dependencies (Webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you’re on your own.
You don’t have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn’t feel obligated to use this feature. However we understand that this tool wouldn’t be useful if you couldn’t customize it when you are ready for it.

> 看了这两段,我们首先可以看出来 npm run eject 是一个'一次性操作',只能使用一次.

# 一、package.json 详解

先不看配置目录,先看看create-react-app 构建出来的项目用了哪些依赖.
```javascript
 "dependencies": {
    //一个为了兼容浏览器,为样式自动添加前缀的库
    "autoprefixer": "7.1.6",
	//babel es6->es5
    "babel-core": "6.26.0",
    "babel-eslint": "7.2.3",
    "babel-jest": "20.0.3",
    "babel-loader": "7.1.2",
    "babel-preset-react-app": "^3.1.0",
    "babel-runtime": "6.26.0",
	//对于这个插件不是很了解，简单看了一下文档，应该是为了兼容引入插件时的路径问题。
    "case-sensitive-paths-webpack-plugin": "2.1.1",
    "chalk": "1.1.3",
	//css引入插件,将css装载到JavaScript例如 import './index.css'
    "css-loader": "0.28.7",
	//env 处理
    "dotenv": "4.0.0",
	 //当你运行或者构建的时候，可以检查语法的库。我只能说这个库非常有用，
	 //毕竟有时候除了error致命，warning也非常致命（如果你不注意的话）
    "eslint": "4.10.0",
    "eslint-config-react-app": "^2.0.1",
    "eslint-loader": "1.9.0",
    "eslint-plugin-flowtype": "2.39.1",
    "eslint-plugin-import": "2.8.0",
    "eslint-plugin-jsx-a11y": "5.1.1",
    "eslint-plugin-react": "7.4.0",
	//css 打包插件
    "extract-text-webpack-plugin": "3.0.2",
	//文件加载打包插件包括图片，js文件等
    "file-loader": "1.1.5",
	//文件系统扩展模块
    "fs-extra": "3.0.1",
	//html生成插件，可以自动引入css和js
    "html-webpack-plugin": "2.29.0",
	//单元测试工具
    "jest": "20.0.4",
	//目测应该是Object.assign()的兼容库---不懂。。。
    "object-assign": "4.1.1",
	//一种用于修复flexbug的bug的插件。
    "postcss-flexbugs-fixes": "3.2.0",
	 //css构建中，浏览器兼容库
    "postcss-loader": "2.0.8",
	//promise库
    "promise": "8.0.1",
    "raf": "3.4.0",
	//内置react相关库
    "react": "^16.1.1",
    "react-dev-utils": "^4.2.1",
    "react-dom": "^16.1.1",
	//样式加载库，使JavaScript认识css
    "style-loader": "0.19.0",
	//不是很了解，搜了一下应该提供一种web前端的缓存方案的库
    "sw-precache-webpack-plugin": "0.11.4",
	//css和dom属性中 的各种文件引入
    "url-loader": "0.6.2",
	//webpack
    "webpack": "3.8.1",
    "webpack-dev-server": "2.9.4",
    "webpack-manifest-plugin": "1.3.2",
	//fetch 请求，一种更加优雅异步加载的请求方式
    "whatwg-fetch": "2.0.3"
  }
```

![image](https://github.com/csy512889371/reactLearn/blob/master/img/reactAntd1.png)


--env.js
> 返回客户端的环境配置

--paths.js
> 返回各种项目关键的目录位置

--polufills.js
> 引入promise，fetch，object.assign三种常用方法。

--webpack.config.dev.js
> webpack开发环境配置文件

--webpack.config.prod.js
> webpack生产环境配置文件

--webpackDevServer.config.js
> 小型的Node.js Express服务器

# 二、配置文件 env.js

```javascript
'use strict';

const fs = require('fs');
const path = require('path');
const paths = require('./paths');

// Make sure that including paths.js after env.js will read .env variables.
delete require.cache[require.resolve('./paths')];

const NODE_ENV = process.env.NODE_ENV;
if (!NODE_ENV) {
  throw new Error(
    'The NODE_ENV environment variable is required but was not specified.'
  );
}

// https://github.com/bkeepers/dotenv#what-other-env-files-can-i-use
var dotenvFiles = [
  `${paths.dotenv}.${NODE_ENV}.local`,
  `${paths.dotenv}.${NODE_ENV}`,
  // Don't include `.env.local` for `test` environment
  // since normally you expect tests to produce the same
  // results for everyone
  NODE_ENV !== 'test' && `${paths.dotenv}.local`,
  paths.dotenv,
].filter(Boolean);

// Load environment variables from .env* files. Suppress warnings using silent
// if this file is missing. dotenv will never modify any environment variables
// that have already been set.
// https://github.com/motdotla/dotenv
dotenvFiles.forEach(dotenvFile => {
  if (fs.existsSync(dotenvFile)) {
    require('dotenv').config({
      path: dotenvFile,
    });
  }
});

// We support resolving modules according to `NODE_PATH`.
// This lets you use absolute paths in imports inside large monorepos:
// https://github.com/facebookincubator/create-react-app/issues/253.
// It works similar to `NODE_PATH` in Node itself:
// https://nodejs.org/api/modules.html#modules_loading_from_the_global_folders
// Note that unlike in Node, only *relative* paths from `NODE_PATH` are honored.
// Otherwise, we risk importing Node.js core modules into an app instead of Webpack shims.
// https://github.com/facebookincubator/create-react-app/issues/1023#issuecomment-265344421
// We also resolve them to make sure all tools using them work consistently.
const appDirectory = fs.realpathSync(process.cwd());
process.env.NODE_PATH = (process.env.NODE_PATH || '')
  .split(path.delimiter)
  .filter(folder => folder && !path.isAbsolute(folder))
  .map(folder => path.resolve(appDirectory, folder))
  .join(path.delimiter);

// Grab NODE_ENV and REACT_APP_* environment variables and prepare them to be
// injected into the application via DefinePlugin in Webpack configuration.
const REACT_APP = /^REACT_APP_/i;

function getClientEnvironment(publicUrl) {
  const raw = Object.keys(process.env)
    .filter(key => REACT_APP.test(key))
    .reduce(
      (env, key) => {
        env[key] = process.env[key];
        return env;
      },
      {
        // Useful for determining whether we’re running in production mode.
        // Most importantly, it switches React into the correct mode.
        NODE_ENV: process.env.NODE_ENV || 'development',
        // Useful for resolving the correct path to static assets in `public`.
        // For example, <img src={process.env.PUBLIC_URL + '/img/logo.png'} />.
        // This should only be used as an escape hatch. Normally you would put
        // images into the `src` and `import` them in code to get their paths.
        PUBLIC_URL: publicUrl,
      }
    );
  // Stringify all values so we can feed into Webpack DefinePlugin
  const stringified = {
    'process.env': Object.keys(raw).reduce((env, key) => {
      env[key] = JSON.stringify(raw[key]);
      return env;
    }, {}),
  };

  return { raw, stringified };
}

module.exports = getClientEnvironment;

```

**首先明确env.js的主要目的在于读取env配置文件并将env的配置信息给到全局变量process.env**

## 1.配置文件的优先级问题

```javascript
### What other `.env` files can be used?

>Note: this feature is **available with `react-scripts@1.0.0` and higher**.

* `.env`: Default.
* `.env.local`: Local overrides. **This file is loaded for all environments except test.**
* `.env.development`, `.env.test`, `.env.production`: Environment-specific settings.
* `.env.development.local`, `.env.test.local`, `.env.production.local`: Local overrides of environment-specific settings.

Files on the left have more priority than files on the right:

* `npm start`: `.env.development.local`, `.env.development`, `.env.local`, `.env`
* `npm run build`: `.env.production.local`, `.env.production`, `.env.local`, `.env`
* `npm test`: `.env.test.local`, `.env.test`, `.env` (note `.env.local` is missing)
```

通过打印加上代码的逻辑,我们不难看出 文档给出的env的file 路径符合实际
![image](https://github.com/csy512889371/reactLearn/blob/master/img/reactAntd2.png)


## 2.env的常用方法,

1.启动协议,端口和地址的变更

```javascript
// Tools like Cloud9 rely on this.
const DEFAULT_PORT = parseInt(process.env.PORT, 10) || 3000;
const HOST = process.env.HOST || '0.0.0.0';

// We attempt to use the default port but if it is busy, we offer the user to
// run on a different port. `detect()` Promise resolves to the next free port.
choosePort(HOST, DEFAULT_PORT)
  .then(port => {
    if (port == null) {
      // We have not found a port.
      return;
    }
    const protocol = process.env.HTTPS === 'true' ? 'https' : 'http';
```

配置文件 .env.local
```javascript
HTTPS=true
PORT=3001
```
![image](https://github.com/csy512889371/reactLearn/blob/master/img/reactAntd4.png)
![image](https://github.com/csy512889371/reactLearn/blob/master/img/reactAntd3.png)


## 3.项目相关key存储
.env还是很有用的.在项目开发上必然可能会使用到一些第三方平台的接口,那么在多人协同开发的时候,key的有效存储就很有必要
首先我们写下如下两个键值对

正则过滤非REACT_APP开头的变量:
![image](https://github.com/csy512889371/reactLearn/blob/master/img/reactAntd5.png)

注意我们在定义一个全局变量的时候一定要注意以REACT_APP开头,当然如果哪些同学不是很满意这个设定,可以在env.js中去除filter.当然不是很推荐.


## 4.env的扩展使用想法

>* 封装开发环境.
思路:封装 启动命令,读取指定env..读取指定配置文件,(有空再详细些)
>* 静态资源的统一引入,在多人开发的时候.

# 三、path.js详解

```javascript
'use strict';

const path = require('path');
const fs = require('fs');
const url = require('url');

// Make sure any symlinks in the project folder are resolved:
// https://github.com/facebookincubator/create-react-app/issues/637
const appDirectory = fs.realpathSync(process.cwd());
const resolveApp = relativePath => path.resolve(appDirectory, relativePath);

const envPublicUrl = process.env.PUBLIC_URL;

function ensureSlash(path, needsSlash) {
  const hasSlash = path.endsWith('/');
  if (hasSlash && !needsSlash) {
    return path.substr(path, path.length - 1);
  } else if (!hasSlash && needsSlash) {
    return `${path}/`;
  } else {
    return path;
  }
}

const getPublicUrl = appPackageJson =>
  envPublicUrl || require(appPackageJson).homepage;

// We use `PUBLIC_URL` environment variable or "homepage" field to infer
// "public path" at which the app is served.
// Webpack needs to know it to put the right <script> hrefs into HTML even in
// single-page apps that may serve index.html for nested URLs like /todos/42.
// We can't use a relative path in HTML because we don't want to load something
// like /todos/42/static/js/bundle.7289d.js. We have to know the root.
function getServedPath(appPackageJson) {
  const publicUrl = getPublicUrl(appPackageJson);
  const servedUrl = envPublicUrl ||
    (publicUrl ? url.parse(publicUrl).pathname : '/');
  return ensureSlash(servedUrl, true);
}

// config after eject: we're in ./config/
module.exports = {
  dotenv: resolveApp('.env'),
  appBuild: resolveApp('build'),
  appPublic: resolveApp('public'),
  appHtml: resolveApp('public/index.html'),
  appIndexJs: resolveApp('src/client/index.js'),
  appPackageJson: resolveApp('package.json'),
  appSrc: resolveApp('src'),
  yarnLockFile: resolveApp('yarn.lock'),
  testsSetup: resolveApp('src/__tests__/index.test.js'),
  appNodeModules: resolveApp('node_modules'),
  publicUrl: getPublicUrl(resolveApp('package.json')),
  servedPath: getServedPath(resolveApp('package.json')),
};

```

代码太短 没啥好讲的 主要就是提供给项目的各种路径 .包括构建路径 public路径等等

## 利用path.js修改项目的运行路径

情景 如果你的项目运行的目录并不是根目录下 例如是xxx.com/html/
那么我们可以根据上面的分析 在package.json中添加homepage的属性 .来使buld时各种静态资源的正确引入.

> publicUrl 和serverdPath 均修改为 /html/

# 四、如何优雅的配置多入口访问

在大多数情况底下,我们只需要一个单页应用便可以顺利的完成许多应用场景.但是还是免不了有很多情况下我们需要通过多页才能够顺利的完成任务.

本篇文章就为大家讲述如何快速优雅的 生成多页访问.
>* 1.增加入口文件
>* 2.增加HtmlWebpackPlugin

**注意:本文环境实在开发环境下配置,生产环境略有不同.稍微整改即可**
```javascript
//原生代码
entry: [
    //引入三个es6新特性
    require.resolve('./polyfills'),
    //载入热更新
    require.resolve('react-dev-utils/webpackHotDevClient'),
    //入口文件
    paths.appIndexJs,
  ],

```
这里entry是一个数组,不支持CommonsChunkPlugin .所以我们根具webpack官方文档

> https://webpack.js.org/concepts/entry-points/#multi-page-application

把entry改成一个对象.
此时 可以这样子写
```javascript
entry:{
index:[
    //引入三个es6新特性
    require.resolve('./polyfills'),
    //载入热更新
    require.resolve('react-dev-utils/webpackHotDevClient'),
    //入口文件
    path.resolve(paths.appSrc, "index/index.js")
  ],
admin:[
    //引入三个es6新特性
    require.resolve('./polyfills'),
    //载入热更新
    require.resolve('react-dev-utils/webpackHotDevClient'),
    //入口文件
    path.resolve(paths.appSrc, "admin/index.js")
  ],
}

```
此时我们就成功载入了index和admin模块
但是此时注意 因为是在开发模式底下 为了避免引入js冲突 的问题.
output中需要修改

```javascript
//增加模块名字和hash值 避免缓存  等等一切问题
filename: 'static/js/[name].[hash:8].bundle.js',
```
## 1、增加HtmlWebpackPlugin

webpack.config.prod.js

```javascript
new HtmlWebpackPlugin({
      inject: true,
     chunks: ['index'],
      template: paths.appHtml,
     filename: "index/index.html"
     }),
new HtmlWebpackPlugin({
      inject: true,
     chunks: ['admin'],
      template: paths.appHtml,
     filename: "admin/index.html"
     }),


```
非常明确 到处两个不同的index.html
配置到这里 npm start 发现还是有一点小问题,就是永远无法访问到admin,google一翻之后,发现create-react-app帮我们做的太好了,为了支持react-router 这个本家的组件的在开发环境下的调试,已经在配置文件中帮我们配置好了 可以直接访问react router 路径 访问组件

其实就是支持historyApi,这点在我用刚入门react-router是给我了很大的疑惑,因为线上和开发环境是完全不同的.

> 原话链接:https://webpack.js.org/configuration/dev-server/#devserver-historyapifallback

修改webpackDevServer.config中的historyApiFallback为false(这样子就无法直接访问组件地址访问组件了.完美的解决方式,请看官网即可)
生产环境下不用考虑这个问题

## 2、优雅的解决
根目录下 创建 .env.local
```javascript
REACT_APP_ENTRY=["index","admin"]
```

回到webpack.config.dev
定义两个函数

```javascript
const env = getClientEnvironment(publicUrl);
function setEntryConfig(arrayString) {
  let entryArray = JSON.parse(arrayString)
  if (!Array.isArray(entryArray)) {
    console.log("请确保entry是一个数组")
    return {}
  }
  let entry = {}
  entryArray.map(function (item) {
    entry[item] = [
      require.resolve("./polyfills"),
      require.resolve('react-dev-utils/webpackHotDevClient'),
      //合成入口文件
      path.resolve(paths.appSrc, item + "/index.js")
    ]
  })
  return entry
}
function setHtmlPluginConfig(arrayString) {
  let entryArray = JSON.parse(arrayString)
  if (!Array.isArray(entryArray)) {
    console.log("请确保entry是一个数组")
    return []
  }
  let plugin = []
  entryArray.map(function (item) {
    plugin.push(
      new HtmlWebpackPlugin({
        inject: true,
        chunks: [item],
        template: paths.appHtml,
        filename: item + "/index.html"
      })
    )
  })
  return plugin
}

```
应用到应用上：
```javascript
entry: setEntryConfig(env.raw.REACT_APP_ENTRY),

...(setHtmlPluginConfig(env.raw.REACT_APP_ENTRY)),
```









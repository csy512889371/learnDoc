
Webpack 可以将多种静态资源 js、css、less 转换成一个静态文件，减少了页面的请求

http://www.runoob.com/w3cnote/webpack-tutorial.html
入门教程

# loader

* https://github.com/vuejs/vue-loader
* https://github.com/webpack-contrib/css-loader
* https://github.com/webpack-contrib/url-loader

* https://github.com/postcss/postcss-loader
添加浏览器前缀

* https://github.com/shama/stylus-loader

* https://github.com/babel/babel-loader

转化ES6代码

* https://github.com/webpack-contrib/file-loader

简单来说，file-loader 就是将文件（由于一般是图片文件为主），在进行一些处理后（主要是处理文件名和路径），移动打包后的目录中。

* https://github.com/webpack-contrib/gzip-loader



# cross-env简介


运行跨平台设置和使用环境变量的脚本

https://github.com/kentcdodds/cross-env

# 出现原因

* 当您使用NODE_ENV =production, 来设置环境变量时，大多数Windows命令提示将会阻塞(报错)。 （异常是Windows上的Bash，它使用本机Bash。）同样，Windows和POSIX命令如何使用环境变量也有区别。 使用POSIX，您可以使用：$ ENV_VAR和使用％ENV_VAR％的Windows。 

* windows不支持NODE_ENV=development的设置方式。会报错


* (cross-env)能够提供一个设置环境变量的scripts，让你能够以unix方式设置环境变量，然后在windows上也能兼容运行


```
npm install --save-dev cross-env


```

```
{
  "scripts": {
    "build": "cross-env NODE_ENV=production webpack --config build/webpack.config.js"
  }
}
```

NODE_ENV环境变量将由cross-env设置


# webpack 拷贝插件copy-webpack-plugin

* https://github.com/webpack-contrib/copy-webpack-plugin

```
cnpm install --save-dev copy-webpack-plugin
```

```
// Plugins
var CopyWebpackPlugin = require('copy-webpack-plugin');
 
 
 plugins: [
 
new CopyWebpackPlugin([ // 复制插件
        { from: path.join(__dirname,'app/node/main.js'), to:  path.join(__dirname,'public/node/') }
      ])
]


```

# mini-css-extract-plugin

https://github.com/webpack-contrib/mini-css-extract-plugin

将CSS提取为独立的文件的插件，对每个包含css的js文件都会创建一个CSS文件，支持按需加载css和sourceMap

* https://www.jianshu.com/p/91e60af11cc9


# uglifyjs-webpack-plugin

使用uglify-js进行js文件的压缩

https://github.com/webpack-contrib/uglifyjs-webpack-plugin


# optimize-css-assets-webpack-plugin

压缩css文件

https://github.com/NMFR/optimize-css-assets-webpack-plugin



# webpack-dev-server

https://github.com/webpack/webpack-dev-server




浅显认识，这是一个插件，插件的作用是用来生成一个服务器，通过这个服务器，可以开启一个本地服务，一个服务器必备的两个方面
1.服务器的资源
2.服务资源访问规则

服务器资源通过加载配置，进行编译生成
访问资源配置通过express来生成

那么其中牵涉到的 hot-module-replace,webpack-dev-middleware,webpack-hot-middleware,还有express,还有bin/www,webpack-dev-server这些文件之间的关系究竟是怎样的。好像不是很理解。

webpack-dev-server
使用方式：webpackDevServer(配置项, {
    //一些属性
})
作用：构成一个服务器，通过访问文件路径，获得对应的文件
启动一个使用express的http服务器，主要用来提供资源文件，这个服务器和client之间使用websocket来进行通讯，

webpack-dev-server支持两种刷新方式
1.iframe
请求/webpack-dev-server/index.html, 会返回 client/index.html,这个文件内容
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script type="text/javascript" charset="utf-8" src="/webpack-dev-server/live.bundle.js"></script>
</head>
<body></body>
</html>
```
这个live.bundle.js文件会新建一个iframe,应用会被注入到这个iframe中，这个文件中还有soket.io的client相关的代码，依靠这个代码和webpack-dev-server建立的服务器进行websoket通讯
2.inline
webpack-dev-server会在webpackConfig文件，entry中增加一个文件
entry: ['webpack-dev-server/client?http://localhost:8080/', './src/index.js']
这个新增的入口文件，会将客户端与服务端进行websocket通讯的逻辑打包进来。

这两个模式最终形成的效果就是，都是监听文件变化，然后将编译后的文件推送给前端，完成页面reload

在命令行上增加 --hot 参数，开启HMR(Hot Module Replacement)s

webpack-dev-middleware
使用方式：
server.js
let compiler = webpack(webpackConfig);
webpackDevMiddleware(配置项, {
    //一些属性
})
作用：构成一个服务器，和webpack-dev-server的区别就是devServer是在devMiddle基础上进行封装的

webpack-hot-middleware
使用方式：
webpackConfig.js 
entry属性中必须增加一条 ['webpack-hot-middleware/client?noInfo=true&reload=true']
server.js
let compiler = webpack(webpackConfig);
webpackHotMiddleware(compiler, {
    //一些配置项
})
作用：实现文件更新后，浏览器自动刷新。这个刷新指的是整个页面的刷新

还有一个模块热更新的概念 Hot Module Replacement,模块热替换，与webpack-hot-middleware的区别是，HMR是局部刷新，状态可以保存，WHM是整个页面全部刷新，刷新前状态不需要保持。
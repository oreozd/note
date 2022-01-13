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
webpack热更新，英文名称为，Hot Module Replace, 模块热更新，感性的认识是，修改代码之后，可以只更新一个模块，不需要刷新整个页面，那么页面的状态还是可以保留下来。

打包过程和浏览器之间如何进行进行交互的

有几个问题
Q: 模块热更新是如何开启的？为什么我的开启不了
是webpack的内置功能，打开方式有两种
1.webpack.HotModuleReplacementPlugin
2.命令行增加--hot参数

Q: webpack如何知道需要更新哪个模块
哪个模块的代码发生了变更，就更新哪个模块
Q: 模块重新编译之后，浏览器是如何知道的
会通过websocket向浏览器发送消息，浏览器通过实现注入的监听逻辑进行监听。hash和ok事件
Q: 浏览器在拿到更新的模块之后，是如何更新页面的？
进行新的模块替换，接下来就是一些正常的页面解析流程吧，解析dom，解析css等等，hmr进行到将代码更新到浏览器中，剩下的就是浏览器自己的流程了。
Q: HMR和webpack-dev-server的关系是什么？
HMR的实现方案有两种
1.HMR的实现依赖于webpack-dev-server,需要使浏览器可以访问到静态资源，webpack-dev-server在这个过程中所起的作用是什么
    - 提供一个静态资源服务器
    - 提供服务器和客户端之间的websocket链接
2.直接使用webpack-hot-middleware来实现，使用这种方式实现，浏览器和服务器之间通信并没有使用到webscoket，而是使用event source进行信息传递

Q:每次更新代码之后，都会触发重新编译，为什么会触发重新编译，
是webpack内部的一种机制，可能是监测文件更新的时间发生改变，这一步的产生的结果

编译控制台出现三个新文件
- 生成一个新的hash值
- 新的json文件 hash.hot-update.json
这个文件包含的是本次更新的hash值
- 新的js文件 index.hash.hot-update.js
文件内容是本次更新发生变更的模块打包出来的代码，后面就是使用这个文件中的内容来替换模块内容，从而引起页面更新
  

浏览器控制台会出现两个新的文件请求
- hash.hot-update.json
- index.hash.hot-update.js

Q:为什么浏览器会自动发起对这两个文件的请求
浏览器监听到了服务器发送的type为ok的消息
感性认识是浏览器监听了对应的事件，然后作出了自己的响应就是去发起请求。

##### 热更新实现原理

###### 1.webpack-dev-server
在开发模式下启动一个webpack服务器，本地服务器
- 启动webpack,生成compiler实例，
- 使用express框架启动本地服务，使得浏览器能够调用本地的静态资源
- 本地服务开启之后，启动websocket服务，浏览器可以接收到消息推送就是通过websocket实现的

###### 2.修改webpack.config.js的 entry配置项
一般而言，对于单文件的项目，entry是一个单独的文件。
Q: 这个地方为什么要修改这个entry属性，是用来做什么的？
entry属性的作用，作为一个编译入口文件，查找依赖进行打包，所以增加入口就相当于将对应的代码打包。所以这里其实是在做一个功能上的附加。

在启动本地服务之前，会有两个关键操作
- 获取webscoket客户端代码路径<这个客户端指的是？>
用来接收websocket消息的 webpack-dev-server/client/index.js
- 根据配置获取webpack热更新代码路径<不理解>

修改后的入口文件为
```
{
    entry: {
        index: [
            'xxx/node_modules/webpack-dev-server/client/index.js?http://localhost:8080',
            'xxx/node_modules/webpack/hot/dev-devser.js',
            './src/index.js' //开发配置的入口
        ]
    }
}
```
webpack-dev-server/client/index.js
这个文件主要是websocket, 在初始化过程中，启动本地服务端的websocket,这个websocket的客户端指的是浏览器，但是浏览器本身并没有去响应websocket的代码，所以需要去附加上去。

webpack/hot/dev-server.js
主要用来检查更新逻辑

###### 3.监听webpack编译结束
修改入口配置，调用setupHooks方法注册监听事件，监听每次webpack编译完成
```
setupHooks() {
    const {done} = compiler.hooks;
    //监听编译完成的事件
    done.tap('webpack-dev-server', (stats) => {
        this._sendStats(this.sockets, this.getStats(stats));
        this._stats = stats;
    })
}
//通过socket给客户端发送消息
_sendStats() {
    this.sockWrite(sockets, 'hash', stats.hash); //浏览器通过监听‘hash’拿到最新hash值，做检查更新的逻辑
    this.sockWrite(sockets, 'ok');
}
```

###### 4.webpack监听文件的更新
修改文件，会触发webpack编译，监听本地代码更新通过 setupDevMiddleware 方法，这个方法主要执行webpack-dev-middleware这个库

webpack-dev-middleware：主要负责本地文件的编译，输出，以及监听
webpack-dev-server：主要负责启动服务和前置准备工作

```
//监听
//1.对本地文件进行编译打包，执行webpack打包流程
//2.编译结束后，对本地文件进行监听，文件发生变化，重新编译，编译完成继续监听
compiler.watch(options.watchOptions, (err) => {

})

//通过memory-fs将文件写入内存
//Q:为什么编译后的文件要写入内存中
//访问内存中的代码比文件系统中的速度要快
setFs(context, compiler)

```

###### 浏览器接收热更新的通知
浏览器通过打包进来的socket方法建立了websocket和服务端的链接，并注册了两个监听事件
- hash事件：获取最新hash
- ok事件：进行热更新检查

```
reloadApp() {
    if(hot) {
        log.info('[WDS App hot update...]');

        var hotEmitter = require('webpack/hot/emitter');
        hotEmitter.emit('webpackHotUpdate', currentHash);
        //其实就是进行了一个转交，真正进行检查更新的是 webpackHotUpdate
    }
}
```
webpack检查更新的逻辑存在于 webpack/hot/dev-server.js文件中，也就是修改配置文件打包进来的第二个文件

```
var check = function() {
    module.hot.check(true)
    .then()
    .catch()
}

var hotEmitter = require('webpack/hot/emitter');
hotEmitter.on('webpackHotUpdate', function(currentHash){
    lastHash = currentHash;
    check();
})
```
module.hot.check()方法来自于 HotModuleReplacementPlugin

###### 6.HotModuleReplacementPlugin是什么？
配置了热更新文件之后的，会增加一个 hotCreateModule方法，module.hot.check方法就是在这个函数中的。

###### 7.module.hot.check开始热更新
- 利用上一次保存的hash值，调用hotDownloadManifest发送 xxx/hash.hot-update.json文件请求
```
hotAvailableFilesMap= update.c;
hotUpdateNewHash = update.h;
hotSetStatus('prepare'); //进入热更新准备状态
```
- 调用hotDownloadUpdateChunks发送 xxx/hash.hot-update.js请求，通过JSONP形式

```
function hotDownloadUpdateChunk(chunkId) {
    var script = document.createElement('script');
    script.charset = 'utf-8';
    script.src = _webpack_require_.p + "" + chunkId + "." + hotCurrentHash + ".hot-update.js";
    if(null) script.crossOrigin = null;
    document.head.appendChild(script);
}
```
Q: 为什么使用JSONP
因为获取到的代码需要立即执行，没有理解的

###### 8.hotApply 热更新模块替换
- 删除过期模块
- 将新的模块添加到modules中
- 通过__webpack_require__执行相关模块的代码


一些细碎的点：

webpack-dev-server在启动的时候就建立了一条与浏览器之间的websocket链接，通过这个链接，浏览器就可以和webpack发生交互。

webpack-dev-server监听webpack打包过程并同步给浏览器。

浏览器如何建立websocket链接，是通过在entry中增加新的入口文件，将相关的代码打包进去。更新产生的时候，接收到的消息的类型是hash。更新模块的代码编译完成，消息的类型是的 ok。执行reload操作，会根据hot属性是否存在决定是浏览器刷新还是局部更新

HMR新资源的请求是通过谁发起的呢？
由浏览器通过ajax请求, 具体的逻辑是来自于，在初始化编译时，通过修改entry属性注入的 webpack/hot/dev-server.js 文件中

页面更新，不管是整个更新还是热更新，都是会发起对新资源的请求，整个页面刷新的过程中，因为从头走了页面加载的流程，所以资源请求就是遵循页面加载的过程。


关键点就是
1.webpack觉知到更新
文件变更，webpack通过监听文件变更的时间，开启重新编译的流程，因为webpack自身的优化策略，只有变更的文件会发生hash值的变更，每次编译都会产生本次更新的hash值。
2.webpack执行完重新编译的流程
执行完之后，会输出本次更新的hash值还有一个json文件还有js文件
3.浏览器知道webpack重新编译完成
浏览器通过监听dev-server传递过来的消息，来得知是否编译完成，编译完成之后，就开始执行更新流程

Q:消息的传递和流程之间的先后顺序关键吗？先后顺序是什么样的
4.浏览器发起对新的资源的请求
请求发起就是很普通的ajax请求
5.因为是局部更新的，所以只需要请求更新部分的代码

Q:如何知道需要请求哪些资源
所有更新的资源都会被打包在js文件中，请求资源就是按照hash值来请求
Q:请求到的资源，是什么形式的。如何与源代码进行结合
请求到的资源和普通打包到的文件没有什么太大的区别，具体应用就是在hotApply()函数中，删掉没有使用到的，增加新的，剩下的就和直接在浏览器控制台直接修改代码造成页面更新的流程一样



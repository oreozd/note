promise:字面含义，承诺，

```
let p = new Promise((resolve, reject) => {
    //根据不同的逻辑调用resolve()/reject()
})

p.then(res => {}, reason => {})
//或者
p.then(res => {})
.catch();
```
必须使用then()函数进行监听，在exector函数执行resolve()命令的时候，就会执行then()绑定的第一个参数，执行对应的操作

基础概念是这样的
还有一些引申用法

##### Promise.resolve()
作用：将现有对象转化为promise对象
```
Promise.resolve('foo')
//等价
new Promise(resolve => resolve('foo'))
```
不同参数对应不同的结果
- 参数是promise实例
  原封不动返回这个实例
- 参数是一个thenable对象
  将该对象转化为Promise对象，然后立即执行thenable的then方法
- 参数是原始值，不含then()
  返回一个resolved状态的新的promise对象
- 没有参数
  直接返回一个resolved状态的新的promise对象

上面的promise对象都是立即resolve()，执行时机是在本次事件循环结束时，不是在下次事件循环。

##### Promise.reject()
```
Promise.reject('出错了')
//等价于
new Promise((resolve, reject) => {
    reject('出错了');
})
```
生成一个状态为rejected状态的promise,回调函数立即执行
参数会原封不动的传递给后面的回调函数，不论是什么格式的参数

##### Promise.try()
promise对try模块的模拟，可以更加方便处理异常捕获，使用同样的格式处理同步和异步。

##### 
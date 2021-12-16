this的指向有四种


this的指向在作用域体系中存在的位置，在词法作用域环境中

默认绑定
显式绑定
隐式绑定
new绑定


#### 修改this的指向
一般来说修改this指向的方式有三种
- call方法
- apply方法
- bind方法

call和apply类似，执行的完的结果是，执行call/apply方法的函数，以括号中第一个参数为上下文，以括号中剩余参数为实参执行的结果

bind执行完成的结果，返回一个函数，这个函数绑定了指定的上午文，并不会执行，传递进去的参数会作为将来函数执行的参数。

```
调用方式
#call
function.call(obj, arg1, arg2...)
#apply
function.apply(obj, [arg1, arg2])
```
可以看到两者的唯一区别就是，参数传递的方式不同。

引申出一个问题，call和apply两个方法，哪个的执行效率会更高一些？
A:直觉会觉得是call执行效率更高一些，因为apply还需要将数组解析，这是额外的开销。
https://juejin.cn/post/6844903496450310157 这个是一个更合理的解释

#### 手写实现call和apply
首先这个方法是存在于函数的原型上的
```
首先分析这个函数的输入，输出
#input: 需要被绑定的上下文对象 调用函数所需要的参数
#output: 函数调用的返回结果
#函数内部需要完成的操作: 修改函数执行上下文 调用函数返回结果
#疑难点: 如何修改一个函数的执行上下文，
已知函数的上下文取决于函数执行时候点前面的对象
Function.prototype.myCall = function(context){
    //context:将要被绑定的新的执行上下文
    //被执行的函数，此处可以使用this获得，利用的也是，函数的this指向调用它的对象，无限套娃。
    if(typeof this !== 'function'){
        return new Error("call方法只能通过函数调用");
    }
    context = context || window;
    context.fn = this; 
    let result = context.fn(...[...arguments].slice(1));
    delete context.fn;
    return result;
}

#同理apply的思路和这个是类似的
Function.prototype.myApply = function(context){
    if(typeof this !== 'function'){
        return new Error("call方法只能通过函数调用");
    }
    context = context || window;
    context.fn = this;
    let result = null;
    //区别点
    if(arguments[1]){
        result = context.fn(...arguments[1]);
    }else {
        result = context.fn();
    }
    delete context.fn;
    return result;
}
```
#### 手写实现bind方法
```
首先分析这个函数的输入，输出
#input: 需要被绑定的上下文对象 调用函数所需要的参数
#output: 一个指定上下文的函数
#函数内部需要完成的操作: 修改函数执行上下文 将传递的参数拼接到函数执行的实参中
#疑难点: 如何修改一个函数的执行上下文，
已知函数的上下文取决于函数执行时候点前面的对象
Function.prototype.myBind = function(context) {
    if(typeof this !== 'function'){
        return new Error('Error');
    }
    context = context || window;
    let args = [...arguments].slice(1); //获取调用bind的时候传入的参数
    fn = this;
    return function Fn() {
        //考虑函数作为构造函数使用的情况,我不理解
        return fn.apply(this instanceof Fn ? this : context, args.concat(...arguments));
    }
}
```
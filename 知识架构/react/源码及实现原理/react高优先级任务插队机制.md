什么是高优先级任务插队
在concurrent模式下，低优先级任务执行过程中，一旦有高优先级任务进来，低优先级任务会被取消，优先去执行高优先级的任务，等高优先级任务执行完毕，低优先级任务再重新执行。

Q:concurrent模式是什么？什么条件下开启？
Q:印象中低优先级任务重新执行是在被打断的基础上继续执行的

插队行为的本质，内容涉及到
- update对象生成
- 发起调度
- 工作循环
- 高优先级任务插队
- update对象处理
- 低优先级任务重做

###### 产生更新
react的重新渲染就是通过产生一个更新进而触发整一个更新流程的。通常的方式就是通过调用setState, setState实际上是生成一个update对象，调用 enqueueSetState,将这个update对象链接到fiber节点的 updateQueue 链表中。然后发起调度

```
Component.prototype.setState = function(partialState, callback){
    this.updater.enqueueSetState(this, partialState, callback, 'setState');
}

enqueueSetState(inst, payload, callback){
    //获取fiber节点
    const fiber = getInstance(inst);

    //当前触发更新的时间戳
    const eventTime = requestEventTime();

    //
    const suspenseConfig = requestCurrentSuspenseConfig();

    //获取本次更新的优先级
    //获取scheduler中的优先级，这个是计算lane的依据
    const lane = requestUpdateLane(fiber, suspenseConfig);

    //创建更新对象
    const update = createUpdate(eventTime, lane, suspenseConfig);

    //具体的更新内容，参与计算的部分，一般是对象或者回调函数
    update.payload = payload;

    //将update对象放入fiber的updateQueue
    enqueueUpdate(fiber, update);

    //开始调度
    scheduleUpdateOnFiber(fiber, lane, eventTime);

}

//update对象的结构
const update: Update<*> = {
    eventTime, //更新产生的时间
    lane,  //优先级
    suspenseConfig, //挂起标志
    tag:UpdateState, //更新类型(UpdateState, ReplaceState, ForceUpdate, CaptureUpdate)
    payload: null,//更新携带的状态
    //1.在类组件：对象和函数
    //2.在根组件：ReactDOM.render()第一个参数
    callback: null, //setState的回调函数
    next: null //指向下一个update指针
}

```

Q:对于优先级自己还是不太理解？
我不理解的点在于，既然scheduler是一个独立的模块的话，那么它又是如何跟这整套结合起来并发生作用的呢？

###### 调度准备

###### 开始调度

react更新任务的本质
update产生最终的结果就是会根据现有fiber树，产生一棵新的fiber树，在生成新树的过程中会经历新state计算，diff操作，以及调用一些生命周期等操作，这个过程称为render阶段，render阶段的整体被认为是一个完整的react更新任务。更新任务的调度就是函数被sheduler按照任务优先级安排何时执行。

react调度和scheduler调度
react调度是协调任务进入哪种sheduler模式，并不涉及任务的执行，
scheduler是调度的核心，是执行任务，

Q:scheduler都有哪些模式？？

任务调度，scheduler会生成一个任务
```
var newTask = {
    id: taskIdCounter++,
    callback,
    priorityLevel,
    startTime,
    expirationTime,
    sortIndex: -1
}
```
任务会被挂载到root节点的callbackNode属性上，表示当前已有任务被调度。存储任务优先级到root节点的callbackPriority上，新的任务进来会与它进行比较，决定是否取消已经被调度的任务。

###### 任务优先级
任务优先级：
- 同步优先级
- 同步批量优先级
- concurrent模式下的优先级
  

###### 任务调度协调

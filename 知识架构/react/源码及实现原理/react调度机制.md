react是如何调度的？？

scheduler作为一个独立的包，负责的工作就是任务的调度和执行。

它与react的关系，react将任务和任务的优先级交予sheduler,它负责按照一定的顺序去执行这个任务。所以此时就需要把react传递过来的优先级翻译为自己能够理解的优先级。

由于js单线程的限制，所以一个任务并不是一直占用主线程，直到任务执行完毕，而是要符合浏览器时间片轮转的机制，可以在一定条件下暂停，并能够继续执行。

主要有两方面的主要行为：
- 多个任务之间的协调，也就是优先级的排列<任务队列管理>
- 单个任务的具体执行，中断和继续执行<时间片下的任务中断和恢复>

任务队列管理：如何排列一系列的任务，在scheduler中维护了两个队列，timerQueue和taskQueue,在timerQueue中保存了没有到期的任务，taskQueue保存了已经到期将要执行的任务。

那么如何判断任务是否过期？
通过判断任务开始时间startTime和currentTime之间的关系来决定将任务放在哪个队列中

Q:在同一个队列中不同的任务按照什么顺序排列？
宏观看来当然是根据任务的紧急程度来排列，在不同队列之中，紧急程度体现在不同的指标或者维度之上。

taskQueue中按照任务的过期时间expirationTime,过期时间早的排在较前面。过期时间通过任务优先级进行计算。
timerQueue中按照任务开始时间排序，在初次进入队列中，开始时间默认当前时间，如果任务设置有延迟，就是当前时间加上延迟时间。

首先会先去循环执行taskQueue中的任务，放在timerQueue中的任务会等待任务开始执行

Q:每个任务具体是如何被执行的，如果被中断的话又是如何被恢复的。
任务执行过程中有一个调度者和一个执行者，调度者调起一个执行者去循环taskQueue，当某个任务执行时间长被时间片机制中断之后，会将执行结果同步给调度者。任务中断可以重新执行的关键就在这里。

Q：react是如何与scheduler关联起来的
系统会分为三部分：
- react:产生任务的部分
- react和scheduler交流的翻译者；schedulerWithReactIntegration
- 任务调度者：sheduler
任务优先级翻译为调度优先级是通过翻译者实现的

Q:我还应该有什么样的问题？？大脑又是一片的空白

Q:调度优先级都有哪些
sheduler为任务设置了下面几种优先级
- NoPriority
- ImmediatePriority
- UserBlockingPriority
- NormalPriority
- LowPriority
- IdlePriority

任务优先级，通过任务优先级可以得到对应的timeout, expirationTime = startTime + timeout

Q: shedulerCallback是什么？
```
var newTask = {
    id: taskIdCounter++;
    callback, //真正执行任务的函数，例如构建fiber树的任务函数，performConcurrentWorkOnRoot
    priorityLevel,
    startTime,
    expirationTime,
    sortIndex: -1
}
```

调度入口 schedulerCallback
调度流程最初始的位置，功能主要有，
- 生成调度任务，
- 根据任务状态将任务放在timerQueue中还是taskQueue中
- 触发调度行为，将任务加入调度
目的是要将timerQueue中的任务不断监听，然后放入tackQueue中，调用requestHostCallback去执行任务，这才是调度的开始

调度开始
scheduler区分了浏览器和非浏览器环境，所以requestHostCallback有两套实现
- 非浏览器环境下使用 setTimeout实现
- 在浏览器环境下，使用messageChannel实现 -> port.postMessage
  
任务执行-执行，中断和恢复
performWorkUntilDeadline在浏览器环境下的执行者，在时间片的限制下去中断任务的执行，并通知调度者去调度一个新的执行者去执行任务

Q:中断和恢复具体是如何实现的？
通过在workLoop中，具体两部分的工作，循环taskQueue执行任务和任务状态判断
```
中断是通过 
currentTask.expirationTime > currentTime && (!hasTimeRemaining || shouldYieldToHost())
恢复的关键在于在任务是被中断而不是执行完成的时候，向外部返回一个 true，告知任务还没有执行完毕
```
任务是被打断。performWorkUntilDeadline会使调度者再调度一个执行者继续执行剩下的任务

Q:如何判断一个任务已经执行完成
任务函数返回值为一个函数，则说明任务还没有完成，需要继续调用任务函数，否则任务执行完成。

执行任务的本质就是不断从任务队列中最前面的任务进行执行，在执行过程中受限制于时间片，所以需要加入中断和重新执行的逻辑。

上面大概就是scheduler的调度规律
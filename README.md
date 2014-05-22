**Serial vs. Concurrent 串行 vs. 并发**

任务串行执行就是每次只有一个任务被执行，任务并发执行就是在同一时间可以有多个任务被执行。

**Synchronous vs. Asynchronous 同步 vs. 异步**

一个同步函数只在完成了它预定的任务后才返回,预定的任务会完成但不会等它完成，会直接返回。

**Critical Section 临界区**

一段代码不能被并发执行，也就是，两个线程不能同时执行这段代码。

**Race Condition 竞态条件**

基于特定序列或时机的事件的软件系统以不受控制的方式运行的行为。

**Deadlock 死锁**

所谓的死锁是指它们都卡住了，并等待对方完成或执行其它操作。第一个不能完成是因为它在等待第二个的完成。但第二个也不能完成，因为它在等待第一个的完成。

**Thread Safe 线程安全**

线程安全的代码能在多线程或并发任务中被安全的调用，而不会导致任何问题（数据损坏，崩溃，等）。线程不安全的代码在某个时刻只能在一个上下文中运行。

**Context Switch 上下文切换**

一个上下文切换指当你在单个进程里切换执行不同的线程时存储与恢复执行状态的过程。

**Concurrency vs Parallelism 并发与并行**

![image ](https://raw.githubusercontent.com/z55heihei/GCD/master/GCD/Concurrency.png)

为了实现并行来同时执行多个线程，先运行一个线程，执行一个上下文切换，然后运行另一个线程或进程。
如果你想深入此主题，看看[this excellent talk by Rob Pike ](http://vimeo.com/49718712)

**Serial Queues 串行队列**

![image](https://raw.githubusercontent.com/z55heihei/GCD/master/GCD/SerialQueues.png)

一次只执行一个任务，并且按照我们添加到队列的顺序来执行。

**Concurrent Queues 并发队列**

![image](https://raw.githubusercontent.com/z55heihei/GCD/master/GCD/ConcurrentQueue.png)

按照被添加的顺序开始执行，取决于GCD任意时刻有多少 Block 在执行下一个任务。

**Queue Types 队列类型**

系统提供给你一个叫做 主队列（main queue） 的特殊队列。
系统同时提供给你好几个并发队列。它们叫做 全局调度队列（Global Dispatch Queues） 。目前的四个全局队列有着不同的优先级：background、low、default 以及 high。

**Dispatch Groups（调度组）**

Dispatch Group 会在整个组的任务都完成时通知你。这些任务可以是同步的，也可以是异步的，即便在不同的队列也行。而且在整个组的任务都完成时，Dispatch Group 可以用同步的或者异步的方式通知你。因为要监控的任务在不同队列，那就用一个 dispatch_group_t 的实例来记下这些不同的任务。

异步实现调度组：
1. 在新的实现里，因为你没有阻塞主线程，所以你并不需要将方法包裹在 async 调用中。
2. 同样的 enter 方法，没做任何修改。
3. 同样的 leave 方法，也没做任何修改。
4. dispatch_group_notify 以异步的方式工作。当 Dispatch Group 中没有任何任务时，它就会执行其代码，那么 completionBlock 便会运行。你还指定了运行 completionBlock 的队列，此处，主队列就是你所需要的。
对于这个特定的工作，上面的处理明显更清晰，而且也不会阻塞任何线程。

**GCD的好处**

1. 高效 - More CPU cycles available for your code
2. 使用方便
- Blocks are easy to use
- Queues are inherently producer/consumer
3. Systemwide perspective
- Only the OS can balance unrelated subsystems

**兼容性**

1. Existing threading and synchronization primitives are 100% compatible
2. GCD threads are wrapped POSIX threads
- Do not cancel, exit, kill, join, or detach GCD threads
3. GCD reuses threads
- Restore any per-thread state changed within a block

**多线程**

**锁定资源**

1. 对关键资源进行互斥访问。
2. 在线程中按序访问共享资源。
3. Ensure data integrity

**Support**

[Apple Development Guide](https://developer.apple.com/library/mac/documentation/general/conceptual/concurrencyprogrammingguide/OperationQueues/OperationQueues.html#//apple_ref/doc/uid/TP40008091-CH102-SW1)



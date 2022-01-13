在书写webpack配置中，文件名字中会出现 [hash],[chunkhash],[contenthash]
是什么？
这三者分别代表什么含义，在什么时候使用
- hash：表示整个构建过程的唯一标识，重新打包就会生成新的hash
Q:如果是HMR，并没有从头开始构建流程，是否会生成新的hash
Q:hash值是怎么生成的，在什么节点生成的
- chunkhash:代表chunk中文件的变更，如果chunk中的文件没有发生变化，chunkhash不会变更
Q:chunk除了通过不同的entry生成，splitChunks，会生成chunk
- contenthash:表示一个单独的文件是否发生变更
Q:什么样的变更会引起contenthash的变更？

怎么用？
使用方式：[hash],[chunkhash],[contenthash]可以在打包过程中将对应的[hash值]填写上。

怎么生成的？
hash的生成是在打包过程中的什么环节，三种hash生成的时机是不同的。hash的生成算法是一个全领域互通的知识，这里不做过多的讨论。关键就是判断是否需要生成新的hash,比较什么，如何比较，这个就需要知道编译的详细细节。


刚开始看到代码中的这些hash，会有种排斥的感觉，觉得这样的代码有很大的阅读门槛。
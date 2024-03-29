webpack打包流程，一个感性的认识
1.加载配置项和命令行参数
2.初始化compiler对象，进行构建准备工作
3.处理入口文件和依赖项，对文件进行loader翻译，生成js文件
4.处理依赖项中的文件，并递归得到依赖关系图
5.对生成js文件并根据分块逻辑形成chunk，并执行相应plugin的操作
6.将打好包的文件根据配置的输出路径输出到文件系统中

Q：对loader的执行时机有些不确定
执行时机是在处理依赖项的时候，因为loader作用是翻译，处理依赖的项的时候就需要生成js代码了，所以翻译应该是在生成依赖图表之前


整个打包做的事就是一系列的文件，打进一个包，最后再把这个包通过**script**标签放入到 html文件中，我们可以通过这个html文件访问到我们的应用。
开始打包：因为编译器只认识js文件，所以需要loader对其他类型的文件进行翻译，所以最后输出的文件都是js文件。
当前进行完这一步也是可以的，但是为了可读性和一些性能优化的可能性，有一些可优化的地方
- 提取css文件到单独的文件
因为其他类型的文件杂糅在一起，css在js文件中，书写为对象形式，增加了文件体积，也减少了文件的可读性。需要拆分开，所以需要使用mini-css-extract-plugin插件，将css代码从js文件出来。之前使用的是 extract-text-webpack-plugin,webpack4+之后，不再支持这个写法。

Q:这个插件的执行时机到底是什么时候啊，配置的时候会在loader和plugin中都有配置，它的作用是不是不那么单纯？

- 提取公共模块
因为很多文件引用到同一个模块，如果不做任何的处理，就会发现在最后打包出来的结果中，一个模块会出现在很多包中，被重复进行计算，这个是不合理的。
webpack4之前提取公共模块是通过 CommonsChunkPlugin来实现的，webpack4+这个插件不可用了。现在提取公共模块放在 optimization.splitChunks 中进行配置。

- 对chunk进行拆分
因为所有文件杂糅在一起，修改一处，就会引起整个文件的变更。
一个文件太大，也会加重加载负担
所以需要对文件进行分块。分块的配置也是在 optimization.splitChunks 中进行配置

- 去掉没有使用到的代码 
去掉没有使用到的代码，也可以叫作 tree-shaking,如何删除掉未使用到的，具体可以查看tree shaking

- 压缩代码
打包出来的文件，占用的空间会比较大，使用压缩算法对代码进行压缩。webpack4-使用的压缩插件 uglifyjs-webpack-plugin.webpack4+ 可以使用webpack自带的压缩插件 terser, 通过optimization.minimize = true 进行开启，也可以在 optimization.minimizer = [new TerserPlugin({
    //配置项
}))]的形式来设置一些压缩配置项。

进行打包流程之后，会生成若干个js文件，需要将生成的js文件，引入到html文件中。实现这个放入的插件是 html-webpack-pligin

整个打包过程就是一个整合，拆分，重新整合的过程。

在第一次整合过程中，关键点是，应该是如何递归查找依赖项。使用loader对非js文件进行处理
拆分：提取css文件，提取公共模块，将比较大的文件按照一定规则进行切分。
重新整合：按照拆分的逻辑生成新的文件，对文件进行压缩，对不可用代码进行剔除
html注入依赖：将生成的文件通过**script**文件注入。这个时候注入的是文件的路径，真正的文件在开发环境中存在于内存中，生产环境存在于配置的文件路径中

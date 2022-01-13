webpack4+新增加了一种打包优化

tree-shaking是什么？
摇树算法，功能是在webpack打包过程中会将未使用到的代码进行剔除。从而缩小打包体积。

什么样的代码被认为是死代码？会被摇掉
1.导入但没有使用到的代码
整个被导入的模块也会被当作死代码
eg: import './index.js'

如何实现tree-shaking?在配置过程中的一些坑和注意点？
打开方式：
1.只有生产模式下可以开启tree shaking,因为tree shaking只发生在代码压缩过程中
2.optimization: {usedExports: true}这个配置项的含义是，识别出未被使用到的代码，并在最初的打包步骤中做上标记

坑1: tree shaking 只对通过import方式引入的模块有用，也就是commonjs 模块不可以进行tree shaking
因为commonjs的导入是静态的，一次性全部导入。
解决方案：使用esmodule方式写代码，第三方库也使用es版本的

坑2: 上面提到，对于整个被导入的模块会被当作死代码，所以全局样式文件，全局代码等会有被剔除的风险。
解决方案：显示声明具有副作用的文件
1.配置package.json文件中的sideEffects
true(def): 所有文件都有副作用，都不可以进行tree shaking
false: 所有文件都没有副作用
[文件路径数组]：直接列出可能具有副作用的文件，对除此之外的文件进行tree shaking
2.上面的文件还是没有办法解决全局样式文件的问题
配置module中对应css规则，单独设置，这里的设置会覆盖掉package.json文件中的设置
const config = {
    module: {
        rules: [
            {
                test: /\.css/,
                use: [loaders],
                sideEffects: true
            }
        ]
    }
}
3.babel为了兼容性的缘故，会将esmodule语法编译为 commonjs，但是tree shaking只能在esmodule中发生作用
解决方案：修改bable配置
const config = {
    preset: [
        [
            '[@babel/preset-env](http://twitter.com/babel/preset-env)',
            {
                modules: false //告诉babel不要编译模块代码
            }
        ]
    ]
}
4.对特定库做针对性优化
MomentJS
lodash
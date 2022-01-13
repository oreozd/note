
#### 项目属性
##### flex
flex: 1;设置这个属性之后，
表现为弹性容器被弹性项目均分，
是一个缩写写法表示 
flex-grow: 1; 有剩余空间的时候放大比例
flex-shrink: 1; 空间不足时候缩小比例
flex-basis: 0%; 计算剩余空间时，项目所占大小。

项目初始宽度为0，所以剩余宽度就是整个容器的宽度，所以可以实现平均分配。

还有很多单个属性
flex:initital; -> flex-grow: 0; flex-shrink: 1; flex-basis: auto;
flex:none; -> flex-grow: 0; flex-shrink: 0; flex-basis: auto;

##### order
表示弹性项目在弹性容器中的排列顺序，如果不写或者写相同的值，表示按照文档的顺序进行排列。
order的值可以是负数。
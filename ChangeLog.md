### TO DO:
1. 改画：应用跳进来时图片作背景呈现；图层需要保存和加载（序列化数据）； !important  加载的painting和设备尺寸不一样  

to do:
1. 转屏
2. painting文件的尺寸和本设备不相同
4. painting的flattenMode
5. 加入drawView对dirty部分rect的绘制
7. 插入图片后的撤销注册操作

bug:
4. 触摸其他popover后应该将当前popover消除

### UPDATED:
1. 修改Canvas的底色设置方式
2. 对screenScale的处理，可提高绘制清晰度
3. Canvas的绘制部分移入到CZCanvas中
4. 更新插入图片的编辑方式
5. 增加画笔大小调整
6. painting的DIC跳转 
7. painting的删除
8. 增加画布变幻复原的手势（双指双击）

- 2016-05-24
    1. 将interface相关的代码独立出来，放在本项目外
    2. 将core中的代码与glsl分开
    3. 删除陈旧代码（CZRender，CZCanvas_original...）

- 2016-05-26
    1. 完善内核的封装，将平台相关的中间层和某些组件封装到库里
    2. 将画布管理功能集成进HYBrushCore，剔除PaintingManager单例


### CORE:
1. CZCanvas不仅仅作为core调用view的接口，同时承担着canvas的实体功能，由view去调用。
2. CZLayer的背景图片绘制方法
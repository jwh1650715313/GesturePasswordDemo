
# 简介
GesturePasswordView是一个非常方便使用的Gesture Lock控件只需要简单的几步便可以在你的app中实现如安卓那样的手势解锁的效果。其实之前并不看好这种解锁的方式，不过上次发现支付宝iOS新版app中使用了这样的形式来进行功能的解锁，觉得也还方便

# 效果图

![九宫格解锁.gif](http://upload-images.jianshu.io/upload_images/1818626-16859665f17c8616.gif?imageMogr2/auto-orient/strip)

### 分析实现原理
>1.首先要自定义一个view(也就是GesturePasswordView)，因为要监听手指在View上的移动,最后必须重写：
touchesBegan
touchesMoved
touchesEnded
2.界面的实现【9宫格按钮】
3.创建一个类,自定义View,取名叫GesturePasswordView，然后创建9个按钮
4.监听手指的移动,准确来说是当手指移动到按钮的范围内,触发按钮,让按钮变亮具体细节如下
>>1.重写touchesBegan的方法
     获取当前触摸的点。
     循环判断当前触摸的点在哪个按钮的范围之内, 找到对一个的按钮之后, 把这个按钮的selected = YES。
     2.重写touchesmoved方法
        获取当前触摸的点。
        循环判断当前触摸的点在哪个按钮的范围之内, 找到对一个的 按钮之后, 把这个按钮的selected = YES。
        重绘，把选中的按钮链接起来调用[self setNeedsDisplay],重写- (void)drawRect:(CGRect)rect 方法
3.重写touchesEnded方法
   获得用户绘制的密码，并实现操作代码的业务

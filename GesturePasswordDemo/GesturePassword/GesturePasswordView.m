//
//  GesturePasswordView.m
//  GesturePasswordDemo
//
//  Created by 白石洲霍华德 on 2017/7/31.
//  Copyright © 2017年 景文浩. All rights reserved.
//

#import "GesturePasswordView.h"
#import "UIView+Extension.h"
#import "NSUserDefaultTools.h"

#define SteveZLineColor [UIColor colorWithRed:0.0 green:170/255.0 blue:255/255.0 alpha:1.0]




@interface GesturePasswordView ()


// 所有的按钮
@property (nonatomic, strong) NSArray* buttons;


// 所有选中的按钮
@property (nonatomic, strong) NSMutableArray* selectedButtons;


// 定义一个线的颜色
@property (nonatomic, strong) UIColor *lineColor;


// 记录最后用户触摸的点
@property (nonatomic, assign) CGPoint currentPoint;


@end






@implementation GesturePasswordView



//连起来的颜色
- (UIColor *)lineColor
{
    if (_lineColor == nil) {
        _lineColor = SteveZLineColor;
    }
    return _lineColor;
}


//被选中的按钮
- (NSMutableArray*)selectedButtons
{
    if (_selectedButtons == nil) {
        _selectedButtons = [NSMutableArray array];
    }
    return _selectedButtons;
}





- (void)layoutSubviews
{
    [super layoutSubviews];
 
    
     self.backgroundColor=[UIColor clearColor];
     [self SetButtonFrame];
    
}

//初始化所有的按钮
- (NSArray*)buttons
{
    if (_buttons == nil) {
        // 创建9个按钮
        NSMutableArray* arrayM = [NSMutableArray array];
        
        for (int i = 0; i < 9; i++) {
            UIButton *button=[[UIButton alloc]init];
            button.tag = i;
            
            button.userInteractionEnabled = NO;
            
            // 设置按钮的背景图片
            [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_error"] forState:UIControlStateDisabled];
            [self addSubview:button];
            [arrayM addObject:button];
        }
        _buttons = arrayM;
    }
    return _buttons;
}



-(void)SetButtonFrame
{
    // 设置每个按钮的frame
    CGFloat w = 74;
    CGFloat h = 74;
    // 列（和行）的个数
    int columns = 3;
    // 计算水平方向和垂直方向的间距
    CGFloat marginX = (self.frame.size.width - columns * w) / (columns + 1);
    CGFloat marginY = (self.frame.size.height - columns * h) / (columns + 1);
    
    // 计算每个按钮的x 和 y
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton* button = self.buttons[i];
        
        // 计算当前按钮所在的行号
        int row = i / columns;
        // 计算当前按钮所在的列索引
        int col = i % columns;
        
        CGFloat x = marginX + col * (w + marginX);
        CGFloat y = marginY + row * (h + marginY);
        
        button.frame = CGRectMake(x, y, w, h);
    }
}


//手势解锁的过程
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // 1. 获取当前触摸的点
    UITouch* touch = touches.anyObject;
    CGPoint loc = [touch locationInView:touch.view];
    
    // 2. 循环判断当前触摸的点在哪个按钮的范围之内, 找到对一个的按钮之后, 把这个按钮的selected = YES
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton* button = self.buttons[i];
        if (CGRectContainsPoint(button.frame, loc) && !button.selected) {
            button.selected = YES;
            [self.selectedButtons addObject:button];
            break;
        }
    }
    
}


- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    // 1. 获取当前触摸的点
    UITouch* touch = touches.anyObject;
    CGPoint loc = [touch locationInView:touch.view];
    
    self.currentPoint = loc;
    
    // 2. 循环判断当前触摸的点在哪个按钮的范围之内, 找到对一个的按钮之后, 把这个按钮的selected = YES
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton* button = self.buttons[i];
        if (CGRectContainsPoint(button.frame, loc) && !button.selected) {
            button.selected = YES;
            [self.selectedButtons addObject:button];
            break;
        }
    }
    
    // 3. 重绘
    [self setNeedsDisplay];
}

// 手指抬起事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1. 获取用户绘制的密码
    NSMutableString *password = [NSMutableString string];
    for (UIButton *button in self.selectedButtons) {
        [password appendFormat:@"%@", @(button.tag)];
    }
    
    NSLog(@"======%@",password);
    //获取本地的密码,第一个要确认的密码,一个每次都验证的密码
    

     NSString *Psd  = [NSUserDefaultTools getStringValueWithKey:@"Psd"];//第一次设置密码,需要验证的密码
     NSString *SavePsd  = [NSUserDefaultTools getStringValueWithKey:@"SavePsd"];//第二次设置密码
    
    
    if (Psd==nil) {//判断 有没有设置密码(这里存在输入第一次密码)
        
        //保存用户第一次绘制的密码
        [NSUserDefaultTools setStringValueWithKey:password key:@"Psd"];
        
        if ([self.delegate respondsToSelector:@selector(submitPsd:)]) {
            [self.delegate submitPsd:@"请设置第二次密码"];
        }
        [self clearPassd];
        
    }
    else{//第二次密码输入确定
        
        if ([password  isEqualToString:Psd] && SavePsd==nil) {//判断第二次输入的密码,和第一次是否相同,做第二次确定判断
            
            [NSUserDefaultTools setStringValueWithKey:password key:@"SavePsd"];
            
            
            if ([self.delegate respondsToSelector:@selector(submitPsd:)]) {
                [self.delegate submitPsd:@"手势解锁"];
            }
            [self clearPassd];
            
        }
        else{
            
            [self confirmPassWord:password];
            
            
        }
        
    }

    

    
}

//把选中的按钮绘制起来
- (void)drawRect:(CGRect)rect
{
    //    if (self.selectedButtons.count > 0) {
    //        // 需要绘图
    //    }
    
    if (self.selectedButtons.count == 0) return;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    // 循环获取每个按钮的中心点，然后连线
    for (int i = 0; i < self.selectedButtons.count; i++) {
        UIButton *button = self.selectedButtons[i];
        if (i == 0) {
            // 如果是第一个按钮, 那么就把这个按钮的中心点作为起点
            [path moveToPoint:button.center];
        } else {
            [path addLineToPoint:button.center];
        }
    }
    
    // 把最后手指的位置和最后一个按钮的中心点连起来
    [path addLineToPoint:self.currentPoint];
    
    // 设置线条颜色
    [self.lineColor set];
    
    
    // 渲染
    [path stroke];
    
}


//清楚密码
- (void)clearPassd
{
    // 先将所有selectedButtons中的按钮的selected 设置为NO
    for (UIButton *button in self.selectedButtons) {
        button.selected = NO;
        button.enabled = YES;
    }
    self.lineColor = SteveZLineColor;
    
    // 移除所有的按钮
    [self.selectedButtons removeAllObjects];
    
    
    // 重绘
    [self setNeedsDisplay];
}



//那边控制器得到参数,比较完后,然后通过代理返回过来
- (void)confirmPassWord:(NSString *)password{
    // 2. 通过代理, 把密码传递给控制器, 在控制器中判断密码是否正确
    if ([self.delegate respondsToSelector:@selector(GesturePasswordView:withPassword:)]) {
        // 判断密码是否正确
        if ([self.delegate GesturePasswordView:self withPassword:password]) {
            // 密码正确
            [self clearPassd];
        } else {
            // 密码不正确
            // 1. 重绘成红色效果
            // 1.1 把selectedButtons中的每个按钮的selected = NO, enabled = NO
            for (UIButton *button in self.selectedButtons) {
                button.selected = NO;
                button.enabled = NO;
            }
            
            // 1.2 设置线段颜色为红色
            self.lineColor = [UIColor redColor];
            
            // 1.3 重绘
            [self setNeedsDisplay];
            
            
            // 禁用与用户的交互
            self.userInteractionEnabled = NO;
            
            
            // 2. 等待0.5秒中, 然后再清空
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self clearPassd];
                self.userInteractionEnabled = YES;
            });
        }
    } else {
        [self clearPassd];
    }
    
    
    
    
    
    
    
}



@end

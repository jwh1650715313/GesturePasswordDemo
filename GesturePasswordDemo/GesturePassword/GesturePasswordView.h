//
//  GesturePasswordView.h
//  GesturePasswordDemo
//
//  Created by 白石洲霍华德 on 2017/7/31.
//  Copyright © 2017年 景文浩. All rights reserved.
//

#import <UIKit/UIKit.h>



@class GesturePasswordView;
@protocol GesturePasswordViewDelegate <NSObject>



- (void)submitPsd:(NSString *)toast;//验证密码成功

//那边控制器得到参数,比较完后,然后通过代理返回过来
-(BOOL)GesturePasswordView:(GesturePasswordView *)gesturePasswordView
              withPassword:(NSString *)password;


@end



@interface GesturePasswordView : UIView



@property (nonatomic, weak)id<GesturePasswordViewDelegate>  delegate;


@end

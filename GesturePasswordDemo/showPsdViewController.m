//
//  showPsdViewController.m
//  GesturePasswordDemo
//
//  Created by 白石洲霍华德 on 2017/7/31.
//  Copyright © 2017年 景文浩. All rights reserved.
//

#import "showPsdViewController.h"
#import "GesturePasswordView.h"
#import "NSUserDefaultTools.h"
#define KSCREENW [UIScreen mainScreen].bounds.size.width

#define KSCREENH [UIScreen mainScreen].bounds.size.height


@interface showPsdViewController ()<GesturePasswordViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PsdWordViewLeft;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PsdWordViewTop;

@property (weak, nonatomic) IBOutlet UIView *PsdWordView;


@property (weak, nonatomic) IBOutlet UILabel *TopToast;

//标记是否是重置密码
@property(nonatomic ,assign,getter=isresetpassword)BOOL resetpassword;
@end

@implementation showPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
     [self CustomView];
    
    
}


-(void)CustomView
{
    
    self.resetpassword=NO;
    self.PsdWordViewLeft.constant=(KSCREENW-300)/2;
    self.PsdWordViewTop.constant=(KSCREENH-300)/2;
    
    
    GesturePasswordView  *lockview=[[GesturePasswordView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    lockview.delegate=self;
    [self.PsdWordView addSubview:lockview];
}




//显示的的Toast
-(void)submitPsd:(NSString *)toast
{
    self.TopToast.text=toast;
}


-(BOOL)GesturePasswordView:(GesturePasswordView *)gesturePasswordView withPassword:(NSString *)password
{
   
     NSString *Psd = [NSUserDefaultTools getStringValueWithKey:@"Psd"];//每次验证的密码
  
    if ([password isEqualToString:Psd]) {//做密码的验证,无论是改密码,还是二次确认密码都拿第一个“newPsd”做判断
        
        
        if (self.resetpassword) {//判断是否重新设置密码

            self.TopToast.text=@"设置新密码";
            self.resetpassword=NO;
            [NSUserDefaultTools setStringValueWithKey:nil key:@"Psd"];
            [NSUserDefaultTools setStringValueWithKey:nil key:@"SavePsd"];

        
        }
        else{
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        
    
         return YES;
      
        
    }
    
    

    return NO;
    
    
    
}


- (IBAction)SetPsdWord:(id)sender {
    
    
    self.TopToast.text=@"确认旧手势密码";
    
     self.resetpassword=YES;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

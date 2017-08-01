//
//  ViewController.m
//  GesturePasswordDemo
//
//  Created by 白石洲霍华德 on 2017/7/31.
//  Copyright © 2017年 景文浩. All rights reserved.
//

#import "ViewController.h"
#import "showPsdViewController.h"
@interface ViewController ()




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    

    
    
   
   
    
    
    
    
    
}




- (IBAction)Action:(id)sender {
    
    
    showPsdViewController *lockController = [[showPsdViewController alloc]init];
    [self presentViewController:lockController animated:YES completion:nil];
    
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

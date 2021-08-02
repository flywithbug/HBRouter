//
//  ViewController02.m
//  Example_swift
//
//  Created by flywithbug on 2021/7/27.
//

#import "ViewController02.h"
#import <HBRouter/HBRouter-Swift.h>

@interface ViewController02 ()

@end

@implementation ViewController02

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"objective-C 02";
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = UIColor.blueColor.CGColor;
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"跳转到01页面" forState:UIControlStateNormal];
    
    btn.frame = CGRectMake(100, 100, 200, 40);
    [btn setTitleColor: UIColor.blackColor forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
}


- (void)btnAction:(UIButton *)sender{
    HBRouterAction *action = [[HBRouterAction alloc]initWithPath:@"vc_01_oc"];
    action.isSingleton = YES;
    [HBRouter.router openRouterAction:action];
    
}

@end

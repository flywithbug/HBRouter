//
//  ViewController.m
//  HBRouter
//
//  Created by flywithbug on 2021/7/6.
//

#import "ViewController.h"
#import <HBRouter/HBRouter-Swift.h>

@interface ViewController ()

@end

@implementation ViewController
- (BOOL)handleRouterAction:(HBRouterAction *)action{
    return [super handleRouterAction:action];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.redColor;
}


@end

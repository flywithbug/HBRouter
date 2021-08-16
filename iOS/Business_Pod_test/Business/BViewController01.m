//
//  BViewController01.m
//  Pods
//
//  Created by flywithbug on 2021/7/27.
//

#import "BViewController01.h"
#import <HBrouter/HBRouter-Swift.h>
@interface BViewController01 ()

@end

@implementation BViewController01

- (BOOL)handleRouterAction:(HBRouterAction *)action{
    NSLog(@"from:%@",action.from);
    NSLog(@"current:%@",action.current);
//    NSLog(@"next:%@",action.next);
    return  [super handleRouterAction:action];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.systemBlueColor;
    self.title = @"bvc_02_oc";
}

@end

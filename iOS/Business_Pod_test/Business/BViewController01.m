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
    
    return  [super handleRouterAction:action];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.grayColor;
}

@end

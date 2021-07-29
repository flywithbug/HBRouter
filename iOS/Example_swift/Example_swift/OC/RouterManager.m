//
//  RouterManager.m
//  Example_swift
//
//  Created by flywithbug on 2021/7/27.
//

#import "RouterManager.h"
#import <HBRouter/HBRouter-Swift.h>


@implementation RouterManager

+ (void)registRouter{
    
    [[HBRouter router]registRouter:@"hb"
                           mapping:@{@"vc_02_oc":@"ViewController02"}
                            bundle:@""
                              host:@"router.com" targetType:HBTargetTypeController];
    
}


+ (void)actionTest{
    NSURL *url = [NSURL URLWithString:@"https:www.baidu.com"];
    HBRouterAction *action = [[HBRouterAction alloc]initWithUrl:url];
    [action setOpenStateBlock:^(BOOL success) {
        
    }];
    
    [action addValue:@"1" key:@"a"];
    NSLog(@"params:%@",action.params);
    
}




@end

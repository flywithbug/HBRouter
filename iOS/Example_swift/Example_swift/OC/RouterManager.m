//
//  RouterManager.m
//  Example_swift
//
//  Created by flywithbug on 2021/7/27.
//

#import "RouterManager.h"
#import <HBRouter/HBRouter-Swift.h>
#import "Example_swift-Swift.h"
#import "HBBaseNavigationController.h"


@interface RouterManager ()

@end

@implementation RouterManager


//01控制器需要的Data
+ (NSArray *)loadDataSource01{
    NSMutableArray *dataSource = [NSMutableArray new];
    HBRouterAction *action = [[HBRouterAction alloc]initWithPath:@"login"];
    action.option = HBRouterOptionPresent;
    action.wrapNavgClass = HBBaseNavigationController.class;
    action.useExistingPage = true;

    [HBRouter.shared openRouterAction:action];
    ItemModel *item = [[ItemModel alloc]initWithAction:action title:@"" subTitle:@""];
    [dataSource addObject:item];
    
    
    action = [[HBRouterAction alloc]initWithPath:@"vc_01_oc"];
    action.useExistingPage = true;
    [HBRouter.shared openRouterAction:action];
    item = [[ItemModel alloc]initWithAction:action title:@"" subTitle:@""];
    
    
    
    return  dataSource;
}


+ (void)registRouter{
    
    [[HBRouter shared]registRouter:@"hb"
                           mapping:@{@"vc_02_oc":@"ViewController02"}
                            bundle:@""
                              host:@"router.com" targetType:HBTargetTypeController];
    
}


+ (void)actionTest{
    NSURL *url = [NSURL URLWithString:@"https:www.baidu.com"];
    HBRouterAction *action = [[HBRouterAction alloc]initWithUrl:url];
    [action setOpenCompleteBlock:^(BOOL success) {
        
    }];
    
    [action addValue:@"1" key:@"a"];
    NSLog(@"params:%@",action.params);
    
}




@end

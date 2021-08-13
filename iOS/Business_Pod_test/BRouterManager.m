//
//  BRouterManager.m
//  Business_Pod_test
//
//  Created by flywithbug on 2021/7/27.
//

#import "BRouterManager.h"
#import <HBRouter/HBRouter-Swift.h>

@interface BRouterManager ()

@end

@implementation BRouterManager


static BRouterManager *manager = nil;

+ (instancetype)shared{
    if(!manager){
        manager = [BRouterManager new];
    }
    return  manager;
}
- (instancetype)init{
    self = [super init];
    if (self) {
       
    }
    return  self;
}

+ (void)registRouter{
    [BRouterManager shared];
    [[HBRouter shared]registRouter:@{
        @"b_vc01_oc":@"BViewController01"
    } bundleClass:self.class];
}




@end

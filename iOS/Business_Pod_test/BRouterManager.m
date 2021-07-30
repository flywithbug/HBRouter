//
//  BRouterManager.m
//  Business_Pod_test
//
//  Created by flywithbug on 2021/7/27.
//

#import "BRouterManager.h"
#import <HBRouter/HBRouter-Swift.h>

@interface BRouterManager ()<HBRouterDelegate>

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
        [HBRouter router].deleage = self;
    }
    return  self;
}

+ (void)registRouter{
    [BRouterManager shared];
    [[HBRouter router]registRouter:@{} bundle:self.class];
}




- (void)didOpenExternal:(HBRouterAction * _Nonnull)action {
    
}

- (void)didOpenRouter:(HBRouterAction * _Nonnull)action {
    
}

- (BOOL)loginStatus:(HBRouterAction * _Nonnull)action completion:(void (^ _Nullable)(BOOL))completion {
    return  true;
}


- (void)onMatchUnhandleRouterAction:(HBRouterAction * _Nonnull)action {
    
}

- (void)openExternal:(HBRouterAction * _Nonnull)action completion:(void (^ _Nullable)(BOOL))completion {
  
}

- (BOOL)shouldOpenExternal:(HBRouterAction * _Nonnull)action {
    return  true;
}

- (BOOL)shouldOpenRouter:(HBRouterAction * _Nonnull)action {
    return  true;
}

- (void)willOpenExternal:(HBRouterAction * _Nonnull)action {
    
}

- (void)willOpenRouter:(HBRouterAction * _Nonnull)action {
    
}

- (void)onMatchRouterAction:(HBRouterAction * _Nonnull)action any:(id _Nullable)any {
    
}


@end

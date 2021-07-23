//
//  HBRouterDefinition.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/6.
//

import Foundation


extension  NSObject {
    public class func swizzleMethod(for aClass:AnyClass, originalSelector:Selector,swizzledSelector:Selector){
        let originalMethod = class_getInstanceMethod(aClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector)

        let didAddMethod = class_addMethod(aClass, originalSelector,
                                           method_getImplementation(swizzledMethod!),
                                           method_getTypeEncoding(swizzledMethod!))
        if didAddMethod {
           class_replaceMethod(aClass, swizzledSelector,
                               method_getImplementation(originalMethod!),
                               method_getTypeEncoding(originalMethod!))
        } else {
           method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
}




class HBRSwizzleManager:NSObject {
    private static let shareManager:HBRSwizzleManager = {
        let shared = HBRSwizzleManager.init()
        return shared
    }()
    
    private override init(){
//        UINavigationController.initializeMethod()
//        UIViewController.initializeVCMethod()
    }
    
    @discardableResult
    public class func shared() -> HBRSwizzleManager{
        return shareManager
    }
}
















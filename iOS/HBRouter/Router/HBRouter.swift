//
//  HBRouter.swift
//  Pods
//
//  Created by flywithbug on 2021/7/6.
//

import UIKit



@objcMembers open class HBRouter:HBNavigator  {
    
    private static let shareInstance = HBRouter()
    private override init() {
        super.init()
    }
    public static func shared() -> HBRouter{
        return shareInstance
    }
    
    @discardableResult
    public func open(url:URL) -> Any? {
        let action = HBRouterAction.init(url: url)
        return openRouterAction(action)
    }
    
    @discardableResult
    public func open(urlPattern:routerURLPattern) -> Any? {
        let action = HBRouterAction.init(urlPattern: urlPattern)
        return openRouterAction(action)
    }
    @discardableResult
    public func open(action:HBRouterAction) -> Any? {
        return openRouterAction(action)
    }
    
    @discardableResult
    public func open(path:routerPath) -> Any? {
        let action = HBRouterAction.init(path: path)
        return openRouterAction(action)
    }
    
}


extension UIViewController{
    
    @discardableResult
    @objc public func openRouterAction(_ action:HBRouterAction)  -> Any?{
        return HBRouter.shared().openRouterAction(action)
    }
    
    @discardableResult
    @objc public func open(url:URL) -> UIViewController? {
        let action = HBRouterAction.init(url: url)
        return HBRouter.shared().openRouterAction(action) as? UIViewController
    }
    
    @discardableResult
    @objc public func open(urlPattern:routerURLPattern) -> Any? {
        let action = HBRouterAction.init(urlPattern: urlPattern)
        return openRouterAction(action)
    }
    @discardableResult
    @objc public func open(action:HBRouterAction) -> Any? {
        return openRouterAction(action)
    }
    
    @discardableResult
    @objc public func open(path:routerPath) -> Any? {
        let action = HBRouterAction.init(path: path)
        return openRouterAction(action)
    }
    
    
}

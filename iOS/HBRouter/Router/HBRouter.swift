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
    func open(_ url:URL) -> UIViewController? {
        let action = HBRouterAction.init(url: url)
        return HBRouter.shared().openRouterAction(action) as? UIViewController
    }
    
    
}

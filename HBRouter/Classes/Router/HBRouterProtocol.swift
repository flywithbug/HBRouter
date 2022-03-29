//
//  HBRouterProtocol.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/19.
//

import Foundation



@objc
public protocol HBRouterDelegate:AnyObject {
    
    //router权限校验及调用生命周期
    //登录态判断及状态回调
    func loginStatus(_ action:HBRouterAction, completion: ((Bool) -> Void)?) -> Bool
    
    //路由权限校验
    func shouldOpenRouter(_ action:HBRouterAction) -> Bool
   
    //路由打开状态
    func willOpenRouter(_ action:HBRouterAction)
    func didOpenRouter(_ action:HBRouterAction)
    
    
    
    //外链判断
    func shouldOpenExternal(_ action:HBRouterAction) -> Bool
    
    //外链打开状态
    func willOpenExternal(_ action:HBRouterAction)
    
    //处理外链打开逻辑，不实现本方法，则使用默认
    func openExternal(_ action:HBRouterAction, completion: ((Bool) -> Void)?)
    func didOpenExternal(_ action:HBRouterAction)
    
    
    //未能匹配到的路由回调
    func onMatchUnhandleRouterAction(_ action:HBRouterAction)
    //路由匹配成功回调
    func onMatchRouterAction(_ action:HBRouterAction, any:Any?)
    
    
    
}

//
//  HBRouterProtocol.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/19.
//

import Foundation



@objc
public protocol HBRouterDelegate:class {
    
    //router权限校验及调用生命周期
    //登录态判断及状态回调
    func loginStatus(_ action:HBRouterAction, completion: ((Bool) -> Void)?) -> Bool
    
    func shouldOpenRouter(_ action:HBRouterAction) -> Bool
    func willOpenRouter(_ action:HBRouterAction)
    func didOpenRouter(_ action:HBRouterAction)
    
    
    //外链判断
    func shouldOpenExternal(_ action:HBRouterAction) -> Bool
    //打开外链
    func willOpenExternal(_ action:HBRouterAction)
    func openExternal(_ action:HBRouterAction, completion: ((Bool) -> Void)?)
    func didOpenExternal(_ action:HBRouterAction)
    
    //未能打开的Router回调
    func onMatchUnhandleRouterAction(_ action:HBRouterAction)
    //页面打开回调
    func onMatchRouterAction(_ action:HBRouterAction, any:Any?)
    
    
    
}

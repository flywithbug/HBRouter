//
//  HBURLAction.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/6.
//

import Foundation



//原生路由跳转 Action
open class HBRouterAction {
    //默认转场为push
    var options:[HBRouterOptions] = [.push]
    private(set) var params:Dictionary<String,Any> = [:]
    var animation:Bool = true
    
    //转场或者调用完成
    var completionBlock:((Bool)->Void)? = nil
    
    //回调
    var callBackBlock:((Any)->Void)? = nil
    
    
    
}

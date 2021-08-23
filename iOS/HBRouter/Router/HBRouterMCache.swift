//
//  HBRouterMCache.swift
//  HBRouter
//
//  Created by flywithbug on 2021/8/9.
//

import Foundation



@objcMembers class  HBRouterMCache: NSObject {
    private static let shareInstance = HBRouterMCache()
    private override init() {
        super.init()
    }
    public static func shared() -> HBRouterMCache{
        return shareInstance
    }

    public private(set)  var defaultRouterHost:String!
    public private(set)  var defaultRouterScheme:String!
    public func setDefault(_ scheme:routerScheme,host:routerHost) {
        if defaultRouterHost != nil || defaultRouterScheme != nil  {
            #if DEBUG
            assert(false, "HBRouter::::重复设置 默认host和scheme......")
            #else
            #endif
        }
        defaultRouterHost = host
        defaultRouterScheme = scheme
    }
    
    
    
    
    
    
    
    
}

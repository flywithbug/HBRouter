//
//  HBRouter.swift
//  Pods
//
//  Created by flywithbug on 2021/7/6.
//

import Foundation


open class HBRouter:HBNavigator  {
    
    private static let shareInstance = HBRouter()
    private override init() {
        super.init()
    }
    public static func router() -> HBRouter{
        return shareInstance
    }
    
}

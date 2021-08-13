//
//  Models.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/7.
//

import Foundation

@objcMembers public class HBRouterResponse:NSObject {
    //默认-标识成功
    public private(set) var code:Int = 0
    public private(set) var msg:String = ""
    //返回值
    public private(set) var data:Any?
    public private(set) var action:HBRouterAction
    
    @objc
    public init(_ action:HBRouterAction,data:Any? = nil,msg:String = "", code:Int = 0){
        self.code = code
        self.data = data
        self.msg = msg
        self.action = action
    }
}


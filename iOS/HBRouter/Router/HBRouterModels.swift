//
//  Models.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/7.
//

import Foundation

open class HBRouterResponse {
    //默认-标识成功
    var code:Int = 0
    var msg:String = ""
    //返回值
    var data:Any?
}

//
//  HBRouterDefinition.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/6.
//

import Foundation

@objc public enum HBTargetType:Int {
    //未定义
    case undefined  = 0
    //原生
    case controller = 1   //路由

    //flutter
    case flutter = 2   //路由
    case bridge     = 3    //功能调用
    
    
}

@objc public enum  HBRouterOption : Int{
    case push = 0
    case present //优先级最高
    
    //present时添加导航控制器
    case wrap_nc
    
    //强制全屏
    case fullScreen
    
}




public func Dlog(_ item: Any, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    #if DEBUG
        print( "file:\(file)\tline:\(line)\t function:\(function)\n" , item)
    #else
    #endif
}

//
//  HBRouterDefinition.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/6.
//

import Foundation

public enum HBTargetType {
     case undefined
     case controller //路由
     case bridge //功能调用
}


public enum  HBRouterOptions : Int{
    case push = 0
    case present
    
    //present时添加导航控制器
    case wrap_nc
    
    //强制全屏
    case fullScreen
}


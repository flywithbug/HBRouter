//
//  HBRouterDefinition.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/6.
//

import Foundation

public enum HBTargetType:Int {
    
    //未定义
    case undefined  = 0
    //原生
    case controller = 1   //路由

    //flutter
    case flutter = 2   //路由
    case bridge     = 3    //功能调用
    
    
}


public enum  HBRouterOptions : Int{
    case push = 0
    case present
    
    //present时添加导航控制器
    case wrap_nc
    
    //强制全屏
    case fullScreen
}


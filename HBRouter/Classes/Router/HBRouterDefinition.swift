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
    case controller = 1
    //bridge调用 
    case bridge     = 2
    

}

@objc public enum  HBRouterOption : Int{
    case push = 0
    case present //优先级最高
    //present时添加导航控制器
    case wrap_nc
    
    //强制全屏
    case fullScreen
    
}




public func Dlog(_ value: Any, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    #if DEBUG
    var stringRepresentation: String?
    if let value = value as? CustomDebugStringConvertible {
        stringRepresentation = value.debugDescription
    }
    else if let value = value as? CustomStringConvertible {
        stringRepresentation = value.description
    }
    else {
        fatalError("gLog only works for values that conform to CustomDebugStringConvertible or CustomStringConvertible")
    }
    let gFormatter = DateFormatter()
    gFormatter.dateFormat = "HH:mm:ss:SSS"
    let timestamp = gFormatter.string(from: Date())
    let queue = Thread.isMainThread ? "Main" : "BG"
    let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
    
    if let string = stringRepresentation {
        print("✅ \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]: \(string)")
    } else {
        print("✅ \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]: \(value)")
    }

    #else
    #endif
}

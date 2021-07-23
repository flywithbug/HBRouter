//
//  StringExtension.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/8.
//

import Foundation

public let HBRouterAppName =  Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String?



public func  HBClassFromString(string: String)-> AnyClass?{
    let stringName = HBRouterAppName! + "." + string
    return NSClassFromString(stringName)
}

public func  HBClassFromString(string: String,_bundleClass:AnyClass)-> AnyClass?{
    let stringName = HBBundleNameFromClass(_class: _bundleClass) + "." + string
    return NSClassFromString(stringName)
}

public func  HBClassFromString(string: String,bundle:String)-> AnyClass?{
    let cla: AnyClass? = NSClassFromString(string)
    if cla != nil {
        return cla
    }
    let stringName = bundle + "." + string
    return NSClassFromString(stringName)
}

public func HBBundleNameFromClass(_class: AnyClass) -> String {
    let bundleName = String(NSStringFromClass(_class).split(separator: ".")[0])
    return bundleName
}

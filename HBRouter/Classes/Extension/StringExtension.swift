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
    if let  bundClass = HBBundleNameFromClass(_class: _bundleClass) {
        let stringName = bundClass + "." + string
        return NSClassFromString(stringName)
    }
    return nil
}

public func  HBClassFromString(string: String,bundle:String)-> AnyClass?{
    let cla: AnyClass? = NSClassFromString(string)
    if cla != nil {
        return cla
    }
    let stringName = bundle + "." + string
    return NSClassFromString(stringName)
}

public func HBBundleNameFromClass(_class: AnyClass?) -> String? {
    guard let _class = _class else {
        return nil
    }
    let splits =  NSStringFromClass(_class).split(separator: ".")
    if splits.count == 2{
        let bundleName = String(splits[0])
        return bundleName
    }
    if splits.count == 1 {
        assert(false, "无法获取 bundle name")
    }
    return nil
}

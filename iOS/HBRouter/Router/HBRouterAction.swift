//
//  HBURLAction.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/6.
//

import Foundation

//原生路由跳转 Action
open class HBRouterAction {
    //默认转场为push
    public var options:[HBRouterOptions] = [.push]
    public private(set) var params:Dictionary<String,Any> = [:]
    
    public var target:HBRouterTarget?
    
    //转场动画
    public var animation:Bool = true
    //转场或者调用完成
    public var completeBlock:((Bool)->Void)? = nil
    //回调
    public var callBackBlock:((Any?)->Void)? = nil
    
    public private(set) var url:URL?

    
    public var scheme:String?
    public var path:String?
    public var host:String?
    
    public init(url:URL) {
        initt(url: url)
    }
    
    
    
    
    public init(urlString:String){
        guard let _url = URL.init(string: urlString) else {
            return
        }
        initt(url: _url)
        
    }

    private func initt(url:URL){
        self.url = url
        scheme = url.scheme
        host = url.host
        path = url.path
        
        guard let para = url.queryParameters else {
            return
        }
        for item in para{
            params[item.key] = item.value
        }
    }
}

extension HBRouterAction{
    
    public func setCompleteBlock(_ block: @escaping ((Bool) -> Void)){
        self.completeBlock = block
    }
    
    public func setCallBackBlock(_ block: @escaping ((Any?) -> Void)){
        self.callBackBlock = block
    }
    
    
    public func addEntriesFromDictonary(_ entries:Dictionary<String,Any>){
        for item in entries{
            self.params[item.key] = item.value
        }
    }
    
    public func addParamsFromURLAction(routerAction:HBRouterAction) {
        self.addEntriesFromDictonary(routerAction.params)
    }
    
    //any nil时，删除对应Key的Value值
    public func setValue(_ key:String,value:Any?){
        self.params[key] = value
    }
    
    public func any(_ key:String)-> Any?{
        return self.params[key]
    }
    
    
    public func int(_ key:String)->Int?{
        return intValue(any(key))
    }
    public func double(_ key:String)->Double?{
        return doubleValue(any(key))
    }
    public func number(_ key:String)->NSNumber?{
        return numberValue(any(key))
    }
    public func string(_ key:String)->String?{
        return stringValue(any(key))
    }
    public func bool(_ key:String)->Bool?{
        return boolValue(any(key))
    }
    
    
    
    
    //类型自动化转换
    private func intValue(_ value:Any?) -> Int? {
        if let val = value as? Int{
            return val
        }
        if let val = value as? Bool{
            return val ? 1 : 0
        }
        
        if let val = value as? Double {
            return Int(val)
        }
        
        if let val = value as? NSNumber {
            return Int(val.intValue)
        }
        if let val = value as? String {
            return Int(val) ?? 0
        }
        return nil
    }
    
    private func doubleValue(_ value:Any?) -> Double? {
        if let val = value as? Double {
            return val
        }
        if let val = value as? Int{
            return Double(val)
        }
        if let val = value as? Bool{
            return val ? 1 : 0
        }
        if let val = value as? NSNumber {
            return val.doubleValue
        }
        if let val = value as? String {
            return Double(val)
        }
        return nil
    }
    
    
    private func stringValue(_ value:Any?) -> String? {
        if let val = value as? String {
            return val
        }
        if let val = value as? Double{
            return String.init(val)
        }
        if let val = value as? NSNumber {
            return val.stringValue
        }
        if let val = value as? Bool{
            return val ? "1" : "0"
        }
        if let val = value as? Int{
            return String.init(val)
        }
        return nil
    }
    
    private func numberValue(_ value:Any?) -> NSNumber? {
        if let val = value as? NSNumber {
            return val
        }
        if let val = value as? Int{
            return  NSNumber(value:val)
        }
        if let val = value as? Double{
            return NSNumber(value:val)
        }
        if let val = value as? Bool{
            return val ? 1 : 0
        }
        if let val = value as? String {
            if let val = Double(val) {
                return NSNumber(value: val)
            }
            return nil
        }
        return nil
    }
    private func boolValue(_ value:Any?) -> Bool?{
        if let val = value as? Bool{
            return val
        }
        return numberValue(value)?.boolValue
    }
}




//导航跳转Target
open class HBRouterTarget {
    public var  scheme:String  //scheme
    public var  host:String
    public var  path:String   //
    public var  target:String
    public var  targetClass:AnyClass?
    public var  bundle:String  //注册路由所属bundle name
    
    //target 调用类型
    public var  targetType:HBTargetType

    init(scheme:String,host:String,path:String,target:String,bundle:String,targetType:HBTargetType = .undefined) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.target = target
        self.bundle = bundle
        self.targetClass =  HBClassFromString(string: target,bundle: bundle)
        self.targetType = targetType
        if self.targetClass is UIViewController.Type{
            self.targetType = .controller
        }
    }
}





extension UIViewController {
    private struct AssociatedKey {
        static var routerActionIdentifier: String = "routerActionIdentifier"
    }
    public var routerAction:HBRouterAction?{
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.routerActionIdentifier) as? HBRouterAction
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.routerActionIdentifier, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setURLAction(urlAction:HBRouterAction) {
        self.routerAction = urlAction
    }
    
    convenience init(urlAction:HBRouterAction) {
        self.init()
        self.routerAction = urlAction
        
    }
}




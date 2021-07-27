//
//  HBURLAction.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/6.
//

import UIKit

//原生路由跳转 Action

@objcMembers  open class HBRouterAction:NSObject {
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
        super.init()
        self.initt(url: url)
    }
    
    
    public init(_ scheme:routerScheme,host:routerHost,path:routerPath){
        super.init()
        self.scheme = scheme
        self.host = host
        self.path = path
        
        if scheme.hasSuffix("://") {
            self.scheme = String(scheme.prefix(scheme.count - 3))
        }
        if host.hasSuffix("/") {
            self.host = String(host.prefix(host.count - 1))
        }
        if !path.hasPrefix("/") {
            self.path =  "/\(path)"
        }
        if path.hasSuffix("/") {
            self.path = String(host.prefix(path.count - 1))
        }
        self.url = URL.init(string: "\(scheme)://\(host)\(path)")
    }
    
    public  init(urlPattern:routerURLPattern){
        super.init()
        guard let _url = URL.init(string: urlPattern) else {
            //bh://router.com/path
            //hb://router.com
            //hb://
            assert(false, "不符合 urlPatter规则")
            return
        }
        self.initt(url: _url)
        
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
    
    
    public func routerURLPattern() -> routerURLPattern?{
        if let scheme = scheme {
            if let host = host {
                if let path = path {
                    return "\(scheme)://\(host)/\(path)"
                }
                return "\(scheme)://\(host)"
            }
            return scheme
        }
        return nil
    }
}

extension HBRouterAction{
    
//    public func setCompleteBlock(_ block: @escaping ((Bool) -> Void)){
//        self.completeBlock = block
//    }
//    
//    public func setCallBackBlock(_ block: @escaping ((Any?) -> Void)){
//        self.callBackBlock = block
//    }
    
    public func addEntriesFromDictonary(_ entries:Dictionary<String,Any>){
        for item in entries{
            self.params[item.key] = item.value
        }
    }
    
    
    public func addParamsFromURLAction(routerAction:HBRouterAction) {
        self.addEntriesFromDictonary(routerAction.params)
    }
    
    //any nil时，删除对应Key的Value值

    public func addValue(_ value:Any?, key:String?){
        if key == nil {
            return
        }
        self.params[key!] = value
    }
    
    public func any(_ key:String)-> Any?{
        return self.params[key]
    }
    
    public func intValue(_ key:String)->Int?{
        return intValue(any(key))
    }
    
    public func doubleValue(_ key:String)->Double?{
        return doubleValue(any(key))
    }
    
    public func numberValue(_ key:String)->NSNumber?{
        return numberValue(any(key))
    }
    
    public func stringValue(_ key:String)->String?{
        return stringValue(any(key))
    }
    
    public func boolValue(_ key:String)->Bool?{
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
@objcMembers  open class HBRouterTarget:NSObject {
    public var  scheme:String  //scheme
    public var  host:String
    public var  path:String   //
    public var  target:String
    public var  targetClass:AnyClass?
    public var  bundle:String  //注册路由所属bundle name
    public var  url:URL?
    public func routerURLPattern() -> routerURLPattern{
        return "\(scheme)://\(host)\(path)"
    }
    //target 调用类型
    public var  targetType:HBTargetType

    
    /// 规则定义
    /// - Parameters:
    ///   - scheme: hb://  & hb   &   https://  & http
    ///   - host: router.com
    ///   - path: /home/page/detail
    ///   - target: 目标类
    ///   - bundle: 目标类所在库的库名
    ///   - targetType: 目标类能力类型
    init(scheme:String,host:String,path:String,target:String,bundle:String,targetType:HBTargetType = .undefined) {
        self.scheme = scheme
        if scheme.hasSuffix("://") {
            self.scheme = String(scheme.prefix(scheme.count - 3))
        }
        self.host = host
        if host.hasSuffix("/") {
            self.host = String(host.prefix(host.count - 1))
        }
        self.path = path
        if path.hasSuffix("/") {
            self.path = String(self.path.prefix(self.path.count - 1))
        }
        if !path.hasPrefix("/"){
            self.path = "/\(self.path)"
        }
        self.target = target
        self.bundle = bundle
        self.targetType = targetType
        
        super.init()
        
        if let _url = URL.init(string: routerURLPattern()) {
            self.url = _url
        }else{
           assert(false, "\(routerURLPattern()) 注册规则不正确，请检查注册元数据")
        }
        if let target =  HBClassFromString(string: target,bundle: bundle){
            self.targetClass = target
            if targetType == .undefined {
                if self.targetClass is UIViewController.Type{
                    self.targetType = .controller
                }
            }
        }else{
            #if DEBUG
            assert(false, "target 类型无法获取，请检查注册对象")
            #else
            #endif
           
        }
        
        
    }
}





extension UIViewController {
    private struct AssociatedKey {
        static var routerActionIdentifier: String = "routerActionIdentifier"
        static var routerSchemeIdentifier: String = "routerSchemeIdentifier"
    }
    @objc
    public var routerAction:HBRouterAction?{
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.routerActionIdentifier) as? HBRouterAction
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.routerActionIdentifier, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
//    public var routerScheme:String?{
//
//    }
    @objc
    func setRouterAction(routerAction:HBRouterAction) {
        self.routerAction = routerAction
    }
    
    convenience init(routerAction:HBRouterAction) {
        self.init()
        self.routerAction = routerAction
        
    }
}




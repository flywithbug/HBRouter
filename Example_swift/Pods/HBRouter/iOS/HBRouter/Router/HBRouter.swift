//
//  HBRouter.swift
//  Pods
//
//  Created by flywithbug on 2021/7/6.
//

import UIKit



@objcMembers open class HBRouter:HBNavigator  {
    
    private static let shareInstance = HBRouter()
    private override init() {
        super.init()
    }
    public static func shared() -> HBRouter{
        return shareInstance
    }
    public  var defaultRouterHost:String{
        get {
            return HBRouterMCache.shared().defaultRouterHost
        }
    }
    public  var defaultRouterScheme:String{
        get {
            return HBRouterMCache.shared().defaultRouterScheme
        }
    }
    
    
    @discardableResult
    public func open(url:URL) -> Any? {
        let action = HBRouterAction.init(url: url)
        return openRouterAction(action)
    }
    
    @discardableResult
    public func open(url:URL,params:[String:Any]) -> Any? {
        let action = HBRouterAction.init(url: url)
        action.addEntriesFromDictonary(params)
        return openRouterAction(action)
    }
    
    @discardableResult
    public func open(urlPattern:routerURLPattern) -> Any? {
        let action = HBRouterAction.init(urlPattern: urlPattern)
        return openRouterAction(action)
    }
    
    @discardableResult
    public func open(urlPattern:routerURLPattern,params:[String:Any]) -> Any? {
        let action = HBRouterAction.init(urlPattern: urlPattern)
        action.addEntriesFromDictonary(params)
        return openRouterAction(action)
    }
    @discardableResult
    public func open(action:HBRouterAction) -> Any? {
        return openRouterAction(action)
    }
    @discardableResult
    public func open(action:HBRouterAction,params:[String:Any]) -> Any? {
        return openRouterAction(action,params: params)
    }
    @discardableResult
    public func open(path:routerPath) -> Any? {
        let action = HBRouterAction.init(path: path)
        return openRouterAction(action)
    }
    @discardableResult
    public func open(path:routerPath,params:[String:Any]) -> Any? {
        let action = HBRouterAction.init(path: path)
        action.addEntriesFromDictonary(params)
        return openRouterAction(action)
    }
    @discardableResult
    public func openRouterAction(_ action:HBRouterAction,params:[String:Any])  -> Any?{
        action.addEntriesFromDictonary(params)
        return openRouterAction(action)
    }
    
    
    
    
    @discardableResult
    public override func openRouterAction(_ action: HBRouterAction) -> Any? {
        return super.openRouterAction(action)
    }
    
    public override func registRouter(_ mapping:[routerPath:routerTarget],
                             bundleClass:AnyClass? = nil){
        super.registRouter(mapping, bundleClass: bundleClass)
    }
    
    public override func registRouter(_ mapping:[routerPath:routerTarget],
                                bundle:routerBundle? = nil){
        super.registRouter(mapping, bundle: bundle)
    }
    
    public override func registRouter(_ scheme:routerScheme,
                             mapping:[routerPath:routerTarget],
                             bundle:routerBundle,
                             host:routerHost,
                             targetType:HBTargetType = .undefined){
        super.registRouter(scheme, mapping: mapping, bundle: bundle, host: host, targetType: targetType)
    }
    
    
    /// 注册路由表
    /// - Parameters:
    ///   - mapping: {"bos":{"/home/bike/map":"bikeViewController"}}
    ///              routerTarget: 路由目标对象
    ///          - routerScheme 不同的scheme可以配置不同的handler
    ///   - bundle: 注册路由所属bundle（swift需要bundle名称，Objective-C不需要）
    public override func registerRouter(_ mapping:[routerScheme:[routerPath:routerTarget]],
                               bundle:routerBundle ,
                               host:routerHost,
                               targetType:HBTargetType = .undefined){
        super.registerRouter(mapping, bundle: bundle, host: host, targetType: targetType)
    }
    
    
    /// 自行处理openAction操作
    /// - Parameters:
    ///   - urlPatterns: hb://router.com/path  hb://router.com  hb://  hb
    ///   - factory:  回调方法
    public override func registeHander(_ urlPatterns:[routerURLPattern],
                              factory: @escaping handlerFactory){
        super.registeHander(urlPatterns, factory: factory)
    }
    
    public override func registerHander(_ urlPattern:routerURLPattern,
                               factory: @escaping handlerFactory){
        super.registerHander(urlPattern, factory: factory)
    }
    
    public override func registeViewController(_ urlPatterns:[routerURLPattern],
                              factory: @escaping viewControllerFactory){
        super.registeViewController(urlPatterns, factory: factory)
    }

    public override func registerViewController(_ urlPattern:routerURLPattern,
                                       factory: @escaping viewControllerFactory){
        super.registerViewController(urlPattern, factory: factory)
    }
    
    
    @objc
    public override func matchPages(_ action: HBRouterAction) -> [UIViewController]? {
        return super.matchPages(action)
    }
    
    
    override func pop2Any(_ actions: [HBRouterAction]) -> [UIViewController]? {
        return super.pop2Any(actions)
    }
    override func pop2Path(_ urlPattern: routerURLPattern, params: [String : Any] = [:]) -> [UIViewController]? {
        return super.pop2Path(urlPattern,params: params)
    }
    override func pop(_ action: HBRouterAction) -> [UIViewController]? {
        return super.pop(action)
    }
    
}


extension UIViewController{
    
    @discardableResult
    @objc public func openRouterAction(_ action:HBRouterAction)  -> Any?{
        return HBRouter.shared().openRouterAction(action)
    }
    
    @discardableResult
    @objc public func open(url:URL) -> UIViewController? {
        let action = HBRouterAction.init(url: url)
        return HBRouter.shared().openRouterAction(action) as? UIViewController
    }
    
    @discardableResult
    @objc public func open(urlPattern:routerURLPattern) -> Any? {
        let action = HBRouterAction.init(urlPattern: urlPattern)
        return openRouterAction(action)
    }
    @discardableResult
    @objc public func open(action:HBRouterAction) -> Any? {
        return openRouterAction(action)
    }
    
    @discardableResult
    @objc public func open(path:routerPath) -> Any? {
        let action = HBRouterAction.init(path: path)
        return openRouterAction(action)
    }
    
    
}

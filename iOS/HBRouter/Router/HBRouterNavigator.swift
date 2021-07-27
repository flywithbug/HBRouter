//
//  HBRouterNavigator.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/8.
//

import UIKit



//public let HBRouterDefaultHost = "router.com"
//public let HBRouterDefaultScheme = "hb"


//不附带参数
//scheme://host.com/path  && scheme://host.com
public typealias routerURLPattern = String

public typealias routerScheme = String
public typealias routerHost = String
public typealias routerPath = String

//目标类
public typealias routerTarget = String
public typealias routerBundle = String


//跳转控制
//自定义跳转方法
public typealias  handlerFactory = (_ router: HBRouterAction) -> Any?


@objcMembers open class HBNavigator:NSObject {
    
    //
    public private(set)  var defaultRouterHost:String!
    public private(set)  var defaultRouterScheme:String!
    
    public func setDefault(_ scheme:routerScheme,host:routerHost) {
        if defaultRouterHost != nil || defaultRouterScheme != nil  {
            #if DEBUG
            assert(false, "HBRouter::::重复设置 默认host和scheme......")
            #else
            #endif
        }
        defaultRouterHost = host
        defaultRouterScheme = scheme
    }
    var lock:NSLock = NSLock.init()
    
    private  var handlerFactories = [routerURLPattern: handlerFactory]()

    //路由表注册
    public private(set)  var routerTargetMapping = [routerScheme: [routerPath:HBRouterTarget]]()
    
    
    public private(set) var routerMapping = [routerURLPattern:HBRouterTarget]()
    
    /// 路由表注册
    /// - Parameters:
    ///   - mapping: 路由表映射关系
    ///   - bundle: 映射对象所在bundle name
    public func registRouter(_ mapping:[routerPath:routerTarget],
                             bundle:routerBundle){
        
        #if DEBUG
        if defaultRouterHost  == nil {
            assert(false, "默认 host 未设置")
        }
        if defaultRouterScheme == nil {
            assert(false, "默认 scheme 未设置")
        }
        #else
        #endif
        registerRouter([defaultRouterScheme:mapping],
                       bundle: bundle,
                       host: defaultRouterHost,
                       targetType: .undefined)
    }
    
    public func registRouter(_ scheme:routerScheme,
                             mapping:[routerPath:routerTarget],
                             bundle:routerBundle,
                             host:routerHost,
                             targetType:HBTargetType = .undefined){
        var scheme = scheme
        if scheme == "" {
            scheme = defaultRouterScheme
        }
        registerRouter([scheme:mapping],
                       bundle: bundle,
                       host: host,
                       targetType: targetType)
    }
    
    
    /// 注册路由表
    /// - Parameters:
    ///   - mapping: {"bos":{"/home/bike/map":"bikeViewController"}}
    ///              routerTarget: 路由目标对象
    ///          - routerScheme 不同的scheme可以配置不同的handler
    ///   - bundle: 注册路由所属bundle（swift需要bundle名称，Objective-C不需要）
    public func registerRouter(_ mapping:[routerScheme:[routerPath:routerTarget]],
                               bundle:routerBundle ,
                               host:routerHost,
                               targetType:HBTargetType = .undefined){
        lock.lock()
        defer {
            lock.unlock()
        }
        
        #if DEBUG
        if defaultRouterHost  == nil {
            assert(false, "默认 host 未设置")
        }
        #else
        #endif
        
        var _host = defaultRouterHost!
        if host != "" {
            _host = host
        }
        
        for map in mapping{
            var rMap = routerTargetMapping[map.key] ?? [routerPath:HBRouterTarget]()
            for item in map.value{
                let target = HBRouterTarget.init(scheme: map.key, host: _host, path: item.key, target: item.value, bundle: bundle,targetType: targetType)
                #if DEBUG
                if let val = rMap[target.path] {
                    assert(false, "该路由path:\(target.path),target\(target.target)已被注册为target:\(val.target),请检查路由表:")
                }
                #else
                #endif
                routerMapping[target.routerURLPattern()] = target
                rMap[target.scheme] = target
            }
            routerTargetMapping[map.key] = rMap
        }
    }
    
    
    /// handler注册
    /// - Parameters:
    ///   - urlPatterns: hb://router.com/path  hb://router.com  hb://  hb
    ///   - factory:  回调方法
    public func registeHander(_ urlPatterns:[routerURLPattern],
                              factory: @escaping handlerFactory){
        lock.lock()
        defer {
            lock.unlock()
        }
        for urlPattern in urlPatterns{
            #if DEBUG
            if let val = handlerFactories[urlPattern] {
                assert(false, "该scheme：\(urlPattern)，factory:\(String(describing: factory)),已被注册为\(String(describing: val))，请检查注册表")
            }
            #else
            #endif
            let action = HBRouterAction.init(urlPattern: urlPattern)
            if let pattern = action.routerURLPattern() {
                handlerFactories[pattern] = factory
            }
        }
    }
    
    public func registerHander(_ urlPattern:routerURLPattern,
                               factory: @escaping handlerFactory){
        registeHander([urlPattern], factory: factory)
    }
    
    
    //跳转控制器
    @discardableResult
    public func openRouterAction(_ action:HBRouterAction)  -> Any?{
        action.target = matchTarget(action)
        if let val = hanldeFactory(action),val.success {
            return val.target
        }
        if let val = openController(action),val.success {
            return val
        }
        
        return openController(action)
    }
    
    
    
    
    
    /// 检索注册自定义方法
    /// - Parameter action: 路由action
    /// - Returns: 返回调用对象, 若返回空则表示调用失败
    private func hanldeFactory(_ action:HBRouterAction) -> (target:Any?, success:Bool)? {
        
        if let scheme = action.scheme, let host = action.host,let path = action.path, let handle = handlerFactories["\(scheme)://\(host)/\(path)"] {
            return (handle(action),true)
        }
        if let scheme = action.scheme, let host = action.host, let handle = handlerFactories["\(scheme)://\(host)"] {
            return (handle(action),true)
        }
        if let scheme = action.scheme, let handle = handlerFactories[scheme]{
            return (handle(action),true)
        }
        
        return nil
    }
    
    
    public func openController(_ action:HBRouterAction)  -> (target:Any?, success:Bool)?{
        
        
        
        
        return nil
    }
    
    
    
    public func openRouteString(_ routePath:String){
        
        
    }
}



extension HBNavigator {
    
    
    @discardableResult
    func matchTargetController(_ action:HBRouterAction,
                               navigationController:UINavigationController) -> UIViewController? {
        
//        guard  let targetClass = action.target?.targetClass as? UIViewController.Type else {
//            return nil
//        }
        
//        let viewController =   navigationController.viewControllers.match { (vc) -> Bool in
//            return vc.isKind(of: targetClass)
//        }
        
        
        
        
        return nil
    }
    
    @discardableResult
    func matchTarget(_ action:HBRouterAction) -> HBRouterTarget? {
        guard let scheme = action.scheme,let path = action.path else {
            assert(false, "scheme or  path is nil")
            return nil
        }
        if let target = routerTargetMapping[scheme]?[path]{
            return target
        }
        
        return nil
    }
    
    
    
}

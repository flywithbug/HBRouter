//
//  HBRouterNavigator.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/8.
//

import Foundation



//public let HBRouterDefaultHost = "router.com"
//public let HBRouterDefaultScheme = "hb"

public typealias routerScheme = String
public typealias routerHost = String
public typealias routerPath = String
public typealias routerTarget = String
public typealias routerBundle = String


//跳转控制
//自定义跳转方法
public typealias  handlerFactory = (_ router: HBRouterAction) -> Any?


open class HBNavigator {
    
    //
    public var defaultRouterHost:String!
    public var defaultRouterScheme:String!
    
    var lock:NSLock = NSLock.init()
    
    private var handlerFactories = [routerScheme: handlerFactory]()

    //路由表注册
    public var routerTargetMapping = [routerScheme: [String:HBRouterTarget]]()
    
    
    
    
    /// 路由表注册
    /// - Parameters:
    ///   - mapping: 路由表映射关系
    ///   - scheme: 路由 scheme头
    ///   - bundle: 映射对象所在bundle name
    ///   - host: 路由Host
    ///   - factory: 路由自定义方法调用
    ///   - targetType: 路由类型
    open func registRouterMapping(mapping:[routerPath:routerTarget],
                                  scheme:routerScheme,
                                  bundle:routerBundle,
                                  host:routerHost = "",
                                  _ factory: handlerFactory? = nil,targetType:HBTargetType = .undefined){
        registerRouterMapping(mapping: [scheme:mapping], bundle: bundle, host: host, factory,targetType: targetType)
    }
    
    /// 注册路由表
    /// - Parameters:
    ///   - mapping: {"bos":{"bike":"bikeViewController"}}
    ///              routerTarget: 路由目标对象
    ///          - routerScheme 不同的scheme可以配置不同的handler
    ///   - bundle: 注册路由所属bundle（swift需要bundle名称，Objective-C不需要）
    open func registerRouterMapping( mapping:[routerScheme:[routerPath:routerTarget]],
                                     bundle:routerBundle = "" ,
                                     host:routerHost? = nil,
                                     _ factory: handlerFactory? = nil,targetType:HBTargetType = .undefined){
        lock.lock()
        defer {
            lock.unlock()
        }
        
        #if DEBUG
        if defaultRouterHost  == nil {
            assert(false, "默认 host 未设置")
        }
        if defaultRouterScheme == nil {
            assert(false, "默认 scheme 未设置")
        }
        #else
        #endif
        
        var _host = defaultRouterHost!
        if let host = host {
            _host = host
        }
        
        for map in mapping{
            var rMap = routerTargetMapping[map.key] ?? [String:HBRouterTarget]()
            for item in map.value{
                let target = HBRouterTarget.init(scheme: map.key, host: _host, path: item.key, target: item.value, bundle: bundle,targetType: targetType)
                #if DEBUG
                if let val = rMap[item.key] {
                    assert(false, "该路由path:\(item.key),target\(item.value)已被注册为target:\(val.target),请检查路由表:")
                }
                #else
                #endif
               
                rMap[item.key] = target
            }
            routerTargetMapping[map.key] = rMap
            if let factory = factory {
                registeHander(map.key, factory: factory)
            }
        }
    }
    
    public func registeHander(_ schemes:[routerScheme],factory: @escaping handlerFactory){
        for item in schemes{
            registeHander(item, factory: factory)
        }
    }
    public func registeHander(_ scheme:routerScheme,factory: @escaping handlerFactory){
        #if DEBUG
        if let val = handlerFactories[scheme] {
            assert(false, "该scheme：\(scheme)，factory:\(String(describing: factory)),已被注册为\(String(describing: val))，请检查注册表")
        }
        #else
        #endif
        handlerFactories[scheme] = factory
    }
    
    
    //跳转控制器
    @discardableResult
    public func openRouterAction(_ action:HBRouterAction)  -> Any?{
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
        if let scheme = action.scheme, let handle = handlerFactories[scheme] {
            //处理成功
            return (handle(action),true)
        }
        
        return nil
    }
    
    
    private func openController(_ action:HBRouterAction)  -> (target:Any?, success:Bool)?{
        
        
        
        
        
        return nil
    }
    
    
    
    public func openRouteString(_ routePath:String){
        
        
    }
}



extension HBNavigator {
    
    
    
    
}

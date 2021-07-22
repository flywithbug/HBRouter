//
//  HBRouterNavigator.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/8.
//

import Foundation


public typealias routerScheme = String
public typealias routerHost = String
public typealias routerPath = String
public typealias routerTarget = String
public typealias routerBundle = String


//跳转控制
//自定义跳转方法
public typealias  handlerFactory = (_ router: HBRouterAction) -> Any?


open class HBNavigator {
    
    var lock:NSLock = NSLock.init()
    
    private var handlerFactories = [routerScheme: handlerFactory]()

    //路由表注册
    public var routerMapping = [routerScheme: [String:HBRouterTarget]]()
    
    
    /// 注册路由表
    /// - Parameters:
    ///   - mapping: {"bos":{"bike":"bikeViewController"}}
    ///              routerTarget: 路由目标对象
    ///          - routerScheme 不同的scheme可以配置不同的handler
    ///   - bundle: 注册路由所属bundle（swift需要bundle名称，Objective-C不需要）
    open func registerRouterMapping( mapping:[routerScheme:[routerPath:routerTarget]],
                                     bundle:routerBundle = "" ,
                                     host:routerHost = "hellobike.com",
                                     _ factory: handlerFactory? = nil){
        lock.lock()
        defer {
            lock.unlock()
        }
        for map in mapping{
            var rMap = routerMapping[map.key] ?? [String:HBRouterTarget]()
            for item in map.value{
                let target = HBRouterTarget.init(scheme: map.key, host: host, path: item.key, target: item.value, bundle: bundle)
                #if DEBUG
                if let val = rMap[item.key] {
                    assert(false, "该路由path:\(item.key),target\(item.value)已被注册为target:\(val.target ?? "--"),请检查路由表:")
                }
                #else
                #endif
               
                rMap[item.key] = target
            }
            routerMapping[map.key] = rMap
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
        if let scheme = action.scheme, let handlefactory = handlerFactories[scheme] {
            return handlefactory(action)
        }
        
        return nil
    }
    
    
    
    
    public func openRouteString(_ routePath:String){
        
        
        
    }
}



extension HBNavigator {
    
    
    
    
}

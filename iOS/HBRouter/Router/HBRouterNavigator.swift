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

//注册自定义返回Controller
public typealias  viewControllerFactory = (_ router:HBRouterAction) -> UIViewController?


@objcMembers open class HBNavigator:NSObject {
    
    public override init() {
        super.init()
        HBRSwizzleManager.shared()
    }
    
    private weak var _deleage:HBRouterDelegate?
    public weak var deleage:HBRouterDelegate?{
        set{
            if _deleage != nil {
                #if DEBUG
                assert(false, "delegate只能有一个地方回调，请检查代码重新设置")
                #else
                #endif
            }
            _deleage = newValue
        }
        get {
            return _deleage
        }
    }
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
    
    private var handlerFactories = [routerURLPattern: handlerFactory]()
    private var viewControllerFactories = [routerURLPattern:viewControllerFactory]()

    //路由表 元数据
    public private(set)  var routerTargetMapping = [routerScheme: [routerPath:HBRouterTarget]]()
    //路由表 生成
    public private(set) var routerMapping = [routerURLPattern:HBRouterTarget]()
    
    /// 路由表注册
    /// - Parameters:
    ///   - mapping: 路由表映射关系
    ///   - bundle: 映射对象所在bundle name
    public func registRouter(_ mapping:[routerPath:routerTarget],
                             bundle:AnyClass){
        
        #if DEBUG
        if defaultRouterHost  == nil {
            assert(false, "默认 host 未设置")
        }
        if defaultRouterScheme == nil {
            assert(false, "默认 scheme 未设置")
        }
        #else
        #endif
        let bundleName = HBBundleNameFromClass(_class: bundle)

        registerRouter([defaultRouterScheme:mapping],
                       bundle: bundleName ?? "",
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
    
    
    /// 自行处理openAction操作
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
                assert(false, "urlPattern:\(urlPattern)，factory:\(String(describing: factory)),已被注册为\(String(describing: val))，请检查注册表")
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
    
    public func registeViewController(_ urlPatterns:[routerURLPattern],
                              factory: @escaping viewControllerFactory){
        lock.lock()
        defer {
            lock.unlock()
        }
        for urlPattern in urlPatterns{
            #if DEBUG
            if let val = viewControllerFactories[urlPattern] {
                assert(false, "urlPattern:\(urlPattern)，factory:\(String(describing: factory)),已被注册为\(String(describing: val))，请检查注册表")
            }
            #else
            #endif
            let action = HBRouterAction.init(urlPattern: urlPattern)
            if let pattern = action.routerURLPattern() {
                viewControllerFactories[pattern] = factory
            }
        }
    }

    public func registerViewController(_ urlPattern:routerURLPattern,
                                       factory: @escaping viewControllerFactory){
        registeViewController([urlPattern], factory: factory)
    }
    
    
    /// 检索注册自定义方法
    /// - Parameter action: 路由action
    /// - Returns: 返回调用对象, 若返回空则表示调用失败
    private func hanldeFactory(_ action:HBRouterAction) -> (target:Any?, success:Bool)? {
        print("routerURLPattern::\(action.routerURLPattern() ?? "")")
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
    
    
    //跳转控制器
    @discardableResult
    public func openRouterAction(_ action:HBRouterAction)  -> Any?{
        if checkRouterActionAuth(action)  == false {
            return nil
        }
        action.target = matchTarget(action)
        if let val = hanldeFactory(action),val.success {
            return val.target
        }
        if let val = openController(action),val.success {
            return val
        }
        
        return nil
    }
    
    
    
    
    public func openController(_ action:HBRouterAction)  -> (target:Any?, success:Bool)?{
        
        
        return nil
    }
    
    
    
}





extension HBNavigator{
    
    //权限校验
    func checkRouterActionAuth(_ action:HBRouterAction) -> Bool {
        if !shouldOpenRouter(action) {
            return false
        }
        
        if action.openExternal && !shouldOpenExternal(action) {
            return false
        }
        return true
    }
   
    
    //router权限校验及调用生命周期
    func shouldOpenRouter(_ action:HBRouterAction) -> Bool{
        return self.deleage?.shouldOpenRouter(action) ?? true
    }
    func willOpenRouter(_ action:HBRouterAction){
        self.deleage?.willOpenRouter(action)
    }
    func didOpenRouter(_ action:HBRouterAction){
        self.deleage?.didOpenRouter(action)
    }
    
    
    //外链权限校验
    func shouldOpenExternal(_ action:HBRouterAction) -> Bool{
        return self.deleage?.shouldOpenExternal(action) ?? true
    }
    //打开外链
    func willOpenExternal(_ action:HBRouterAction){
        self.deleage?.willOpenExternal(action)
    }
    func didOpenExternal(_ action:HBRouterAction, completion: ((Bool) -> Void)?){
        self.deleage?.didOpenExternal(action, completion: completion)
    }
    
    //未能打开的Router回调
    func onMatchUnhandleRouterAction(_ action:HBRouterAction){
        self.deleage?.onMatchUnhandleRouterAction(action)
    }
    //页面打开回调
    func onMatchRouterAction(_ action:HBRouterAction, viewController:UIViewController){
        self.deleage?.onMatchRouterAction(action, viewController: viewController)
    }
    
    func loginState() -> Bool {
        
        return false
    }
    
    
}




extension HBNavigator {
    
    
    /// 获取跳转控制器对象
    /// - Parameters:
    ///   - action: action 参数
    ///   - navigationController: 导航栈
    /// - Returns: 返回控制器对象
    @discardableResult func matchTargetController(_ action:HBRouterAction,
                               navigationController:UINavigationController) -> UIViewController? {
        guard let target = action.target else {
            return nil
        }
        guard let targetClass = target.targetClass as? UIViewController.Type else {
            return nil
        }
        var isSingleton = action.isSingleton
        if  targetClass.isSingleton(action) {
            isSingleton = true
        }
        if isSingleton {
            if let viweController =  navigationController.viewControllers.match(validate: {(item:UIViewController) -> Bool in return item.isKind(of: targetClass)}) {
                return viweController
            }
        }
        let viewController = targetClass.init()
        viewController.setRouterAction(routerAction: action)
        return viewController
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

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



 open class HBNavigator:NSObject {
    
    public override init() {
        super.init()
        
        HBRSwizzleManager.shared()
    }
    public var wrapNavgClass:UINavigationController.Type = UINavigationController.self
    
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

    public func setDefault(_ scheme:routerScheme,host:routerHost) {
        HBRouterMCache.shared().setDefault(scheme,host:host)
    }
    
    let lock:NSLock = NSLock.init()
    private var handlerFactories = [routerURLPattern: handlerFactory]()
    private var viewControllerFactories = [routerURLPattern:viewControllerFactory]()
    private var checkInBlockModesemaphore = DispatchSemaphore.init(value: 1)
    
    //路由表 元数据
    public private(set)  var routerTargetMapping = [routerScheme: [routerPath:HBRouterTarget]]()
    //路由表 生成
    public private(set) var routerMapping = [routerURLPattern:HBRouterTarget]()
    
    /// 路由表注册
    /// - Parameters:
    ///   - mapping: 路由表映射关系
    ///   - bundleClass: 映射对象所在 bundleClass
    func registRouter(_ mapping:[routerPath:routerTarget],
                             bundleClass:AnyClass? = nil){
        let bundleName = HBBundleNameFromClass(_class: bundleClass)
        registRouter(mapping, bundle: bundleName)
    }
    
    func registRouter(_ mapping:[routerPath:routerTarget],
                                bundle:routerBundle? = nil){
        #if DEBUG
        if HBRouterMCache.shared().defaultRouterHost  == nil {
            assert(false, "默认 host 未设置")
        }
        if HBRouterMCache.shared().defaultRouterScheme == nil {
            assert(false, "默认 scheme 未设置")
        }
        #else
        #endif
        registRouter(HBRouterMCache.shared().defaultRouterScheme,
                     mapping:mapping,
                     bundle: bundle ?? "",
                     host: HBRouterMCache.shared().defaultRouterHost,
                     targetType: .undefined)
    }
    
    func registRouter(_ scheme:routerScheme,
                             mapping:[routerPath:routerTarget],
                             bundle:routerBundle,
                             host:routerHost,
                             targetType:HBTargetType = .undefined){
        var scheme = scheme
        if scheme == "" {
            scheme = HBRouterMCache.shared().defaultRouterScheme
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
    func registerRouter(_ mapping:[routerScheme:[routerPath:routerTarget]],
                               bundle:routerBundle ,
                               host:routerHost,
                               targetType:HBTargetType = .undefined){
        lock.lock()
        defer {
            lock.unlock()
        }
        
        #if DEBUG
        if HBRouterMCache.shared().defaultRouterHost  == nil {
            assert(false, "默认 host 未设置")
        }
        #else
        #endif
        
        var _host = HBRouterMCache.shared().defaultRouterHost!
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
    func registeHander(_ urlPatterns:[routerURLPattern],
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
    
    func registerHander(_ urlPattern:routerURLPattern,
                               factory: @escaping handlerFactory){
        registeHander([urlPattern], factory: factory)
    }
    
    func registeViewController(_ urlPatterns:[routerURLPattern],
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

    func registerViewController(_ urlPattern:routerURLPattern,
                                       factory: @escaping viewControllerFactory){
        registeViewController([urlPattern], factory: factory)
    }
    
    //跳转控制器
    @discardableResult
    func openRouterAction(_ action:HBRouterAction)  -> Any?{
        //获取target类型
        action.target = matchTarget(action)
        if checkRouterActionAuth(action)  == false {
            return nil
        }
        if action.openExternal && shouldOpenExternal(action) {
            willOpenExternal(action)
            openExternal(action) { [weak self] (success) in
                self?.didOpenExternal(action)
            }
        }
        if  let _target =  handleFactory(action) {
            return _target.target
        }
        if let val = openController(action,inside: true),val.success{
            return val.viewController
        }
        //未处理action回调
        onMatchUnhandleRouterAction(action)
        return nil
    }
    
    
    public func openController(_ action:HBRouterAction)  -> (viewController:UIViewController?, success:Bool)?{
        return openController(action, inside: false)
    }
    
    private func checkInBlockMode() ->Bool{
        guard let navigationController = UIViewController.topMost?.navigationController else {
            return false
        }
        if navigationController.hbr_inAnimating  || navigationController.topViewController?.hbr_inAnimating ?? false{
            return true
        }
        return false
    }
    
    
    
    private func openController(_ action:HBRouterAction, inside:Bool)  -> (viewController:UIViewController?, success:Bool)?{
        //防止连续Open导致动画冲突
        if action.animation && checkInBlockMode(){
            checkInBlockModesemaphore.wait()
            DispatchQueue.global().asyncAfter(deadline: .now()) { () in
                self.checkInBlockModesemaphore.signal()
            }
        }
        var success:Bool = false
        defer {
            if inside == false && success == false {
                onMatchUnhandleRouterAction(action)
            }
        }
        guard let viewController = matchTargetController(action) else {
            return (nil,false)
        }
       
        
        if action.options.contains(.present) || action.option == .present{
            if !present(action, viewController: viewController)  {
                return (viewController,false)
            }
        }else{
            if !push(action, viewController: viewController){
                return (viewController,false)
            }
        }
        success = true
        onMatchRouterAction(action, any: viewController)
        viewController.setRouterAction(action)
        viewController.handleRouterAction(action)
        
        return (viewController,true)
    }
   
    
    func push(_ action:HBRouterAction,viewController:UIViewController) -> Bool {
        guard let vc = UIViewController.topMost, let navigationController = vc.navigationController else {
            return false
        }
        if action.useExistPage {
            if navigationController.viewControllers.last == viewController {
                viewController.viewWillAppear(false)
                viewController.viewDidAppear(false)
                return true
            }
            var viewControllers = [UIViewController]()
            for item in navigationController.viewControllers{
                if item != viewController {
                    viewControllers.append(item)
                }
            }
            navigationController.setViewControllers(viewControllers, animated: false)
            navigationController.pushViewController(viewController, animated: action.animation)
        }else{
            navigationController.pushViewController(viewController, animated: action.animation)
        }
        //调用链
        action.from = vc
        action.current = viewController
        vc.routeAction?.next = viewController
        return true
        
    }
    
    func present(_ action:HBRouterAction,viewController:UIViewController) -> Bool  {
        guard let vc = UIViewController.topMost, let navigationController = vc.navigationController else {
            return false
        }
        
        var _viewController = viewController
        if action.options.contains(.wrap_nc) || action.wrapNavgClass != nil {
            if action.wrapNavgClass != nil && action.wrapNavgClass !=  self.wrapNavgClass{
                _viewController = action.wrapNavgClass!.init(rootViewController: viewController)
            }else{
                _viewController = wrapNavgClass.init(rootViewController: viewController)
            }
        }
        navigationController.present(_viewController, animated: action.animation)
        action.from = vc
        action.current = viewController
        vc.routeAction?.next = viewController
        return true
    }
    
    //示例：path, 会使用默认的scheme 和 host
    //若scheme不是默认的，请使用pop2URL
    @discardableResult
    func pop2Path(_ path:routerPath, params:[String:Any] = [:], completion: ((_ success:Bool) -> Void)? = nil) ->  [UIViewController]? {
        let action = HBRouterAction.init(path: path)
        action.addEntriesFromDictonary(params)
        return pop2Action(action,completion: completion)
    }
    
    @discardableResult
    func pop2URL(_ url:URL,params:[String:Any] = [:], completion: ((_ success:Bool) -> Void)? = nil) -> [UIViewController]? {
        let action = HBRouterAction.init(url: url)
        action.addEntriesFromDictonary(params)
        return pop2Action(action,completion: completion)
    }
    
    //回退到当前导航栈中的某控制器
    @discardableResult
    func pop2Action(_ action:HBRouterAction,completion:((_ success:Bool)->Void)? = nil) -> [UIViewController]? {
        guard let navigationController = UIViewController.topMost?.navigationController else {
            completion?(false)
            return nil
        }
        guard let target = matchTarget(action),let targetClass = target.targetClass else {
            completion?(false)
            return nil
        }
        action.target = target
        //倒叙遍历
        for item in navigationController.viewControllers.reversed() {
            if item.isKind(of: targetClass) {
                //参数回传
                if item.routeAction != nil {
                    item.routeAction?.addEntriesFromDictonary(action.params)
                }else{
                    item.setRouterAction(action)
                }
                item.handleRouterAction(item.routeAction!)
                let list = navigationController.popToViewController(item, animated: action.animation) {
                    completion?(true)
                }
                return  list
            }
        }
        completion?(false)
        return nil
    }
    
    
    
    ///关闭导航栈中匹配到的路由
    /// - Parameter path: path   使用默认scheme和host
    /// - Returns: 返回被关闭的控制器
    @discardableResult
    func closePage(path:routerPath) -> [UIViewController]? {
        let action = HBRouterAction.init(path: path)
        return closePage(action: action)
    }
    
    /// 关闭导航栈中匹配到的路由
    /// - Parameter urlPattern: hb://router.com/path
    /// - Returns: 返回被关闭的控制器
    @discardableResult
    func closePage(urlPattern:routerURLPattern) -> [UIViewController]? {
        let action = HBRouterAction.init(urlPattern: urlPattern)
        return closePage(action: action)
    }
    
    //只关闭当前导航栈中匹配的路由的所有页面,
    @discardableResult
    func closePage(action:HBRouterAction) -> [UIViewController]? {
        guard let navigationController = UIViewController.topMost?.navigationController else {
            return nil
        }
        guard let target = matchTarget(action),let targetClass = target.targetClass else {
            return nil
        }
        action.target = target
        var viewControllers:[UIViewController] = navigationController.viewControllers
        var removeViewControllers:[UIViewController] = []
        var index = viewControllers.count
        
        for item in navigationController.viewControllers.reversed() {
            index = index - 1
            if item.isKind(of: targetClass) {
                //参数回传
                if item.routeAction != nil {
                    item.routeAction?.addEntriesFromDictonary(action.params)
                }else{
                    item.setRouterAction(action)
                }
                item.handleRouterAction(item.routeAction!)
                if viewControllers.count > 1 {
                    viewControllers.remove(at: index)
                    item.viewWillDisappear(false)
                    item.viewDidDisappear(false)
                    removeViewControllers.append(item)
                }else{
                    assert(false, "根视图不能被移除")
                }
            }
        }
        if removeViewControllers.count > 0 {
            navigationController.setViewControllers(viewControllers, animated: false)
            return removeViewControllers
        }else{
            return nil
        }
    }
    
    
    
    //回退到任意actions
    @discardableResult
    func pop2Any(_ actions:[HBRouterAction],completion:((_ success:Bool)->Void)? = nil) ->  [UIViewController]? {
        for item in actions{
            if let items =  pop2Action(item,completion: completion) {
                return items
            }
        }
        return nil
    }
    
}







extension HBNavigator {
    
    func handleFactory(_ action:HBRouterAction) -> (target:Any?,success:Bool)? {
        guard let handler = matchFactory(action) else {
            return nil
        }
        let target = handler(action)
        onMatchRouterAction(action, any: target)
        return (target,true)
    }

    
    /// 获取跳转控制器对象
    /// - Parameters:
    ///   - action: action 参数
    ///   - navigationController: 导航栈
    /// - Returns: 返回控制器对象
    @discardableResult func matchTargetController(_ action:HBRouterAction) -> UIViewController? {
        //从注册工厂中获取
        if let viewController = matchViewControllerFactory(action){
            return viewController
        }
      
        guard let target = action.target else {
            return nil
        }
        guard let targetClass = target.targetClass as? UIViewController.Type else {
            return nil
        }
        action.useExistPage = action.useExistPage || targetClass.isSingleton(action)
        if action.useExistPage {
            if let navigationController = UIViewController.topMost?.navigationController {
                if let viewController =  navigationController.viewControllers.match(validate: {(item:UIViewController) -> Bool in return item.isKind(of: targetClass)}) {
                    action.addParamsFromURLAction(viewController.routeAction)
                    viewController.setRouterAction( action)
                    return viewController
                }
            }
        }
        let viewController = targetClass.init()
        viewController.setRouterAction(action)
        return viewController
    }
    
    @discardableResult
    func matchTarget(_ action:HBRouterAction) -> HBRouterTarget? {
        return  routerMapping[action.routerURLPattern() ?? ""]
    }
    
    /// 检索注册自定义方法
    /// - Parameter action: 路由action
    /// - Returns: 返回调用对象, 若返回空则表示调用失败
    private func matchFactory(_ action:HBRouterAction) -> handlerFactory? {
//        Dlog("routerURLPattern::\(action.routerURLPattern() ?? "")")
        if let scheme = action.scheme, let host = action.host,let path = action.path, let handle = handlerFactories["\(scheme)://\(host)/\(path)"] {
            return handle
        }
        
        if let scheme = action.scheme, let host = action.host, let handle = handlerFactories["\(scheme)://\(host)"] {
            return handle
        }
        
        if let scheme = action.scheme, let handle = handlerFactories[scheme]{
            return handle
        }
        
        return nil
    }
    
    func matchViewControllerFactory(_ action:HBRouterAction) -> UIViewController? {
        if let scheme = action.scheme, let host = action.host,let path = action.path, let handle = viewControllerFactories["\(scheme)://\(host)/\(path)"] {
            return handle(action)
        }
        if let scheme = action.scheme, let host = action.host, let handle = viewControllerFactories["\(scheme)://\(host)"] {
            return handle(action)
        }
        
        if let scheme = action.scheme, let handle = viewControllerFactories[scheme]{
            return handle(action)
        }
        return nil
    }
    
    
    //获取最顶层导航栈中对应routerURLPattern的控制器
    @objc
    func matchPages(_ action:HBRouterAction) -> [UIViewController]? {
        guard let navigationController = UIViewController.topMost?.navigationController else {
            return nil
        }
        guard  let target = matchTarget(action),let targetClass = target.targetClass else {
            return nil
        }
        action.target = target
        return navigationController.viewControllers.filter { (item) -> Bool in
            return item.isKind(of: targetClass)
        }
        
    }
}




extension HBNavigator{
    
    //权限校验
    //登录态判断，登录回调，登录成功之后，重新执行前流程
    func checkRouterActionAuth(_ action:HBRouterAction) -> Bool {
        if let target = action.target ,
           let targetClass = target.targetClass as? UIViewController.Type,targetClass.needsLogin(action) {
            if !loginStatus(action, completion: { [weak self] (success) in
                if success{
                    self?.openRouterAction(action)
                }
            }) {
                return false
            }
        }
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
    
    //将要打开外链
    func willOpenExternal(_ action:HBRouterAction){
        self.deleage?.willOpenExternal(action)
    }
    
    func openExternal(_ action:HBRouterAction, completion: ((Bool) -> Void)?){
        if ((self.deleage?.openExternal(action,completion: completion)) != nil)  {
            return
        }
        if let url = action.externalURL() {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:]) { (success) in
                    action.openCompleteBlock?(HBRouterResponse.init(action))
                }
            } else {
                if UIApplication.shared.openURL(url) {
                    action.openCompleteBlock?(HBRouterResponse.init(action))
                }else{
                    action.openCompleteBlock?(HBRouterResponse.init(action,code: -1))
                }
            }
        }else{
            action.openCompleteBlock?(HBRouterResponse.init(action,code: -1))
        }
    }
    
    func didOpenExternal(_ action:HBRouterAction){
        self.deleage?.didOpenExternal(action)
    }
    
    //未能打开的Router回调
    func onMatchUnhandleRouterAction(_ action:HBRouterAction){
        self.deleage?.onMatchUnhandleRouterAction(action)
        action.openCompleteBlock?(HBRouterResponse.init(action, data: nil, msg: "", code: -1))
        Dlog(action.routerURLPattern() ?? "")
    }
    
    //页面打开回调
    func onMatchRouterAction(_ action:HBRouterAction, any:Any?){
        self.deleage?.onMatchRouterAction(action, any:any)
        action.openCompleteBlock?(HBRouterResponse.init(action, data: any, msg: ""))
        Dlog(action.routerURLPattern() ?? "")
    }
    
    func loginStatus(_ action:HBRouterAction, completion: ((Bool) -> Void)?) -> Bool{
        return self.deleage?.loginStatus(action, completion: completion) ?? false
    }
    
    
}

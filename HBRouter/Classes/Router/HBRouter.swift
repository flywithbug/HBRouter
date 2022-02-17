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
    
    
    ///默认路由host
    public  var defaultRouterHost:String{
        get {
            return HBRouterMCache.shared().defaultRouterHost
        }
    }
    
    /// 默认路由scheme
    public  var defaultRouterScheme:String{
        get {
            return HBRouterMCache.shared().defaultRouterScheme
        }
    }
    /// 设置默认 schem和host
    /// - Parameters:
    ///   - scheme: 示例：hb
    ///   - host: router.com
     public func setDefault(_ scheme:routerScheme,host:routerHost) {
        HBRouterMCache.shared().setDefault(scheme,host:host)
    }
    
    
    
    /// 注册路由表
    /// - Parameters:
    ///   - mapping: 路由表Map
    ///   - bundle: bundle 名称
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
    
    
    public override func registeRouter(_ targets: [HBRouterTarget]) {
        super.registeRouter(targets)
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
    
    
    
    @discardableResult
    public override func openRouterAction(_ action: HBRouterAction) -> Any? {
        return super.openRouterAction(action)
    }
    
//     @discardableResult
//     public override func matchPages(_ action: HBRouterAction) -> [UIViewController]? {
//         return super.matchPages(action)
//     }
    public func matchPages(path:routerPath)-> [UIViewController]?{
        return super.matchPages(HBRouterAction.init(path: path));
    }
    
//    public func matchPages(urlPattern:routerURLPattern)-> [UIViewController]?{
//        return super.matchPages(HBRouterAction.init(urlPattern: urlPattern))
//    }
    
    
    /// 获取当前导航栈中的控制器对象
    /// - Parameters:
    ///   - path: home/v1/user
    ///   - host: router.com
    ///   - scheme: hb://
    /// - Returns: 匹配到的控制器对象
    @discardableResult
    public func matchPages(path:routerPath,host:routerHost,scheme:routerScheme)-> [UIViewController]?{
        return super.matchPages(HBRouterAction.init(scheme, host: host, path: path))
    }
    
    
//    override func matchLatestPage(_ action: HBRouterAction) -> UIViewController? {
//        return super.matchLatestPage(action)
//    }
    public func matchLatestPage(path:routerPath) -> UIViewController?{
        return super.matchLatestPage(HBRouterAction.init(path: path))
    }
    public func matchLatestPage(path:routerPath,host:routerHost,scheme:routerScheme) -> UIViewController?{
        return super.matchLatestPage(HBRouterAction.init(scheme,host: host,path: path))
    }
    
    public override func matchPages(targetClass: AnyClass) -> [UIViewController]? {
        return super.matchPages(targetClass: targetClass)
    }
    
    //传递参数给最近匹配到的页面
//    public func transfer2LatestPage(path:routerPath,params:[String:Any],completion: ((_ success:Bool) -> Void)? = nil){
//        guard  let vc = matchLatestPage(path: path) else {
//            completion?(false)
//            return
//        }
////        vc.routeAction?.addEntriesFromDictonary(<#T##entries: [String : Any]##[String : Any]#>)
//        completion?(true)
//    }
    
    
    
     @discardableResult
     public override func pop2Path(_ path: routerPath, params: [String : Any] = [:],completion: ((_ success:Bool) -> Void)? = nil) -> [UIViewController]? {
         return super.pop2Path(path,params: params,completion: completion)
     }

    
    
    @discardableResult
    public override func pop2Action(_ action: HBRouterAction, completion: ((_ success:Bool) -> Void)? = nil) -> [UIViewController]? {
        return super.pop2Action(action,completion: completion)
    }
    
    
    @discardableResult
    public override  func pop2URL(_ url: URL,params:[String:Any] = [:],completion: ((_ success:Bool) -> Void)? = nil) -> [UIViewController]? {
        return super.pop2URL(url,params: params,completion: completion)
    }
    
    /// 关闭栈内路由匹配成功的控制器，如果只有一个根控制器，则不返回
    /// - Parameter path: 路由path
    /// - Returns: 被移除的控制器
    @discardableResult
    public override func closePage(path: routerPath) -> [UIViewController]? {
        return super.closePage(path: path)
    }
    @discardableResult
    public override func closePage(urlPattern: routerURLPattern) -> [UIViewController]? {
        return super.closePage(urlPattern: urlPattern)
    }
    
}

extension HBRouter{
    
    /// 回退到 path
    /// - Parameter path: 路由 path
    /// - Returns: 返回被释放的控制器
    
    @discardableResult public func pop2Path(_ path: routerPath) -> [UIViewController]? {
        return super.pop2Path(path)
    }
    
    @discardableResult
    public  func pop2URL(_ url: URL) -> [UIViewController]? {
        return super.pop2URL(url)
    }
    
    
    @discardableResult
    public func open(url:URL) -> Any? {
        let action = HBRouterAction.init(url: url)
        return openRouterAction(action)
    }
    
    @discardableResult
    public func open(url:URL,completion:((_ response:HBRouterResponse)->Void)? = nil,callBack:((_ value:Any?)->Void)? = nil) -> Any? {
        let action = HBRouterAction.init(url: url)
        action.openCompleteBlock = completion
        action.callBackBlock = callBack
        return openRouterAction(action)
    }
    
    
    //TODO
    /// 发送消息给栈内任意匹配到path的页面
    /// - Parameters:
    ///   - urlPattern: hb://router.com/path
    ///   - params:{"a":"b"}
//    func sendMessage(urlPattern:routerURLPattern,
//                     params:[String:Any] = [:])  {
//        let action = HBRouterAction.init(urlPattern: urlPattern)
//        action.addEntriesFromDictonary(params)
//        sendMessage(action: action)
//
//
//    }
//    func sendMessage(path:routerPath,
//                     params:[String:Any] = [:])  {
//        let action = HBRouterAction.init(path: path)
//        action.addEntriesFromDictonary(params)
//        sendMessage(action: action)
//
//
//    }
//
//    func sendMessage(path:routerPath,
//                     host:routerHost,
//                     scheme:routerScheme,
//                     params:[String:Any] = [:])  {
//        let action = HBRouterAction.init(scheme, host: host, path: path)
//        action.addEntriesFromDictonary(params)
//        sendMessage(action: action)
//    }
//
//    func sendMessage(action:HBRouterAction,params:[String:Any] = [:])  {
////        UIViewController.topMost
////        var loop:Bool = true
////        while loop {
////
////
////
////
////
////
////        }
//
//
//
//
//
//
//    }
    
    
    @discardableResult
    public func open(url:URL,params:[String:Any]) -> Any? {
        let action = HBRouterAction.init(url: url)
        action.addEntriesFromDictonary(params)
        return openRouterAction(action)
    }
    
    @discardableResult
    public func open(url:URL,params:[String:Any],completion:((_ response:HBRouterResponse)->Void)? = nil,callBack:((_ value:Any?)->Void)? = nil) -> Any? {
        let action = HBRouterAction.init(url: url)
        action.openCompleteBlock = completion
        action.callBackBlock = callBack
        action.addEntriesFromDictonary(params)
        return openRouterAction(action)
    }
    
    
    @discardableResult
    public func open(_ path:routerPath,
                     host:routerHost,
                     scheme:routerScheme,
                     params:[String:Any] = [:],
                     completion:((_ response:HBRouterResponse)->Void)? = nil,
                     callBack:((_ value:Any?)->Void)? = nil) -> Any? {
        
        let action = HBRouterAction.init(scheme, host: host, path: path)
        action.openCompleteBlock = completion
        action.callBackBlock = callBack
        action.addEntriesFromDictonary(params)
        return openRouterAction(action)
    }
    
    
    @discardableResult
    public func open(urlPattern:routerURLPattern,completion:((_ response:HBRouterResponse)->Void)? = nil,callBack:((_ value:Any?)->Void)? = nil) -> Any? {
        let action = HBRouterAction.init(urlPattern: urlPattern)
        action.openCompleteBlock = completion
        action.callBackBlock = callBack
        return openRouterAction(action)
    }
    
    @discardableResult
    public func open(urlPattern:routerURLPattern,params:[String:Any]) -> Any? {
        let action = HBRouterAction.init(urlPattern: urlPattern)
        action.addEntriesFromDictonary(params)
        return openRouterAction(action)
    }


    @discardableResult
    public func open(urlPattern:routerURLPattern,params:[String:Any],completion:((_ response:HBRouterResponse)->Void)? = nil,callBack:((_ value:Any?)->Void)? = nil) -> Any? {
        let action = HBRouterAction.init(urlPattern: urlPattern)
        action.openCompleteBlock = completion
        action.callBackBlock = callBack
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
    public func open(path:routerPath,params:[String:Any] = [:]) -> Any? {
        let action = HBRouterAction.init(path: path)
        action.addEntriesFromDictonary(params)
        return openRouterAction(action)
    }
    
    
    @discardableResult
    /// 打开路由
    /// - Parameters:
    ///   - path: 路由path
    ///   - params: 参数
    ///   - completion: 页面打开完成回调
    ///   - callBack: 下一个页面回传参数Block
    /// - Returns: 返回打开的路由对象
    public func open(path:routerPath,params:[String:Any] = [:],completion:((_ response:HBRouterResponse)->Void)? = nil,callBack:((_ value:Any?)->Void)? = nil) -> Any? {
        let action = HBRouterAction.init(path: path)
        action.openCompleteBlock = completion
        action.callBackBlock = callBack
        action.addEntriesFromDictonary(params)
        return openRouterAction(action)
    }
    
    @discardableResult
    public func openRouterAction(_ action:HBRouterAction,params:[String:Any])  -> Any?{
        action.addEntriesFromDictonary(params)
        return openRouterAction(action)
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
    @objc public func open(url:URL,params:[String:Any] = [:]) -> UIViewController? {
        let action = HBRouterAction.init(url: url)
        action.addEntriesFromDictonary(params)
        return HBRouter.shared().openRouterAction(action) as? UIViewController
    }
    
    @discardableResult
    @objc public func open(path:routerPath) -> Any? {
        let action = HBRouterAction.init(path: path)
        return openRouterAction(action)
    }
    
    @discardableResult
    @objc public func open(path:routerPath,params:[String:Any] = [:]) -> Any? {
        let action = HBRouterAction.init(path: path)
        action.addEntriesFromDictonary(params)
        return openRouterAction(action)
    }
    
    @discardableResult
    @objc public func open(action:HBRouterAction,params:[String:Any] = [:]) -> Any? {
        action.addEntriesFromDictonary(params)
        return openRouterAction(action)
    }
    @discardableResult
    @objc public func open(action:HBRouterAction) -> Any? {
        return openRouterAction(action)
    }
    
    
    
}

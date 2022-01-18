# HBRouter

![image](https://user-images.githubusercontent.com/3955387/149880769-43c21105-d9a1-4eb4-9ded-e40de2f05033.png)


路由初始化注册管理
 ```
  //方法工厂
 //自定义跳转方法
  public typealias  handlerFactory = (_ router: HBRouterAction) -> Any?

  //注册自定义返回Controller
  public typealias  viewControllerFactory = (_ router:HBRouterAction) -> UIViewController?
  
 //全局单例
  public static func shared() -> HBRouter.HBRouter
  ///默认路由host
  public var defaultRouterHost: String { get }

  /// 默认路由scheme
  public var defaultRouterScheme: String { get }

  //默认导航控制器类（初始化时使用）
  public var wrapNavgClass: UINavigationController.Type

  @objc weak public var deleage: HBRouter.HBRouterDelegate?

  @objc public func setDefault(_ scheme: HBRouter.routerScheme, host: HBRouter.routerHost)

  @objc public private(set) var routerMapping: [HBRouter.routerURLPattern : HBRouter.HBRouterTarget] { get }

  /// 路由表注册
  /// - Parameters:
  ///   - mapping: 路由表映射关系
  ///   - bundleClass: 映射对象所在 bundleClass
  public func registRouter(_ mapping: [HBRouter.routerPath : HBRouter.routerTarget], bundleClass: AnyClass? = nil)

  public func registRouter(_ mapping: [HBRouter.routerPath : HBRouter.routerTarget], bundle: HBRouter.routerBundle? = nil)

  public func registeRouter(_ targets: [HBRouter.HBRouterTarget])

  public func openController(_ action: HBRouter.HBRouterAction) -> (viewController: UIViewController?, success: Bool)?


  自定义路由方法处理（用于处理jsbridge和flutter 路由相关）
  /// 自行处理openAction操作
  /// - Parameters:
  ///   - urlPatterns: hb://router.com/path  hb://router.com  hb://  hb
  ///   - factory:  回调方法
  override public func registeHander(_ urlPatterns: [HBRouter.routerURLPattern], factory: @escaping HBRouter.handlerFactory)

  override public func registerHander(_ urlPattern: HBRouter.routerURLPattern, factory: @escaping HBRouter.handlerFactory)

  override public func registeViewController(_ urlPatterns: [HBRouter.routerURLPattern], factory: @escaping HBRouter.viewControllerFactory)

  override public func registerViewController(_ urlPattern: HBRouter.routerURLPattern, factory: @escaping HBRouter.viewControllerFactory)
 ```
### 代理协议：HBRouterDelegate

```
    //router权限校验及调用生命周期
    //登录态判断及状态回调
    func loginStatus(_ action:HBRouterAction, completion: ((Bool) -> Void)?) -> Bool
    
    //路由权限校验
    func shouldOpenRouter(_ action:HBRouterAction) -> Bool
    //路由打开状态
    func willOpenRouter(_ action:HBRouterAction)
    func didOpenRouter(_ action:HBRouterAction)
    
    
    //外链判断
    func shouldOpenExternal(_ action:HBRouterAction) -> Bool
    
    //外链打开状态
    func willOpenExternal(_ action:HBRouterAction)
    func openExternal(_ action:HBRouterAction, completion: ((Bool) -> Void)?)
    func didOpenExternal(_ action:HBRouterAction)
    
    
    //未能匹配到的路由回调
    func onMatchUnhandleRouterAction(_ action:HBRouterAction)
    //路由匹配成功回调
    func onMatchRouterAction(_ action:HBRouterAction, any:Any?)
```
路由组件使用
```
//打开路由Action
override public func openRouterAction(_ action: HBRouter.HBRouterAction) -> Any?
public func open(url: URL) -> Any?
public func open(url: URL, completion: ((HBRouter.HBRouterResponse) -> Void)? = nil, callBack: ((Any?) -> Void)? = nil) -> Any?
public func open(url: URL, params: [String : Any]) -> Any?
public func open(url: URL, params: [String : Any], completion: ((HBRouter.HBRouterResponse) -> Void)? = nil, callBack: ((Any?) -> Void)? = nil) -> Any?
public func open(_ path: HBRouter.routerPath, host: HBRouter.routerHost, scheme: HBRouter.routerScheme, params: [String : Any] = [:], completion: ((HBRouter.HBRouterResponse) -> Void)? = nil, callBack: ((Any?) -> Void)? = nil) -> Any?
public func open(urlPattern: HBRouter.routerURLPattern, completion: ((HBRouter.HBRouterResponse) -> Void)? = nil, callBack: ((Any?) -> Void)? = nil) -> Any?
public func open(urlPattern: HBRouter.routerURLPattern, params: [String : Any]) -> Any?
public func open(urlPattern: HBRouter.routerURLPattern, params: [String : Any], completion: ((HBRouter.HBRouterResponse) -> Void)? = nil, callBack: ((Any?) -> Void)? = nil) -> Any?
public func open(action: HBRouter.HBRouterAction) -> Any?
public func open(action: HBRouter.HBRouterAction, params: [String : Any]) -> Any?
public func open(path: HBRouter.routerPath) -> Any?
public func open(path: HBRouter.routerPath, params: [String : Any] = [:]) -> Any?
public func open(path: HBRouter.routerPath, params: [String : Any] = [:], completion: ((HBRouter.HBRouterResponse) -> Void)? = nil, callBack: ((Any?) -> Void)? = nil) -> Any?

//查询栈内匹配到相关页面
override public func matchPages(_ action: HBRouter.HBRouterAction) -> [UIViewController]?

//回退到栈内匹配到的页面
override public func pop2Path(_ path: HBRouter.routerPath, params: [String : Any] = [:], completion: ((Bool) -> Void)? = nil) -> [UIViewController]?
override public func pop2Action(_ action: HBRouter.HBRouterAction, completion: ((Bool) -> Void)? = nil) -> [UIViewController]?
override public func pop2URL(_ url: URL, params: [String : Any] = [:], completion: ((Bool) -> Void)? = nil) -> [UIViewController]?

/// 关闭栈内路由匹配成功的控制器，如果只有一个根控制器，则不返回
/// - Parameter path: 路由path
/// - Returns: 被移除的控制器
override public func closePage(path: HBRouter.routerPath) -> [UIViewController]?

/// 关闭导航栈中匹配到的路由
/// - Parameter urlPattern: hb://router.com/path
/// - Returns: 返回被关闭的控制器
override public func closePage(urlPattern: HBRouter.routerURLPattern) -> [UIViewController]?
```

### 路由模型：
```
@objc public enum HBRouterOption : Int {

    case push = 0  //导航栈 push

    case present   // present到新的导航栈

    case wrap_nc   // present页面时是否添加导航控制器

    case fullScreen  // iOS13 是否强制全屏
}


//路由打开成功时返回模型对象
@objcMembers public class HBRouterResponse : NSObject {

    public private(set) var code: Int { get }

    public private(set) var msg: String { get }

    public private(set) var data: Any? { get }

    public private(set) var action: HBRouter.HBRouterAction { get }

    @objc public init(_ action: HBRouter.HBRouterAction, data: Any? = nil, msg: String = "", code: Int = 0)
}
    
//Target对象
@objcMembers open class HBRouterTarget : NSObject {

    public var scheme: String

    public var host: String

    public var path: String

    public var target: String

    public var targetClass: AnyClass?

    public var bundle: String

    public var url: URL?

    public func routerURLPattern() -> HBRouter.routerURLPattern

    public var targetType: HBRouter.HBTargetType

    /// 规则定义
    /// - Parameters:
    ///   - scheme: hb://  & hb   &   https://  & http
    ///   - host: router.com
    ///   - path: /home/page/detail
    ///   - target: 目标类
    ///   - bundle: 目标类所在库的库名
    ///   - targetType: 目标类能力类型
    public init(scheme: String, host: String, path: String, target: String, bundle: String, targetType: HBRouter.HBTargetType = .undefined)

    public init(path: String, target: String, bundle: String)

    public init(path: String, target: String)
}


    //router类型
    @objc public enum HBTargetType : Int {

        case undefined = 0

        case controller = 1

        case flutter = 2

        case bridge = 3
    }

```





### UIViewController扩展
```
 //router item数据源
 @objc public private(set) var routeAction: HBRouter.HBRouterAction?
 //路由path
 @objc public private(set) var routeURLPattern: String?

 //手动设置action
 @objc public func setRouterAction(_ routeAction: HBRouter.HBRouterAction)  
 /// 控制器内处理action回调
 /// - Parameter action: action参数
 /// - Returns: 判断是否可以打开页面 false 时，不能打开该页面
 @objc open func handleRouterAction(_ action: HBRouter.HBRouterAction) -> Bool

 @objc open class func needsLogin(_ action: HBRouter.HBRouterAction) -> Bool

 /// 栈内单例是否唯一：
 /// - Parameter
 @objc open class func isSingleton(_ action: HBRouter.HBRouterAction) -> Bool

 //是否支持侧滑返回
 @objc open func canSlideBack() -> Bool

```

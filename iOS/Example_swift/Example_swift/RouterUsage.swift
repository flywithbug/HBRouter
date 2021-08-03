//
//  RouterUsage.swift
//  Example_swift
//
//  Created by flywithbug on 2021/7/22.
//

import SafariServices

import HBRouter



class RouterUsage {
    func handler()  {
//        send
    }
    //注册handler
    public  static func registerHandler(){
        HBRouter.shared().setDefault("hb", host: "router.com")
        HBRouter.shared().registeViewController(["http://","https://"], factory: RouterUsage.webViewControllerFactory)
        HBRouter.shared().registeHander(["http://","https://"], factory: RouterUsage.openWebViewController)
        HBRouter.shared().registeHander(["bridge://"], factory: RouterUsage.handlerBridge)
        HBRouter.shared().registeHander(["hb://flutter.com"], factory: RouterUsage.handlerflutter)
    }
    
    public static func registRouterMapping(){
        HBRouter.shared().registRouter(HBRouter.shared().defaultRouterScheme,
                                        mapping:
                                            ["home_swift":"ViewController"
                                             ,"vc_01_oc":"ViewController01",
                                             "login":"LoginViewController",
                                            ],
                                        bundle:   HBRouterAppName ?? "Example_swift",
                                        host:     HBRouter.shared().defaultRouterHost,
                                        targetType:.controller)
        RouterManager.registRouter()
    }
    
    static func handlerflutter(_ action:HBRouterAction) -> Any? {
        print(action.url?.absoluteURL ?? "")
        return nil
    }
    
    
    static func webViewControllerFactory(_ action:HBRouterAction) -> UIViewController?{
        guard var url = action.url else {
            return nil
        }
        for item in action.params{
            if let value = item.value as? String {
                url.appendQueryParameters([item.key:value])
            }
        }
        action.options = [.present]
        let safar = SFSafariViewController.init(url: url)
        return safar
    }
    
    static func openWebViewController(_ action:HBRouterAction) -> Any? {
        return HBRouter.shared().openController(action)
    }
    
    static func handlerBridge(_ action:HBRouterAction) -> Any? {
//        print("path:\(action.path ?? ""),host:\(action.host ?? "")")
        if let callBackBlock = action.callBackBlock {
            callBackBlock("handlerBridge")
        }
        //调用方式优化
        if action.path == "/routerActionTest" {
           return routerActionTest(action)
        }
        
        
        if action.path == "/navigationPushtest" {
            return navigationPushtest(action)
        }
        return nil
    }
    
    
    
    
    public static func  dataSource() -> [HBRouterAction] {
        var dataSource:[HBRouterAction] = []
        let action = HBRouterAction.init(urlPattern: "https://www.baidu.com/s?wd=name&rsv_spt=1&rsv_iqid=0xaf313311006a4028&issp=1&f=8&rsv_bp=1&rsv_idx=2&ie=utf-8&tn=baiduhome_pg&rsv_enter=1&rsv_dl=tb&rsv_sug3=12&rsv_sug1=3&rsv_sug7=100&rsv_sug2=0&rsv_btype=i&inputT=2967&rsv_sug4=3153")
        action.addValue("网页跳转测试", key: "subTitle")
        action.callBackBlock = { (value) in
            print("\(value ?? "---")")
        }
        dataSource.append(action)
        
        for item in HBRouter.shared().routerMapping{
            let action = HBRouterAction.init(urlPattern: item.key)
            action.addValue("已注册原生路由跳转测试", key: "subTitle")
            action.callBackBlock = { (value) in
                print("\(value ?? "---")")
            }
            dataSource.append(action)
        }
        dataSource.append(action)
        return dataSource
    }
    
    public static func bridgeDataSource() -> [HBRouterAction] {
        
        var dataSource:[HBRouterAction] = []
        var action = HBRouterAction.init(urlPattern: "bridge://hellobike/routerActionTest")
        action.addValue("基础功能测试，HBRouterAction参数获取", key: "subTitle")
        action.callBackBlock = { (value) in
            print("\(value ?? "---")")
        }
        dataSource.append(action)
        
        action = HBRouterAction.init(urlPattern: "bridge://hellobike/navigationPushtest")
        action.animation = false
        action.addValue("基础功能测试，连续跳转，关闭转场动画", key: "subTitle")
        action.callBackBlock = { (value) in
            print("\(value ?? "---")")
        }
        dataSource.append(action)
        
        action = HBRouterAction.init(urlPattern: "bridge://hellobike/navigationPushtest?a=10")
        action.animation = true
        action.addValue("基础功能测试，连续跳转，打开转场动画", key: "subTitle")
        action.callBackBlock = { (value) in
            print("\(value ?? "---")")
        }
        dataSource.append(action)
        
        return dataSource
    }
    
    
    
    
    

}

extension RouterUsage{
    
    
    
    static func navigationPushtest(_ action:HBRouterAction) -> Any?{
        let nav = UIViewController.topMost?.navigationController
        let vc1 = ViewController01.init()
        
        let vc2 = ViewController02.init()
        nav?.pushViewController(vc1, animated: false)
        nav?.pushViewController(vc2, animated: false)
//        vc1 = ViewController01.init()
        nav?.pushViewController(vc1, animated: false)
        nav?.pushViewController(vc2, animated: false)

        return true
    }
    static func routerActionTest(_ action:HBRouterAction) -> Any?{
        
        print("==============================routerActionTest==============================")
        
        var scheme = "https://"
        print(scheme)
        scheme = String(scheme.prefix(scheme.count - 3))
        print(scheme)
        
        
        
        
        
        var url:URL = URL.init(string: "http://www.baidu.com/path/home/page1?abc=1&a=10")!
        url.appendQueryParameters(["url":"https://www.baidu.com?c=2302322aaaa&d=4"])
        print(url.scheme ?? "");
        print(url.host ?? "");
        print(url.path );
        print(url.pathComponents );
        print(url.relativePath)
        print(url.absoluteString)
        print(url.deletingAllPathComponents())
        
        print(url.queryParameters as Any)
        let action:HBRouterAction = HBRouterAction(url: url)
        
        print( action.stringValue("url") ?? "")
        
        print(action.scheme ?? "")
        print(action.host ?? "")
        print(action.path ?? "")
        print(action.params)

        print( action.stringValue("a") ?? "")
        print( action.intValue("a") ?? "")
        print( action.boolValue("a") ?? "")
        print( action.numberValue("a") ?? "")
        print( action.doubleValue("a") ?? "")
        
        print("==============================routerActionTest==============================")

        return true
    }
}

//
//  RouterUsage.swift
//  Example_swift
//
//  Created by flywithbug on 2021/7/22.
//

import Foundation

import HBRouter

class RouterUsage {
    
    
    func handler()  {
//        send
    }
    //注册handler
    public  static func registerHandler(){
        HBRouter.router().setDefault("hb", host: "router.com")
        
        HBRouter.router().registeHander(["bridge://"], factory: RouterUsage.handlerBridge)
        HBRouter.router().registeHander(["hb://flutter.com"], factory: RouterUsage.handlerflutter)
        HBRouter.router().registeHander(["hb://router.com"], factory: HBRouter.router().openController)
        
    }
    
    
    
    public static func registRouterMapping(){
        HBRouter.router().registRouter(HBRouter.router().defaultRouterScheme,
                                        mapping:
                                            ["home_swift":"ViewController"
                                             ,"vc_01_oc":"ViewController01"],
                                        bundle:   HBRouterAppName ?? "Example_swift",
                                        host:     HBRouter.router().defaultRouterHost,
                                        targetType:.controller)
        
        
        
        RouterManager.registRouter()
    }
    
    
    
    static func handlerflutter(_ action:HBRouterAction) -> Any? {
        print(action.url?.absoluteURL ?? "")
        return nil
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
        
        //调用方式优化
        if action.path == "/routerActionTest1" {
           return routerActionTest(action)
        }
        
        return nil
    }
    
    
    
    
    public static func  dataSource() -> [HBRouterAction] {
        var dataSource:[HBRouterAction] = []
        var action = HBRouterAction.init(urlPattern: "bridge://hellobike/routerActionTest")
//        action.setCallBackBlock { (value) in
////            print("\(value ?? "---")","a")
//        }
        dataSource.append(action)
        
        action = HBRouterAction.init(urlPattern: "bridge://hellobike/routerActionTest1")
//        action.setCallBackBlock { (value) in
////            print("\(value ?? "---")", "b")
//        }
        dataSource.append(action)
        
        
        action = HBRouterAction.init(urlPattern: "hb://router.com/home")
//        action.setCallBackBlock { (value) in
////            print("\(value ?? "---")", "b")
//        }
        dataSource.append(action)
        
        
        
        action = HBRouterAction.init(urlPattern: "hb://flutter.com/flutterpage")
//        action.setCallBackBlock { (value) in
////            print("\(value ?? "---")", "b")
//        }
        
        
//        for scheme in HBRouter.router().{
//            for path in HBRouter.router().routerTargetMapping[scheme]{
//                
//            }
//        }
        dataSource.append(action)
        return dataSource
    }
    
    
    
    
    

}

extension RouterUsage{
    
    
    
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

        return nil
    }
    
    
    
}

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
        HBRouter.router().defaultRouterScheme = "hb"
        HBRouter.router().defaultRouterHost = "router.com"
        
        HBRouter.router().registeHander(["bridge"], factory: RouterUsage.handlerBridge)
        
    }
    
    
    
    public static func registRouterMapping(){
        
        HBRouter.router().registRouterMapping(mapping: ["home":"ViewController"], scheme: "hb", bundle: HBRouterAppName ?? "")
        
        
        
    }
    
    
    
    
    static func handlerBridge(_ action:HBRouterAction) -> Any? {
        print("path:\(action.path ?? ""),host:\(action.host ?? "")")
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
    
    
    
    static func routerActionTest(_ action:HBRouterAction) -> Any?{
        
        print(action.url?.absoluteURL ?? "")
        
        var url:URL = URL.init(string: "http://www.baidu.com")!
        
        url.appendQueryParameters(["url":"www.baidu.com?c=2302322aaaa&d=4"])
        print(url.scheme ?? "");
        print(url.host ?? "");
        print(url.path );
        print(url.pathComponents );
        print(url.queryParameters as Any)

        let action:HBRouterAction = HBRouterAction(url: url)
        print(action.scheme ?? "")
        print(action.host ?? "")
        print(action.path ?? "")
        print(action.params)
        
        print( action.string("a") ?? "")
        print( action.int("a") ?? "")
        print( action.bool("a") ?? "")
        print( action.number("a") ?? "")
        print( action.double("a") ?? "")
        
        return nil
    }
    
    

}

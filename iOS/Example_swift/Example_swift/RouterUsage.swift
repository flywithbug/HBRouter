//
//  RouterUsage.swift
//  Example_swift
//
//  Created by flywithbug on 2021/7/22.
//

import Foundation

import HBRouter

class RouterUsage {
    
    //注册handler
    public  static func registerHandler(){
        HBRouter.router().registeHander(["http","https"], factory: RouterUsage.handlerBridge)
    }
    
    
    static func handlerBridge(_ action:HBRouterAction) -> Any? {
        print("path:\(action.path ?? ""),host:\(action.host ?? "")")
        
        if let callBackBlock = action.callBackBlock {
            callBackBlock("handlerBridge")
        }
        
        return nil
    }
    
    
    
    
    

}

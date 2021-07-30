//
//  UserAccountManager.swift
//  Example_swift
//
//  Created by flywithbug on 2021/7/30.
//

import UIKit

class UserAccountManager: NSObject {
    
    public var loginState:Bool = false
    private static let shareInstance = UserAccountManager()
    private override init() {
        super.init()
        
    }
    public static func share() -> UserAccountManager{
        return shareInstance
    }
    func login(completion:((Bool)->Void)? = nil)  {
        //模拟登陆
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion?(true)
        }
    }
}

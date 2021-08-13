//
//  AppDelegate.swift
//  Example_swift
//
//  Created by flywithbug on 2021/7/6.
//

import UIKit
@_exported import HBRouter

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {
        super.init()
        UserAccountManager.share()
        RouterUsage.registerHandler()
        RouterUsage.registRouterMapping()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
     
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.backgroundColor = .white
        window.rootViewController = UINavigationController.init(rootViewController: FuncModuleViewController())
        self.window = window
    
        return true
    }



}


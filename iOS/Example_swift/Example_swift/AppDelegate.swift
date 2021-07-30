//
//  AppDelegate.swift
//  Example_swift
//
//  Created by flywithbug on 2021/7/6.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.backgroundColor = .white
        window.rootViewController = UINavigationController.init(rootViewController: ViewController())
        self.window = window
        UserAccountManager.share()
        RouterUsage.registerHandler()
        RouterUsage.registRouterMapping()
        return true
    }



}


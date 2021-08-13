//
//  UINavigationControllerExtension.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/8.
//

import Foundation
import UIKit


extension UINavigationController {
    
    @discardableResult
    @objc public func popViewController(animated: Bool,completion:(()->Void)? = nil) -> UIViewController?{
        CATransaction.begin()
        CATransaction.setCompletionBlock{
            ()in
            completion?()
        }
        let viewController =  popViewController(animated: animated)
        CATransaction.commit()
        return viewController
    }
    
    public func popToViewController(_ viewController:UIViewController,animated:Bool = true,  completion: (() -> Void)? = nil) -> [UIViewController]?{
        CATransaction.begin()
        let  controllers = popToViewController(viewController, animated: animated)
        CATransaction.setCompletionBlock{
            ()in
            completion?()
        }
        CATransaction.commit()
        return controllers;
    }
    
    
    @objc func hbr_pushViewController(_ viewController:UIViewController,animated:Bool = true){
        if viewControllers.last == viewController {
            return
        }
        if viewControllers.contains(viewController){
            //同一个实例控制器被Push两次
//            assert(false, "pushing the same view controller instance \(viewController)  more than once which is not supported")
            var tempViewControllers = [UIViewController]()
            for item in viewControllers{
                if item != viewController {
                    tempViewControllers.append(item)
                }
            }
            setViewControllers(tempViewControllers, animated: false)
        }
        self.hbr_inAnimating = true
        hbr_pushViewController(viewController, animated: animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + (animated ? 0.4 : 0.1)) {
            self.hbr_inAnimating = false
        }
    }
    
    
    @objc func hbr_popViewController(animated: Bool) -> UIViewController?{
        self.hbr_inAnimating = true
        let viewController = hbr_popViewController(animated: animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + (animated ? 0.4 : 0.1)) {
            self.hbr_inAnimating = false
        }
        return viewController
    }
    
    @objc func hbr_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]?{
        self.hbr_inAnimating = true
        let viewControllers = hbr_popToViewController(viewController, animated: animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + (animated ? 0.4 : 0.1)) {
            self.hbr_inAnimating = false
        }
        return viewControllers
    }
    
    @objc func hbr_popToRootViewController(animated: Bool) -> [UIViewController]?{
        self.hbr_inAnimating = true
        let viewControllers = hbr_popToRootViewController(animated: animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + (animated ? 0.4 : 0.1)) {
            self.hbr_inAnimating = false
        }
        return viewControllers
    }
    
    
    @objc static func initializeNavSwizzleMethod(){
        swizzleMethod(for: self, originalSelector: #selector(pushViewController(_:animated:)), swizzledSelector: #selector(hbr_pushViewController(_:animated:)))
        swizzleMethod(for: self, originalSelector: #selector(popViewController(animated:)), swizzledSelector: #selector(hbr_popViewController(animated:)))
        swizzleMethod(for: self, originalSelector: #selector(popToViewController(_:animated:)), swizzledSelector: #selector(hbr_popToViewController(_:animated:)))
        swizzleMethod(for: self, originalSelector: #selector(popToRootViewController(animated:)), swizzledSelector: #selector(hbr_popToRootViewController(animated:)))
    }
    
}


extension UINavigationController:UIGestureRecognizerDelegate{
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == interactivePopGestureRecognizer) {
            //last 控制器禁用侧滑
            if viewControllers.count == 1 {
                return false
            }
            return viewControllers.last?.canSlideBack() ?? false
        }
        return false
    }
    
}

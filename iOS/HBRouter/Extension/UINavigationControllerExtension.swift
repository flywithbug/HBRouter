//
//  UINavigationControllerExtension.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/8.
//

import Foundation


extension UINavigationController {
    
//    func inBlockMode() -> Bool {
//        return self.inAnimating
//    }
    private var fblock:NSLock{
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.fblockIdentifier) as? NSLock ?? NSLock()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.fblockIdentifier, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    private struct AssociatedKey {
        static var inAnimatingIdentifier: String = "inAnimatingIdentifier"
        static var fblockIdentifier: String = "fblockIdentifier"
    }
    public var inAnimating:Bool{
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.inAnimatingIdentifier) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.inAnimatingIdentifier, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    public func push(_ viewController:UIViewController, animated:Bool = true, completion:(() -> Void)? = nil){
        pushViewController(viewController, animated: animated)
        completion?()
    }
    public func pop(_ animated:Bool = true, completion:(() -> Void)? = nil){
        popViewController(animated: animated)
        completion?()
    }
    public func pop(_ toViewController:UIViewController, animated:Bool = true,completion: (([UIViewController]?) -> Void)? = nil){
        let controllers = popToViewController(toViewController, animated: animated)
        completion?(controllers)
    }
    
    @objc func hbr_pushViewController(_ viewController:UIViewController,animated:Bool = true){
        if viewControllers.last == viewController {
            return
        }
        fblock.lock()
        inAnimating = true
        //栈内已存在相同控制器
        if viewControllers.contains(viewController) {
            viewControllers.removeAll { (item) -> Bool in
                return item == viewController
            }
            setViewControllers(viewControllers, animated: false)
        }
        CATransaction.begin()
        hbr_pushViewController(viewController, animated: animated)
        CATransaction.setCompletionBlock {
            ()in
            self.inAnimating = false
            self.fblock.unlock()
        }
        CATransaction.commit()
    }
    
    @objc func hbr_popViewController(animated: Bool) -> UIViewController?{
        inAnimating = true
        fblock.lock()
        CATransaction.begin()
        let viewController = hbr_popViewController(animated: animated)
        CATransaction.setCompletionBlock {
            ()in
            self.inAnimating = false
            self.fblock.unlock()
        }
        CATransaction.commit()
        return viewController
    }
    
    @objc func hbr_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]?{
        inAnimating = true
        fblock.lock()
        CATransaction.begin()
        let viewControllers = popToViewController(viewController, animated: animated)
        CATransaction.setCompletionBlock {
            ()in
            self.inAnimating = false
            self.fblock.unlock()
        }
        CATransaction.commit()
        return viewControllers
    }
    
    @objc func hbr_popToRootViewController(animated: Bool) -> [UIViewController]?{
        inAnimating = true
        fblock.lock()
        CATransaction.begin()
        let viewControllers = popToRootViewController(animated: animated)
        CATransaction.setCompletionBlock {
            ()in
            self.inAnimating = false
            self.fblock.unlock()
        }
        CATransaction.commit()
        return viewControllers
    }
    
    
    
    
    static func initializeSwizzleMethod(){
        
        swizzleMethod(for: self, originalSelector: #selector(pushViewController(_:animated:)), swizzledSelector: #selector(hbr_pushViewController(_:animated:)))
        swizzleMethod(for: self, originalSelector: #selector(popViewController(animated:)), swizzledSelector: #selector(hbr_popViewController(animated:)))
        swizzleMethod(for: self, originalSelector: #selector(popToViewController(_:animated:)), swizzledSelector: #selector(hbr_popToViewController(_:animated:)))
        swizzleMethod(for: self, originalSelector: #selector(popToRootViewController(animated:)), swizzledSelector: #selector(hbr_popToRootViewController(animated:)))
    }
    
    
    
    
    
}

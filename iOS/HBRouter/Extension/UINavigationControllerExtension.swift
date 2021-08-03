//
//  UINavigationControllerExtension.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/8.
//

import Foundation
import UIKit


extension UINavigationController {
    
//    func inBlockMode() -> Bool {
//        return self.inAnimating
//    }
    private var hblock:NSLock{
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
//    @objc public func push(_ viewController:UIViewController, animated:Bool = true, completion:(() -> Void)? = nil){
//        hblock.lock()
//        CATransaction.begin()
//        pushViewController(viewController, animated: animated)
//        CATransaction.setCompletionBlock {
//            ()in
//            completion?()
//            self.hblock.unlock()
//        }
//        CATransaction.commit()
//
//    }
//    @objc public func pop(_ animated:Bool = true, completion:(() -> Void)? = nil){
//        CATransaction.begin()
//        popViewController(animated: animated)
//        CATransaction.setCompletionBlock {
//            ()in
//            completion?()
//        }
//        CATransaction.commit()
//    }
//    @objc
//    public func pop(_ toViewController:UIViewController, animated:Bool = true,completion: (([UIViewController]?) -> Void)? = nil){
//        CATransaction.begin()
//        let controllers = popToViewController(toViewController, animated: animated)
//        CATransaction.setCompletionBlock {
//            ()in
//            completion?(controllers)
//        }
//        CATransaction.commit()
//    }
    
    
    @objc func hbr_pushViewController(_ viewController:UIViewController,animated:Bool = true){
        if viewControllers.contains(viewController){
            assert(false, "pushing the same view controller instance \(viewController)  more than once which is not supported and is most likely an error in the applicatio")
            return
        }
        inAnimating = true
        hbr_pushViewController(viewController, animated: animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + (animated ? 0.4 : 0.1)) {
            self.inAnimating = false
        }
    }
    
    
    @objc func hbr_popViewController(animated: Bool) -> UIViewController?{
        inAnimating = true
        let viewController = hbr_popViewController(animated: animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + (animated ? 0.4 : 0.1)) {
            self.inAnimating = false
        }
        return viewController
    }
    
    @objc func hbr_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]?{
        inAnimating = true
        let viewControllers = hbr_popToViewController(viewController, animated: animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + (animated ? 0.4 : 0.1)) {
            self.inAnimating = false
        }
        return viewControllers
    }
    
    @objc func hbr_popToRootViewController(animated: Bool) -> [UIViewController]?{
        inAnimating = true
        let viewControllers = hbr_popToRootViewController(animated: animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + (animated ? 0.4 : 0.1)) {
            self.inAnimating = false
        }
        return viewControllers
    }
    
    
    
    
    @objc  static func initializeSwizzleMethod(){
        
        swizzleMethod(for: self, originalSelector: #selector(pushViewController(_:animated:)), swizzledSelector: #selector(hbr_pushViewController(_:animated:)))
        swizzleMethod(for: self, originalSelector: #selector(popViewController(animated:)), swizzledSelector: #selector(hbr_popViewController(animated:)))
        swizzleMethod(for: self, originalSelector: #selector(popToViewController(_:animated:)), swizzledSelector: #selector(hbr_popToViewController(_:animated:)))
        swizzleMethod(for: self, originalSelector: #selector(popToRootViewController(animated:)), swizzledSelector: #selector(hbr_popToRootViewController(animated:)))
    }
    
    
    
    
    
}

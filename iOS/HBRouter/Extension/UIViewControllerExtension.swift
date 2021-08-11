//
//  UIViewControllerExtension.swift
//  HBRouter
//
//  Created by flywithbug on 2021/7/8.
//

import UIKit

extension UIViewController{
    
    /// 控制器内处理action回调
    /// - Parameter action: action参数
    /// - Returns: 判断是否可以打开页面 false 时，不能打开该页面
    @discardableResult
    @objc open func handleRouterAction(_ action:HBRouterAction) ->Bool{
        
        return true
    }
    
    @objc open class func needsLogin(_ action:HBRouterAction) ->Bool{
        return false
    }
    /// 栈内单例唯一：
    /// 当前导航栈内唯一
    /// - Parameter
    @objc open class func isSingleton(_ action:HBRouterAction) -> Bool{
        return false
    }
    //是否允许侧滑返回- 默认允许
    @objc open func canSlideBack() -> Bool{
        return true
    }
    
   
    
}

extension UIViewController{
    
    private struct AssociatedKey {
        static var hbr_inAnimatingIdentifier: String = "hbr_inAnimatingIdentifier"
    }
    
    public var hbr_inAnimating:Bool{
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.hbr_inAnimatingIdentifier) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.hbr_inAnimatingIdentifier, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    @objc func hbr_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil){
        self.hbr_inAnimating = true
        hbr_present(viewControllerToPresent, animated: flag) { [weak self] () in
            self?.hbr_inAnimating = false
            completion?()
        }
    }
    
    @objc func hbr_dismiss(animated flag: Bool, completion: (() -> Void)? = nil){
        self.hbr_inAnimating = true
        hbr_dismiss(animated: flag) { [weak self] () in
            self?.hbr_inAnimating = false
            completion?()
        }
    }
    
    
    @objc
    static func initializeVCSwizzleMethod(){
        swizzleMethod(for: self, originalSelector: #selector(present(_:animated:completion:)), swizzledSelector: #selector(hbr_present(_:animated:completion:)))
        swizzleMethod(for: self, originalSelector: #selector(dismiss(animated:completion:)), swizzledSelector: #selector(hbr_dismiss(animated:completion:)))
    }
    
    
    
}








extension UIViewController {
    private class var sharedApplication: UIApplication? {
      let selector = NSSelectorFromString("sharedApplication")
      return UIApplication.perform(selector)?.takeUnretainedValue() as? UIApplication
    }
    
    /// Returns the current application's top most view controller.
    @objc open class var topMost: UIViewController? {
      guard let currentWindows = self.sharedApplication?.windows else { return nil }
      var rootViewController: UIViewController?
      for window in currentWindows {
        if let windowRootViewController = window.rootViewController, window.isKeyWindow {
          rootViewController = windowRootViewController
          break
        }
      }

      return self.topMost(of: rootViewController)
    }

    /// Returns the top most view controller from given view controller's stack.
    @objc open class func topMost(of viewController: UIViewController?) -> UIViewController? {
      // presented view controller
      if let presentedViewController = viewController?.presentedViewController {
        return self.topMost(of: presentedViewController)
      }

      // UITabBarController
      if let tabBarController = viewController as? UITabBarController,
        let selectedViewController = tabBarController.selectedViewController {
        return self.topMost(of: selectedViewController)
      }

      // UINavigationController
      if let navigationController = viewController as? UINavigationController,
        let visibleViewController = navigationController.visibleViewController {
        return self.topMost(of: visibleViewController)
      }

      // UIPageController
      if let pageViewController = viewController as? UIPageViewController,
        pageViewController.viewControllers?.count == 1 {
        return self.topMost(of: pageViewController.viewControllers?.first)
      }

      // child view controller
      for subview in viewController?.view?.subviews ?? [] {
        if let childViewController = subview.next as? UIViewController {
          return self.topMost(of: childViewController)
        }
      }
      return viewController
    }
}





public extension Array where Element:UIViewController {
    typealias HBRValidationBlock = (_ obj:UIViewController)->Bool
    func match(validate:HBRValidationBlock) -> UIViewController?{
        for item in self{
            if validate(item)  {
                return item
            }
        }
        return nil
    }
    
    
}


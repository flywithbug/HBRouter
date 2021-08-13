//
//  LoginViewController.swift
//  Example_swift
//
//  Created by flywithbug on 2021/7/30.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = UserAccountManager.share().loginState ? "已登录" : "需要登录"
        view.backgroundColor = UIColor.white
        let btn = UIButton.init(type: .custom)
        btn.setTitle(UserAccountManager.share().loginState ? "点击退出登录" :"点击登录", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal);
        btn.frame = CGRect.init(x: 100, y: 100, width: self.view.frame.size.width - 200, height: 80)
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    @objc
    func btnAction(_ sender:UIButton) {
        UserAccountManager.share().loginState = !UserAccountManager.share().loginState
        dismiss()
        
    }
    func dismiss()  {
        if presentingViewController != nil{
            dismiss(animated: true) {
                self.routeAction?.callBackBlock?(true)
            }
        }else{
            
            self.navigationController?.popViewController(animated: true, completion: { [weak self]()in
                self?.routeAction?.callBackBlock?(true)
            })
            
        }
    }
}

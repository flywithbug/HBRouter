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
        self.title = "登录页面"
        
        let btn = UIButton.init(type: .custom)
        btn.setTitle("点击登录", for: .normal)
        btn.frame = CGRect.init(x: 100, y: 100, width: self.view.frame.size.width - 200, height: 80)
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    @objc
    func btnAction(_ sender:UIButton) {
        UserAccountManager.share().loginState = true
    }
    func dismiss()  {
        if presentedViewController != nil{
            dismiss(animated: true, completion: nil)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
}

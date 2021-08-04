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
        self.title = "需要登录"
        view.backgroundColor = UIColor.white
        let btn = UIButton.init(type: .custom)
        btn.setTitle("点击登录", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal);
        btn.frame = CGRect.init(x: 100, y: 100, width: self.view.frame.size.width - 200, height: 80)
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    @objc
    func btnAction(_ sender:UIButton) {
        UserAccountManager.share().loginState = true
        dismiss()
        
    }
    func dismiss()  {
        if presentingViewController != nil{
            dismiss(animated: true) {
                self.routeAction?.callBackBlock?(true)
            }
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
}

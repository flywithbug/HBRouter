//
//  ViewController.swift
//  Example_swift
//
//  Created by flywithbug on 2021/7/6.
//

import UIKit
import HBRouter
import WebKit


class ViewController: UIViewController, UIDocumentPickerDelegate {
    
    var webView:WKWebView = WKWebView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        RouterUsage.registerHandler()
        
//        HBNavigator.navigator.registeHander(["http","https"], factory: self.handlrBridge)
        
//        view.addSubview(webView)
//        webView.frame = view.bounds
//        webView.loadHTMLString("<input accept='file/*' type='file'>", baseURL: nil)
//
//
        let btn:UIButton = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 80, height: 60))
        btn.backgroundColor = UIColor.red
        btn.setTitle("push", for: .normal)
        view.addSubview(btn)
        btn.tag = 1
        btn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
        
        
        
        let btn1:UIButton = UIButton.init(frame: CGRect.init(x: 100, y: 200, width: 80, height: 60))
        btn1.backgroundColor = UIColor.black
        btn1.setTitle("bridge", for: .normal)
        view.addSubview(btn1)
        btn1.tag = 2
        btn1.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
        
        
        
//        var url:URL = URL.init(string: "https://baidu.com/a/b/c?a=20&b=2")!
//        url.appendQueryParameters(["url":"www.baidu.com?c=2302322aaaa&d=4"])
//        print(url.scheme ?? "");
//        print(url.host ?? "");
//        print(url.path );
//        print(url.pathComponents );
//        print(url.queryParameters as Any)
//
//        let action:HBRouterAction = HBRouterAction(url: url)
//        print(action.scheme ?? "")
//        print(action.host ?? "")
//        print(action.path ?? "")
//        print(action.params)
        
        
//        print( action.string("a"))
//        print( action.int("a"))
//        print( action.bool("a"))
//        print( action.number("a"))
//        print( action.double("a"))

//        var params:[String:Any]  = [String:Any]()
//        params["a"] = "1"
//        params["b"] = "2"
//        print(params)
//        params["a"] = nil
//        print(params)
        
    }
    
    
    @objc
    func btnAction(btn:UIButton)  {
        let action = HBRouterAction.init(urlString: "http://www.baidu.com/ac/aa")
        action.setCallBackBlock { (value) in
            print("\(value ?? "---")")
        }
        
        HBRouter.router().openRouterAction(action)

    }
    
    
//    func handlrBridge(_ action:HBRouterAction) -> Any? {
//        print("path:\(action.path ?? ""),host:\(action.host ?? "")")
//
//        return nil
//    }


}


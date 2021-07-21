//
//  ViewController.swift
//  Example_swift
//
//  Created by flywithbug on 2021/7/6.
//

import UIKit
import HBRouter


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.red
        
        
        var url:URL = URL.init(string: "https://baidu.com/a/b/c?a=20&b=2")!
        url.appendQueryParameters(["url":"www.baidu.com?c=2302322aaaa&d=4"])
        print(url.scheme ?? "");
        print(url.host ?? "");
        print(url.path );
        print(url.pathComponents );
        print(url.queryParameters as Any)
        
        let action:HBRouterAction = HBRouterAction(url: url)
        print(action.scheme ?? "")
        print(action.host ?? "")
        print(action.path ?? "")
        print(action.params)
        
        
        print( action.string("a"))
        print( action.int("a"))
        print( action.bool("a"))
        print( action.number("a"))
        print( action.double("a"))

//        var params:[String:Any]  = [String:Any]()
//        params["a"] = "1"
//        params["b"] = "2"
//        print(params)
//        params["a"] = nil
//        print(params)
        
    }
    
    


}


//
//  ViewController.swift
//  Example_swift
//
//  Created by flywithbug on 2021/7/6.
//

import UIKit
import HBRouter
import WebKit

//import 

class ViewController: UIViewController {
    
    
    lazy var dataSource:[HBRouterAction] = {
        
        return RouterUsage.dataSource()
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.frame   = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
        
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "home"
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        RouterUsage.registerHandler()
        RouterUsage.registRouterMapping()
    }
    
    
    @objc
    func btnAction(btn:UIButton)  {
      

    }
    
}
extension ViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "UITableViewCell")
        }
        let action = dataSource[indexPath.row]
        cell?.textLabel?.text = action.url?.absoluteString
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let action = dataSource[indexPath.row]
        HBRouter.router().openRouterAction(action)
        
    }
    
    
}


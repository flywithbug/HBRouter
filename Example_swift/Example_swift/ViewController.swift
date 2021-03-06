//
//  ViewController.swift
//  Example_swift
//
//  Created by flywithbug on 2021/7/6.
//

import UIKit
import HBRouter
import WebKit


class ViewController: UIViewController {
    
    override func handleRouterAction(_ action: HBRouterAction) -> Bool {
        
        return super.handleRouterAction(action)
    }
    
    
    lazy var dataSource:[HBRouterAction] = {
        if let dataSource = routeAction?.any("dataSource") as? [HBRouterAction]{
            return dataSource
        }
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
        self.title = routeAction?.stringValue("title") ?? "swift_home"
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
    }
    
    
    @objc
    func btnAction(btn:UIButton)  {

    }
    
}
extension ViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "UITableViewCell")
        }
        let action = dataSource[indexPath.row]
        cell?.textLabel?.text = action.url?.absoluteString
        cell?.detailTextLabel?.text = action.stringValue("subTitle")
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let action = dataSource[indexPath.row]
        action.addValue(indexPath.row , key: "row")
        open(action: action)
        
        
        
//        HBRouter.shared().open(url: URL.init(string: "https://www.baidu.com")!)
    }
    
    
}


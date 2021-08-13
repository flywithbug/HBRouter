//
//  FuncModuleViewController.swift
//  Example_swift
//
//  Created by flywithbug on 2021/8/2.
//

import UIKit
import HBRouter

@objcMembers class ItemModel:NSObject {
    var action:HBRouterAction
    var title:String
    var subTitle:String
    init(action:HBRouterAction,title:String,subTitle:String) {
        self.action = action
        self.title = title
        self.subTitle = subTitle
    }
}



class FuncModuleViewController: UIViewController {

    lazy var collectView:UICollectionView = {
        let width = (view.frame.size.width - 60) / 3
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: width , height: width )
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing =  15
        layout.sectionInset = UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15)
        let collectView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        collectView.backgroundColor = .groupTableViewBackground
        collectView.delegate = self
        collectView.dataSource = self
        collectView.showsVerticalScrollIndicator = true
        collectView.register(SwiftCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "SwiftCollectionViewCell")
        return collectView
    }()
    
    lazy var dataSource:[ItemModel] = {
        var list = [ItemModel]()
        var action:HBRouterAction = HBRouterAction.init(path:"home_swift")
        action.addValue(RouterUsage.dataSource(), key: "dataSource")
        var item:ItemModel = ItemModel.init(action: action, title: "路由表", subTitle: "")
        list.append(item)
        
        action = HBRouterAction.init(path:"home_swift")
        action.addValue(RouterUsage.bridgeDataSource(), key: "dataSource")
        item = ItemModel.init(action: action, title: "调用测试", subTitle: "")
        list.append(item)
        return list
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(collectView)
        title = "HBRouter"
       
        // Do any additional setup after loading the view.
    }
   
}
extension FuncModuleViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellString = "SwiftCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellString, for: indexPath) as! SwiftCollectionViewCell
        cell.backgroundColor = UIColor.white
        let item = dataSource[indexPath.row]
        cell.setItem(item)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        item.action.addValue(item.title, key: "title")
        collectionView.deselectItem(at: indexPath, animated: true)
        HBRouter.shared().openRouterAction(item.action)
    }
    
    
}
class SwiftCollectionViewCell: UICollectionViewCell {
    var titleLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.darkText
        
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    lazy var subTitleLabel:UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 5
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOffset = CGSize.init(width: 4, height: 4)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect.init(x: 0, y: 15, width: contentView.bounds.width, height: 30)
        subTitleLabel.frame = CGRect.init(x: 0, y: contentView.bounds.height - 30, width: contentView.bounds.width, height: 30)
    }
    
    public func setItem(_ item:ItemModel) {
        titleLabel.text = item.title
        subTitleLabel.text = item.subTitle
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






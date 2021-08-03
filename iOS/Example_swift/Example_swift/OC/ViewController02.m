//
//  ViewController02.m
//  Example_swift
//
//  Created by flywithbug on 2021/7/23.
//

#import "ViewController02.h"
#import <HBRouter/HBRouter-Swift.h>
#import "Example_swift-Swift.h"

#import "ViewController01.h"

@interface ViewController02 ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ViewController02

//
//- (BOOL)canSlideBack{
//    return  YES;
//}


//+ (BOOL)needsLogin:(HBRouterAction *)action{
//    return  YES;
//}

- (void)loadData{
//    self.dataSource = [NSMutableArray new];
//    HBRouterAction *action = [[HBRouterAction alloc]initWithPath:@"login"];
//    action.isSingleton = true;
////    action.option = HBRouterOptionPresent;
//    [HBRouter.router openRouterAction:action];
//    ItemModel *item = [[ItemModel alloc]initWithAction:action title:@"" subTitle:@""];
//    [self.dataSource addObject:item];
//
//
//    action = [[HBRouterAction alloc]initWithPath:@"vc_01_oc"];
////    action.isSingleton = true;
//    [HBRouter.router openRouterAction:action];
//    item = [[ItemModel alloc]initWithAction:action title:@"" subTitle:@""];
//    LoginViewController *vc = [[LoginViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//    ViewController01 *vc01 = [ViewController01 new];
//    [self.navigationController push:vc01 animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"objective-C 02 ";
    self.view.backgroundColor = UIColor.whiteColor;
    [self loadData];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"点击退出登录态,并pop当前页面";
    }else if(indexPath.row == 1) {
        cell.textLabel.text = @"点击跳转到01页面：单例页面，栈内唯一";
    }else if(indexPath.row == 2) {
        cell.textLabel.text = @"点击跳转到01页面：新开页面，栈内多开";
    }else{
        cell.textLabel.text = @"点击跳转百度";
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  5;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [UserAccountManager share].loginState = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }else if(indexPath.row == 1){
        HBRouterAction *action = [[HBRouterAction alloc]initWithPath:@"vc_01_oc"];
        action.isSingleton = true;
        [HBRouter.router openRouterAction:action];
    }else if(indexPath.row == 2){
        HBRouterAction *action = [[HBRouterAction alloc]initWithPath:@"vc_01_oc"];
        action.isSingleton = false;
        [HBRouter.router openRouterAction:action];
    }else{
        HBRouterAction *action =   [[HBRouterAction alloc]initWithUrlPattern:@"https://www.baidu.com"];
        [[HBRouter router] openRouterAction:action];
    }
    
    
   
    
}



@end

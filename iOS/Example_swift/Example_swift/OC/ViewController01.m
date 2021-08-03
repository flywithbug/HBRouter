//
//  ViewController01.m
//  Example_swift
//
//  Created by flywithbug on 2021/7/23.
//

#import "ViewController01.h"
#import <HBRouter/HBRouter-Swift.h>
#import "Example_swift-Swift.h"


@interface ViewController01 ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ViewController01


- (BOOL)canSlideBack{
    return  YES;
}
+ (BOOL)needsLogin:(HBRouterAction *)action{
    return  YES;
}

//栈内唯一单例
+ (BOOL)isSingleton:(HBRouterAction *)action{
    return  YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"objective-C 01";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60;
    [self.view addSubview:self.tableView];

    
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.detailTextLabel.text = @"";
    if (indexPath.row == 0) {
        cell.textLabel.text = @"点击退出登录态,并pop当前页面";
    }else if(indexPath.row == 1) {
        cell.textLabel.text = @"点击跳转到02页面：";
        cell.detailTextLabel.text = @"单例使用栈内最近一个打开的相同path页面";
    }else if(indexPath.row == 2) {
        cell.textLabel.text = @"点击跳转到02页面：新开页面，栈内多开";
    }else{
        cell.textLabel.text = @"点击跳转百度";
    }
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  10;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [UserAccountManager share].loginState = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }else if(indexPath.row == 1){
        HBRouterAction *action = [[HBRouterAction alloc]initWithPath:@"vc_02_oc"];
        action.useExistingPage = true;
        [HBRouter.shared openRouterAction:action];
    }else if(indexPath.row == 2){
        HBRouterAction *action = [[HBRouterAction alloc]initWithPath:@"vc_02_oc"];
        action.useExistingPage = false;
        [HBRouter.shared openRouterAction:action];
    }else{
        HBRouterAction *action =   [[HBRouterAction alloc]initWithUrlPattern:@"https://www.baidu.com"];
        [[HBRouter shared] openRouterAction:action];
    }
    
    
   
    
}



@end

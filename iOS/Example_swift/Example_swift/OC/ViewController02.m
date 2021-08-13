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

- (BOOL)handleRouterAction:(HBRouterAction *)action{
    
    
    return  [super handleRouterAction:action];
}

- (void)loadData{
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"点击退出登录态,并pop当前页面";
    }else if(indexPath.row == 1) {
        cell.textLabel.text = @"点击跳转到01页面：栈内唯一";
    }else if(indexPath.row == 2) {
        cell.textLabel.text = @"点击跳转到02页面";
    }else if(indexPath.row == 3) {
        cell.textLabel.text = @"pop到01页面";
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
        action.useExistPage = true;
        [HBRouter.shared openRouterAction:action];
    }else if(indexPath.row == 2){
        HBRouterAction *action = [[HBRouterAction alloc]initWithPath:@"vc_02_oc"];
        action.useExistPage = false;
        [HBRouter.shared openRouterAction:action];
    }else if(indexPath.row == 3){
        [[HBRouter shared] pop2Path:@"vc_01_oc" params:@{} completion:^(BOOL success) {
            NSLog(@"pop success:%@",@(success));
        }];
    }else{
        HBRouterAction *action =   [[HBRouterAction alloc]initWithUrlPattern:@"https://www.baidu.com"];
        [[HBRouter shared] openRouterAction:action];
        
    }
    
    
   
    
}



@end

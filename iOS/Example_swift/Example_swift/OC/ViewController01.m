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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"objective-C 01";
    self.view.backgroundColor = UIColor.whiteColor;
    
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
    }else{
        cell.textLabel.text = @"点击跳转百度";
    }
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
        return;
    }
    HBRouterAction *action =   [[HBRouterAction alloc]initWithUrlPattern:@"https://www.baidu.com"];
    [[HBRouter router] openRouterAction:action];
    
   
    
}



@end

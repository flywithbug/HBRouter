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
@property (nonatomic, copy) NSDictionary *dic;
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


- (BOOL)handleRouterAction:(HBRouterAction *)action{
    NSLog(@"params::%@",action.params);
    return YES;
}
- (NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
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
    }else if(indexPath.row == 3) {
        cell.textLabel.text = @"跳转home_swift页面";
    }else if(indexPath.row == 4) {
        cell.textLabel.text = @"closePage vc_02_oc";
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
    
//    _dic = [self readLocalFileWithName:@"temp"];
//    NSLog(@"%ld", _dic.allKeys.count);
//
//    NSLog(@"%zd", malloc_size((__bridge const void *)_dic));
//    return;;
    if (indexPath.row == 0) {
        [UserAccountManager share].loginState = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }else if(indexPath.row == 1){
        [HBRouter.shared openWithUrl:[NSURL URLWithString:@"hb://router.com/vc_02_oc"] completion:^(HBRouterResponse * _Nonnull response) {
            NSLog(@"path:%@  success:%@",response.action.routerURLPattern,@(response.code == 0));
        } callBack:^(id _Nullable value) {
            NSLog(@"%@",value);
        }];
       
    }else if(indexPath.row == 2){
        HBRouterAction *action = [[HBRouterAction alloc]initWithPath:@"vc_02_oc"];
        action.useExistPage = false;
        [HBRouter.shared openRouterAction:action];
    }else if(indexPath.row == 3){
        HBRouterAction *action = [[HBRouterAction alloc]initWithPath:@"home_swift"];
        action.useExistPage = false;
        [HBRouter.shared openRouterAction:action];
    }else if(indexPath.row == 4){
        [HBRouter.shared closePageWithPath:@"vc_02_oc"];
    }else{
        HBRouterAction *action =   [[HBRouterAction alloc]initWithUrlPattern:@"https://www.baidu.com"];
        [[HBRouter shared] openRouterAction:action];
    }
    
    
   
    
}



@end

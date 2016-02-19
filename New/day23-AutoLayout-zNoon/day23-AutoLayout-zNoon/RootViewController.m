//
//  RootViewController.m
//  day23-AutoLayout-zNoon
//
//  Created by qianfeng on 15/10/8.
//  Copyright (c) 2015年 王恒. All rights reserved.
//

#import "RootViewController.h"
#import "MyTableViewCell.h"
#import "OtherTableViewCell.h"

@interface RootViewController () <UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_data;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _data = [[NSMutableArray alloc] initWithArray:@[@"djf即可订购额品牌为顾客分配情况反馈；看vwvmelrmweglmwgw过任务个位二哥我去恶搞问过企鹅个位光荣和他活泼吧开票快快快跑【 polka来看昆明了尼康ii你就哦健康"]];
    
    [self createTableView];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
//    [_tableView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"Identifier"];
    [_tableView registerNib:[UINib nibWithNibName:@"OtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"Identifier"];
    _tableView.estimatedRowHeight = 44.f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"*******");
    
    MyTableViewCell *cell = (MyTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    //设置最大宽度
    cell.contentLabel.preferredMaxLayoutWidth = self.view.bounds.size.width - 20;
    //cell重绘
    [cell setNeedsLayout];
    //Cell子视图重绘
    [cell layoutSubviews];
    //让父视图进行内容适配
    CGFloat height = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Identifier";
//    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    OtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSLog(@"&&&&&&&&&&");
    cell.contentLabel.text = [_data objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    
        [_data removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

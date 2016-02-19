//
//  RootTableViewCell.m
//  
//
//  Created by Hailong.wang on 15/10/8.
//
//

#import "RootViewController.h"
#import "Masonry.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate> {
    UIView *_topView;
    UILabel *_topTitle;
    
    UIView *_bottomView;
    UILabel *_bottomTitle;
    
    UITableView *_tableView;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topView = [[UIView alloc] initWithFrame:CGRectZero];
    _topView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_topView];
    //屏蔽停靠模式
    _topView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //为_topView添加约束
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        //让_topView的左侧边到self.view的左侧边的距离是0
        make.left.equalTo(self.view.mas_left).with.offset(0);
        //让_topView的右侧边到self.view的右侧边的距离是0
        make.right.equalTo(self.view.mas_right).with.offset(0);
        //设置_topView的高
        make.height.equalTo(@(100));
        //设置顶部到self.view的顶部的距离为0
        make.top.equalTo(self.view.mas_top).with.offset(0);
    }];
    
    _topTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _topTitle.text = @"headerText";
    _topTitle.backgroundColor = [UIColor purpleColor];
    [_topView addSubview:_topTitle];
    _topTitle.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topView.mas_left).with.offset = 30;
        make.right.equalTo(_topView.mas_right).with.offset = -30;
        make.top.equalTo(_topView.mas_top).with.offset = 30;
        make.bottom.equalTo(_topView.mas_bottom).with.offset = -10;
    }];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_bottomView];
    _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset = 0;
        make.left.equalTo(self.view.mas_left).with.offset = 0;
        make.width.equalTo(@(self.view.frame.size.width));
        make.height.equalTo(@(100));
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Identifier"];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).with.offset(0);
        make.bottom.equalTo(_bottomView.mas_top).with.offset(0);
        make.width.equalTo(self.view.mas_width);
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}


@end







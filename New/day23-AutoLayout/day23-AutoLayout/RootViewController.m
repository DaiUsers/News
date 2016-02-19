//
//  RootViewController.m
//  day23-AutoLayout
//
//  Created by qianfeng on 15/10/8.
//  Copyright (c) 2015年 王恒. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
@property (strong, nonatomic) IBOutlet UILabel *label;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createView];
}

- (void)createView {
    self.label.text = @"sdajf;;;;;;;;;;;;;;klflidjfoijijeowijfoiwejoiwrepoipw哦i为我怕我开发机构可大可额可免费的开放老公额佛光客人客人两个蛋壳结构二批我分开搞快点额我忘记放几个金额看我佛法雕刻机看未来房价的我L发动机发来我看我姐夫我看我家的分开佛二姐夫访客等级二姐夫哥i";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

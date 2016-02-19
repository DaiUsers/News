//
//  RootViewController.m
//  WaterFlowDemo
//
//  Created by Hailong.wang on 15/9/18.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//

#import "RootViewController.h"
#import "WaterFlowLayout.h"
#import "CustomCollectionViewCell.h"
#import "CustomCollectionReusableView.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegate, WaterFlowLayoutDelegate> {
    //声明一个collectionView
    UICollectionView *_waterFlow;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createView {
    //将瀑布流布局实例化
    WaterFlowLayout *layout = [[WaterFlowLayout alloc] init];
    layout.delegate = self;
    layout.colum = 3;
    layout.insetSpace = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.distance = 10;
    layout.headerSpace = 200;
    
    //将collectionView实例化，并且让其布局使用自定义的对象
    _waterFlow = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    //delegate
    _waterFlow.delegate = self;
    //dataSource
    _waterFlow.dataSource = self;
    //注册cell的类型
    [_waterFlow registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //注册头视图
    [_waterFlow registerClass:[CustomCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    //添加为子视图
    [self.view addSubview:_waterFlow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
    {
    
        UIView * mainView = cell.contentView;
        mainView.transform = CGAffineTransformMakeRotation(M_PI_2/2);
        mainView.transform = CGAffineTransformTranslate(mainView.transform, 60, 0);
        mainView.alpha = 0;
        [UIView animateWithDuration:1 animations:^{
            mainView.transform = CGAffineTransformIdentity;
            mainView.alpha = 1;
        }];
    }
    


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell changeBackGroundColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        CustomCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.backgroundColor = RandomColor;
        return header;
    } else {
        return nil;
    }
}

- (CGFloat)waterFlow:(WaterFlowLayout *)layout heightForCellAtIndexPath:(NSIndexPath *)indexPath {
    return 100 + arc4random()%100;
}

@end







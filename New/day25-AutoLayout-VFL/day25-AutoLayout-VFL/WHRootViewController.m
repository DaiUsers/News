//
//  WHRootViewController.m
//  day25-AutoLayout-VFL
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 王恒. All rights reserved.
//
/*
 VFL 是 Visual format language （可视格式语言）的缩写,是Apple针对 AutoLayout 设计的一种语言。通过VFL，我们能在代码中灵活的使用AutoLayout而做到真正的不受设备控制！
 */
/*
 当使用代码添加约束的时候，我们需要先将操作视图的依赖视图位置确定下来，然后再将操作视图添加的父视图上，最后添加约束。
 如果有约束的存在，就忽略停靠模式的改变。避免逻辑冲突
 .translatesAutoresizingMaskIntoConstraints = NO;
 */
/*
 VFL语言
 1. H:/V:                       表示水平和纵向。
 2. |                                表示边界(屏幕边界)。
 3. -20-                          表示距离。
 4. [_redView(100)]	  [ ]包裹住的内容表示控件,( )包裹的内容表示宽度/高度
 */

#import "WHRootViewController.h"

@interface WHRootViewController () {
    UIView *_redView;
    UIView *_greenView;
    UIView *_blueView;
    UIView *_redView2;
    UIView *_greenView2;
    UIView *_blueView2;
}

@end

@implementation WHRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建视图
    [self createView];
    //VFL布局
    [self setLayoutVFL];
}

- (void)setLayoutVFL {
    
    //两种常用的约束格式（NSArray/NSLayoutConstraint）
    [self createLabel];//设置两种格式的标题
    //NSArray 适用于添加水平垂直约束
    [self setLayoutVFLOffNSArray];
    //NSLayoutConstraint  适用于添加居中约束
    [self setLayoutVFLOffOther];
    
}
//居中约束
- (void)setLayoutVFLOffOther {
    //声明字典,存储需要用VFL设置的控件，要和VFL语句中保持一致
    NSDictionary *views = NSDictionaryOfVariableBindings(_redView2,_greenView2,_blueView2);
//***********_redView2  x居中，宽100，y居中，高50
    //X居中，
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_redView2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    //Y居中（横在父视图中间）
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_redView2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_redView2(100)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_redView2(50)]" options:0 metrics:nil views:views]];
//*************_greenView2  y居中，高50，在_redView2左侧距离20，宽100
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_greenView2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_greenView2(50)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_greenView2(100)]-20-[_redView2]" options:0 metrics:nil views:views]];
//*************_blueView2  y居中，高50，在_redView2右侧距离20，宽100
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_blueView2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_blueView2(50)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_redView2]-20-[_blueView2(100)]" options:0 metrics:nil views:views]];
}
//水平、垂直约束
- (void)setLayoutVFLOffNSArray {
    //声明字典,存储需要用VFL设置的控件，要和VFL语句中保持一致
    NSDictionary *views = NSDictionaryOfVariableBindings(_redView,_greenView,_blueView);
    /*
     第一个参数     设置VFL语句 (H:|-20-[_redView(100)],H: 可省略，默认是水平)
     第二个参数     设置约束条件
     第三个参数     设置权重（待定）
     第四个参数     参考视图，指定VFL语句中可能涉及的控件
     约束条件，要添加到父视图上。因为子视图是要去适应父视图的大小
     */
//********_redView  距离父视图左边20，宽100，距离父视图顶边100，高50
    NSArray *redViewHConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[_redView(100)]" options:0 metrics:nil views:views];
    [self.view addConstraints:redViewHConstraint];
    
    NSArray *redViewVConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[_redView(50)]" options:0 metrics:nil views:views];
    [self.view addConstraints:redViewVConstraint];
    /*
     添加约束后，redView的尺寸还是x:0, y:0, width:0, height:0
     所以当以约束指导尺寸，不要使用frame
     */
    //    NSLog(@"%@",NSStringFromCGRect(_redView.frame));
    
//********_greenView  距离_redView左边20，宽小于等于_redView的宽，距离父视图顶边100，高50
    NSArray *greenHConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"[_redView]-20-[_greenView(<=_redView)]" options:0 metrics:nil views:views];
    [self.view addConstraints:greenHConstraint];
    NSArray *greenVConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[_greenView(==_redView)]" options:0 metrics:nil views:views];
    [self.view addConstraints:greenVConstraint];
//********_blueView  距离_greenView左边界20，距离父视图右边界20，距离父视图顶边100，高等于_greenView的高
    NSArray *blueHConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"[_greenView]-20-[_blueView]-20-|" options:0 metrics:nil views:views];
    [self.view addConstraints:blueHConstraint
     ];
    NSArray *blueVConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[_blueView(==_greenView)]" options:0 metrics:nil views:views];
    [self.view addConstraints:blueVConstraint];
}

//两种格式的标题
- (void)createLabel {
    UILabel *label = [UILabel new];
    label.text = @"NSArray格式";
    label.textAlignment = NSTextAlignmentCenter;
    [self createViewFactory:label backgroundColor:[UIColor cyanColor]];
    UILabel *otherLabel = [UILabel new];
    otherLabel.text = @"NSLayoutConstraint格式";
    otherLabel.textAlignment = NSTextAlignmentCenter;
    [self createViewFactory:otherLabel backgroundColor:[UIColor cyanColor]];
    //设置字典，保存控件
    NSDictionary *views = NSDictionaryOfVariableBindings(label,otherLabel);
    //*********label   距离左边20，距离右边20，上边50，高30
    NSArray *labelH = [NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[label]-20-|" options:0 metrics:nil views:views];
    [self.view addConstraints:labelH];
    NSArray *labelV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[label(30)]" options:0 metrics:nil views:views];
    [self.view addConstraints:labelV];
    //*********otherLabel   距离左边20，距离右边20，上边200，高30
    NSArray *otherLabelH = [NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[otherLabel]-20-|" options:0 metrics:nil views:views];
    [self.view addConstraints:otherLabelH];
    NSArray *otherLabelV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[otherLabel(30)]" options:0 metrics:nil views:views];
    [self.view addConstraints:otherLabelV];
}
//视图工厂
- (void)createViewFactory:(UIView *)subView backgroundColor:(UIColor *)color {
    subView.backgroundColor = color;
    //忽略停靠模式的改变，避免逻辑冲突
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:subView];
}
//创建视图
- (void)createView {
    _redView = [UIView new];
    [self createViewFactory:_redView backgroundColor:[UIColor redColor]];
    _greenView = [UIView new];
    [self createViewFactory:_greenView backgroundColor:[UIColor greenColor]];
    _blueView = [UIView new];
    [self createViewFactory:_blueView backgroundColor:[UIColor blueColor]];
    _redView2 = [UIView new];
    [self createViewFactory:_redView2 backgroundColor:[UIColor redColor]];
    _greenView2 = [UIView new];
    [self createViewFactory:_greenView2 backgroundColor:[UIColor greenColor]];
    _blueView2 = [UIView new];
    [self createViewFactory:_blueView2 backgroundColor:[UIColor blueColor]];
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

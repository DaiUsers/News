//
//  RootViewController.m
//  
//
//  Created by Hailong.wang on 15/10/8.
//
//

#import "RootViewController.h"

@interface RootViewController ()

@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *greenView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.redView = [[UIView alloc] initWithFrame:CGRectZero];
    self.redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];
    //如果有约束的存在，就忽略停靠模式的改变。避免逻辑冲突。
    self.redView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.greenView = [[UIView alloc] initWithFrame:CGRectZero];
    self.greenView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.greenView];
    self.greenView.translatesAutoresizingMaskIntoConstraints = NO;
    
    /*
     当使用代码添加约束的时候，我们需要先将操作视图的依赖视图位置确定下来，然后再将操作视图添加的父视图上，最后添加约束。
     */
    /*
     VFL语言
     1. H:/V:                       表示水平和纵向。
     2. |                                表示边界(屏幕边界)。
     3. -20-                          表示距离。
     4. [_redView(100)]	  [ ]包裹住的内容表示控件,( )包裹的内容表示宽度/高度
     */
    //声明一个字典，字典存储的是绑定的视图控件
    //当我们的VFL语句中出现"_redView"就意味着，指的是self.redView这个视图。
    NSDictionary *views = NSDictionaryOfVariableBindings(_redView, _greenView);
    
    //设置一个VFL语句，将约束整理起来。
    //NSLayoutFormatDirectionLeadingToTrailing 默认值，将约束使用默认设置就可以
    //第一个参数     设置VFL语句
    //第二个参数     设置约束条件
    //第三个参数     设置权重（待定）
    //第四个参数     参考视图，指定VFL语句中可能涉及的控件
    //约束条件，要添加到父视图上。因为子视图是要去适应父视图的大小
    NSArray *redViewHConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_redView(100)]" options:0 metrics:nil views:views];
    [self.view addConstraints:redViewHConstraint];
    
    NSArray *redViewVConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_redView(150)]-20-|" options:0 metrics:nil views:views];
    [self.view addConstraints:redViewVConstraint];
    //添加约束后，redView的尺寸还是x:0, y:0, width:0, height:0
    //所以当以约束指导尺寸，不要使用frame
    NSLog(@"%@", NSStringFromCGRect(self.redView.frame));
    
    NSArray *greenViewHConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_redView]-20-[_greenView(==_redView)]" options:0 metrics:nil views:views];
    [self.view addConstraints:greenViewHConstraint];
    
    NSArray *greenViewVConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[_greenView]-100-|" options:0 metrics:nil views:views];
    [self.view addConstraints:greenViewVConstraint];
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

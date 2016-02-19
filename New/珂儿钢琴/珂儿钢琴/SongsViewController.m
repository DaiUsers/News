//
//  SongsViewController.m
//  珂儿钢琴
//
//  Created by qianfeng on 15/9/19.
//  Copyright (c) 2015年 NAME. All rights reserved.
//

#import "SongsViewController.h"
#import "NotePlay.h"
#import "CustomCelll.h"
@interface SongsViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property(nonatomic)int maxtime;//文件中最大的时间标示//解析时候得到

@property(nonatomic)UITableView *tableView;
@property(nonatomic)NSMutableArray *dataArray;
@property(nonatomic)NSString *tempString;
@property(nonatomic)float time;
@property (nonatomic) NSTimer *timer;
@property(nonatomic)Parsing *parsing;
@end

@implementation SongsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationBar *bar = self.navigationController.navigationBar;
    bar.translucent = NO;
    
    [self initData];
    [self initUI];
    [self MybarButtonItem];
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(void)initData{
    NSString *homepath =NSHomeDirectory();
    NSString *path=  [homepath stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/MusicFileBox"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *array = [fileManager contentsOfDirectoryAtPath:path error:&error];
    if (error) {
        return;
    }else{
            for (NSMutableString *string in array) {
                if ([string hasSuffix:@"txt"]) {
                    NSString *name=[string substringToIndex:(string.length-4)];
                   // NSLog(@"%@",name);
                    [self.dataArray addObject:name];
                }
            }
    }
}
-(void)initUI{
    CGRect rect = [[UIScreen mainScreen] bounds];//为了适配
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height=size.height;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bigbackground.png"]];
    [self.view addSubview:backgroundView];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setRowHeight:44];
    _tableView.backgroundColor=[UIColor clearColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
    
    
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//     static NSString *cellID=@"cellID";
//    CustomCelll *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell==nil) {
//        cell=[[CustomCelll alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
//    [cell setTheImage:[UIImage imageNamed:@"back_mm"]];
//    cell.textLabel.text=self.dataArray[indexPath.row];
    //====================================================上文为自己封装的方法,不好用
    //====================================================
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text=self.dataArray[indexPath.row];
    [cell.textLabel setTintColor:[UIColor redColor]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_mm"]] ;
    cell.backgroundColor=[UIColor clearColor];

    //====================================================
    
    UIImageView *aa=[[UIImageView alloc]initWithImage:[UIImage imageNamed:nil]];
    UIImageView *bb=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_play"]];
    bb.frame=CGRectMake(0, 0, 70,40);
    [aa addSubview:bb];
    cell.selectedBackgroundView=aa;
    
    //cell.selectedBackgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_mm_select"]];
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.contentView.backgroundColor=[UIColor clearColor];
}

// 修改删除按钮上的文字”Delete”
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
// 当删除按钮被按下
// 这个方法一旦实现，它就具有了手指从右往左滑动cell的时候出现的“删除”按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataArray removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    
    UITableViewCell  *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //NSLog(@"沙盒文件:%@.txt",cell.textLabel.text);
    [self deleteFile:[NSString stringWithFormat:@"%@.txt",cell.textLabel.text]];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    
}
-(void)deleteFile:(NSString *)filename {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dirPath = [docPath stringByAppendingPathComponent:@"MusicFileBox"];
    NSString *path=  [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",filename]];
  //  NSLog(@"%@",path);
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
           // NSLog(@"要删除的文件存在");
        [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
//           BOOL de=[[NSFileManager defaultManager]removeItemAtPath:path error:nil];
//            if (de) {
//                 NSLog(@"删除文件成功");
//            }else{
//             NSLog(@"删除失败");
//            }
        
    }
//       else{
//         NSLog(@"要删除的文件不存在");
//    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_timer invalidate], _timer = nil;
    UITableViewCell  *cell = [self.tableView cellForRowAtIndexPath:indexPath];
   // NSLog(@"沙盒文件:%@.txt",cell.textLabel.text);
    //========================
    self.tempString=[NSString string];
    self.time=0.0;
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dirPath = [docPath stringByAppendingPathComponent:@"MusicFileBox"];
    self.tempString=  [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.txt",cell.textLabel.text]];
   // NSLog(@"%@",self.tempString);
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.tempString]) {
      //  NSLog(@"文件存在,可以读取");
        _parsing=[[Parsing alloc]initWithFilePath:self.tempString];
       
        
        self.timer=[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(musicGo:) userInfo:nil repeats:YES];
        //[_parsing show];
    }//else{NSLog(@"文件没有找到");}
    
    //_parsing=[[Parsing alloc]initWithFilePath:self.tempString];
    //[_parsing show];
}
-(void)musicGo:(NSTimer *)timer{
    self.time=self.time+0.5;
    //NSLog(@"%@",[_parsing noteBytime:self.time]);
    if ([[_parsing noteBytime:self.time]isEqualToString:@"FileEnd"]) {
        [_timer invalidate], _timer = nil;
        [self showUIActionSheet];
    }
    NotePlay *noteplay=[[NotePlay alloc]init];
    [noteplay keybuttonClick:[_parsing noteBytime:self.time]];
    
  
}
-(void)showUIActionSheet{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"你制作的音乐,已播放完毕." delegate:self cancelButtonTitle:@"我知道了" destructiveButtonTitle:nil otherButtonTitles: nil];
    sheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
    
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"head_menu"]];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)MybarButtonItem{
    UIButton *buttonleft=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonleft.frame=CGRectMake(0, 0, 120, 30);
    UIImage *left_back=[UIImage imageNamed:@"left_back"];
    [buttonleft setBackgroundImage:left_back forState:UIControlStateNormal];
    [buttonleft addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:buttonleft];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *buttonright=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonright.frame=CGRectMake(0, 0, 70, 30);
    [buttonright setBackgroundImage:[UIImage imageNamed:@"right_take"] forState:UIControlStateNormal];
    [buttonright setBackgroundImage:[UIImage imageNamed:@"right_done"] forState:UIControlStateSelected];
    [buttonright addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:buttonright];
    self.navigationItem.rightBarButtonItem=rightItem;
}
- (void)itemClick:(UIBarButtonItem *)item {
    [_timer invalidate], _timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightClick:(UIButton *)button{
    button.selected=!button.selected;
    if (button.selected) {
        [self.tableView setEditing:YES animated:YES];
       // NSLog(@"编辑");
    }else{
        [self.tableView setEditing:NO animated:YES];
       // NSLog(@"完成");
    }
}
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 6.0;
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

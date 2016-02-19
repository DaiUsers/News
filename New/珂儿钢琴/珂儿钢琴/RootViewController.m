//
//  RootViewController.m
//  珂儿钢琴
//
//  Created by qianfeng on 15/9/16.
//  Copyright (c) 2015年 NAME. All rights reserved.
//

#import "RootViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SongsViewController.h"

@interface RootViewController ()<AVAudioPlayerDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
{
    NSString *soundFile;
}
@property (nonatomic) NSTimer *timer;
@property(nonatomic)float nowtime;
@property(nonatomic)NSInteger keyNumber;
@property(nonatomic)NSMutableString *dataString;
@end

@implementation RootViewController
-(NSMutableString *)dataString{
    if (_dataString==nil) {
        _dataString=[NSMutableString string];
    }
    return _dataString;
}
- (void)viewWillAppear:(BOOL)animated {
    _keyNumber=0;
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationBar *bar = self.navigationController.navigationBar;
    bar.translucent = NO;
    self.view.backgroundColor=[UIColor blackColor];
    [self creatPianoView];
    [self addAnimationLaunchImage];
}
-(void)addAnimationLaunchImage{
    UIImage *image=[UIImage imageNamed:@"Launch"];
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:self.view.bounds];
    imageview.image=image;
    [self.view addSubview:imageview];
    [UIView animateWithDuration:3 animations:^{
        imageview.alpha=0.0;
    } completion:^(BOOL finished) {
        [imageview removeFromSuperview];
    }];
}
-(void)creatPianoView{
    NSArray *keysArray=@[@"A.png",@"B.png",@"C.png",@"D.png",@"E.png",@"F.png",@"G.png"];
    NSArray *keysBlackArray=@[@"C_black.png",@"D_black.png",@"E_black.png",@"F_black.png",@"G_black.png"];
    CGFloat gap=2;
    CGFloat width=(self.view.frame.size.width-gap*8)/7.0;
    CGFloat height=self.view.frame.size.height;
    for(NSInteger i=0;i<7;i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
        button.frame=CGRectMake(gap+(width+gap)*i, 0, width, height);
        UIImage *imagecommed=[UIImage imageNamed:[NSString stringWithFormat:@"%@", keysArray[i]]];
        [button setBackgroundImage:imagecommed forState:UIControlStateNormal];
        button.tag=100+i;
        [button setTitle:[NSString stringWithFormat:@"%d",(int)button.tag] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];//标题无色
        [button addTarget:self action:@selector(keybuttonClick:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:button];
    }
    CGFloat width_black=width/3.0*2.0;
    CGFloat height_black=height/5.0*3.0;
    CGFloat middle=0;
    for (NSInteger i=0; i<5; i++) {
        if (i>=3) {
            i=i+1;
            middle=gap+(width+gap)*(i+1)-(width_black/2.0);
            i=i-1;
        }else{
        middle=gap+(width+gap)*(i+1)-(width_black/2.0);
        }
        UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
        button.frame=CGRectMake(middle, 0, width_black, height_black);
        UIImage *imagecommed=[UIImage imageNamed:[NSString stringWithFormat:@"%@", keysBlackArray[i]]];
        [button setBackgroundImage:imagecommed forState:UIControlStateNormal];
        button.tag=200+i;
        [button setTitle:[NSString stringWithFormat:@"%d",(int)button.tag] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];//标题无色
        [button addTarget:self action:@selector(keybuttonClick:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:button];
    }
    UIImageView *headView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head"]];
    headView.frame=CGRectMake(0, 0, self.view.frame.size.width, 60);
    [headView setUserInteractionEnabled:YES];
    [self.view addSubview:headView];
    UIImageView *head_sign=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head_sign"]];
    head_sign.frame=CGRectMake(10, 1, 300*0.5, 114*0.5);
    [self.view addSubview:head_sign];
    
    UIImageView *tielView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tiel"]];
    tielView.frame=CGRectMake(0,self.view.frame.size.height-35, self.view.frame.size.width, 40);
    [tielView setUserInteractionEnabled:YES];
    [self.view addSubview:tielView];
    
    NSArray *button_on_off=@[@"button_on",@"button_on",@"button_on",@"button_off",@"button_off",@"button_off",@"button_done_click:"];
    NSArray *labelText=@[@"Done",@"Make",@"Play"];
    CGFloat width_x=self.view.frame.size.width/2.0-50;
    for (NSInteger i=0; i<3; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:button_on_off[i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:button_on_off[i+3]] forState:UIControlStateHighlighted];
        button.tag=300+i;
        [button setTitle:[NSString stringWithFormat:@"%d",(int)button.tag] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];//无色
        [button addTarget:self action:@selector(button_click:) forControlEvents:UIControlEventTouchUpInside];//
         button.frame=CGRectMake(width_x+100*i, 12, 36, 36);
        [self.view addSubview:button];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(width_x-50+105*i, 5, 50, 50)];
        label.text=labelText[i];
        label.textColor=[UIColor whiteColor];
        [self.view addSubview:label];
    }
    UIButton *button_done=(UIButton *)[self.view viewWithTag:300];
    [button_done setUserInteractionEnabled:NO];//让 done 先不可用, make点击后才能用
    [button_done setBackgroundImage:[UIImage imageNamed:@"button_red"] forState:UIControlStateNormal];
    UIButton *button_play=(UIButton *)[self.view viewWithTag:302];
    [button_play setUserInteractionEnabled:YES];
}
//===============================================================================================
-(void)button_click:(UIButton *)button{
    NSString *string=button.titleLabel.text;
    int number=[string intValue];
    switch (number) {
        case 300:
            [self doneClick];
            break;
        case 301:
            [self makeClick];
            break;
        case 302:
            [self playClick];
            break;
        default:
            break;
    }
}
//===============================================================================================

-(void)doneClick{
    UIButton *button_play=(UIButton *)[self.view viewWithTag:302];//done操作,play 恢复使用
    [button_play setUserInteractionEnabled:YES];
    [button_play setBackgroundImage:[UIImage imageNamed:@"button_on"] forState:UIControlStateNormal];
    //NSLog(@"done 300");
    [self doneClick_affection];
    UIButton *button_done=(UIButton *)[self.view viewWithTag:300];//done操作保存一次后, 暂停使用等待 make
    [button_done setUserInteractionEnabled:NO];
    [button_done setBackgroundImage:[UIImage imageNamed:@"button_red"] forState:UIControlStateNormal];
    UIButton *button_make=(UIButton *)[self.view viewWithTag:301];//点击 make ,只能点击一次,不让乱点,保存完再恢复使用
    [button_make setUserInteractionEnabled:YES];
    [button_make setBackgroundImage:[UIImage imageNamed:@"button_on"] forState:UIControlStateNormal];



}
-(void)makeClick{
    UIButton *button_done=(UIButton *)[self.view viewWithTag:300];//点击 make 等待 done操作,
    [button_done setUserInteractionEnabled:YES];
    [button_done setBackgroundImage:[UIImage imageNamed:@"button_on"] forState:UIControlStateNormal];
    UIButton *button_play=(UIButton *)[self.view viewWithTag:302];//点击 make 等待 done操作,play 暂停使用
    [button_play setUserInteractionEnabled:NO];
    [button_play setBackgroundImage:[UIImage imageNamed:@"button_red"] forState:UIControlStateNormal];
    //NSLog(@"make 301");
    [self makeClick_affection];
    UIButton *button_make=(UIButton *)[self.view viewWithTag:301];//点击 make ,只能点击一次,不让乱点
    [button_make setUserInteractionEnabled:NO];
    [button_make setBackgroundImage:[UIImage imageNamed:@"button_red"] forState:UIControlStateNormal];
    
}
-(void)playClick{
    //NSLog(@"play 302");
    SongsViewController *songsviewcontroller=[[SongsViewController alloc]init];
    [self.navigationController pushViewController:songsviewcontroller animated:YES];
    //[songsviewcontroller release];
    //[self playClick_affection];
}
//===============================================================================================
-(void)doneClick_affection{
     [_timer invalidate], _timer = nil;
    if([_dataString length]<1){
       // NSLog(@"你没有输入任何音符,系统自动放弃保存");
        [self showUIActionSheetLength];
        return;
    }
    CGFloat width=self.view.frame.size.width/5.0;
    UITextField *textfield=[[UITextField alloc]initWithFrame:CGRectMake(width, 100, self.view.frame.size.width-width*2, 50)];
    textfield.tag=1512;
    textfield.clearsOnBeginEditing = YES; // 只要重新开始编辑，就马上清空原来内容
    textfield.delegate = self; // 设置textField的代理为self
    //textfield.clearButtonMode = UITextFieldViewModeAlways;
    
    textfield.rightViewMode=UITextFieldViewModeAlways;
    UIButton *rightClear=[UIButton buttonWithType:UIButtonTypeSystem];
    [rightClear setBackgroundImage:[UIImage imageNamed:@"XX"] forState:UIControlStateNormal];
    [rightClear addTarget:self action:@selector(rightClearClikc:) forControlEvents:UIControlEventTouchUpInside];
    rightClear.frame=CGRectMake(0, 0, 266/5.0, 95/5.0);
    textfield.rightView=rightClear;
    
    
    textfield.textAlignment=NSTextAlignmentCenter;
    textfield.textColor=[UIColor blackColor];
    textfield.placeholder=@"给你的音乐文件取个名字吧";
    textfield.keyboardAppearance = UIKeyboardAppearanceLight;
    [textfield setBackground:[[UIImage imageNamed:@"textBG_mm"] stretchableImageWithLeftCapWidth:10 topCapHeight:20]];
    textfield.returnKeyType=UIReturnKeyDone;
    //===================UITextField出现时,stopAndStart为了阻止,用户也其他按钮交互.
    UIImageView *stopAndStart=[[UIImageView alloc]initWithFrame:self.view.bounds];
    stopAndStart.tag=151;
    stopAndStart.userInteractionEnabled=YES;//打开它,允许这个透明的与用户交互,但是不发生任何反应,下面和textfield一块消失
    [self.view addSubview:stopAndStart];
    //===================
    [self.view addSubview:textfield];
    //[self creatOneSongFile:@"123"];//点击 return后引发这个事件,在下面UITextFieldDelegate协议里写着
}
-(void)rightClearClikc:(UIButton *)button{
    UITextField *textField=(UITextField *)[self.view viewWithTag:1512];
    textField.text=nil;
}
-(void)creatOneSongFile:(NSString *)filename{
    //-----------------------------------------------------
//    if(filename.length<1){
//        [self filenameLength];
//        [self doneClick_affection];
//    }
     NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
     NSString *dirPath = [docPath stringByAppendingPathComponent:@"MusicFileBox"];
     [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path=  [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.txt",filename]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager]createFileAtPath:path contents:nil attributes:nil];
        //NSLog(@"创建");
        [_dataString writeToFile:path atomically:YES];
//        BOOL re = [_dataString writeToFile:path atomically:YES];
//        if (re) {
//            NSLog(@"%@",path);
//            NSLog(@"write yes");
//        }else{
//            NSLog(@"%@",path);
//            NSLog(@"写入不成功");
//        }
    } else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"该文件已存在" message:@"在此之前某个时间你已经保存过与名称相同的文件" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
        [self doneClick_affection];
        //NSLog(@"%@",path);
        //NSLog(@"因为原来有,写入不成功");
    }
}
//===============================================================================================
-(void)makeClick_affection{
    if (self.dataString.length!=0) {
        self.dataString=nil;
    }
    self.nowtime=0.0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(jishi) userInfo:nil repeats:YES];
    //NSLog(@"制作开始...");
}
-(void)jishi{
    self.nowtime=self.nowtime+0.5;
    if (self.nowtime>=1500) {//1500走了10分钟
        //NSLog(@"时间太了");
        [self showUIActionSheet];
        [self doneClick];
    }
}
-(void)showUIActionSheet{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"你的制作时间太长了,请及时保存文件,以便你的后期管理!" delegate:self cancelButtonTitle:@"我知道了" destructiveButtonTitle:nil otherButtonTitles: nil];
    sheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
    
}
-(void)showUIActionSheetLength{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"系统拒绝保存空文件" message:@"你没有弹奏任何音符,将要保存的是空文件." delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alertView show];
    
}

-(void)filenameLength{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"文件名不能为空" delegate:self cancelButtonTitle:@"我知道了" destructiveButtonTitle:nil otherButtonTitles: nil];
    sheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
    
}

-(void)singleNotes{
    //NSDate *date=[NSDate date];
    NSString *nowdate=[NSString stringWithFormat:@"%f",self.nowtime];
    NSString *one=[nowdate stringByAppendingFormat:@"<==>%ld\n",_keyNumber];
    [self.dataString appendString:one];
}
//===============================================================================================
//===============================================================================================
-(void)playSound:(NSString*)soundKey{
    NSString *path = [NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] resourcePath],soundKey];
    //NSLog(@"%@\n", path);
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}
-(void)keybuttonClick:(UIButton *)button{
    NSString *string=button.titleLabel.text;
    int number=[string intValue];
    switch (number) {
        case 100:
        {
            soundFile = [NSString stringWithFormat:@"/001.mp3"];
            [self playSound: soundFile];_keyNumber=100;[self singleNotes];
        }
            break;
        case 101:
        {
            soundFile = [NSString stringWithFormat:@"/002.mp3"];
            [self playSound: soundFile];_keyNumber=101;[self singleNotes];
            
        }
            break;
        case 102:
        {
            soundFile = [NSString stringWithFormat:@"/003.mp3"];
            [self playSound: soundFile];_keyNumber=102;[self singleNotes];
            
        }
            break;
        case 103:
        {
            soundFile = [NSString stringWithFormat:@"/004.mp3"];
            [self playSound: soundFile];_keyNumber=103;[self singleNotes];
        }
            break;
        case 104:
        {
            soundFile = [NSString stringWithFormat:@"/005.mp3"];
            [self playSound: soundFile];_keyNumber=104;[self singleNotes];
            
        }
            break;
        case 105:
        {
            soundFile = [NSString stringWithFormat:@"/006.mp3"];
            [self playSound: soundFile];_keyNumber=105;[self singleNotes];
            
        }
            break;
        case 106:
        {
            soundFile = [NSString stringWithFormat:@"/007.mp3"];
            [self playSound: soundFile];_keyNumber=106;[self singleNotes];
        }
            break;
        case 200:
        {
            soundFile = [NSString stringWithFormat:@"/C.mp3"];
            [self playSound: soundFile];_keyNumber=200;[self singleNotes];
        }
            break;
        case 201:
        {
            soundFile = [NSString stringWithFormat:@"/D.mp3"];
            [self playSound: soundFile];_keyNumber=201;[self singleNotes];
        }
            break;
        case 202:
        {
            soundFile = [NSString stringWithFormat:@"/E.mp3"];
            [self playSound: soundFile];_keyNumber=202;[self singleNotes];
        }
            break;
        case 203:
        {
            soundFile = [NSString stringWithFormat:@"/F.mp3"];
            [self playSound: soundFile];_keyNumber=203;[self singleNotes];
        }
            break;
        case 204:
        {
            soundFile = [NSString stringWithFormat:@"/G.mp3"];
            [self playSound: soundFile];_keyNumber=204;[self singleNotes];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//==UITextFieldDelegate==========================================================================================
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //NSLog(@"输入开始");
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    UITextField *textfield=(UITextField *)[self.view viewWithTag:1512];
    NSString *name=textfield.text;
    if (name.length<1) {
        //NSLog(@"名字为空");
        [self filenameLength];
        return NO;
    }else{
           [self.view endEditing:YES];
           [textfield removeFromSuperview];
            UIImageView *stopAndStart=(UIImageView *)[self.view viewWithTag:151];
            [stopAndStart removeFromSuperview];//打开它,允许这个透明的与用户交互,但是不发生任何反应,下面和textfield一块消失
            [self creatOneSongFile:name];
            textfield.text=nil;
            return YES;
    }
    //====================================================================
//    [self.view endEditing:YES];
//    UITextField *textfield=(UITextField *)[self.view viewWithTag:1512];
//    [textfield removeFromSuperview];
//    NSString *name=textfield.text;
//    UIImageView *stopAndStart=(UIImageView *)[self.view viewWithTag:151];
//    [stopAndStart removeFromSuperview];//打开它,允许这个透明的与用户交互,但是不发生任何反应,下面和textfield一块消失
//    [self creatOneSongFile:name];
//    textfield.text=nil;
//    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if ([[textField text] length] + string.length <1) {
//        NSLog(@"名字为空");
//        return NO;
//    }
//    return YES;
//}
//==UITextFieldDelegate==========================================================================================

@end

//
//  Parsing.m
//  珂儿钢琴
//
//  Created by qianfeng on 15/9/21.
//  Copyright (c) 2015年 NAME. All rights reserved.

#import "Parsing.h"

@implementation Parsing


-(instancetype)initWithFilePath:(NSString *)FilePath{
    if (self=[super init]) {
        self.maxtime=0.0;
        self.Time_note_box_Array=[NSMutableArray array];
        NSString *allmessage=[NSString stringWithContentsOfFile:FilePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *All_single=[allmessage componentsSeparatedByString:@"\n"];
        for (NSString *Single_Row_String in All_single){
            if (Single_Row_String.length<1) {
                continue;
            }
            NSArray *single_message=[Single_Row_String componentsSeparatedByString:@"<==>"];
            float time_message=[single_message[0] floatValue];
            NSString *note_message=single_message[1];
            Parsing *parsing=[[Parsing alloc]init];
            parsing.time=time_message;
            parsing.note=note_message;
            _maxtime=time_message>_maxtime?time_message:_maxtime;
            [_Time_note_box_Array addObject:parsing];
        }
}
    return self;
}
-(BOOL)sortBytime:(Parsing *)item{//对象名___怎么和解析歌词的对象区分,传值//这个为什么可以不用声明
    return self.time>item.time;
}
-(void)show{
    [_Time_note_box_Array makeObjectsPerformSelector:@selector(playmessage)];
}
-(void)playmessage{
    NSLog(@"time:%f<==>note:%@",self.time,self.note);
}
-(NSString *)noteBytime:(float)time{
    if (time>_maxtime) {
        return @"FileEnd";
    }
    Parsing *parsing=[self boxBytime:time];
    return parsing.note;
    
}
- (Parsing *)boxBytime:(float)time {
//    NSInteger index = -100;
//    for (NSInteger i = 0; i < self.Time_note_box_Array.count; i++) {
//        Parsing *parsing = self.Time_note_box_Array[i];
//        if (parsing.time > time) { // 找到了比time大一点的项
//            index = i - 1;
//            break;
//        }
//    }
//    
//    if (index == -1) { // 播放第一行
//        index = 0;
//    } else if (index == -100) { // 播放最后一行
//        index = _Time_note_box_Array.count-1;
//    }
//
    for (NSInteger i=0; i<self.Time_note_box_Array.count; i++) {
        Parsing *parsing=self.Time_note_box_Array[i];
        if (parsing.time==time) {
            return _Time_note_box_Array[i];
        }
    }
    return nil;
}
@end

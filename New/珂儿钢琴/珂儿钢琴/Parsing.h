//
//  Parsing.h
//  珂儿钢琴
//
//  Created by qianfeng on 15/9/21.
//  Copyright (c) 2015年 NAME. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parsing : NSObject

@property(nonatomic)float maxtime;//文件中最大的时间标示

@property (nonatomic,) float time;
@property (nonatomic, copy) NSString *note;
@property(nonatomic)NSMutableArray * Time_note_box_Array;
-(instancetype)initWithFilePath:(NSString *)FilePath;
-(void)show;
-(void)playmessage;
-(NSString *)noteBytime:(float)time;
@end

//
//  NotePlay.h
//  珂儿钢琴
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 NAME. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotePlay : NSObject
{
    NSString *soundFile;
}
-(void)keybuttonClick:(NSString *)note;
@end

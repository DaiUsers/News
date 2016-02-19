//
//  NotePlay.m
//  珂儿钢琴
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 NAME. All rights reserved.
//

#import "NotePlay.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
@implementation NotePlay
-(void)playSound:(NSString*)soundKey{
    NSString *path = [NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] resourcePath],soundKey];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
}
-(void)keybuttonClick:(NSString *)note{
    switch ([note intValue]) {
        case 100:
        {
            soundFile = [NSString stringWithFormat:@"/001.mp3"];
            [self playSound: soundFile];
        }
            break;
        case 101:
        {
            soundFile = [NSString stringWithFormat:@"/002.mp3"];
            [self playSound: soundFile];
            
        }
            break;
        case 102:
        {
            soundFile = [NSString stringWithFormat:@"/003.mp3"];
            [self playSound: soundFile];
            
        }
            break;
        case 103:
        {
            soundFile = [NSString stringWithFormat:@"/004.mp3"];
            [self playSound: soundFile];
        }
            break;
        case 104:
        {
            soundFile = [NSString stringWithFormat:@"/005.mp3"];
            [self playSound: soundFile];
            
        }
            break;
        case 105:
        {
            soundFile = [NSString stringWithFormat:@"/006.mp3"];
            [self playSound: soundFile];
            
        }
            break;
        case 106:
        {
            soundFile = [NSString stringWithFormat:@"/007.mp3"];
            [self playSound: soundFile];
        }
            break;
        case 200:
        {
            soundFile = [NSString stringWithFormat:@"/C.mp3"];
            [self playSound: soundFile];
        }
            break;
        case 201:
        {
            soundFile = [NSString stringWithFormat:@"/D.mp3"];
            [self playSound: soundFile];
        }
            break;
        case 202:
        {
            soundFile = [NSString stringWithFormat:@"/E.mp3"];
            [self playSound: soundFile];
        }
            break;
        case 203:
        {
            soundFile = [NSString stringWithFormat:@"/F.mp3"];
            [self playSound: soundFile];
        }
            break;
        case 204:
        {
            soundFile = [NSString stringWithFormat:@"/G.mp3"];
            [self playSound: soundFile];
        }
            break;
        default:
            break;
    }
}

@end

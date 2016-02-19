//
//  CustomCelll.m
//  珂儿钢琴
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 NAME. All rights reserved.
//

#import "CustomCelll.h"

@implementation CustomCelll
- (void)awakeFromNib {
    // Initialization code
}
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Cells are transparent
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
- (void) setTheImage:(UIImage *) icon {
    // Alloc and set the frame
    image = [[UIImageView alloc] initWithImage:icon];
    
    CGRect rect = [[UIScreen mainScreen] bounds];//为了适配
    CGSize size = rect.size;
    CGFloat width = size.width;
    image.frame = CGRectMake(0, 0, width, 44);
    
    // Add subview
    [self.contentView addSubview:image];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:YES animated:YES];
    if (selected == YES){
        image.alpha = 0.5;
    }
    else{
        image.alpha = 1;
    }
}
@end

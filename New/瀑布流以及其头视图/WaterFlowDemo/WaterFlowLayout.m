//
//  WaterFlowLayout.m
//  WaterFlowDemo
//
//  Created by Hailong.wang on 15/9/18.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//

#import "WaterFlowLayout.h"

@interface WaterFlowLayout ()

//存储列高的数组
@property (nonatomic, strong) NSMutableArray *columHeight;
//存储所有cell的尺寸信息
@property (nonatomic, strong) NSMutableArray *cellFrame;
//存储header的尺寸信息
@property (nonatomic, strong) UICollectionViewLayoutAttributes *headerAttributes;

@end

@implementation WaterFlowLayout
//colum的set方法
- (void)setColum:(NSInteger)colum {
    if (_colum != colum) {
        _colum = colum;
        //将之前的布局信息失效，重新布局
        [self invalidateLayout];
    }
}

//distance的set方法
- (void)setDistance:(NSInteger)distance {
    if (_distance != distance) {
        _distance = distance;
        [self invalidateLayout];
    }
}

//insetSpace的set方法
- (void)setInsetSpace:(UIEdgeInsets)insetSpace {
    if (!UIEdgeInsetsEqualToEdgeInsets(_insetSpace, insetSpace)) {
        _insetSpace = insetSpace;
        [self invalidateLayout];
    }
}

//headerSpace的set方法
- (void)setHeaderSpace:(NSInteger)headerSpace {
    if (_headerSpace != headerSpace) {
        _headerSpace = headerSpace;
        [self invalidateLayout];
    }
}

//自定义layout需要重写下面的几个方法
//准备布局，将item的位置信息计算出来
- (void)prepareLayout {
    //将位置信息和高度信息的数组实例化
    [self initDataArray];
    //初始化每一列的初始高度
    [self initColumHeightArray];
    //初始化计算出全部cell的高度，并且存入数组
    [self initAllCellHeight];
}

//初始化计算出全部cell的高度，并且存入数组
- (void)initAllCellHeight {
    //拿出第一组的全部cell的数量
    NSInteger allCellNumber = [self.collectionView numberOfItemsInSection:0];
    
    //取得整个collectionView的宽度
    CGFloat totalWidth = self.collectionView.width;
    //取得一行中Cell的总宽度
    CGFloat itemAllWidth = totalWidth - _insetSpace.left - _insetSpace.right - _distance * (_colum - 1);
    //取得每一个cell的宽度
    CGFloat width = itemAllWidth / _colum;
    
    //循环计算每一个cell的高度并且将位置信息添加到数组中
    for (int i = 0; i < allCellNumber; i ++) {
        //拿到当前的列的信息
        NSInteger currentColum = [self getShortColum];
        //x偏移就是用当前的列去乘以宽度和间距，并且加上内边距
        CGFloat xOffset = _insetSpace.left + currentColum * (width + _distance);
        //制造索引路径
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //取得y偏移
        CGFloat yOffset = [[_columHeight objectAtIndex:currentColum] floatValue] + _distance;
        //取得高度，由实现协议者提供
        CGFloat height = 0.0f;
        if (_delegate && [_delegate respondsToSelector:@selector(waterFlow:heightForCellAtIndexPath:)]) {
            height = [_delegate waterFlow:self heightForCellAtIndexPath:indexPath];
        }
        //整理cell的尺寸信息
        CGRect frame = CGRectMake(xOffset, yOffset, width, height);
        //attributes是用来存储当前indexPath的cell的位置信息的
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = frame;
        //将位置信息添加到cell尺寸数组中
        [_cellFrame addObject:attributes];
        //改变当前列的高度
        _columHeight[currentColum] = @(frame.size.height + frame.origin.y);
    }
}

//取得当前cell的尺寸
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [_cellFrame objectAtIndex:indexPath.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    attributes.frame = CGRectMake(0, _insetSpace.top, self.collectionView.width, _headerSpace);
    return attributes;
}

//根据rect去找出需要布局的cell的位置信息
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    //用来存储可以展示的cell的位置信息
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:0];
    for (UICollectionViewLayoutAttributes *attributes in _cellFrame) {
        //如果取出的位置信息，在rect的范围内，就将这个位置信息，装入数组中。
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [temp addObject:attributes];
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    [temp addObject:attributes];
    return temp;
}

//指定collection的contentSize
- (CGSize)collectionViewContentSize {
    //内容宽度指定为collectionView的宽度(横向不发生滚动)
    CGFloat width = self.collectionView.width;
    //取出最长的列，将其高度定位长度
    CGFloat height = [self getLongColum];
    return CGSizeMake(width, height);
}

- (CGFloat)getLongColum {
    //记录当前最长的列号
    __block NSInteger currentColum = 0;
    //假设最长的列高度为0
    __block CGFloat longHeight = 0;
    //枚举数组中的元素
    [_columHeight enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj floatValue] > longHeight) {
            longHeight = [obj floatValue];
            currentColum = idx;
        }
    }];
    return longHeight + _insetSpace.bottom;
}

//取得最短的列
- (NSInteger)getShortColum {
    //记录当前最短的列号
    __block NSInteger currentColum = 0;
    //假设最短的列高度为float的最大值
    __block CGFloat shortHeight = MAXFLOAT;
    //枚举数组中的元素
    [_columHeight enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj floatValue] < shortHeight) {
            shortHeight = [obj floatValue];
            currentColum = idx;
        }
    }];
    return currentColum;
}

//初始化每一列的初始高度
- (void)initColumHeightArray {
    for (int i = 0; i < _colum; i ++) {
        //[_columHeight addObject:@(_insetSpace.top)];
        //这两种形式一样的结果
        _columHeight[i] = @(_headerSpace + _insetSpace.top);
    }
}

//将位置信息和高度信息的数组实例化
- (void)initDataArray {
    //记录当前每一列的高度，所以我们只需要列数的空间就够了。
    _columHeight = [[NSMutableArray alloc] initWithCapacity:_colum];
    //记录所有cell的尺寸信息
    _cellFrame = [[NSMutableArray alloc] initWithCapacity:0];
}

@end










//
//  CollectFlowLayout.m
//  Calligraphy
//
//  Created by apple on 2017/6/1.
//  Copyright © 2017年 wx. All rights reserved.
//

#import "CollectFlowLayout.h"

static const NSInteger ColumnCount = 3;

static const CGFloat ColumnMargin = 10;

static const CGFloat RowMargin = 10;

static const UIEdgeInsets EdgeInsets = {0,0,0,0};

@interface CollectFlowLayout()
@property (nonatomic,strong) NSMutableArray *attrsArray;
@property (nonatomic,strong) NSMutableArray *columnHeights;
@property (nonatomic,assign) CGFloat contentHeight;

-(CGFloat)rowMargin;
-(CGFloat)columnMargin;
-(CGFloat)columnCount;
-(UIEdgeInsets)edgeInsets;
@end

@implementation CollectFlowLayout
-(CGFloat)rowMargin {
    return RowMargin;
}
-(CGFloat)columnMargin {
    return ColumnMargin;
}
-(CGFloat)columnCount{
    if (_delegate && [self.delegate respondsToSelector:@selector(columnCount:)]) {
        return [_delegate columnCount:self];
    }
    return ColumnCount;
}
-(UIEdgeInsets)edgeInsets {
    return EdgeInsets;
}

-(void)prepareLayout {
    [super prepareLayout];
    self.contentHeight = 0;
    
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArray;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    CGFloat w = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    CGFloat h = w;
    NSInteger itemNum = indexPath.item;
    NSInteger count = self.columnCount;
    NSInteger columun = itemNum % count;
    NSInteger row = itemNum / count;
    CGFloat x = self.edgeInsets.left + columun * (w + self.columnMargin);
    CGFloat y = self.edgeInsets.top  + row * (h + self.rowMargin);
    
    attrs.frame = CGRectMake(x, y, w, h);
    if (indexPath.item == [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0] - 1) {
        self.contentHeight = CGRectGetMaxY(attrs.frame);
    }
    
    return attrs;
}

-(CGSize)collectionViewContentSize {
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

-(NSMutableArray *)attrsArray{
    if (_attrsArray == nil) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}
@end

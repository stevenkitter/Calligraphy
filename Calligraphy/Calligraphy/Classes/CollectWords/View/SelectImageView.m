//
//  SelectImageView.m
//  Calligraphy
//
//  Created by apple on 2017/6/2.
//  Copyright © 2017年 wx. All rights reserved.
//

#import "SelectImageView.h"
#import "ImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "CollectWordModel.h"
#import "ImageLabelCollectionViewCell.h"
@interface SelectImageView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) NSArray *imgUrls;
@property (nonatomic,copy) SelectedBlock block;

@end
@implementation SelectImageView
- (IBAction)bgClicked:(UIButton *)sender {
    [self removeFromSuperview];
}

-(void)awakeFromNib {
    [super awakeFromNib];
     [_collectionView registerNib:[UINib nibWithNibName:@"ImageLabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageLabelCollectionViewCell"];
}

-(instancetype)initWithFrame:(CGRect)frame imgs:(NSArray *)imgs SelectedBlock:(SelectedBlock)block{
    SelectImageView *selectImageView = [[NSBundle mainBundle] loadNibNamed:@"SelectImageView" owner:nil options:nil].firstObject;
    selectImageView.imgUrls = imgs;
    selectImageView.frame = frame;
    selectImageView.block = block;
    return selectImageView;
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgUrls.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageLabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageLabelCollectionViewCell" forIndexPath:indexPath];
    CollectWordModel *model = self.imgUrls[indexPath.item];
    cell.model = model;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectWordModel *model = self.imgUrls[indexPath.item];
    if (self.block) {
        self.block(model.img);
        [self removeFromSuperview];
    }
}
@end

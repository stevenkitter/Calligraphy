//
//  ImageLabelCollectionViewCell.m
//  Calligraphy
//
//  Created by apple on 2017/6/3.
//  Copyright © 2017年 wx. All rights reserved.
//

#import "ImageLabelCollectionViewCell.h"
#import "CollectWordModel.h"
#import "UIImageView+WebCache.h"
@interface ImageLabelCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ImageLabelCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(CollectWordModel *)model {
    _model = model;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.shibeixuan.com/%@",_model.img]] placeholderImage:nil];
    _nameLabel.text = _model.author;
}
@end

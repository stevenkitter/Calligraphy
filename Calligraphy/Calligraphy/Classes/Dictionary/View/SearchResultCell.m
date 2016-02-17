//
//  SearchResultCell.m
//  Calligraphy
//
//  Created by 王旭 on 15/12/22.
//  Copyright © 2015年 wx. All rights reserved.
//

#import "SearchResultCell.h"
#import "UIImageView+WebCache.h"
#import "NSURL+Wx_defined.h"
#import "PreimageView.h"
#import "UIImage+GIF.h"
@interface SearchResultCell()

@property (strong ,nonatomic)  UIImage *cellImage;

@property (weak, nonatomic) IBOutlet UIImageView *LabelImageView;


@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *likeNum;

@property (weak, nonatomic) IBOutlet UILabel *dislikeNum;

@property (retain ,nonatomic)  UIActivityIndicatorView *indicator;
@end
@implementation SearchResultCell

-(UIActivityIndicatorView *)indicator
{
    if (_indicator == nil) {
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:(CGRect){0,0,self.LabelImageView.frame.size}];
        _indicator.hidesWhenStopped = YES;
        [_indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self.LabelImageView addSubview:_indicator];
    }
    return _indicator;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"SearchResultCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
       
    }
    
    return cell;
}

-(void)setData:(DictionaryModel *)data
{
     __weak __typeof(self)weakSelf = self;
    [self.indicator startAnimating];
    
    [self.LabelImageView sd_setImageWithURL:[NSURL urlWithProductimg:data.productimg] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self.indicator stopAnimating];
        UIImage *cutImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 0, image.size.width, image.size.width))];
        [weakSelf.LabelImageView setImage:cutImage];
        weakSelf.cellImage = cutImage;
        
    }];
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wximageViewClicked)];
    [_LabelImageView addGestureRecognizer:tapG];
    
    
    self.author.text = data.productbiaoti;
    
    self.likeNum.text = [NSString stringWithFormat:@"%ld",(long)data.good];
    
    self.dislikeNum.text = [NSString stringWithFormat:@"%ld",(long)data.bad];
}

-(void)wximageViewClicked
{
    PreimageView *preImageView = [PreimageView initWithImage:_cellImage];
    [[UIApplication sharedApplication].keyWindow addSubview:preImageView];
}

@end

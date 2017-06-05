//
//  SelectImageView.h
//  Calligraphy
//
//  Created by apple on 2017/6/2.
//  Copyright © 2017年 wx. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectedBlock)(NSString* img);
@interface SelectImageView : UIView

-(instancetype)initWithFrame:(CGRect)frame imgs:(NSArray*)imgs SelectedBlock:(SelectedBlock)block;
@end

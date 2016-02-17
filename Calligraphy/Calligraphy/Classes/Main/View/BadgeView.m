//
//  BadgeView.m
//  
//
//  Created by apple on 15/11/9.
//
//

#import "BadgeView.h"
#import "UIView+Frame.h"
#define BadgeViewFont [UIFont systemFontOfSize:11]
@implementation BadgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = NO;
        
        [self setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        
        // 设置字体大小
        self.titleLabel.font = BadgeViewFont;
        
        [self sizeToFit];
        
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    
    // 判断badgeValue是否有内容
    // 没有内容或者空字符串,等于0
    if (badgeValue.length == 0 || [badgeValue isEqualToString:@"0"])
    {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    
    
    NSDictionary *attrs = @{NSFontAttributeName:BadgeViewFont};
    CGSize size = [badgeValue sizeWithAttributes:attrs];
    
    if (size.width > self.width) { // 文字的尺寸大于控件的宽度
        [self setImage:[UIImage imageNamed:@"new_dot"] forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
        [self setBackgroundImage:nil forState:UIControlStateNormal];
    }else{
        [self setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
        [self setTitle:badgeValue forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
    }
    
}


@end

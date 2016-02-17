//
//  NSString+Wx_defined.m
//  Calligraphy
//
//  Created by 王旭 on 15/12/22.
//  Copyright © 2015年 wx. All rights reserved.
//

#import "NSString+Wx_defined.h"

@implementation NSString (Wx_defined)
+(NSString *)indexToStr:(NSInteger)index
{
    switch (index) {
        case 0:
            return @"草书";
            break;
        case 1:
            return @"行书";
            break;
        case 2:
            return @"楷书";
            break;
        case 3:
            return @"隶书";
            break;
        case 4:
            return @"篆书";
            break;
        default:
            break;
    }
    return @"";
}
@end

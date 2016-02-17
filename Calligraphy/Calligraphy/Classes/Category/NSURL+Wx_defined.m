//
//  NSURL+Wx_defined.m
//  Calligraphy
//
//  Created by 王旭 on 15/12/23.
//  Copyright © 2015年 wx. All rights reserved.
//

#import "NSURL+Wx_defined.h"

@implementation NSURL (Wx_defined)
+(NSURL *)urlWithProductimg:(NSString *)productimg
{
    NSString *urlStr = [BASE stringByAppendingString:productimg];
    return [NSURL URLWithString:urlStr];
}
@end

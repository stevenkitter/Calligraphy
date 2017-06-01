//
//  CollectWordModel.m
//  Calligraphy
//
//  Created by apple on 2017/6/1.
//  Copyright © 2017年 wx. All rights reserved.
//

#import "CollectWordModel.h"

@implementation CollectWordModel
-(instancetype)initWithWord:(NSString*)word imgUrl:(NSString*)imgUrl{
    if (self = [self init]) {
        self.word = word;
        self.img = imgUrl;
    }
    return self;
}
@end

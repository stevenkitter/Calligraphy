//
//  CollectWordModel.h
//  Calligraphy
//
//  Created by apple on 2017/6/1.
//  Copyright © 2017年 wx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectWordModel : NSObject
@property (nonatomic,copy) NSString *word;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *author;

-(instancetype)initWithWord:(NSString*)word imgUrl:(NSString*)imgUrl;
@end



//
//  DictionaryModel.m
//  Calligraphy
//
//  Created by 王旭 on 15/12/22.
//  Copyright © 2015年 wx. All rights reserved.
//

#import "DictionaryModel.h"

@implementation DictionaryModel
// *productshufaid;
//
// *productfenleiid;
//
// *autoID;
//
//*productbiaoti;
//
// *productguanjianzi;
//
// *productimg;
//
//*good;
//
// *bad;
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        self.productshufaid = dict[@"Productshufaid"];
        self.productfenleiid = dict[@"Productfenleiid"];
        self.autoID = dict[@"AutoID"];
        self.productbiaoti = dict[@"Productbiaoti"];
        self.productguanjianzi = dict[@"Productguanjianzi"];
        self.productimg = dict[@"Productimg"];
        self.good = [dict[@"good"] integerValue];
        self.bad = [dict[@"bad"] integerValue];
    }
    return self;
}

+(instancetype)dictionaryModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end

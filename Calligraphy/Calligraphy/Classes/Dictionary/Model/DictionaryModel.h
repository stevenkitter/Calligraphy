//
//  DictionaryModel.h
//  Calligraphy
//
//  Created by 王旭 on 15/12/22.
//  Copyright © 2015年 wx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryModel : NSObject
//{"0":"379663","Productshufaid":"379663","1":"1","Productfenleiid":"1","2":"1","AutoID":"1","3":"\u5f90\u4f2f\u6e05","Productbiaoti":"\u5f90\u4f2f\u6e05","4":"\u554a","Productguanjianzi":"\u554a","5":"dataimages\/caoshu\/201303312215380ndpcwcmhl5.gif","Productimg":"dataimages\/caoshu\/201303312215380ndpcwcmhl5.gif","6":"4","good":"4","7":"2","bad":"2"}

@property (copy ,nonatomic)  NSString *productshufaid;

@property (copy ,nonatomic)  NSString *productfenleiid;

@property (copy ,nonatomic)  NSString *autoID;

@property (copy ,nonatomic)  NSString *productbiaoti;

@property (copy ,nonatomic)  NSString *productguanjianzi;

@property (copy ,nonatomic)  NSString *productimg;

@property (assign ,nonatomic)  NSInteger good;

@property (assign ,nonatomic)  NSInteger bad;

+(instancetype)dictionaryModelWithDict:(NSDictionary *)dict;
@end

//
//  CLHttpTool.h
//  Calligraphy
//
//  Created by 王旭 on 15/12/23.
//  Copyright © 2015年 wx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLHttpTool : NSObject
+ (void)get:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

+ (void)postNoJson:(NSString *)URLString
        parameters:(id)parameters
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
@end

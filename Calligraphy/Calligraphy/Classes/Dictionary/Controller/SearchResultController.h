//
//  SearchResultController.h
//  Calligraphy
//
//  Created by 王旭 on 15/12/22.
//  Copyright © 2015年 wx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultController : UITableViewController
//类型
@property (assign ,nonatomic)  NSInteger style;

//关键字
@property (copy ,nonatomic)  NSString *keyword;

//
@property (nonatomic, assign) NSInteger type;
@end

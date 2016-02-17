//
//  SearchResultCell.h
//  Calligraphy
//
//  Created by 王旭 on 15/12/22.
//  Copyright © 2015年 wx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DictionaryModel.h"
@interface SearchResultCell : UITableViewCell

//数据
@property (strong ,nonatomic)  DictionaryModel *data;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

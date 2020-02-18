//
//  FunctionView.h
//  Calligraphy
//
//  Created by 王旭 on 15/12/21.
//  Copyright © 2015年 wx. All rights reserved.
//

#import <UIKit/UIKit.h>
#define btnW 280.0f
@class FunctionView;
@protocol FunctionViewDelegate <NSObject>

@required
-(void)functionView:(FunctionView *)functionView btnClicked:(NSInteger)index;

@end

@interface FunctionView : UIView

//顶部广告
@property (strong ,nonatomic)  UIImageView *titleImageView;
//类型按钮
@property (strong ,nonatomic)  UIButton *style;
//input
@property (strong ,nonatomic)  UITextField *inputText;
//历代名家🔘
@property (strong ,nonatomic)  UIButton *checkBtn0;
//当代书家🔘
@property (strong ,nonatomic)  UIButton *checkBtn1;
//btnAction查询
@property (strong ,nonatomic)  UIButton *inquiry;

//加载子视图后得出高度
@property (assign ,nonatomic)  CGFloat CellHeight;
//代理
@property (nonatomic, weak) id<FunctionViewDelegate> delegate;

@property (nonatomic, assign) NSInteger type;
@end

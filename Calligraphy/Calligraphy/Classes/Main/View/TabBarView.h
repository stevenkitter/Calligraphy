//
//  TabBarView.h
//  
//
//  Created by apple on 15/11/9.
//
//

#import <UIKit/UIKit.h>
@class TabBarView;
@protocol TabBarViewDelegate <NSObject>

@optional
- (void)tabBar:(TabBarView *)tabBar didClickButton:(NSInteger)index;

@end


@interface TabBarView : UIView
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) id<TabBarViewDelegate> delegate;
@end

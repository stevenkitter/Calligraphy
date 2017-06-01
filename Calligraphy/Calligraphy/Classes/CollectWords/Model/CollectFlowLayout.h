//
//  CollectFlowLayout.h
//  Calligraphy
//
//  Created by apple on 2017/6/1.
//  Copyright © 2017年 wx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CollectFlowLayout;
@protocol CollectFlowLayoutDlegate <NSObject>

-(CGFloat)columnCount:(CollectFlowLayout*)layout;
@end

@interface CollectFlowLayout : UICollectionViewLayout
@property (nonatomic,weak) id<CollectFlowLayoutDlegate> delegate;
@end

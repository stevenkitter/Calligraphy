#ifndef HXADDelegate_h
#define HXADDelegate_h
#endif

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol HXADDelegate <NSObject>
//  广告加载失败
-(void)adLoadFail:(NSString*) errcode order_id:(NSString*)order_id ad_order:(int)ad_order;
//  广告加载成功
-(void)adLoadSuccess:(NSString*)order_id ad_order:(int)ad_order;
//  广告渲染成功
-(void)adRenderSuccess:(NSString*)order_id ad_order:(int)ad_order;
 //  广告点击
-(void)adClick:(NSString*)order_id ad_order:(int)ad_order;
//  广告关闭
-(void)adClose:(NSString*)order_id ad_order:(int)ad_order;
//  可以发放激励视频奖励
-(void)adReward:(NSString*)order_id ad_order:(int)ad_order;
//  没有广告配置
-(void)adNoConfig:(NSString*)order_id ad_order:(int)ad_order;
//  视频播放完毕
-(void)adVideoPlayFinish:(NSString*)order_id ad_order:(int)ad_order;

@end

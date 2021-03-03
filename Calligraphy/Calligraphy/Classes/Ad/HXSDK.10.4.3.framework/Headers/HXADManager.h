#ifndef HXADManager_h
#define HXADManager_h
#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HXADBase.h"

@interface HXADManager : NSObject
+(HXADManager *)instance;
-(void) initSDK:(NSString*) cp_id ch_id:(NSString*)ch_id;
-(void) initSDK:(NSString*) cp_id ch_id:(NSString*)ch_id  handler:(void (^_Nullable)(NSMutableDictionary * _Nullable data)) handler;
//  加载开屏广告
-(HXADBase*_Nullable)loadSplashAD:(UIViewController*_Nullable)control rect:(CGRect)rect img:(NSString*_Nullable)img;
//  加载插屏广告
-(HXADBase*)loadInsertAD: (UIViewController*)controller rect:(CGRect)rect;
-(HXADBase*)loadBannerAD:(UIViewController*)controller view:(UIView*)view rect:(CGRect)rect;    //  加载 banner 广告
//  加载并显示激励视频广告
-(HXADBase*)loadAndShowRewardVideoAD:(UIViewController*)controller;
//  加载激励视频广告
-(HXADBase*)loadRewardVideoAD:(UIViewController*)controller;
//  加载全屏视频广告
-(HXADBase*)loadFullScreenVideoAD:(UIViewController*)controller;
//  加载并显示全屏视频广告
-(HXADBase*_Nonnull)loadAndShowFullScreenVideoAD:(UIViewController*_Nonnull)controller;
//  加载原生广告
-(HXADBase*_Nonnull)loadNativeAD:(CGRect)rect;
//  加载并显示原生广告
-(HXADBase*_Nonnull)loadAndShowNativeAD:(UIViewController*_Nonnull)controller view:(UIView*_Nonnull)view rect:(CGRect)rect;
@end

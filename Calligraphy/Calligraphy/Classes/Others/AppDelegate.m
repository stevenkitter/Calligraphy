//
//  AppDelegate.m
//  Calligraphy
//
//  Created by apple on 15/12/20.
//  Copyright (c) 2015年 wx. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"

@interface AppDelegate ()
@property (assign ,nonatomic)  NSInteger secondCount;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //创建一个window载体
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    TabBarController *tabBarVc = [[TabBarController alloc] init];
    
    // 设置窗口的根控制器
    
    
    
    self.window.rootViewController = tabBarVc;
    
    [self.window makeKeyAndVisible];
    
    BaiduMobAdSplash *splash = [[BaiduMobAdSplash alloc] init];
    splash.delegate = self;
    //把在mssp.baidu.com上创建后获得的代码位id写到这里
    splash.AdUnitTag = @"2377848";
    splash.canSplashClick = YES;
    self.splash = splash;
    
    //可以在customSplashView上显示包含icon的自定义开屏
    self.customSplashView = [[UIImageView alloc]initWithFrame:self.window.frame];
    _customSplashView.userInteractionEnabled = YES;
    [self.customSplashView setImage:[UIImage imageNamed:@"luanch.png"]];
    
    [self.window addSubview:self.customSplashView];
    
    [splash loadAndDisplayUsingContainerView:self.customSplashView];
    
    //[self.customSplashView setHidden:YES];
    
    return YES;
}

-(void)timerFireMethod:(NSTimer*)timer
{
    _secondCount--;
    [self.label setText:[NSString stringWithFormat:@"%ld",(long)_secondCount]];
}

- (NSString *)publisherId{
    return @"ad761935"; //your_own_app_id
}

-(void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash
{
    
    
    CGFloat labelW = 33;
    CGFloat labelH = 33;
    CGFloat margin = 20;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CLScreenW-margin-labelW, margin, labelW, labelH)];
    self.label = label;
    label.text = @"5";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor grayColor];
    _secondCount = 5;
    label.textColor = [UIColor whiteColor];
    [self.customSplashView addSubview:label];
    [self.customSplashView bringSubviewToFront:label];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    self.timer = timer;
    
}

/**
 *  广告展示失败
 */
- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason) reason
{
    
    //自定义开屏移除
    [self.customSplashView removeFromSuperview];
}

/**
 *  广告展示结束
 */
- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash
{
    
    //自定义开屏移除
    [self.customSplashView removeFromSuperview];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

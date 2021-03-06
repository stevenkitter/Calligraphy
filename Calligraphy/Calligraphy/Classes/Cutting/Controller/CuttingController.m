//
//  CuttingController.m
//  Calligraphy
//
//  Created by 王旭 on 15/12/24.
//  Copyright © 2015年 wx. All rights reserved.
//

#import "CuttingController.h"
#import "MBProgressHUD.h"
#import "UIBarButtonItem+Item.h"
static NSString *cuttingUrlstr = @"http://www.shibeixuan.com/zkindex.php";
@interface CuttingController() <UIWebViewDelegate>

@property (strong ,nonatomic)  UIWebView *webView;

@property (strong ,nonatomic)  MBProgressHUD *hud;

@end

@implementation CuttingController

-(UIWebView *)webView
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

-(MBProgressHUD *)hud
{
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] initWithFrame:contentFrame];
        [self.view addSubview:_hud];
        [_hud setLabelText:@"加载中..."];
    }
    return _hud;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self loadWebView];
    UIBarButtonItem *left = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"navigationbar_back"] highImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] target:self action:@selector(popToPre) forControlEvents:UIControlEventTouchUpInside];
    // 设置导航条的按钮
    self.navigationItem.leftBarButtonItem = left;
}

-(void)popToPre
{
    [self loadWebView];
}

-(void)loadWebView
{
    
    NSURL *url = [NSURL URLWithString:cuttingUrlstr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.hud hide:YES];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.hud show:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.hud hide:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString isEqualToString:cuttingUrlstr]) {
        [self.navigationItem.leftBarButtonItem.customView setHidden:YES];
    }else{
        [self.navigationItem.leftBarButtonItem.customView setHidden:NO];
    }
    return YES;
}

@end

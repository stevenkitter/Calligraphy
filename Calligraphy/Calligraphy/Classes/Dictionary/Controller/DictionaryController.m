//
//  DictionaryController.m
//  Calligraphy
//
//  Created by 王旭 on 15/12/21.
//  Copyright © 2015年 wx. All rights reserved.
//

#import "DictionaryController.h"
#import "FunctionView.h"
#import "SearchResultController.h"
#import "NSString+Wx_defined.h"
#import "UIView+Toast.h"
#import "WebViewController.h"
@interface DictionaryController ()<FunctionViewDelegate,UIActionSheetDelegate>


@property (strong ,nonatomic)  UIScrollView *mainScrollView;

@property (strong ,nonatomic)  FunctionView *funcView;

@property (assign ,nonatomic) NSInteger styleIndex;
@end

@implementation DictionaryController

-(UIScrollView *)mainScrollView
{
    if (_mainScrollView == nil) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:_mainScrollView];
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
        [_mainScrollView addGestureRecognizer:tapG];
    }
    return _mainScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addsubViews];
    self.navigationItem.title = @"拾贝轩";
}

-(void)hideKeyboard:(UITapGestureRecognizer*)tapG
{
    [self.view endEditing:YES];
}

-(void)addsubViews
{
    FunctionView *funcView = [[FunctionView alloc] initWithFrame:CGRectMake(0, 0, CLScreenW, 250)];
    self.funcView = funcView;
    funcView.delegate = self;
    [self.mainScrollView addSubview:funcView];
   
    
    UIButton *btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btn0_backgroundImage = [UIImage imageNamed:@"btn0_backgroundImage"];
    btn0.frame = CGRectMake((CLScreenW-btnW)*0.5, CGRectGetMaxY(funcView.frame)+10, btnW, btn0_backgroundImage.size.height*btnW/btn0_backgroundImage.size.width);
    btn0.tag = 0;
    [btn0 setBackgroundImage:btn0_backgroundImage forState:UIControlStateNormal];
    [btn0 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = 1;
    UIImage *btn1_backgroundImage = [UIImage imageNamed:@"btn1_backgroundImage"];
    btn1.frame = CGRectMake(CGRectGetMinX(btn0.frame), CGRectGetMaxY(btn0.frame)+10, btnW, btn1_backgroundImage.size.height*btnW/btn1_backgroundImage.size.width);
    [btn1 setBackgroundImage:btn1_backgroundImage forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 2;
    UIImage *btn2_backgroundImage = [UIImage imageNamed:@"btn2_backgroundImage"];
    btn2.frame = CGRectMake(CGRectGetMinX(btn0.frame), CGRectGetMaxY(btn1.frame)+10, btnW, btn2_backgroundImage.size.height*btnW/btn2_backgroundImage.size.width);
    
    [btn2 setBackgroundImage:btn2_backgroundImage forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *labelDown = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn2.frame)+10, CLScreenW,33.0f)];
    labelDown.textAlignment = NSTextAlignmentCenter;
    labelDown.textColor = [UIColor grayColor];
    labelDown.text = @"版权所有 拾贝轩";
    [self.mainScrollView setContentSize:CGSizeMake(CLScreenW, CGRectGetMaxY(labelDown.frame)+5)];
    
    [self.mainScrollView addSubview:btn0];
    [self.mainScrollView addSubview:btn1];
    [self.mainScrollView addSubview:btn2];
    [self.mainScrollView addSubview:labelDown];
}

-(void)btnClicked:(UIButton*)btn
{
    WebViewController *webViewC = [[WebViewController alloc] init];
    
    switch (btn.tag) {
        case 0:
            webViewC.url = @"http://www.shibeixuan.com/bibei/mb.html";
            break;
        case 1:
            webViewC.url = @"http://syh.shibeixuan.com";
            break;
        case 2:
            webViewC.url = @"http://zl.shibeixuan.com";
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:webViewC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)functionView:(FunctionView *)functionView btnClicked:(NSInteger)index
{
    [self.view endEditing:YES];
    if (index == 0) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"字体类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"草书" otherButtonTitles:@"行书",@"楷书",@"隶书",@"篆书", nil];
        actionSheet.destructiveButtonIndex = _styleIndex;
        [actionSheet showInView:self.view.window];
       
        return;
    }
    
    
    
    //跳转页面
    SearchResultController *searchResultController = [[SearchResultController alloc] init];
    searchResultController.style = _styleIndex+1;
    searchResultController.keyword = _funcView.inputText.text;
    searchResultController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchResultController animated:YES];
  
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 5) return;
    //@"草书",@"行书",@"楷书",@"隶书",@"篆书"
    _styleIndex = buttonIndex;
    [_funcView.style setTitle:[[NSString indexToStr:buttonIndex] stringByAppendingString:@" \u25BE"] forState:UIControlStateNormal];
}






@end

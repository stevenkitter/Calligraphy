//
//  SearchResultController.m
//  Calligraphy
//
//  Created by 王旭 on 15/12/22.
//  Copyright © 2015年 wx. All rights reserved.
//

#import "SearchResultController.h"
#import "FunctionView.h"
#import "CLHttpTool.h"
#import "DictionaryModel.h"
#import "SearchResultCell.h"
#import "UIView+Toast.h"
#import "UIView+Frame.h"
#import "NSString+Wx_defined.h"
#import "MJRefresh.h"
#import "UIBarButtonItem+Item.h"
#import "MBProgressHUD.h"
#import "BaiduMobAdSDK/BaiduMobAdView.h"
#import "BaiduMobAdSDK/BaiduMobAdSetting.h"
static NSInteger pageSize = 10;
@interface SearchResultController ()<FunctionViewDelegate,UIActionSheetDelegate,BaiduMobAdViewDelegate>
@property (strong ,nonatomic)  FunctionView *funcView;

@property (strong ,nonatomic)  NSMutableArray *dataSource;

@property (assign ,nonatomic)  NSInteger pageIndex;


@property (assign ,nonatomic)  BOOL isAllDataFinished;

@property (strong ,nonatomic)  BaiduMobAdView *sharedAdView;

@property (strong ,nonatomic)  UIView *superView;
@end

@implementation SearchResultController

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = _keyword;
    self.tableView.scrollsToTop = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addHeader];
    
    [self loadDataFromServer:@(_pageIndex)];
    
    [self addRefresh];
    
    UIBarButtonItem *right = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"refresh"] highImage:[UIImage imageNamed:@"refresh_selected"] target:self action:@selector(refreshTableView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = right;
    
    
}

- (NSString	*)publisherId
{
    return	 @"ad761935";	//@"your_own_app_id";
}

-(void)refreshTableView
{
    [self.tableView scrollRectToVisible:self.tableView.tableHeaderView.frame animated:YES];
    
}

-(void)addRefresh
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    __weak __typeof(self)weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）+
        //[weakSelf.dataSource removeAllObjects];
        //weakSelf.pageIndex = 0;
        weakSelf.isAllDataFinished = NO;
        [weakSelf loadDataFromServer:@0];
        [tableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        [tableView.mj_footer endRefreshing];
        if (weakSelf.isAllDataFinished) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window makeToast:@"没有更多内容了"
                     duration:1.0
                     position:CSToastPositionCenter];
            return ;
        }
        weakSelf.pageIndex = weakSelf.pageIndex+pageSize;
        [weakSelf loadDataFromServer:@(weakSelf.pageIndex)];
    }];
    
    
    
    
    
    
}

-(void)addHeader
{
    UIView *superView = [UIView new];
    superView.frame = CGRectMake(0, 0, CLScreenW, 250+CLScreenW*0.15);
    _superView = superView;
    
    FunctionView *funcView = [[FunctionView alloc] initWithFrame:CGRectMake(0, CLScreenW*0.15, CLScreenW, 250)];
    
    self.funcView = funcView;
    funcView.inputText.text = _keyword;
    [funcView.style setTitle:[[NSString indexToStr:_style-1]stringByAppendingString:@" \u25BE"] forState:UIControlStateNormal];
    funcView.delegate = self;
    
    
    [superView addSubview:self.funcView];
    
    _sharedAdView	=	[[BaiduMobAdView	alloc]	init];
    //把在mssp.baidu.com上创建后获得的代码位id写到这⾥
    _sharedAdView.AdUnitTag	=	@"2377848";
    _sharedAdView.AdType	=	BaiduMobAdViewTypeBanner;
    _sharedAdView.frame	=	CGRectMake(0, 0, CLScreenW, CLScreenW*0.15);
    _sharedAdView.delegate	=	self;
    [superView addSubview:_sharedAdView];
    
    [_sharedAdView	start];
    
    self.tableView.tableHeaderView = superView;
}


- (void)failedDisplayAd:(BaiduMobFailReason)reason{
    [_sharedAdView removeFromSuperview];
    _superView.frame = CGRectMake(0, 0, CLScreenW, 250);
    _funcView.frame = CGRectMake(0, 0, CLScreenW, 250);
    [self.tableView reloadData];
}

- (void)didAdImpressed{
    [_superView addSubview:_sharedAdView];
    _superView.frame = CGRectMake(0, 0, CLScreenW, 250+CLScreenW*0.15);
    _funcView.frame = CGRectMake(0, CLScreenW*0.15, CLScreenW, 250);
    [self.tableView reloadData];
}


-(void)loadDataFromServer:(NSNumber *)pageIndex
{
    //find=find&page=0&pageend=15
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, naviHeight, CLScreenW, self.view.height-naviHeight)];
    [hud setLabelText:@"加载中..."];
    [self.view addSubview:hud];
    [hud show:YES];
    NSString *url = [NSString stringWithFormat:@"http://www.shibeixuan.com/xzqy3/mo_cidian2.php?find=find&page=%@&pageend=%ld",pageIndex,(long)pageSize];
    NSDictionary *paramters = @{@"gjz":_funcView.inputText.text,@"fenlei":@(_style)};
    
    [CLHttpTool post:url parameters:paramters success:^(id responseObject) {
        [hud hide:YES];
        [hud removeFromSuperview];
        
        if ([pageIndex intValue] == 0)
        {
            self.pageIndex = 0;
            [self.dataSource removeAllObjects];
        }
        _isAllDataFinished = NO ;
        NSArray *postResult = (NSArray*)responseObject;
        for (NSDictionary *item in postResult) {
            DictionaryModel *model = [DictionaryModel dictionaryModelWithDict:item];
            [self.dataSource addObject:model];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [hud hide:YES];
        [hud removeFromSuperview];
        _isAllDataFinished = YES;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window makeToast:@"没有更多内容了"
                 duration:1.0
                 position:CSToastPositionCenter];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 252.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    SearchResultCell *cell = [SearchResultCell cellWithTableView:tableView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DictionaryModel *data = self.dataSource[indexPath.row];
    
    [cell setData:data];
    
    return cell;
}




#pragma mark - Navigation
-(void)functionView:(FunctionView *)functionView btnClicked:(NSInteger)index
{
    [self.view endEditing:YES];
    if (index == 0) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"字体类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"草书" otherButtonTitles:@"行书",@"楷书",@"隶书",@"篆书", nil];
        actionSheet.destructiveButtonIndex = _style-1;
        [actionSheet showInView:self.view.window];
        return;
    }
    
    
    
    self.title = _funcView.inputText.text;
    [self loadDataFromServer:@0];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 5) return;
    //@"草书",@"行书",@"楷书",@"隶书",@"篆书"
    _style = buttonIndex+1;
    [_funcView.style setTitle:[[NSString indexToStr:buttonIndex] stringByAppendingString:@" \u25BE"] forState:UIControlStateNormal];
}


@end

//
//  TabBarController.m
//  
//
//  Created by apple on 15/11/9.
//
//

#import "TabBarController.h"
#import "NavigationController.h"
#import "TabBarView.h"
#import "UIImage+Image.h"
#import "DictionaryController.h"
#import "EssentialController.h"
#import "CuttingController.h"
#import "CommunityController.h"
#import "CollectWordsViewController.h"
@interface TabBarController ()<TabBarViewDelegate>

@property (nonatomic, strong) NSMutableArray *items;


@end

@implementation TabBarController

- (NSMutableArray *)items
{
    if (_items == nil) {
        
        _items = [NSMutableArray array];
        
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加所有子控制器
    [self setUpAllChildViewController];
    
    
    // 自定义tabBar
    [self setUpTabBar];
}

- (void)setUpTabBar
{
    // 自定义tabBar
    TabBarView *tabBar = [[TabBarView alloc] initWithFrame:self.tabBar.frame];
    tabBar.backgroundColor = [UIColor colorWithRed:0.977 green:0.977 blue:0.977 alpha:1.00];
    tabBar.frame = self.tabBar.bounds;
    // 设置代理
    tabBar.delegate = self;
    
    // 给tabBar传递tabBarItem模型
    tabBar.items = self.items;
    
    // 添加自定义tabBar
    [self.tabBar addSubview:tabBar];
    
    // 移除系统的tabBar
    //[self.tabBar removeFromSuperview];
}

#pragma mark - 当点击tabBar上的按钮调用
- (void)tabBar:(TabBarView *)tabBar didClickButton:(NSInteger)index
{
    self.selectedIndex = index;
}

- (void)setUpAllChildViewController
{
    //888888  f58717
    // 词典
    DictionaryController *home = [[DictionaryController alloc] init];
    home.view.backgroundColor = [UIColor whiteColor];
    [self setUpOneChildViewController:home image:[UIImage imageNamed:@"dictionary"] selectedImage:[UIImage imageWithOriginalName:@"dictionary_selected"] title:@"辞典"];
    
    CollectWordsViewController *collectWordsViewController = [CollectWordsViewController new];
    [self setUpOneChildViewController:collectWordsViewController image:[UIImage imageWithOriginalName:@"collectWords"] selectedImage:[UIImage imageWithOriginalName:@"collectWords_selected"] title:@"集字"];
    
    // 必备
    EssentialController *essential = [[EssentialController alloc] init];
    [self setUpOneChildViewController:essential image:[UIImage imageNamed:@"essential"] selectedImage:[UIImage imageWithOriginalName:@"essential_selected"] title:@"必备"];
    
    

    
    
    
    // 篆刻
        CuttingController *cutting = [[CuttingController alloc] init];
        [self setUpOneChildViewController:cutting image:[UIImage imageNamed:@"cutting"] selectedImage:[UIImage imageWithOriginalName:@"cutting_selected"] title:@"篆刻"];
    
    // 社区
    CommunityController *community = [[CommunityController alloc] init];
    [self setUpOneChildViewController:community image:[UIImage imageNamed:@"community"] selectedImage:[UIImage imageWithOriginalName:@"community_selected"] title:@"社区"];
    
}
// navigationItem决定导航条上的内容
// 导航条上的内容由栈顶控制器的navigationItem决定

#pragma mark - 添加一个子控制器
- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    //    // navigationItem模型
    //    vc.navigationItem.title = title;
    //
    //    // 设置子控件对应tabBarItem的模型属性
    //    vc.tabBarItem.title = title;
    vc.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
 
    // 保存tabBarItem模型到数组
    [self.items addObject:vc.tabBarItem];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
}

@end

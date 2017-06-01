//
//  CollectWordsViewController.m
//  Calligraphy
//
//  Created by apple on 2017/5/31.
//  Copyright © 2017年 wx. All rights reserved.
//

#import "CollectWordsViewController.h"
#import "MBProgressHUD.h"
#import "CollectWordModel.h"
#define httpUrlImages @"http://www.shibeixuan.com/xzqy3/jzgj_mo.php?fenlei="
@interface CollectWordsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *selectWordTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *getPicturesButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewLayout *layout;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
//[[url],[url],[url]]
@property (strong,nonatomic) NSMutableArray *images;
@property (nonatomic,assign) NSInteger type;

@property (strong,nonatomic) NSMutableArray<CollectWordModel*> *imageItems;
@end

@implementation CollectWordsViewController
- (IBAction)btnClicked:(UIButton *)sender {
    if (sender.tag == 0) {
        //字体
        [self selectType];
        return;
    }else{
        //请求图片
        _textView.text = [self filterCharactor:_textView.text withRegex:@"[^\u4e00-\u9fa5|,，]"];
        [self getImages];
    }
}

-(void)selectType {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择字体" preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *types = @[@"草书",@"行书",@"楷书",@"隶书",@"篆书"];
    for (NSInteger i = 0;i < types.count;i++) {
        UIAlertActionStyle style = _type == (i+1)?UIAlertActionStyleDestructive:UIAlertActionStyleDefault;
        UIAlertAction *action = [UIAlertAction actionWithTitle:types[i] style:style handler:^(UIAlertAction * _Nonnull action) {
            _type = i + 1;
        }];
        [actionSheet addAction:action];
    }
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)viewDidLoad {
    _type = 1;
    [super viewDidLoad];
    _noticeLabel.hidden = YES;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)getImages {
    NSString *urlStr = [NSString stringWithFormat:@"%@%ld",httpUrlImages,(long)_type];
    NSString *json = [self postedJson:_textView.text];
    
    NSDictionary *parameters = @{@"words":json};
    [CLHttpTool post:urlStr parameters:parameters success:^(id responseObject) {
        [self.images removeAllObjects];
        [self.images addObjectsFromArray:(NSArray*)responseObject];
        [self initImageItems];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)initImageItems {
    [self.imageItems removeAllObjects];
    NSInteger maxCount = 0;
    for (NSInteger i = 0; i < self.images.count; i++) {
        NSArray *items = self.images[i];
        if (items.count > maxCount) {
            maxCount = items.count;
        }
    }
    NSMutableArray *itemImages = [NSMutableArray array];
    for (NSInteger j = 0; j < maxCount; j++) {
        for (NSInteger k = 0; k < self.images.count; k++) {
            NSArray *items = self.images[k];
            if (items.count > j) {
                CollectWordModel *model = [[CollectWordModel alloc] initWithWord:@"" imgUrl:items[j]];
                [itemImages addObject:model];
            }
        }
    }
    [self.imageItems addObjectsFromArray:itemImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray*)seperateWords:(NSString*)text {
    NSArray *mutWors = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",，"]];
    
    NSArray *reversed = [[mutWors reverseObjectEnumerator] allObjects];
    
    //["xx","yy","zzz"]
    NSMutableArray *exact = [self removeEmptyWord:reversed];
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *words in exact) {
        NSArray *seperatedWords = [self getAStringOfChineseWord:words];
        [result addObject:seperatedWords];
    }
    return result;
}

-(NSString*)postedJson:(NSString*)text {
    NSArray *mutWors = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",，"]];
    
    NSArray *reversed = [[mutWors reverseObjectEnumerator] allObjects];
    
    //["xx","yy","zzz"]
    NSMutableArray *exact = [self removeEmptyWord:reversed];
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *words in exact) {
        NSArray *seperatedWords = [self getAStringOfChineseWord:words];
        NSMutableArray *dicts = [NSMutableArray array];
        for (NSString *wordItem in seperatedWords) {
            NSDictionary *itemDict = @{@"word":wordItem};
            [dicts addObject:itemDict];
        }
        [result addObject:dicts];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result options:0 error:NULL];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return json;
}


-(NSMutableArray*)removeEmptyWord:(NSArray *)array {
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSString *word in array) {
        if (![word isEqualToString:@""]) {
            [result addObject:word];
        }
    }
    return result;
}



- (NSArray *)getAStringOfChineseWord:(NSString *)string
{
    if (string == nil || [string isEqual:@""])
    {
        return nil;
    }
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i=0; i<[string length]; i++)
    {
        int a = [string characterAtIndex:i];
        if (a < 0x9fff && a > 0x4e00)
        {
            [arr addObject:[string substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    return arr;
}

//正则表达式 替换不需要的东西
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    
    _noticeLabel.hidden = [result isEqualToString:string];
    
    return result;
}


#pragma mark collectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageItems.count;
}





#pragma mark init
-(NSMutableArray *)images {
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}
-(NSMutableArray<CollectWordModel *> *)imageItems{
    if (_imageItems == nil) {
        _imageItems = [NSMutableArray array];
    }
    return _imageItems;
}

@end

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
#import "ImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "CollectFlowLayout.h"
#import "SelectImageView.h"
#import <Photos/Photos.h>
#import "UITextView+Placeholder.h"
#define httpUrlImages @"http://www.shibeixuan.com/xzqy3/jzgj_mo.php?fenlei="
#define httpUrlSelectedImages @"http://www.shibeixuan.com/xzqy3/setword.php?fenlei="
#define downloadUrl @"http://www.shibeixuan.com/xzqy3/jzgj_new.php?fenlei="
@interface CollectWordsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CollectFlowLayoutDlegate>
@property (weak, nonatomic) IBOutlet UIButton *selectWordTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *getPicturesButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet CollectFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
//[[url],[url],[url]]
@property (strong,nonatomic) NSMutableArray *images;
@property (nonatomic,assign) NSInteger type;

@property (strong,nonatomic) NSMutableArray<CollectWordModel*> *imageItems;
@end

@implementation CollectWordsViewController
- (IBAction)btnClicked:(UIButton *)sender {
    [self.view endEditing:YES];
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
            NSString *selectTypeStr = [types objectAtIndex:i];
            [_selectWordTypeButton setTitle:[NSString stringWithFormat:@"选择字体(%@)",selectTypeStr] forState:UIControlStateNormal];
        }];
        [actionSheet addAction:action];
    }
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)viewDidLoad {
    _textView.placeholder = @"请输入汉字，用逗号换行（建议输入50字以内）";
    _type = 1;
    [super viewDidLoad];
    _noticeLabel.hidden = YES;
    [_collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    _layout.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下载图片" style:UIBarButtonItemStylePlain target:self action:@selector(download)];
    // Do any additional setup after loading the view from its nib.
}

-(void)download{
    if (self.imageItems.count == 0) {
        _noticeLabel.text = @"请点击生成图片";
        _noticeLabel.hidden = NO;
        return ;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%ld&json=1",downloadUrl,(long)_type];
    
    
    NSDictionary *parameters = @{@"words":[self downloadJson]};
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, naviHeight, CLScreenW, self.view.height-naviHeight)];
    [hud setLabelText:@"加载中..."];
    [self.view addSubview:hud];
    [hud show:YES];
    
    
    [CLHttpTool post:urlStr parameters:parameters success:^(id responseObject) {
       
        [hud hide:YES];
        [hud removeFromSuperview];
        NSDictionary *data = (NSDictionary*)responseObject;
        NSString *imgUrl = data[@"img"];
        
        MBProgressHUD *hudNew = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, naviHeight, CLScreenW, self.view.height-naviHeight)];
        [hudNew setLabelText:@"加载中..."];
        [self.view addSubview:hudNew];
        [hudNew show:YES];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            dispatch_async(dispatch_get_main_queue(),^{
                [hudNew hide:YES];
                [hudNew removeFromSuperview];
                UIImage *downloadImage = [UIImage imageWithData:imageData];
                //        UIImage *downloadImage = [UIImage imageWithData:imageData];
                
                [self saveImageToPhotos:downloadImage];
            });
        });
        
     
        
    } failure:^(NSError *error) {
        [hud hide:YES];
        [hud removeFromSuperview];
    }];

}

- (void)saveImageToPhotos:(UIImage*)savedImage

{
    
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

// 指定回调方法

- (void)image: (UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    
    NSString *msg = nil ;
    
    if(error != NULL){
        
        msg = @"保存图片失败" ;
        
    }else{
        
        msg = @"保存图片成功" ;
        
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg
                          
                                                    message:nil
                          
                                                   delegate:self
                          
                                          cancelButtonTitle:@"确定"
                          
                                          otherButtonTitles:nil];
    
    [alert show];
    
}


- (void)loadImageFinished:(UIImage *)image
{
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
//        NSLog(@"success = %d, error = %@", success, error);
        if (success) {
            _noticeLabel.text = @"图片保存成功！！已保存到相册";
            _noticeLabel.hidden = NO;
        }else{
            _noticeLabel.text = @"图片保存失败！！";
            _noticeLabel.hidden = NO;
        }
    }];
}

-(NSString*)downloadJson {
   
    NSMutableArray *downloadArr = [NSMutableArray array];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSInteger i = 0;i < self.imageItems.count;i++) {
        CollectWordModel *model = self.imageItems[i];
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        if (![model.img isEqualToString:@""]) {
            [tempDict setValue:model.img forKey:@"img"];
        }
        
        if (temp.count == self.images.count) {
            [downloadArr addObject:[NSArray arrayWithArray:temp]];
            [temp removeAllObjects];
        }
        [temp addObject:tempDict];
        
        if (i == self.imageItems.count - 1) {
            [downloadArr addObject:temp];
        }
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:downloadArr options:0 error:NULL];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}

-(BOOL)check:(NSString*)text {
    NSArray *mutWors = [text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",，"]];
    
    NSArray *reversed = [[mutWors reverseObjectEnumerator] allObjects];
    
    //["xx","yy","zzz"]
    NSMutableArray *exact = [self removeEmptyWord:reversed];
    NSInteger wordsNum = 0;
    for (NSString *str in exact) {
        wordsNum += str.length;
    }
    if (wordsNum > 50) {
        _noticeLabel.text = @"文字最多不超过50个";
        _noticeLabel.hidden = NO;
        return NO;
    }
    return YES;
}

-(void)getImages {
    if ([_textView.text isEqualToString:@""]) {
        _noticeLabel.text = @"请输入文字哦";
        _noticeLabel.hidden = NO;
        return;
    }
    
    if (![self check:_textView.text]) {
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%ld",httpUrlImages,(long)_type];
    
    NSString *json = [self postedJson:_textView.text];
    
    NSDictionary *parameters = @{@"words":json};
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, naviHeight, CLScreenW, self.view.height-naviHeight)];
    [hud setLabelText:@"加载中..."];
    [self.view addSubview:hud];
    [hud show:YES];
    
    
    [CLHttpTool post:urlStr parameters:parameters success:^(id responseObject) {
        [hud hide:YES];
        [hud removeFromSuperview];
        
        [self.images removeAllObjects];
        NSArray *models = (NSArray*)responseObject;
        
        for(NSArray *imgDicts in models){
            NSMutableArray *imgs = [NSMutableArray array];
            for(NSDictionary *dict in imgDicts){
                [imgs addObject:dict[@"img"]];
            }
            [self.images addObject:imgs];
        }
        
      
        [self initImageItems];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [hud hide:YES];
        [hud removeFromSuperview];
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
            }else{
                CollectWordModel *model = [[CollectWordModel alloc] initWithWord:@"" imgUrl:@""];
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
        if (a <= 0x9FA5 && a >= 0x4e00)
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

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    CollectWordModel *model = self.imageItems[indexPath.item];
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.shibeixuan.com/%@",model.img]] placeholderImage:nil];
//    cell.label.text = [NSString stringWithFormat:@"http://www.shibeixuan.com/%@",model.img];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    CollectWordModel *model = self.imageItems[indexPath.item];
    if ([model.img isEqualToString:@""]) {
        return;
    }
    [self getSelectedImages:model indexPath:indexPath];
}

-(void)getSelectedImages:(CollectWordModel*)model indexPath:(NSIndexPath*)indexPath {
    NSString *urlStr = [NSString stringWithFormat:@"%@%ld",httpUrlSelectedImages,(long)_type];
   
    
    NSDictionary *parameters = @{@"words":model.img};
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, naviHeight, CLScreenW, self.view.height-naviHeight)];
    [hud setLabelText:@"加载中..."];
    [self.view addSubview:hud];
    [hud show:YES];
    
    
    [CLHttpTool post:urlStr parameters:parameters success:^(id responseObject) {
        [hud hide:YES];
        [hud removeFromSuperview];
        NSArray *imgAuthors = (NSArray*)responseObject;
        NSMutableArray *models = [NSMutableArray array];
        for (NSDictionary *dict in imgAuthors) {
            CollectWordModel *model = [[CollectWordModel alloc] initWithWord:@"" imgUrl:dict[@"img"]];
            model.author = dict[@"author"];
            [models addObject:model];
        }
        SelectImageView *selectImageView = [[SelectImageView alloc] initWithFrame:self.view.bounds imgs:models SelectedBlock:^(NSString *img) {
            model.img = img;
            
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
        [self.view addSubview:selectImageView];
        
        
    } failure:^(NSError *error) {
        [hud hide:YES];
        [hud removeFromSuperview];
    }];
}

-(CGFloat)columnCount:(CollectFlowLayout *)layout{
    return self.images.count;
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

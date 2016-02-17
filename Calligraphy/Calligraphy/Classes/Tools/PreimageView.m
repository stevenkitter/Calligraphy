//
//  PreimageView.m
//  Calligraphy
//
//  Created by 王旭 on 15/12/23.
//  Copyright © 2015年 wx. All rights reserved.
//

#import "PreimageView.h"
#define btnW 44.0f
@implementation PreimageView
+(instancetype)initWithImage:(UIImage *)image
{
    return [[self alloc] initWithImage:image];
}
-(instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor blackColor]];
        self.frame = [UIApplication sharedApplication].keyWindow.frame;
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.image = image;
        [self addSubViews];
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageVIewClicked:)];
        [self addGestureRecognizer:tapG];
    }
    
    return self;
}
-(void)imageVIewClicked:(UITapGestureRecognizer*)tapG
{
    [self removeFromSuperview];
}

-(void)addSubViews
{
//    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    likeBtn.frame = CGRectMake(10, CLWindowH-20-btnW, btnW, btnW);
//    [likeBtn setImage:[UIImage imageNamed:@"likeBtn"] forState:UIControlStateNormal];
//    [likeBtn setImage:[UIImage imageNamed:@"likeBtn_selected"] forState:UIControlStateSelected];
//    likeBtn.tag = 0;
//    [likeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:likeBtn];
    
    UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadBtn.frame = CGRectMake((CLScreenW-btnW)*0.5, CLWindowH-20-btnW, btnW, btnW);
    [downloadBtn setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    [downloadBtn setImage:[UIImage imageNamed:@"download_highlight"] forState:UIControlStateHighlighted];
    downloadBtn.tag = 1;
    [downloadBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:downloadBtn];
    
//    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shareBtn.frame = CGRectMake(CLScreenW-10-btnW, CLWindowH-20-btnW, btnW, btnW);
//    [shareBtn setImage:[UIImage imageNamed:@"shareBtn"] forState:UIControlStateNormal];
//    [shareBtn setImage:[UIImage imageNamed:@"shareBtn_highlight"] forState:UIControlStateHighlighted];
//    shareBtn.tag = 2;
//    [shareBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:shareBtn];
}

-(void)btnClicked:(UIButton*)btn
{
    switch (btn.tag) {
        case 0:
            btn.selected = !btn.selected;
            break;
        case 1:
            [self saveImageToPhotos:self.image];
            break;
        case 2:
            
            break;
        default:
            break;
    }
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





@end

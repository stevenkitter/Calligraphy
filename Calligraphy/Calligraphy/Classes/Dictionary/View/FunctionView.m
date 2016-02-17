//
//  FunctionView.m
//  Calligraphy
//
//  Created by 王旭 on 15/12/21.
//  Copyright © 2015年 wx. All rights reserved.
//

#import "FunctionView.h"
#import "UIView+Toast.h"
#define CLCornerRadius 3.0f
@interface FunctionView()




@end

@implementation FunctionView

-(UIImageView *)titleImageView
{
    if (_titleImageView == nil) {
        _titleImageView = [[UIImageView alloc] init];
        [self addSubview:_titleImageView];
    }
    return _titleImageView;
}

-(UIButton *)style
{
    if (_style == nil) {
        _style = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_style];
        _style.layer.borderWidth = 1.0f;
        _style.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _style.tag = 0;
        _style.layer.cornerRadius = CLCornerRadius;
        _style.layer.masksToBounds = YES;
        [_style addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _style;
}

-(UITextField *)inputText
{
    if (_inputText == nil) {
        _inputText = [[UITextField alloc] init];
        [self addSubview:_inputText];
        _inputText.layer.borderWidth = 1.0f;
        _inputText.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _inputText.layer.cornerRadius = CLCornerRadius;
        _inputText.textAlignment = NSTextAlignmentCenter;
        _inputText.layer.masksToBounds = YES;
    }
    return _inputText;
}

-(UIButton *)inquiry
{
    if (_inquiry == nil) {
        _inquiry = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_inquiry];
        _inquiry.layer.borderWidth = 1.0f;
        _inquiry.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _inquiry.tag = 1;
        _inquiry.layer.cornerRadius = CLCornerRadius;
        _inquiry.layer.masksToBounds = YES;
        [_inquiry addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inquiry;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
        [self addGestureRecognizer:tapG];

        [self setSubViewsContent];
        [self setSubViewsFrame];
     
    }
    return self;
}

-(void)hideKeyboard:(UITapGestureRecognizer*)tapG
{
    [self endEditing:YES];
}

-(void)setSubViewsFrame
{
    CGFloat percent = _titleImageView.image.size.height/_titleImageView.image.size.width;
    _titleImageView.frame = CGRectMake((CLScreenW-150)*0.5, CLMargin, 150, 150*percent);
    
    
    _style.frame = CGRectMake((CLScreenW-btnW)*0.5, CGRectGetMaxY(_titleImageView.frame)+CLMargin, btnW, 44);
    
    _inputText.frame = (CGRect){{CGRectGetMinX(_style.frame), CGRectGetMaxY(_style.frame)+CLMargin}, _style.frame.size};
    
    _inquiry.frame = (CGRect){{CGRectGetMinX(_style.frame), CGRectGetMaxY(_inputText.frame)+CLMargin}, _inputText.frame.size};
    
    self.height = CGRectGetMaxY(_inquiry.frame);
}

-(void)setSubViewsContent
{
    [self.titleImageView setImage:[UIImage imageNamed:@"titleImageView"]];
    
    [self.style setTitle:[@"草书" stringByAppendingString:@" \u25BE"] forState: UIControlStateNormal];
    [self.style setContentMode:UIViewContentModeCenter];
    [_style setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [self.inputText setPlaceholder:@"请输入您要查询的汉字"];
    
    [self.inquiry setTitle:@"查字典" forState:UIControlStateNormal];
    [_inquiry setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
}

-(void)btnClicked:(UIButton *)btn
{
    if (btn.tag == 1) {
        //判断子
        if (self.inputText.text.length == 0) {
            [self makeToast:@"请输入要查询的汉字"
                        duration:1.0
                        position:CSToastPositionCenter];
            
            return;
        }
        
        if(self.inputText.text.length > 1){
            NSString *inputText = [self.inputText.text substringWithRange:NSMakeRange(0, 1)];
            self.inputText.text = inputText;
            [self   makeToast:@"只能查询单个汉字"
                          duration:1.0
                          position:CSToastPositionCenter];
            return;
        }
        //是汉字就通过
        const char *cString=[self.inputText.text UTF8String];
        if (strlen(cString)!=3&&strlen(cString)!=0){
            [self   makeToast:@"只能查询汉字"
                          duration:1.0
                          position:CSToastPositionCenter];
            self.inputText.text = @"";
            return;
        }

    }
    
    if (_delegate&&[_delegate respondsToSelector:@selector(functionView:btnClicked:)]) {
        [_delegate functionView:self btnClicked:btn.tag];
    }
}


@end

#ifndef HXADBase_h
#define HXADBase_h
#endif
//  打印日志
#define HXLog(formater,...) NSLog((@"%s" formater),"HXSDK:",##__VA_ARGS__)
#import <UIKit/UIKit.h>
#import <HXSDK.10.4.3/HXADDelegate.h>

//  广告状态
typedef enum {
    ZTAD_STATE_LOADING = 1, //  加载中
    ZTAD_STATE_SUCCESS,     //  加载成功
    ZTAD_STATE_FAILD,       //  加载失败
} ZTAD_STATE;

@interface HXADBase : NSObject
@property NSString* app_id;             //  app id
@property NSString* app_key;            //  app key
@property NSString* rect;               //  广告显示大小位置
@property UIView* view;                 //  显示容器
@property NSString* ad_id;              //  广告位 ID
@property UIViewController *controller; //  视图控制器
@property id<HXADDelegate> delegate;    //  广告通用代理
@property id<HXADDelegate> cp_delegate; //  广告通用代理
@property NSString* img;                //  附加图片
@property int ad_type;                  //  广告类型
@property int sdk_type;                 //  广告 SDK 类型
@property NSString* order_id;           //  订单 ID
@property int ad_dex;
@property NSMutableArray* arr_ad_config;    //  广告配置
@property NSMutableArray* arr_ad;           //  广告实例
@property int ad_state;                     //  广告状态
@property int ad_order;                     //  广告顺序
@property BOOL b_ad_load_show;              //  是否加载完直接显示

-(instancetype)initWithPara:(UIViewController*)controller view:(UIView*)view ad_type:(int)ad_type rect:(CGRect)rect img_name:(NSString*)img_name;
-(void)requestZTAD:(BOOL) b_ad_load_show;
-(void)showAD;
-(void)showAD:(UIViewController*)controller view:(UIView*)view;
-(void)destroy;
@end

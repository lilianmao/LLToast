//
//  LLToast.m
//  LLToast
//
//  Created by 李林 on 2016/12/8.
//  Copyright © 2016年 lee. All rights reserved.
//

#import "LLToast.h"
#import <objc/runtime.h>
#import <pop/POP.h>

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

static const NSString * const LLBackGroundImg = @"LLBackGroundImg";

@interface LLToast()

@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat topMargin;

@end

@implementation LLToast

#pragma mark - sharedInstance
+ (LLToast *)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - commonInit
- (void)commonInit
{
    self.fontSize = 15;
    self.textColor = [UIColor whiteColor];
    self.leftMargin = 25;
    self.topMargin = 11;
}

#pragma mark - 核心函数，将text放在view上
- (void)showText:(NSString *)text withBackgroundColor:(UIColor *)color toView:(UIView *)view
{
    if(view == nil){
        NSArray<UIWindow *> *windows = [UIApplication sharedApplication].windows;
        view = [windows lastObject];
        if([view isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")])
            view = windows[windows.count - 2];
    }
    
    CGSize textSize = [LLToast sizeWithText:text andFontSize:self.fontSize];
    
   
    CGRect frame = [LLToast textPositionWithTextSize:textSize andLeftMargin:self.leftMargin andTopMargin:self.topMargin];
    UIView *originImg = [[UIView alloc] initWithFrame:frame];
    if(self.bgImage){
        // 根据文字将图片压缩
        UIImage *bgImg = [LLToast compressOriginalImage:self.bgImage toSize:frame.size];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImg];
        
        [originImg addSubview:bgImageView];
        
    }
    originImg.backgroundColor = color;
    UIView *backgroundImg = [LLToast clipCornerWithView:originImg andRadius:self.backImgCornerRadius];
    [view addSubview:backgroundImg];
    
    UILabel *textLabel = [LLToast createLabelWithText:text andTextFont:self.fontSize andTextColor:self.textColor];
    [LLToast addLabel:textLabel toView:backgroundImg];
    
    /*
     动态绑定（绑定到一个window上）- 防止toast重复出现
     bind the backgroundImg to the window
     */
    UIView *previousImg = (UIView *)objc_getAssociatedObject(view, &LLBackGroundImg);
    if(previousImg != nil)   previousImg.hidden = YES;
    objc_setAssociatedObject(view, &LLBackGroundImg, backgroundImg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
    // pop animation
    CGFloat duration = 3.0f;
    CGFloat delay = 2.0f;
    CGFloat distance = 50;
    [LLToast showAnimationWithUIView:backgroundImg andDistance:distance andStartAlpha:0 andEndAlpha:1.0f andDuration:duration];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LLToast showAnimationWithUIView:backgroundImg andDistance:-distance andStartAlpha:1.0f andEndAlpha:0 andDuration:duration];
        // 隐藏，防止页面堆积太多的backgroundImg
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            backgroundImg.hidden = YES;
        });
    });
    
}

#pragma mark - 显示带背景的信息
+ (void)showText:(NSString *)text withBackgroundImg:(UIImage *)image
{
    LLToast *toast = [LLToast sharedInstance];
    [toast commonInit];
    toast.bgImage = image;
    toast.textColor = RGB(231, 0, 18);
    [toast showText:text withBackgroundColor:[UIColor whiteColor] toView:nil];
}

#pragma mark - 显示成功信息
+ (void)showSuccess:(NSString *)success
{
    LLToast *toast = [LLToast sharedInstance];
    [toast commonInit];
    toast.bgImage = NULL;
    [toast showText:success withBackgroundColor:RGB(77, 77, 77) toView:nil];
}

#pragma mark - 显示错误信息
+ (void)showError:(NSString *)error
{
    LLToast *toast = [LLToast sharedInstance];
    [toast commonInit];
    toast.bgImage = NULL;
    [toast showText:error withBackgroundColor:RGB(231, 0, 18) toView:nil];
}

#pragma mark - 根据文字确定区域
+ (CGSize)sizeWithText:(NSString *)text andFontSize:(CGFloat)fontSize
{
    CGSize titleSize = [text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize] constrainedToSize:CGSizeMake(screenWidth-40, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return titleSize;
}

#pragma mark - 文字显示位置
+ (CGRect)textPositionWithTextSize:(CGSize)textSize andLeftMargin:(CGFloat)leftMargin andTopMargin:(CGFloat)topMargin
{
    CGFloat width = textSize.width + leftMargin*2;
    CGFloat height = textSize.height + topMargin*2;
    CGFloat x = (screenWidth/2) - (width/2);
    CGFloat y = screenHeight * 0.06;
    return CGRectMake(x, y, width, height);
}

#pragma mark - 根据文字属性返回label
+ (UILabel *)createLabelWithText:(NSString *)text andTextFont:(CGFloat)fontSize andTextColor:(UIColor *)textColor
{
    UILabel *textLabel = [[UILabel alloc] init];
    
    textLabel.text = text;
    textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
    textLabel.textColor = textColor;
    [textLabel setNumberOfLines:0];
    [textLabel sizeToFit];
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    return textLabel;
}

#pragma mark - 将textLabel添加到UIView上
+ (void)addLabel:(UILabel *)textLabel toView:(UIView *)backgroundImg
{
    [backgroundImg addSubview:textLabel];
    CGFloat centerX = backgroundImg.frame.size.width/2;
    CGFloat centerY = backgroundImg.frame.size.height/2;
    [textLabel setCenter:CGPointMake(centerX, centerY)];
}

#pragma mark - 将图片压缩到指定尺寸
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

#pragma mark - 切圆角
+ (UIView *)clipCornerWithView:(UIView *)originView
                     andRadius:(CGFloat)radius
{
    if(radius == 0)
        radius = originView.frame.size.height / 2;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:originView.bounds
                                                   byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(radius, radius)];
    // 创建遮罩层
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = originView.bounds;
    maskLayer.path = maskPath.CGPath;   // 轨迹
    originView.layer.mask = maskLayer;
    
    return originView;
}

#pragma mark - POP动画
+ (void)showAnimationWithUIView:(UIView *)view
                    andDistance:(CGFloat)distance
                  andStartAlpha:(CGFloat)startAlpha
                    andEndAlpha:(CGFloat)endAlpha
                    andDuration:(CGFloat)duration
{
    // move Animation移动的动画
    POPDecayAnimation *moveAnim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveAnim.velocity = @(distance);
    moveAnim.beginTime = CACurrentMediaTime() + 0.1f;
    [view pop_addAnimation:moveAnim forKey:@"position"];
    
    //    POPBasicAnimation *moveAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    //    moveAnim.toValue = @(view.center.y+distance);
    //    moveAnim.beginTime = CACurrentMediaTime() + 1.0f;
    //    moveAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //    [view pop_addAnimation:moveAnim forKey:@"position"];
    
    // fade Animation淡入淡出的动画
    POPBasicAnimation *fadeAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    fadeAnim.fromValue = @(startAlpha);
    fadeAnim.toValue = @(endAlpha);
    fadeAnim.beginTime = CACurrentMediaTime();
    fadeAnim.duration = duration * 0.8;
    [view pop_addAnimation:fadeAnim forKey:@"fade"];
}

@end

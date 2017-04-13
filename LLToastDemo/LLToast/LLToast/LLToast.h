//
//  LLToast.h
//  LLToast
//
//  Created by 李林 on 2016/12/8.
//  Copyright © 2016年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLToast : UIView

/**
 The background image.Default is none
 背景图片，默认无
 */
@property (nonatomic, strong) UIImage *bgImage;

/**
 The background image cornerRadius.Defualt is (the height of background) / 2
 */
@property (nonatomic, assign) CGFloat backImgCornerRadius;

@property (nonatomic, assign) CGFloat fontSize;

@property (nonatomic, strong) UIColor *textColor;


- (void)commonInit;

/**
 根据背景颜色和需要显示的view显示文本（核心函数）
 show toast according to the background color and add the toast to the view.(core function)

 @param text 文本
 @param color 背景颜色
 @param view 需要显示在哪个view上
 */
- (void)showText:(NSString *)text withBackgroundColor:(UIColor *)color toView:(UIView *)view;

/**
 显示成功消息（默认偏黑色）
 show the success toast. Default is black color.
 
 @param success success message
 */
+ (void)showSuccess:(NSString *)success;

/**
 显示失败消息（默认偏红色）
 show the error toast. Default is red color.
 
 @param error error message
 */
+ (void)showError:(NSString *)error;

/**
 显示带背景图片的消息
 show the toast with backgroundImg.

 @param text 文本
 @param image 背景图片
 */
+ (void)showText:(NSString *)text withBackgroundImg:(UIImage *)image;

/**
 根据文字和字体大小返回size
 return the size of text according the text and fontSize. Default font is Helvetica-Bold.
 
 @param text 文字
 @param fontSize 文字字体大小
 @return 文字所占的size
 */
+ (CGSize)sizeWithText:(NSString *)text andFontSize:(CGFloat)fontSize;

/**
 根据文字的size返回文字显示位置（这里可以修改代码，选择你自己要显示的位置）
 return the position of text according the size of text
 
 @param textSize 文字所占尺寸
 @param leftMargin 左边距
 @param topMargin 右边距
 @return 文字的显示位置
 */
+ (CGRect)textPositionWithTextSize:(CGSize)textSize
                     andLeftMargin:(CGFloat)leftMargin
                      andTopMargin:(CGFloat)topMargin;

/**
 根据文字、字体大小 和 字体颜色返回label
 return label according the text、the size of text and the color of color
 
 @param text 文字
 @param textColor 文字颜色
 @return label
 */
+ (UILabel *)createLabelWithText:(NSString *)text
                     andTextFont:(CGFloat)fontSize
                    andTextColor:(UIColor *)textColor;

/**
 将label添加到背景的view上
 add the text label to the backgroundImage

 @param textLabel text
 @param backgroundImg 背景图片
 */
+ (void)addLabel:(UILabel *)textLabel
          toView:(UIView *)backgroundImg;

/**
 压缩图片到指定尺寸
 compress the image to specify size

 @param image 图片
 @param size 指定的size
 */
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size;

/**
 切圆角（如果你没有指定radius，那么默认是高度的一半）
 chip the cornerRadius for view(if you don't set the radius,Default is half of the height)
 
 @param originView 原始的view
 @param radius 圆角的度数
 @return 新的切过圆角的view
 */
+ (UIView *)clipCornerWithView:(UIView *)originView
                     andRadius:(CGFloat)radius;

/**
 POP动画
 pop animation
 */
+ (void)showAnimationWithUIView:(UIView *)view
                    andDistance:(CGFloat)distance
                  andStartAlpha:(CGFloat)startAlpha
                    andEndAlpha:(CGFloat)endAlpha
                    andDuration:(CGFloat)duration;

@end

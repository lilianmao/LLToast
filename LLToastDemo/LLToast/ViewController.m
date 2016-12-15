//
//  ViewController.m
//  LLToast
//
//  Created by 李林 on 2016/12/9.
//  Copyright © 2016年 lee. All rights reserved.
//

#import "ViewController.h"
#import "LLToast.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backgroundImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *successBtn;
@property (weak, nonatomic) IBOutlet UIButton *errorBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.backgroundImgBtn addTarget:self action:@selector(backgroundImgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.successBtn addTarget:self action:@selector(successBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.errorBtn addTarget:self action:@selector(errorBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - backgroundImgBtnClick
/**
 Click the backgroundImgBtn and it will show a toast with backgroundImage
 展示一个带背景图片的toast
 */
- (void)backgroundImgBtnClick
{
    LLToast *toast = [[LLToast alloc] init];
    UIImage *bgImg = [UIImage imageNamed:@"bgImg"];
    [toast showText:@"这是一条带背景的消息" withBackgroundImg:bgImg];
}

#pragma mark - successBtnClick
/**
 Click the successBtn and it will show a success toast
 展示一个成功的toast
 */
- (void)successBtnClick
{
    [[[LLToast alloc] init] showSuccess:@"这是一个成功的消息"];
}

#pragma mark - errorBtnClick
/**
 Click the errorBtn and it will show a error toast
 */
- (void)errorBtnClick
{
    [[[LLToast alloc] init] showError:@"这是一个错误的消息"];
}

@end

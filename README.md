# **LLToast**
This is a simple Toast.You can use the toast to show some friendly text.
LLToast is my first framework. Welcome to improve my framework.

## **Installation**
Pop is available on [CocoaPods](http://cocoapods.org/). Just add the following to your project Podfile:（Please use the github srouce）
```
pod 'LLToast', '~> 1.0.0’
```

## **Usage**
1. success msg
```objective-c
[[[LLToast alloc] init] showSuccess:@"这是一个成功的消息"];
```
2. error msg
```objective-c
[[[LLToast alloc] init] showError:@"这是一个错误的消息"];
```
3. simple toast which have a background image
```objective-c
LLToast *toast = [[LLToast alloc] init];
UIImage *bgImg = [UIImage imageNamed:@"bgImg"];
[toast showText:@"这是一条带背景的消息" withBackgroundImg:bgImg];
```

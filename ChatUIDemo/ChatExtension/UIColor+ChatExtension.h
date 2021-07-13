//
//  UIColor+ChatExtension.h
//  ChatExtension
//
//  Created by GXL on 2018/9/20.
//  Copyright © 2018年 GXL. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark 颜色
#define kChatRGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A];
#pragma mark 随机颜色
#define kChatRandomColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ChatExtension)

#pragma mark 16进制颜色
+ (UIColor *)colorWithHexString:(NSString *)hexString;

#pragma mark 获取颜色RGB
+ (NSArray *)getRGBWithColor:(UIColor *)color;

#pragma mark 获取两种颜色的过渡色
+ (UIColor *)getTransitionColorWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor scale:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END

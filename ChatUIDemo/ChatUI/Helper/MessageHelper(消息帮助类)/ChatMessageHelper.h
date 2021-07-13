//
//  ChatMessageHelper.h
//  ChatUIDemo
//
//  Created by GXL on 2018/6/5.
//  Copyright © 2018年 GXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ChatMessage;

/**
 聊天帮助类
 */
@interface ChatMessageHelper : NSObject

//获取零时区时间(yyyy-MM-dd-HH-mm-ss-SSS)
+ (NSString *)getTimeWithZone;
//获取当前时区时间(yyyy-MM-dd-HH-mm-ss-SSS)
+ (NSString *)getTimeWithCurrentZone;

//获取零时区转当前时区的时间(yyyy-MM-dd HH:mm)
+ (NSString *)getCurrentTimeWithZone:(NSString *)zone;

//获取当前时区的时间(yyyy-MM-dd HH:mm)
+ (NSString *)getCurrentTimeWithCurrentZone:(NSString *)currentZone;

//添加公共参数
+ (ChatMessage *)addPublicParameters;
+ (ChatMessage *)addPublicParametersWithMessage:(ChatMessage *)message;

//是否显示时间
+ (BOOL)isShowTimeWithTime:(NSString *)time setTime:(NSString *)setTime;

//获取聊天时间
+ (NSString *)getChatTimeWithTime:(NSString *)time;

//获取Size
+ (CGSize)getSizeWithMaxSize:(CGSize)maxSize size:(CGSize)size;

//获取文本高度
- (CGFloat)getHeightWithTextView:(UITextView *)textView maxH:(CGFloat)maxH minH:(CGFloat)minH;

//获取视频第一帧图片
+ (UIImage *)getVideoImage:(NSString *)path;

//image 转 data
+ (NSData *)getDataWithImage:(UIImage *)image num:(CGFloat)num;

@end

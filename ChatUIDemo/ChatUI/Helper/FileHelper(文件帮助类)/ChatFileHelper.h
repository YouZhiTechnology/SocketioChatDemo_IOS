//
//  ChatFileHelper.h
//  SHChatUI
//
//  Created by GXL on 2018/6/5.
//  Copyright © 2018年 GXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ChatMessageType.h"

/**
 文件帮助类
 */
@interface ChatFileHelper : NSObject

#pragma mark 获取文件路径（没有的话创建）
+ (NSString *)getCreateFilePath:(NSString *)path;

#pragma mark 获取录音设置
+ (NSDictionary *)getAudioRecorderSettingDict;

#pragma mark 获取资源路径并且保存资源
+ (NSString *)saveFileWithContent:(id)content type:(ChatMessageFileType)type;

#pragma mark 获取资源路径
+ (NSString *)getFilePathWithName:(NSString *)name type:(ChatMessageFileType)type;

#pragma mark 获取文件名
+ (NSString *)getFileNameWithPath:(NSString *)path;

#pragma mark 获取图片
+ (UIImage *)imageNamed:(NSString *)name;

#pragma mark 获取文件大小
+ (NSString *)getFileSize:(NSString *)path;

@end

//
//  ChatAudioRecordHelper.h
//  SHChatMessageUI
//
//  Created by GXL on 16/7/27.
//  Copyright © 2016年 GXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChatAudioRecordHelperDelegate <NSObject>

/// 结束录音
/// @param path 路径
/// @param duration 时长
- (void)audioFinishWithPath:(NSString *)path duration:(NSInteger)duration;

@end

@interface ChatAudioRecordHelper : NSObject

//代理
@property (nonatomic, weak) id<ChatAudioRecordHelperDelegate> delegate;

//开始录音
- (void)startRecord;

//停止录音
- (void)stopRecord;

//取消录音
- (void)cancelRecord;

//声音检测
- (int)peekRecorderVoiceMetersWithMax:(int)max;

@end

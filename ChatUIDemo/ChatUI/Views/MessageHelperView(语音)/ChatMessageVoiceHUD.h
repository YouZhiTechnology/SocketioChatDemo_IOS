//
//  ChatMessageVoiceHUD.h
//  ChatUIDemo
//
//  Created by GXL on 16/8/4.
//  Copyright © 2016年 GXL. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  语音录制界面
 */
typedef enum : NSUInteger {
    ChatVoiceHudType_remove = 0,//移除
    ChatVoiceHudType_recording,//录音中
    ChatVoiceHudType_cancel,//将要取消
    ChatVoiceHudType_warning,//警告，时间太短
    ChatVoiceHudType_countdown//倒计时
} ChatVoiceHudType;
@interface ChatMessageVoiceHUD : UIView

//(0:移除 1:文字 2:取消发送 3:警告 4:倒计时)
@property (nonatomic, assign) ChatVoiceHudType hudType;

//实例化
+ (instancetype)shareInstance;

//显示声音声波
- (void)showVoiceMeters:(int)meter;

//显示倒计时
- (void)showCountDownWithTime:(NSInteger)time;

@end

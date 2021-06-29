//
//  ChatMessageHeader.h
//  ChatChatUI
//
//  Created by CChat on 2018/6/5.
//  Copyright © 2018年 CChat. All rights reserved.
//

#ifndef ChatMessageHeader_h
#define ChatMessageHeader_h


#endif /* ChatMessageHeader_h */


//Caches目录
#define CachesPatch NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

#pragma mark - 聊天资源路径
//语音WAV路径
#define kPath_audio_wav [ChatFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Audio/WAV",CachesPatch]]
//语音AMR路径
#define kPath_audio_amr [ChatFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Audio/AMR",CachesPatch]]
//图片路径
#define kPath_image [ChatFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Image",CachesPatch]]
//Gif路径
#define kPath_gif [ChatFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Gif",CachesPatch]]
//视频路径
#define kPath_video [ChatFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/Video",CachesPatch]]
//视频第一帧图片路径
#define kPath_video_image [ChatFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/VideoImage",CachesPatch]]
//文件路径
#define kPath_file [ChatFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/Chat/File",CachesPatch]]

#pragma mark - 颜色定义
//三原色
#define kRGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
//输入框及菜单背景颜色
#define kInPutViewColor kRGB(243, 243, 247, 1)
//按钮背景颜色
#define kShareMenuViewItemColor kRGB(255, 255, 255, 1)

#pragma mark - 宏定义

//输入框高度
#define kInPutHeight 49
//输入框控件间隔
#define kInPutSpace 7
//输入框控件宽高
#define kInPutIcon_size CGSizeMake(35,35)
//输入框最多几行
#define kInPutNum 5

//菜单一行几个
#define kShareMenuPerRowItemCount 4
//菜单几行
#define kShareMenuPerColum 2
//下方菜单选项宽高
#define kShareMenuItemWH 60
//下方菜单选项整体的高度(KXHShareMenuItemHeight - kXHShareMenuItemWH 为标题的高)
#define KShareMenuItemHeight 80
//下方菜单控件上下间隔
#define KShareMenuItemTop 15
//页码高度
#define kShareMenuPageControlHeight 30

//设备Size
#define kWidth ([[UIScreen mainScreen] bounds].size.width)
#define kHeight ([[UIScreen mainScreen] bounds].size.height)

//下方输入控件高度
#define kChatMessageInput_H 205

//录音最大时长与最小
#define kMaxRecordTime 60
#define kMinRecordTime 1

#define kIsFull (kTopSafe > 20)

#define kBottomSafe (kIsFull?39:0)
#define kTopSafe ([[UIApplication sharedApplication] statusBarFrame].size.height)

/**宏定义  __weak typeof(self)*/
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define kWeak(VAR) \
try {} @finally {} \
__weak __typeof__(VAR) VAR##_myWeak_ = (VAR)

#define kSHStrong(VAR) \
try {} @finally {} \
__strong __typeof__(VAR) VAR = VAR##_myWeak_;\
if(VAR == nil) return

#pragma mark - 文件

//聊天界面帮助类
#import "ChatMessageHelper.h"
//语音提示框
#import "ChatMessageVoiceHUD.h"
//多媒体
#import <AVFoundation/AVFoundation.h>
//文件
#import "ChatFileHelper.h"
//音频操作
#import "VoiceConverter.h"
//音频播放
#import "ChatAudioPlayerHelper.h"
//音频录制
#import "ChatAudioRecordHelper.h"
//消息模型
#import "ChatMessage.h"
//类型
#import "ChatMessageType.h"
#import "ChatMessageFrame.h"
#import <UIKit/UIKit.h>

//表情键盘
#import "ChatEmotionKeyboard.h"
#import "ChatEmotionTool.h"
//菜单
#import "ChatShareMenuView.h"
//聊天cell
#import "ChatMessageTableViewCell.h"
//长按菜单
#import "ChatMenuController.h"

#import "ChatActivityIndicatorView.h"
#import "ChatTextView.h"
#import "MessageTextView.h"
#import <WebKit/WebKit.h>

#import "UIView+ChatExtension.h"
#import "UIImage+ChatExtension.h"
#import "ChatTool.h"

#import "AudioWrapper.h"

#import <TZImagePickerController.h>

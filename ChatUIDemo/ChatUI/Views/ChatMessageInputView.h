//
//  ChatMessageInputView.h
//  ChatUIDemo
//
//  Created by GXL on 2018/6/5.
//  Copyright © 2018年 GXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageHeader.h"

/**
 聊天输入框
 */

@protocol ChatMessageInputViewDelegate <NSObject>

@optional

// text
- (void)chatMessageWithSendText:(NSString *)text;

// image
//- (void)chatMessageWithSendImage:(NSString *)imageName size:(CGSize)size;

- (void)chatMessageWithSendImage:(UIImage *)image imageName:(NSString *)name size:(CGSize)size;

// video
- (void)chatMessageWithSendVideo:(NSString *)videoName fileSize:(NSString *)fileSize duration:(NSString *)duration size:(CGSize)size;

// audio
- (void)chatMessageWithSendAudio:(NSString *)audioName duration:(NSInteger)duration;

// location
- (void)chatMessageWithSendLocation:(NSString *)locationName lon:(CGFloat)lon lat:(CGFloat)lat;

// card
- (void)chatMessageWithSendCard:(NSString *)card;

// note
- (void)chatMessageWithSendNote:(NSString *)note;

// red
- (void)chatMessageWithSendRedPackage:(NSString *)redPackage;

// gif
- (void)chatMessageWithSendGif:(NSString *)gifName size:(CGSize)size;

// file
- (void)chatMessageWithSendFile:(NSString *)fileName displayName:(NSString *)displayName fileSize:(NSString *)fileSize;

//工具栏高度改变
- (void)toolbarHeightChange;

//下方菜单点击
- (void)didSelecteMenuItem:(ChatShareMenuItem *)menuItem index:(NSInteger)index;

@end

@interface ChatMessageInputView : UIView

//父视图
@property (nonatomic, strong) UIViewController *supVC;
//代理
@property (nonatomic, weak) id<ChatMessageInputViewDelegate> delegate;
//当前输入框类型
@property (nonatomic, assign) ChatInputViewType inputType;
//多媒体数据
@property (nonatomic, strong) NSArray *shareMenuItems;
//其他输入控件
//表情控件
@property (nonatomic, strong) ChatEmotionKeyboard *emojiView;

//刷新视图
- (void)reloadView;

#pragma mark - 菜单内容
//打开照片
- (void)openPhoto;
//打开相机
- (void)openCarema;
//打开定位
- (void)openLocation;
//打开名片
- (void)openCard;
//打开红包
- (void)openRedPaper;
//打开文件
- (void)openFile;

//清除内部通知
-(void)clear;

@end

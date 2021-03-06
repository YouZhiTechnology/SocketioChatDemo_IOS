//
//  ChatMessageVoiceHUD.m
//  ChatUIDemo
//
//  Created by GXL on 16/8/4.
//  Copyright © 2016年 GXL. All rights reserved.
//

#import "ChatMessageVoiceHUD.h"
#import "ChatMessageHeader.h"

@interface ChatMessageVoiceHUD ()

//录音界面图片
@property (nonatomic, strong) UIImageView *messageVoiceImage;

//录音界面文字
@property (nonatomic, strong) UILabel *messageVoiceLabel;
//录音界面背景
@property (nonatomic, strong) UIView *messageBgView;
//整体背景
@property (nonatomic, strong) UIWindow *overlayWindow;

//定时器
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ChatMessageVoiceHUD

#pragma mark - 实例化
+ (id)shareInstance
{
    static ChatMessageVoiceHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ChatMessageVoiceHUD alloc] init];
        //跟视图
        instance.overlayWindow = [UIApplication sharedApplication].keyWindow;
    });
    return instance;
}

#pragma mark - 懒加载
- (UIView *)messageBgView
{
    if (!_messageBgView)
    {
        //背景
        _messageBgView = [[UIView alloc] initWithFrame:CGRectMake((kWidth - 150) / 2, (kHeight - 170) / 2, 150, 160)];
        
        _messageBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _messageBgView.layer.cornerRadius = 5;
        _messageBgView.layer.masksToBounds = YES;
        
        [self addSubview:_messageBgView];
    }
    
    return _messageBgView;
}

- (UIImageView *)messageVoiceImage
{
    if (!_messageVoiceImage)
    {
        //图片
        self.messageVoiceImage = [[UIImageView alloc] initWithFrame:CGRectMake(35, 15, 80, 90)];
        self.messageVoiceImage.image = [ChatFileHelper imageNamed:@"voice_play_animation_0"];
        
        [self.messageBgView addSubview:self.messageVoiceImage];
    }
    
    return _messageVoiceImage;
}

- (UILabel *)messageVoiceLabel
{
    if (!_messageVoiceLabel)
    {
        //文字
        _messageVoiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.messageBgView.frame.size.height - 35, self.messageBgView.frame.size.width - 10, 30)];
        _messageVoiceLabel.textAlignment = NSTextAlignmentCenter;
        _messageVoiceLabel.numberOfLines = 0;
        _messageVoiceLabel.font = [UIFont systemFontOfSize:13];
        _messageVoiceLabel.textColor = [UIColor whiteColor];
        
        _messageVoiceLabel.layer.cornerRadius = 5;
        _messageVoiceLabel.layer.borderWidth = 1;
        _messageVoiceLabel.layer.borderColor = [UIColor clearColor].CGColor;
        _messageVoiceLabel.layer.masksToBounds = YES;
        
        [self.messageBgView addSubview:_messageVoiceLabel];
    }
    
    return _messageVoiceLabel;
}

#pragma mark - 设置状态
- (void)setHudType:(ChatVoiceHudType)hudType
{
    if (_hudType == hudType)
    {
        return;
    }
    _hudType = hudType;
    
//    self.messageVoiceLabel.backgroundColor = [UIColor clearColor];
    
    if (![self.overlayWindow.subviews containsObject:self])
    {
        [self.overlayWindow addSubview:self];
    }

    switch (hudType)
    {
        case ChatVoiceHudType_remove:
        {
            if (self.timer) {
                [self.timer invalidate];
            }
            self.timer = nil;
            [self removeFromSuperview];
        }
            break;
        case ChatVoiceHudType_recording:
        {
            if (self.timer) {
                return;
            }
            self.messageVoiceLabel.text = @"手指上滑，取消发送";
        }
            break;
        case ChatVoiceHudType_cancel:
        {
//            self.messageVoiceLabel.backgroundColor = kRGB(155, 57, 57, 1);
            
            self.messageVoiceLabel.text = @"松开手指，取消发送";
            self.messageVoiceImage.image = [ChatFileHelper imageNamed:@"voice_change"];
        }
            break;
        case ChatVoiceHudType_warning:
        {
            self.messageVoiceLabel.text = @"时间太短";
            self.messageVoiceImage.image = [ChatFileHelper imageNamed:@"voice_failure"];
        }
            break;
        case ChatVoiceHudType_countdown:
        {
            if (self.timer) {
                return;
            }
            __block NSInteger index = 10;
            self.messageVoiceLabel.text = [NSString stringWithFormat:@"%ld“ 后将停止录音",(long)index];
            self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                index -= 1;
                if (hudType == ChatVoiceHudType_recording || hudType == ChatVoiceHudType_countdown) {
                    self.messageVoiceLabel.text = [NSString stringWithFormat:@"%ld“ 后将停止录音",(long)index];
                }
            }];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 显示声音声波
- (void)showVoiceMeters:(int)meter
{
    if (self.hudType == ChatVoiceHudType_recording)
    {
        NSString *imageName = [NSString stringWithFormat:@"voice_play_animation_%d", meter];
        self.messageVoiceImage.image = [ChatFileHelper imageNamed:imageName];
    }
}

- (void)showCountDownWithTime:(NSInteger)time
{
}

@end

//
//  ChatAudioTableViewCell.m
//  ChatUIDemo
//
//  Created by GXL on 2021/5/20.
//  Copyright © 2018 GXL. All rights reserved.
//

#import "ChatAudioTableViewCell.h"

@interface ChatAudioTableViewCell ()

// audio
@property (nonatomic, retain) UIImageView *voiceView;
// audio 时长
@property (nonatomic, retain) UILabel *voiceNum;
// 未读标记
@property (nonatomic, retain) UIImageView *readMarker;

@end

@implementation ChatAudioTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setMessageFrame:(ChatMessageFrame *)messageFrame
{
    [super setMessageFrame:messageFrame];
    
    ChatMessage *message = messageFrame.message;
    
    //设置内容
    self.readMarker.hidden = YES;
    
    NSInteger set_space = 5;
    
    if (message.bubbleMessageType == ChatBubbleMessageType_Receiving)
    {
        self.readMarker.hidden = message.messageRead;
        //未读标记
        self.readMarker.x = self.btnContent.width + set_space;
    }
    
    self.voiceNum.hidden = (message.messageState != ChatSendMessageType_Successed);
    self.voiceNum.text = [NSString stringWithFormat:@"%@\"", message.audioDuration];
    
    if (!message.fileName.length)
    {
        message.fileName = [ChatFileHelper getFileNameWithPath:message.fileUrl];
    }
    
    //设置frame
    self.voiceView.centerY = self.btnContent.height / 2;
    self.voiceNum.centerY = self.btnContent.height / 2;
    
    //语音图片
    self.voiceView.x = kChat_angle_w + kChat_margin + 5;
    
    //动画
    self.voiceView.image = [ChatFileHelper imageNamed:@"chat_receive_voice4"];
    self.voiceView.animationImages = @[
        [ChatFileHelper imageNamed:@"chat_receive_voice1"],
        [ChatFileHelper imageNamed:@"chat_receive_voice2"],
        [ChatFileHelper imageNamed:@"chat_receive_voice3"],
        [ChatFileHelper imageNamed:@"chat_receive_voice4"]
    ];
    //时长
    self.voiceNum.x = self.btnContent.width + set_space;
    self.voiceNum.textAlignment = NSTextAlignmentLeft;
    
    if (message.bubbleMessageType == ChatBubbleMessageType_Send)
    {
        //语音图片
        self.voiceView.x = self.btnContent.width - kChat_angle_w - kChat_margin - self.voiceView.width - 5;
        //动画
        self.voiceView.animationImages = @[
            [ChatFileHelper imageNamed:@"chat_send_voice1"],
            [ChatFileHelper imageNamed:@"chat_send_voice2"],
            [ChatFileHelper imageNamed:@"chat_send_voice3"],
            [ChatFileHelper imageNamed:@"chat_send_voice4"]
        ];
        //时长
        self.voiceNum.x = -(25 + set_space);
        self.voiceNum.textAlignment = NSTextAlignmentRight;
    }
    
    self.voiceView.image = self.voiceView.animationImages.lastObject;
}

#pragma mark - 语音动画
#pragma mark 语音播放开始动画
- (void)playVoiceAnimation
{
    self.readMarker.hidden = YES;
    [self.voiceView stopAnimating];
    [self.voiceView startAnimating];
    self.isPlaying = YES;
}

#pragma mark 语音播放停止动画
- (void)stopVoiceAnimation
{
    [self.voiceView stopAnimating];
    self.isPlaying = NO;
}

#pragma mark 语音消息视图
- (UIImageView *)voiceView
{
    //语音声波
    if (!_voiceView)
    {
        _voiceView = [[UIImageView alloc] init];
        _voiceView.size = CGSizeMake(15, 15);
        [self.btnContent addSubview:_voiceView];
        //动画
        _voiceView.animationDuration = 1;
        _voiceView.animationRepeatCount = 0;
    }
    return _voiceView;
}

- (UILabel *)voiceNum
{
    //语音时长
    if (!_voiceNum)
    {
        _voiceNum = [[UILabel alloc] init];
        _voiceNum.size = CGSizeMake(25, 20);
        _voiceNum.textColor = [UIColor lightGrayColor];
        _voiceNum.font = [UIFont systemFontOfSize:14];
        [self.btnContent addSubview:_voiceNum];
    }
    return _voiceNum;
}

- (UIImageView *)readMarker
{
    //未读标记
    if (!_readMarker)
    {
        _readMarker = [[UIImageView alloc] init];
        _readMarker.frame = CGRectMake(0, 1, 9, 9);
        _readMarker.image = [ChatFileHelper imageNamed:@"unread.png"];
        [self.btnContent addSubview:_readMarker];
    }
    return _readMarker;
}

@end

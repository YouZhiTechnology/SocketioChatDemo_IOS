//
//  ChatMessageFrame.m
//  SHChatUI
//
//  Created by GXL on 2018/6/5.
//  Copyright © 2018年 GXL. All rights reserved.
//

#import "ChatMessageFrame.h"

@implementation ChatMessageFrame

#pragma mark - 修改一些数据源与界面frame的计算
- (void)setMessage:(ChatMessage *)message{
    _message = message;
    
    //数据源的一些修改（计算时间、头像、id、聊天气泡大小）
    //这些消息状态只有成功
    switch (message.messageType) {
        case ChatMessageBodyType_redPaper:
        case ChatMessageBodyType_note:
        {//红包、通知
            message.messageState = SHSendMessageType_Successed;
        }
            break;
        default:
            break;
    }
    
    // 判断收发
    BOOL  isSend = (message.bubbleMessageType == SHBubbleMessageType_Send);
    // 判断特殊消息
    BOOL isSpecial = (message.messageType == ChatMessageBodyType_note);
    // 角
    BOOL isAngle = NO;

    
    CGFloat viewY = kChat_margin;
    
    // 计算时间
    if (_showTime){
        
        CGSize timeSize = [ChatTool getSizeWithStr:[ChatMessageHelper getChatTimeWithTime:message.sendTime] font:kChatFont_time maxSize:CGSizeMake(CGFLOAT_MAX, kChat_content_maxW)];

        CGFloat timeX = (kWidth - timeSize.width - 2*kChat_margin_time) / 2;
        _timeF = CGRectMake(timeX, viewY, timeSize.width + 2*kChat_margin_time, timeSize.height + 2*kChat_margin_time);
        
        viewY = CGRectGetMaxY(_timeF) + kChat_margin;
    }

    if (!isSpecial) {//特殊消息没有头像、用户名
        // 计算头像
        CGFloat iconX = kChat_margin;
        if (isSend) {//发送方
            iconX = kWidth - kChat_margin - kChat_icon;
        }
        _iconF = CGRectMake(iconX, viewY, kChat_icon, kChat_icon);
        
        // 计算用户名
        if (_showName){
            CGFloat nameX = kChat_margin + kChat_icon  + kChat_margin + kChat_angle_w;
            _nameF = CGRectMake(nameX, viewY , kWidth - 2*nameX, kChat_name_h);
            viewY = CGRectGetMaxY(_nameF) + kChat_margin_name;
        }
    }
    
    // 计算整体聊天气泡的Size
    CGSize contentSize = CGSizeZero;
    // 判断消息类型
    switch (_message.messageType) {
        case ChatMessageBodyType_text://文字
        {
            NSAttributedString *att = [ChatEmotionTool getAttWithStr:message.text font:kChatFont_content];
            
            contentSize = [att boundingRectWithSize:CGSizeMake((kChat_content_maxW - 2*kChat_angle_w), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            
            //其他微调
            if (kChatFont_content.lineHeight < kChat_min_h) {//为了使聊天内容与最小高度对齐
                contentSize.height += (kChat_min_h - kChatFont_content.lineHeight);
            }else{
                contentSize.height += 2*kChat_margin;
            }
            contentSize.width += (2*kChat_margin + kChat_angle_w);
        }
            break;
        case ChatMessageBodyType_image://图片
        {
            isAngle = YES;
            contentSize = [ChatMessageHelper getSizeWithMaxSize:kChat_pic_size size:CGSizeMake(message.imageWidth, message.imageHeight)];
        }
            break;
        case ChatMessageBodyType_voice://语音
        {
            contentSize = CGSizeMake(((kChat_voice_size.width - 60)/kMaxRecordTime)*[message.audioDuration intValue] + 60, kChat_voice_size.height);
            if (contentSize.width > kChat_voice_size.width) {//限制最大宽
                contentSize.width = kChat_voice_size.width;
            }
            contentSize.width += kChat_angle_w;
        }
            break;
        case ChatMessageBodyType_location://位置
        {
            contentSize = kChat_location_size;
        }
            break;
        case ChatMessageBodyType_note://通知
        {
            contentSize = [message.note boundingRectWithSize:CGSizeMake(kChat_content_maxW - 2*kChat_margin, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kChatFont_note} context:nil].size;
            //要预留出来边距
            contentSize.height += 2*kChat_margin;
            contentSize.width += 2*kChat_margin;
        }
            break;
        case ChatMessageBodyType_card://名片
        {
            contentSize = kChat_card_size;
            contentSize.width +=  kChat_angle_w;
        }
            break;
        case ChatMessageBodyType_redPaper://红包
        {
            contentSize = kChat_red_size;
            contentSize.width +=  kChat_angle_w;
        }
            break;
        case ChatMessageBodyType_gif://Gif
        {
            contentSize = [ChatMessageHelper getSizeWithMaxSize:kChat_gif_size size:CGSizeMake(self.message.gifWidth, self.message.gifHeight)];
        }
            break;
        case ChatMessageBodyType_video://视频
        {
            isAngle = YES;
            contentSize = [ChatMessageHelper getSizeWithMaxSize:kChat_video_size size:CGSizeMake(message.videoWidth, message.videoHeight)];
        }
            break;
        case ChatMessageBodyType_file://文件
        {
            contentSize = kChat_file_size;
        }
            break;
        default:
            break;
    }

    // 计算X轴
    CGFloat viewX = 0;
    
    if (isSpecial) {//特殊消息 居中显示
        
        viewX = (kWidth - contentSize.width)/2;
        
    }else{//其他消息 根据发送方X轴不一样
        
        viewX = CGRectGetMaxX(_iconF) + kChat_margin;
        if (isSend) {
            viewX = CGRectGetMidX(_iconF) - kChat_margin - contentSize.width - 2*kChat_margin;
        }
    }
    
    if (isAngle) {
        //没有角的
        if (message.bubbleMessageType == SHBubbleMessageType_Send) {
            viewX -= kChat_angle_w;
        }else{
            viewX += kChat_angle_w;
        }
    }

    //聊天气泡frame
    _contentF = CGRectMake(viewX, viewY, contentSize.width, contentSize.height);
    //cell高度
    _cell_h = CGRectGetMaxY(_contentF)  + kChat_margin;
}

@end

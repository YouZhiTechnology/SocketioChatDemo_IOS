//
//  ChatMessageTableViewCell.m
//  ChatUIDemo
//
//  Created by GXL on 2018/6/7.
//  Copyright © 2018年 GXL. All rights reserved.
//

#import "ChatMessageTableViewCell.h"
#import <Foundation/Foundation.h>
#import "ChatMessageFrame.h"

@interface ChatMessageTableViewCell ()

@end

@implementation ChatMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 懒加载
#pragma mark 创建时间
- (UILabel *)labelTime{
    if (!_labelTime) {
        _labelTime = [[UILabel alloc] init];
        _labelTime.textAlignment = NSTextAlignmentCenter;
        _labelTime.textColor = [UIColor whiteColor];
        _labelTime.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _labelTime.layer.masksToBounds = YES;
        _labelTime.layer.cornerRadius = 5;
        _labelTime.font = kChatFont_time;
        [self.contentView addSubview:_labelTime];
    }
    return _labelTime;
}

#pragma mark 创建ID
- (UILabel *)labelNum{
    if (!_labelNum) {
        _labelNum = [[UILabel alloc] init];
        _labelNum.textColor = [UIColor grayColor];
        _labelNum.textAlignment = NSTextAlignmentCenter;
        _labelNum.font = kChatFont_name;
        [self.contentView addSubview:_labelNum];
    }
    return _labelNum;
}

#pragma mark 创建头像
- (UIButton *)btnHeadImage{
    if (!_btnHeadImage) {
        _btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnHeadImage.layer.cornerRadius = 5;
        _btnHeadImage.layer.masksToBounds = YES;
        //点击头像
        [_btnHeadImage addTarget:self action:@selector(didSelectHeadImage)  forControlEvents:UIControlEventTouchUpInside];
        //长按头像
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongHeadImage:)];
        
        [_btnHeadImage addGestureRecognizer:longTap];
        [self.contentView addSubview:_btnHeadImage];
    }
    return _btnHeadImage;
}

#pragma mark 创建内容
- (UIButton *)btnContent{
    if (!_btnContent) {
        _btnContent = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnContent addTarget:self action:@selector(didSelectMessage) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnContent];
    }
    return _btnContent;
}

#pragma mark 消息发送状态视图
- (ChatActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[ChatActivityIndicatorView alloc]init];
        [_activityView addTarget:self action:@selector(repeatClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_activityView];
    }
    return _activityView;
}

#pragma mark - 内容及Frame设置
- (void)setMessageFrame:(ChatMessageFrame *)messageFrame {
    
    _messageFrame = messageFrame;
    ChatMessage *message = messageFrame.message;
    
    // 初始化 (如果不显示时间、头像、ID，在frame中就没有计算)
    //发送状态
    self.activityView.hidden = YES;
    
    BOOL isSend = (message.bubbleMessageType == ChatBubbleMessageType_Send);
    
    // 设置时间
    self.labelTime.frame = messageFrame.timeF;
    self.labelTime.text = [ChatMessageHelper getChatTimeWithTime:message.sendTime];
    
    // 设置头像
    self.btnHeadImage.frame = messageFrame.iconF;
    [self.btnHeadImage setBackgroundImage:[UIImage imageNamed:message.avator] forState:0];
    
    // 设置昵称
    self.labelNum.frame = messageFrame.nameF;
    self.labelNum.text = message.userName;
    if (isSend) {
        self.labelNum.textAlignment = NSTextAlignmentRight;
    }else{
        self.labelNum.textAlignment = NSTextAlignmentLeft;
    }
    
    // 设置内容
    self.btnContent.frame = messageFrame.contentF;
    UIImage *image = nil;
    // 设置聊天气泡背景
    if (isSend) {
        image = [ChatFileHelper imageNamed:@"chat_message_send"];
    }else{
        image = [ChatFileHelper imageNamed:@"chat_message_receive"];
    }
    
    [self setBubbleImage:image];
    
    // 设置发送状态样式
    self.activityView.messageState = message.messageState;
    
    // 发送状态
    if (isSend && message.messageState != ChatSendMessageType_Successed) {
        self.activityView.frame = CGRectMake(self.btnContent.x - (5 + 20), self.btnContent.y + (self.btnContent.height - 20)/2, 20, 20);
    }
    
    // 12、添加长按内容
    if (message.messageType != ChatMessageBodyType_note && message.messageType != ChatMessageBodyType_redPaper) {
        //长按内容
        UILongPressGestureRecognizer *longContent = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongMessage:)];
        longContent.minimumPressDuration = 0.4;
        [self.btnContent addGestureRecognizer:longContent];
    }
}

//设置气泡背景
- (void)setBubbleImage:(UIImage *)image{
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(35, 25, 10, 25)];
    [self.btnContent setBackgroundImage:image forState:UIControlStateNormal];
    [self.btnContent setBackgroundImage:image forState:UIControlStateHighlighted];
}

#pragma mark - 点击事件
#pragma mark 点击头像
- (void)didSelectHeadImage{
    if ([self.delegate respondsToSelector:@selector(didSelectWithCell:type:message:)])  {
        [self.delegate didSelectWithCell:self type:ChatMessageClickType_click_head message:self.messageFrame.message];
    }
}

#pragma mark 长按头像
- (void)didLongHeadImage:(UILongPressGestureRecognizer *)tap {
    
    if (tap.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(didSelectWithCell:type:message:)])  {
            [self.delegate didSelectWithCell:self type:ChatMessageClickType_long_head message:self.messageFrame.message];
        }
    }
}

#pragma mark 点击消息体
- (void)didSelectMessage{
    if ([self.delegate respondsToSelector:@selector(didSelectWithCell:type:message:)])  {
        [self.delegate didSelectWithCell:self type:ChatMessageClickType_click_message message:self.messageFrame.message];
    }
}

#pragma mark 长按消息体
- (void)didLongMessage:(UILongPressGestureRecognizer *)tap{

    if (tap.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(didSelectWithCell:type:message:)])  {
            
            self.tapPoint = [tap locationInView:self];
            [self.delegate didSelectWithCell:self type:ChatMessageClickType_long_message message:self.messageFrame.message];
        }
    }
}

#pragma mark 点击重发
- (void)repeatClick{
    
    if (self.messageFrame.message.messageState == ChatSendMessageType_Failed) {
        if ([self.delegate respondsToSelector:@selector(didSelectWithCell:type:message:)])  {
            [self.delegate didSelectWithCell:self type:ChatMessageClickType_click_retry message:self.messageFrame.message];
        }
    }
}

#pragma mark 添加第一响应
//- (BOOL)canBecomeFirstResponder {
//    return YES;
//}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

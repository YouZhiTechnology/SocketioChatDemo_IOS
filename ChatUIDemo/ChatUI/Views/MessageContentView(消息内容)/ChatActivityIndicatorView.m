//
//  ChatActivityIndicatorView.m
//  iOSAPP
//
//  Created by GXL on 16/8/16.
//  Copyright © 2016年 GXL. All rights reserved.
//

#import "ChatActivityIndicatorView.h"
#import "ChatFileHelper.h"

@interface ChatActivityIndicatorView ()

//失败按钮
@property (nonatomic, strong) UIButton *failBtn;
//菊花图标
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation ChatActivityIndicatorView

- (UIButton *)failBtn{
    if (!_failBtn) {
        //失败图标
        _failBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _failBtn.userInteractionEnabled = NO;
        [_failBtn setBackgroundImage:[ChatFileHelper imageNamed:@"message_fail"] forState:0];
        [self addSubview:_failBtn];
    }
    return _failBtn;
    
}

- (UIActivityIndicatorView *)activity{
    if (!_activity) {
        //菊花图标
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:_activity];
    }
    return _activity;
}


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];

    self.failBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.activity.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

#pragma mark - 显示操作
- (void)setMessageState:(ChatSendMessageStatus)messageState{
    
    _messageState = messageState;
    
    self.failBtn.hidden = YES;
    self.activity.hidden = YES;
    [self.activity stopAnimating];
    
    switch (messageState) {
        case ChatSendMessageType_Sending://发送中
        {
            self.hidden = NO;
            self.activity.hidden = NO;
            [self.activity startAnimating];
        }
            break;
        case ChatSendMessageType_Failed://失败
        {
            self.hidden = NO;
            self.failBtn.hidden = NO;
        }
            break;
        case ChatSendMessageType_Successed://成功
        {
            self.hidden = YES;
        }
            break;
        default:
            break;
    }
}

@end

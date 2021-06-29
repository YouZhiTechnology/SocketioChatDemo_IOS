//
//  ChatTextTableViewCell.m
//  SHChatUI
//
//  Created by GXL on 2021/5/20.
//  Copyright © 2018 GXL. All rights reserved.
//

#import "ChatTextTableViewCell.h"

@interface ChatTextTableViewCell ()

// text
@property (nonatomic, retain) MessageTextView *textView;

@end

@implementation ChatTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageFrame:(ChatMessageFrame *)messageFrame{
    [super setMessageFrame:messageFrame];
    
    ChatMessage *message = messageFrame.message;
    
    NSMutableAttributedString *str = (NSMutableAttributedString *)[ChatEmotionTool getAttWithStr:message.text font:kChatFont_content];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str.length)];
    
    self.textView.attributedText = str;
    
    //设置frame
    CGFloat view_y = kChat_margin;
    if (kChatFont_content.lineHeight < kChat_min_h) {//为了使聊天内容与最小高度对齐
        view_y = (kChat_min_h - kChatFont_content.lineHeight)/2;
    }
    
    CGFloat margin = (message.bubbleMessageType == SHBubbleMessageType_Send) ? 0 : kChat_angle_w;
    self.textView.frame = CGRectMake(margin + kChat_margin, view_y, self.btnContent.width - 2*kChat_margin - kChat_angle_w, self.btnContent.height - 2*view_y);
}

#pragma mark 文本消息视图
- (MessageTextView *)textView{
    //文本
    if (!_textView) {
        _textView = [[MessageTextView alloc]init];
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        [self.btnContent addSubview:_textView];
    }
    return _textView;
}




@end

//
//  ChatNoteTableViewCell.m
//  ChatUIDemo
//
//  Created by GXL on 2021/5/20.
//  Copyright © 2018 GXL. All rights reserved.
//

#import "ChatNoteTableViewCell.h"

@interface ChatNoteTableViewCell ()

// note
@property (nonatomic, retain) UILabel *noteLab;

@end

@implementation ChatNoteTableViewCell

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
    
    //设置内容
    self.btnContent.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.btnContent.layer.cornerRadius = 5;
    self.btnContent.layer.masksToBounds = YES;

    self.noteLab.text = message.note;
    
    //设置frame
    self.noteLab.frame = CGRectMake(kChat_margin, kChat_margin, self.btnContent.width - 2*kChat_margin, self.btnContent.height - 2*kChat_margin);
    
    [self setBubbleImage:nil];
}

#pragma mark 通知消息视图
- (UILabel *)noteLab{
    //提示
    if (!_noteLab) {
        _noteLab = [[UILabel alloc]init];
        _noteLab.font = kChatFont_note;
        _noteLab.textColor = [UIColor whiteColor];
        _noteLab.textAlignment = NSTextAlignmentLeft;
        _noteLab.numberOfLines = 0;
        [self.btnContent addSubview:_noteLab];
    }
    return _noteLab;
}

@end

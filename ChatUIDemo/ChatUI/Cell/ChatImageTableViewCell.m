//
//  ChatImageTableViewCell.m
//  SHChatUI
//
//  Created by GXL on 2021/5/20.
//  Copyright © 2018 GXL. All rights reserved.
//

#import "ChatImageTableViewCell.h"
#import <SDWebImage.h>

@implementation ChatImageTableViewCell

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
    self.btnContent.layer.cornerRadius = 5;
    self.btnContent.layer.masksToBounds = YES;
    self.btnContent.backgroundColor = [UIColor whiteColor];
    [self setBubbleImage:nil];

    NSString *filePath = [ChatFileHelper getFilePathWithName:message.fileName type:ChatMessageFileType_image];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    if (image) {//本地
        [self.btnContent setImage:image forState:0];
    }else{//网络
//        [self.btnContent setImage:[ChatFileHelper imageNamed:@"chat_picture"] forState:0];
        [self.btnContent sd_setImageWithURL:[NSURL URLWithString:message.fileUrl] forState:0 placeholderImage:[ChatFileHelper imageNamed:@"chat_picture"]];
        
    }
}

@end

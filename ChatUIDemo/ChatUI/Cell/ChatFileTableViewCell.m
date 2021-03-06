//
//  ChatFileTableViewCell.m
//  ChatUIDemo
//
//  Created by GXL on 2020/11/3.
//  Copyright © 2020 GXL. All rights reserved.
//

#import "ChatFileTableViewCell.h"

@interface ChatFileTableViewCell ()

//文件图标
@property (nonatomic, retain) UIImageView *iconImg;
//文件名称
@property (nonatomic, retain) UILabel *fileName;
//文件大小
@property (nonatomic, retain) UILabel *fileSize;

@end

@implementation ChatFileTableViewCell

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
    self.fileName.text = message.displayName;
    self.fileSize.text = message.fileSize;
    
    UIImage *image = [self.btnContent.currentBackgroundImage imageWithColor:[UIColor whiteColor]];
    [self setBubbleImage:image];
    
    //设置frame
    CGFloat margin = (message.bubbleMessageType == ChatBubbleMessageType_Send) ? 0 : kChat_angle_w;
    
    self.iconImg.x = self.btnContent.width - kChat_margin - self.iconImg.width;
    
    self.fileSize.width = self.iconImg.x -  self.fileName.x - kChat_margin;
    
    self.fileName.x = margin + kChat_margin;
    self.fileName.width = self.fileSize.width;
    [self.fileName sizeToFit];
    
    self.fileSize.origin = CGPointMake(self.fileName.x, self.fileName.maxY + 5);
}

#pragma mark 文件消息视图
//文件图标
- (UIImageView *)iconImg{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]init];
        _iconImg.size = CGSizeMake(40, 45);
        _iconImg.y = kChat_margin;
        _iconImg.image = [ChatFileHelper imageNamed:@"chat_file"];
        [self.btnContent addSubview:_iconImg];
    }
    return _iconImg;
}

//文件名称
- (UILabel *)fileName {
    //来源
    if (!_fileName) {
        _fileName = [[UILabel alloc]init];
        _fileName.y = kChat_margin;
        _fileName.font = [UIFont boldSystemFontOfSize:16];
        _fileName.textColor = [UIColor blackColor];
        _fileName.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _fileName.numberOfLines = 2;
        [self.btnContent addSubview:_fileName];
    }
    return _fileName;
}

//文件大小
- (UILabel *)fileSize {
    //来源
    if (!_fileSize) {
        _fileSize = [[UILabel alloc]init];
        _fileSize.font = [UIFont systemFontOfSize:10];
        _fileSize.height = _fileSize.font.lineHeight;
        _fileSize.textColor = [UIColor grayColor];
        [self.btnContent addSubview:_fileSize];
    }
    return _fileSize;
}
@end

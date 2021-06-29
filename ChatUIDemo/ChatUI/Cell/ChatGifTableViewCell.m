//
//  ChatGifTableViewCell.m
//  SHChatUI
//
//  Created by GXL on 2021/5/20.
//  Copyright © 2018 GXL. All rights reserved.
//

#import "ChatGifTableViewCell.h"

@interface ChatGifTableViewCell ()

// Gif
@property (nonatomic, retain) WKWebView *gifView;

@end

@implementation ChatGifTableViewCell

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
    //获取Gif路径 (自带Gif)
    NSString *gifPath = [[ChatEmotionTool getEmojiPathWithType:SHEmoticonType_gif] stringByAppendingString:message.gifName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:gifPath]) {
        
        //获取Gif路径(缓存)
        gifPath = [ChatFileHelper getFilePathWithName:message.gifName type:ChatMessageFileType_gif];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:gifPath]) {//本地
        [self.gifView loadData:[NSData dataWithContentsOfFile:gifPath] MIMEType:@"image/gif" characterEncodingName:@"" baseURL:[NSURL new]];
    }else{//网络
        [self.gifView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:message.gifUrl]]];
    }
    
    //设置frame
    self.gifView.size = CGSizeMake(self.btnContent.width, self.btnContent.height);
    
    [self.btnContent setBackgroundImage:nil forState:0];
}

#pragma mark Gif消息视图
- (WKWebView *)gifView{
    if (!_gifView) {
        _gifView = [[WKWebView alloc]init];
        _gifView.origin = CGPointMake(0, 0);
        _gifView.backgroundColor = [UIColor clearColor];
        _gifView.userInteractionEnabled = NO;
        _gifView.scrollView.scrollEnabled = NO;
        _gifView.opaque = NO;
        [self.btnContent addSubview:_gifView];
    }
    return _gifView;
}


@end

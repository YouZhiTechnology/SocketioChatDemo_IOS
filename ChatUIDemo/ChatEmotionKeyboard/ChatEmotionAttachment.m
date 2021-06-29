//
//  SHEmotionAttachment.m
//  ChatEmotionKeyboardExmaple
//
//  Created by GXL on 2018/8/16.
//  Copyright © 2018年 GXL. All rights reserved.
//

#import "ChatEmotionAttachment.h"
#import "ChatEmotionTool.h"

@implementation ChatEmotionAttachment

- (void)setEmotion:(ChatEmotionModel *)emotion{
    _emotion = emotion;
    
    switch (emotion.type) {
        case SHEmoticonType_custom://自定义
        {
            self.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[ChatEmotionTool getEmojiPathWithType:emotion.type],emotion.png]];
        }
            break;
        default:
            break;
    }
}

@end

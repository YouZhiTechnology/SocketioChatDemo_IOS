//
//  SHEmotionAttachment.h
//  ChatEmotionKeyboardExmaple
//
//  Created by GXL on 2018/8/16.
//  Copyright © 2018年 GXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatEmotionModel.h"

@interface ChatEmotionAttachment : NSTextAttachment

@property (nonatomic, strong) ChatEmotionModel *emotion;

@end

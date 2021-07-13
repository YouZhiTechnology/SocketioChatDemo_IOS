//
//  ChatActivityIndicatorView.h
//  iOSAPP
//
//  Created by GXL on 16/8/16.
//  Copyright © 2016年 GXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageType.h"

@interface ChatActivityIndicatorView : UIButton

@property (nonatomic, assign) ChatSendMessageStatus messageState;

@end

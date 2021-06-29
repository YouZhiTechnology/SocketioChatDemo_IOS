//
//  ChatMessageLocationViewController.h
//  SHChatUI
//
//  Created by GXL on 2018/6/26.
//  Copyright © 2018年 GXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageType.h"
#import "ChatMessageHeader.h"

/**
 定位界面
 */
@interface ChatMessageLocationViewController : UIViewController

//地图类型
@property (nonatomic, assign) ChatMessageLocationType locType;

//数据模型
@property (nonatomic, strong) ChatMessage *message;

//回调
@property (nonatomic, copy) void (^block)(ChatMessage *message);

@end

//
//  ChatMessageTableViewCell.h
//  ChatUIDemo
//
//  Created by GXL on 2018/6/7.
//  Copyright © 2018年 GXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageHeader.h"
#import "ChatActivityIndicatorView.h"

@class ChatMessageContentView;
@class ChatMessageFrame;
@class ChatMessageTableViewCell;

@protocol ChatMessageCellDelegate <NSObject>

@optional
//点击
- (void)didSelectWithCell:(ChatMessageTableViewCell *)cell type:(ChatMessageClickType)type message:(ChatMessage *)message;

@end

@interface ChatMessageTableViewCell : UITableViewCell

//点击位置
@property (nonatomic, assign) CGPoint tapPoint;

//代理
@property (nonatomic, weak) id <ChatMessageCellDelegate>delegate;
//坐标
@property (nonatomic, retain) ChatMessageFrame *messageFrame;
//内容
@property (nonatomic, retain) UIButton *btnContent;
//时间
@property (nonatomic, retain) UILabel *labelTime;
//ID
@property (nonatomic, retain) UILabel *labelNum;
//头像
@property (nonatomic, retain) UIButton *btnHeadImage;
//消息状态
@property (nonatomic, retain) ChatActivityIndicatorView *activityView;

//设置气泡背景
- (void)setBubbleImage:(UIImage *)image;

@end

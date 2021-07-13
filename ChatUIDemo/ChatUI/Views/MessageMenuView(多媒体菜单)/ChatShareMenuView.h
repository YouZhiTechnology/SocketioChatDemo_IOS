//
//  ChatShareMenuView.h
//  ChatUIDemo
//
//  Created by GXL on 16/7/27.
//  Copyright © 2016年 GXL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatShareMenuItem.h"

/**
 多媒体菜单视图
 */
@protocol ChatShareMenuViewDelegate <NSObject>

@optional
//点击菜单
- (void)didSelecteShareMenuItem:(ChatShareMenuItem *)menuItem index:(NSInteger)index;

@end

@interface ChatShareMenuView : UIView

//功能数据
@property (nonatomic, strong) NSArray *shareMenuItems;
//代理
@property (nonatomic, weak) id <ChatShareMenuViewDelegate> delegate;

/**
 *  根据数据源刷新自定义按钮的布局
 */
- (void)reloadData;

@end

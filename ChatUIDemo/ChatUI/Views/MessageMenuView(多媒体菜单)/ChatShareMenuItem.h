//
//  ChatShareMenuItem.h
//  SHChatMessageUI
//
//  Created by GXL on 16/7/27.
//  Copyright © 2016年 GXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 多媒体菜单按钮
 */
@interface ChatShareMenuItem : NSObject

/**
 *  正常显示图片
 */
@property (nonatomic, strong) UIImage *icon;

/**
 *  第三方按钮的标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  第三方按钮的标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 *  第三方按钮的标题字体大小
 */
@property (nonatomic, strong) UIFont *titleFont;

@end

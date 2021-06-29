//
//  ChatMenuController.h
//  SHChatUI
//
//  Created by GXL on 2018/6/25.
//  Copyright © 2018年 GXL. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 长按菜单
 */
@interface ChatMenuController : UIMenuController

/**
 显示菜单

 @param view 父视图
 @param menuArr 集合
 @param showPiont 坐标
 */
+ (void)showMenuControllerWithView:(UIView *)view menuArr:(NSArray *)menuArr showPiont:(CGPoint)showPiont;

@end

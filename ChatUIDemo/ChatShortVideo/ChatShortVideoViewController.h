//
//  ChatShortVideoViewController.h
//  ChatShortVideoExmaple
//
//  Created by GXL on 2018/8/29.
//  Copyright © 2018年 GXL. All rights reserved.
//

#import <UIKit/UIKit.h>

//完成回调
typedef void(^FinishBlock)(id content);

/**
 短视频录制界面
 */
@interface ChatShortVideoViewController : UIViewController

//进度颜色(默认 orangeColor)
@property (nonatomic, copy) UIColor *progressColor;
//最大时长(默认 60)
@property (nonatomic, assign) NSInteger maxSeconds;
//是否保存到系统(默认 不保存)
@property (nonatomic, assign) BOOL isSave;
//完成回调
@property (nonatomic, copy) FinishBlock finishBlock;

@end

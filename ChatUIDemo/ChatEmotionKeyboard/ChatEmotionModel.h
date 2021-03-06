//
//  ChatEmotionModel.h
//  ChatEmotionKeyboard
//
//  Created by GXL on 2016/12/7.
//  Copyright © 2016年 GXL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ChatEmoticonType) {
    ChatEmoticonType_custom = 101,  //自定义表情
    ChatEmoticonType_system,        //系统表情
    ChatEmoticonType_gif,           //GIF表情
    ChatEmoticonType_collect,       //收藏表情
    ChatEmoticonType_recent,        //最近表情
};

/**
 表情键盘模型
 */
@interface ChatEmotionModel : NSObject

/**
 *  emoji表情的code
 */
@property (nonatomic, copy) NSString *code;

/**
 *  图片名字
 */
@property (nonatomic, copy) NSString *png;

/**
 *  GIF图片名字
 */
@property (nonatomic, copy) NSString *gif;

/**
 *  收藏图片Url
 */
@property (nonatomic, copy) NSString *url;

/**
 *  表情对应的路径
 */
@property (nonatomic, copy) NSString *path;

/**
 表情类型
 */
@property (nonatomic, assign) ChatEmoticonType type;

//转换
+ (instancetype)emotionWithDict:(NSDictionary *)dict;

@end

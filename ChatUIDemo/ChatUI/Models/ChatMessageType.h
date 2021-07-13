//
//  ChatMessageType.h
//  ChatUIDemo
//
//  Created by GXL on 2018/6/5.
//  Copyright © 2018年 GXL. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 聊天Type定义
 */

/**
 *  消息类型
 */
typedef enum {
    ChatMessageBodyType_text = 1,       //文本类型
    ChatMessageBodyType_image,          //图片类型
    ChatMessageBodyType_voice,          //语音类型
    ChatMessageBodyType_video,          //视频类型
    ChatMessageBodyType_location,       //位置类型
    ChatMessageBodyType_card,           //名片类型
    ChatMessageBodyType_redPaper,       //红包类型
    ChatMessageBodyType_gif,            //动图类型
    ChatMessageBodyType_note,           //通知类型
    ChatMessageBodyType_file,           //文件类型
}ChatMessageBodyType;

/**
 *  资源类型
 */
typedef enum {
    ChatMessageFileType_image = 1,    //image类型
    ChatMessageFileType_wav,          //wav类型
    ChatMessageFileType_amr,          //amr类型
    ChatMessageFileType_gif,          //gif类型
    ChatMessageFileType_video,        //video类型
    ChatMessageFileType_video_image,  //video图片类型
    ChatMessageFileType_file,         //file类型
}ChatMessageFileType;

/**
 *  输入框类型
 */
typedef enum {
    ChatInputViewType_default,     //默认
    ChatInputViewType_text,        //文本
    ChatInputViewType_voice,       //语音
    ChatInputViewType_emotion,     //表情
    ChatInputViewType_menu,        //菜单
}ChatInputViewType;

/**
 *  地图类型
 */
typedef enum {
    ChatMessageLocationType_Location = 1,   //定位
    ChatMessageLocationType_Look            //查看
}ChatMessageLocationType;

/**
 *  点击类型
 */
typedef enum {
    ChatMessageClickType_click_message = 1,   //点击消息
    ChatMessageClickType_long_message,        //长按消息
    ChatMessageClickType_click_head,          //点击头像
    ChatMessageClickType_long_head,           //长按头像
    ChatMessageClickType_click_retry,         //点击重发
}ChatMessageClickType;

/**
 *  发送方
 */
typedef enum{
    ChatBubbleMessageType_Send = 0, // 发送
    ChatBubbleMessageType_Receiving, // 接收
}ChatBubbleMessageType;

/**
 *  聊天类型
 */
typedef enum{
    ChatType_Chat = 1,  //单聊
    ChatType_GroupChat  //群聊
}ChatType;

/**
 *  消息发送状态
 */
typedef enum{
    ChatSendMessageType_Successed = 1,  //发送成功
    ChatSendMessageType_Failed,         //发送失败
    ChatSendMessageType_Sending         //发送中
}ChatSendMessageStatus;


@interface ChatMessageType : NSObject



@end

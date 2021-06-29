//
//  ChatListModel.swift
//  ChatUIDemo
//
//  Created by youzhi-air8 on 2021/6/23.
//

import UIKit

class ChatListModel: BaseModel {
    
    @objc var toUserId : String?  //联系人ID
    @objc var toId : String?   //联系人账户ID
    @objc  var me : String?   //当前用户ID
    @objc var sessionId : String?   //会话ID
    @objc var lastTime : String?   //最后联系时间
    @objc  var lastMsg : String?   //最后一则消息（只保留最长10个字符）
    @objc var lastTimestr : String?   //最后联系时间
    @objc var num : String?    //未读条数，目前先返回0，后期再实现真实数据
    @objc var online : String?   //是否在线
    @objc var read : String?   //最后消息是否已读 0未读 1已读
    @objc var type : String?   //是否群聊 0非群聊 1群聊
    @objc var nick : String?   //用户名称
    @objc var fileType : String? //最后一条消息的类型 0文字 2图片 3语音
    
    @objc var avatar : String? //头像
    
    @objc var id : String? //置顶id
    
    @objc var isTop : String? //是否置顶
    
}

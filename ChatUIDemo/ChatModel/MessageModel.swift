//
//  MessageModel.swift
//  ChatUIDemo
//
//  Created by youzhi-air8 on 2021/6/24.
//

import UIKit

class MessageModel: BaseModel {
    // uuid
    var mid: String?
    // 聊天属性1文本 2文件
    var cmd: Int?
    // 发言者ID
    var from: String?
    // 是否 是已撤回消息 1撤回0未撤回
    var msgType: String?
    // 消息类型0文字1文件2图片
    var fileType: String?
    // 发言者昵称
    var fNick: String?
    // 发言者头像
    var fAvatar: String?
    // 接收者ID
    var toId: String?
    // 接收者昵称
    var tNick: String?
    // 接收者头像
    var tAvatar: String?
    // 消息内容
    var msg: String?
    // 发言时间
    var ctime: String?
    // 是否已读
    var read: Int?
    // 将所有透传信息打包统一存储传递
    var ext: String?
    // 进度id
    var progressId: Int?
    
    var id: String?
    
    var visitorLoginStatisics: String?
}

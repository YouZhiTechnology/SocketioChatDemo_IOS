//
//  SendMessageModel.swift
//  ChatUIDemo
//
//  Created by youzhi-air8 on 2021/6/24.
//

import UIKit

/**
 *  消息发送状态
 */
enum TextMessageSendState {
    case success     // 消息发送成功
    case sending    // 发送中
    case fail           // 消息发送失败
}


struct SendMessageModel {
    // 对方用户ID
    var toId: String
    // 消息内容
    var msg: String
    // （可选默认0）文件类型：0文本 1附件 2图片 3视频 4语音 11转接
    var filetype: String
    // 发给访客 0
    var tousertype: NSInteger
    /// 进度ID
    var progressId: Int?

}

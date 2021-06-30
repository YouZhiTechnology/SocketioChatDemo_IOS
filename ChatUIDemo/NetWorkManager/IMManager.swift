//
//  IMManager.swift
//  PalmHeCheng
//
//  Created by 梁 on 2020/6/4.
//  Copyright © 2020 songweipng. All rights reserved.
//

import Foundation
import UIKit
import SocketIO
import SwiftyUserDefaults

/*
 消息类型枚举
 */
enum IMOnlineStatus {
    case online
    case leave
    case outline
}


/*
 消息处理协议
 */

protocol MessageProcessingProtocol:AnyObject {
    
    //聊天列表
    func chatList(list:[ChatListModel])

    /// 历史消息
    func setHistoryMessage(list: [MessageModel])

    /// 新消息
    func newMessage(model: MessageModel)

}

extension MessageProcessingProtocol {
    
//    // 聊天列表
    func chatList(list: [ChatListModel]) {
    }
//    // 新消息
    func newMessage(model: MessageModel) {

    }
//    // 历史消息
    func setHistoryMessage(list: [MessageModel]) {

    }
 
}

@objc protocol OCMessageProcessingProtocol:AnyObject {
    
    @objc func OCmandatorySessionSuccess(message:Any)
    
}

fileprivate var sharedInstance: IMManager? = IMManager()

@objcMembers class IMManager: NSObject {
    
    @objc static var shared: IMManager {
        if sharedInstance == nil {
            sharedInstance = IMManager()
        }
        return sharedInstance!
    }
    
    @objc var OCdelegate:OCMessageProcessingProtocol?
    
    var delegate: MessageProcessingProtocol?
    
    // socket
    var socket: SocketIOClient?
    // socket.io 初始化
    
    let manager = SocketManager(socketURL: URL(string: APIManager.IMUrl)!, config: [.log(true), .forceWebsockets(true), .compress, .extraHeaders(["Content-type":"application/json;charset=UTF-8"]), .connectParams(["companyId" : Defaults[\.companyId] ?? "", "siteId" : "1","mUserId":Defaults[\.mUserId] ?? "", "deviceType": "ios"])])
    
    
    fileprivate override init() {
        super.init()
        socket = manager.defaultSocket
        
        socket?.on(clientEvent: .connect) {[weak self]data, ack in
            print("socket connected")
            self?.socket?.connect()
        }

        //错误
        
        socket?.on(clientEvent: .error) {[weak self] (data, eck) in
            print("--------socket error")
            self?.socket?.connect()
        }
        
        //断开连接
        socket?.on(clientEvent: .disconnect){ (data,eck) in
            print("--------socket disconnect")
        }
        
        //重连
        socket?.on(clientEvent: SocketClientEvent.reconnect) { (data,eck) in
            print("------socket reconnect")
            self.socket?.connect()
        }
        
        //监听cmd消息
        self.socket?.on("cmd"){[unowned self] data,ack in
            if data.count > 0 {
                let info: IMCmdInfo = JsonUtil.dictionaryToModel(data.first as! Dictionary, IMCmdInfo.self) as! IMCmdInfo
                guard let body = info.body else {
                    return
                }

                switch info.cmd {
                case "31": //聊天列表
                    
                    let list: [ChatListModel] = JsonUtil.jsonStringToModel(body["contacts"] as! String, ChatListModel.self) as! [ChatListModel]
                    if self.delegate != nil {
                        self.delegate?.chatList(list: list)
                    }
                    break

                case "33":  //历史消息
                    let list: [MessageModel] = JsonUtil.jsonStringToModel(body["list"] as! String, MessageModel.self) as! [MessageModel]

                    if self.delegate != nil {
                        self.delegate?.setHistoryMessage(list: list)
                    }
                    break

                case "5"://接收到新消息
                    let model: MessageModel = JsonUtil.dictionaryToModel(body, MessageModel.self) as! MessageModel
                    model.mid = info.mid
                    if let progressId: Int = body["progressId"] as? Int {
                        model.progressId = progressId
                    }
                    if self.delegate != nil {
                        self.delegate?.newMessage(model: model)
                    }

                    break

                default:
                    break
                }
            }
            ack.with("Got your currentAmount","dude")
        }
    }
   
    //链接状态
    var isConnected: Bool {
        return socket?.status == .connected
    }
    //链接
    @objc func connect(){
        //IM 链接
        manager.setConfigs([.log(true), .forceWebsockets(true), .compress, .connectParams(["companyId" : Defaults[\.companyId] ?? "", "siteId" : "1","mUserId":Defaults[\.mUserId] ?? "", "deviceType": "ios"])])
        
        socket?.connect(timeoutAfter: 3, withHandler: {
            
        })
        
    }

//    //获取聊天列表
    func chatList() {
        let jsonObject: [String: Any] = ["cmd": "31"]
        socket?.emit("cmd", with:[jsonObject], completion: nil)
    }
//
//    //历史消息
    func historyList(sessionId:String,toId:String) {
        let param = [
            "sessionId":sessionId,
        ]

        let jsonObject:[String: Any] = ["cmd":"33",
                                        "param":param]
        socket?.emit("cmd", with: [jsonObject])
    }

//    //发送消息
    func sendMessage(model: SendMessageModel) {
        let param: [String: Any] = ["toId": model.toId,
                                    "msg": model.msg,
                                    "fileType": model.filetype,
                                    "mUserId":Defaults[\.mUserId] ?? "",
                                    "companyId": Defaults[\.companyId] ?? "",
        ]
        let jsonObject: [String: Any] = ["cmd": "5",
                                         "param": param]
        socket?.emitWithAck("cmd", with: [jsonObject]).timingOut(after: 3, callback: { (data) in
            print(">>>>>>>>>>>>>>>\(data)")
        })
    }

    //断开连接
    @objc func disconnect() {
        sharedInstance = nil
    }
}

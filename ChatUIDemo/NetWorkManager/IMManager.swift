//
//  IMManager.swift
//  PalmHeCheng
//
//  Created by 梁 on 2020/6/4.
//  Copyright © 2020 songweipng. All rights reserved.
//
/**
 
 */

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
    // 获取在线状态
//    func onlineStatus(status: IMOnlineStatus)
    /// 历史消息
    func setHistoryMessage(list: [MessageModel])
    //发送消息成功
//    func sendSuccess()
    /// 新消息
    func newMessage(model: MessageModel)
    // 结束对话
//    func endChat()
    
    //删除最近联系人成功
//    func deleteRecordSuccess()
    //发起会话成功
//    func mandatorySessionSuccess(model:ChatListModel)
    //置顶成功
//    func topSuccess()
//    //取消置顶成功
//    func CanceltopSuccess()
//    //被拉黑
//    func beBlack(userid:String)
//    //未读总数
//    func totalNumber(incount:String)
    
}

extension MessageProcessingProtocol {
    
    //在线状态
//    func onlineStatus(status: IMOnlineStatus) {
//
//    }
//    // 聊天列表
    func chatList(list: [ChatListModel]) {
    }
    //发送消息成功
//    func sendSuccess() {
//
//    }
    
    // 结束对话
//    func endChat() {
//
//    }
//    // 新消息
    func newMessage(model: MessageModel) {

    }
//    // 历史消息
    func setHistoryMessage(list: [MessageModel]) {

    }
    //删除最近联系人成功
//    func deleteRecordSuccess() {
//
//    }
    
    //强制会话成功
//    func mandatorySessionSuccess(model:ChatListModel) {
//
//    }
    
    //置顶成功
//    func topSuccess(){
//
//    }
//    //取消置顶成功
//    func CanceltopSuccess(){
//
//    }
//    //被拉黑
//    func beBlack(userid:String){
//
//    }
//    //未读总数
//    func totalNumber(incount:String){
//
//    }
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
        
//        self.socket?.connect()
        
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
//                    let list:[ChatListModel] = JsonUtil.jsonStringToModel(body["contacts"] as! String, ChatListModel.self) as! [ChatListModel]
                    
                    let list: [ChatListModel] = JsonUtil.jsonStringToModel(body["contacts"] as! String, ChatListModel.self) as! [ChatListModel]
                    if self.delegate != nil {
                        self.delegate?.chatList(list: list)
                    }
                    break
//
//                case "32": //总未读数量
//
//                    if self.delegate != nil {
//                        self.delegate?.totalNumber(incount:body["incount"] as! String)
//                    }
//
//                    break
                case "33":  //历史消息
                    let list: [MessageModel] = JsonUtil.jsonStringToModel(body["list"] as! String, MessageModel.self) as! [MessageModel]

                    if self.delegate != nil {
                        self.delegate?.setHistoryMessage(list: list)
                    }
                    break
//                case "38":  //删除最近联系人
//                    if body["contacts"] as! String == "true" {
//                        self.delegate?.deleteRecordSuccess()
//                    }
//
//                    break
//                case "56"://发起会话失败
//                    JKToast.show(withText: "发起会话失败")
//
//                    break
//                case "57"://发起会话成功
//
//                    let model = ChatListModel()
//                    model.sessionId = (body["sessionId"] as! String)
//                    model.nick = (body["name"] as! String)
//                    model.toUserId = (body["toId"] as! String)
//                    if self.delegate != nil {
//                        self.delegate?.mandatorySessionSuccess(model: model)
//                    }
//
//                    if self.OCdelegate != nil{
//                        self.OCdelegate?.OCmandatorySessionSuccess(message:body)
//                    }
//
//                    break
//                case "75":  //发送消息成功
//
//                    if self.delegate != nil {
//                        self.delegate?.sendSuccess()
//                    }
//
//                    break
//
//                case "88":
//
//                    if self.delegate != nil {
//                        self.delegate?.topSuccess()
//                    }
//
//                    break
//                case "89":
//
//                    if self.delegate != nil {
//                        self.delegate?.CanceltopSuccess()
//                    }
//
//                    break
//
//                case "91":
//                    //被加入黑名单
//                    if self.delegate != nil{
//                        self.delegate?.beBlack(userid: body["mUserId"] as! String)
//                    }
//                    break
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
    
    //获取当前状态
//    func getIMStatus(info:GetOnlineStatus){
//        var type: IMOnlineStatus
//        switch info.userctype {
//        case "1":
//            type = .online
//        case "3":
//            type = .leave
//        default:
//            type = .outline
//        }
//        if self.delegate != nil {
//            self.delegate?.onlineStatus(status: type)
//        }
//    }
    
    //链接状态
    var isConnected: Bool {
        return socket?.status == .connected
    }
    //链接
    @objc func connect(){
        //IM 链接
//        guard let mUserId =  UserDefaults.standard.string(forKey:"mUserId") else { return }
        
        manager.setConfigs([.log(true), .forceWebsockets(true), .compress, .connectParams(["companyId" : Defaults[\.companyId] ?? "", "siteId" : "1","mUserId":Defaults[\.mUserId] ?? "", "deviceType": "ios"])])
        
        socket?.connect(timeoutAfter: 3, withHandler: {
            
        })
        
    }
//    //获取聊天未读数量
//    func chatNotReadNumber() {
//        let jsonObject: [String: Any] = ["cmd": "32"]
//        socket?.emit("cmd", with:[jsonObject])
//    }
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
//    //删除联系人
//    func deleteRecord(sessionId:String) {
//        let param = [
//            "sessionId":sessionId,
//        ]
//
//        let jsonObject: [String: Any] = ["cmd": "38","param":param]
//        socket?.emit("cmd", with:[jsonObject])
//    }
//    //置顶
//    func makeTop(TopId:String) {
//        let param = [
//            "id":TopId,
//        ]
//
//        let jsonObject: [String: Any] = ["cmd": "88","param":param]
//        socket?.emit("cmd", with:[jsonObject])
//    }
//
//
//    //取消置顶
//    func CancelTop(TopId:String) {
//        let param = [
//            "id":TopId,
//        ]
//
//        let jsonObject: [String: Any] = ["cmd": "89","param":param]
//        socket?.emit("cmd", with:[jsonObject])
//    }
//
//
//    /// 强制会话
//    @objc func mandatorySession(toId: String) {
//        guard let mUserId =  UserDefaults.standard.string(forKey:"mUserId") else { return }
//        let param: [String: Any] = ["mUserId": String(mUserId),
//                                    "toId":toId
//        ]
//
//        if toId == String(mUserId){
//            JKToast.show(withText: "无法对自己发起会话")
//            return
//        }
//
//        let jsonObject: [String: Any] = ["cmd": "56",
//                                         "param": param]
//        socket?.emit("cmd", with: [jsonObject])
//    }
//
//    //加入黑名单
//
//    func addBlackList(toId:String) {
//        let param = [
//            "toId":toId,
//            "mUserId":UserDefaults.standard.string(forKey:"mUserId")
//        ]
//
//        let jsonObject: [String: Any] = ["cmd": "90","param":param]
//        socket?.emit("cmd", with:[jsonObject])
//    }
//
//
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
//
//    //已读确认
//    func alreadyRead(mid:String) {
//        let param = [
//            "mid":mid,
//        ]
//
//        let jsonObject: [String: Any] = ["cmd": "75","param":param]
//        socket?.emit("cmd", with:[jsonObject])
//    }
    //断开连接
    @objc func disconnect() {
        sharedInstance = nil
    }
}

/**
 
 */

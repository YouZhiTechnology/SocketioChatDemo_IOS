//
//  SocketChatViewController.swift
//  ChatUIDemo
//
//  Created by youzhi-air8 on 2021/7/9.
//

import UIKit
import SwiftyUserDefaults

class SocketChatViewController: UIViewController , ChatMessageInputViewDelegate, ChatMessageCellDelegate, ChatAudioPlayerHelperDelegate {
    
    var chatInputView:ChatMessageInputView?
    
    var shareMenuItems:[ChatShareMenuItem] = []
    
    var refresh:UIRefreshControl?
    
    var dataSource:[ChatMessageFrame] = []
    
    var player : AVPlayer!
    
    var palyerItem : AVPlayerItem!
    
    var sessionId:String = ""
    
    var toId:String = ""
    
    var imageArray:[String] = []
    
    //当前点击的Cell
    var selectCell:ChatMessageTableViewCell?
    
    var timeArr:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white

        self.config()
        
        IMManager.shared.historyList(sessionId: sessionId, toId: "")
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IMManager.shared.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        chatInputView?.emojiView.clear() //移除表情键盘观察者
    }

    /// MARK - 配置参数
    func config() {
        // MARKV --
        /// 下方输入框
        chatInputView = ChatMessageInputView()
        self.view.addSubview(chatInputView!)
        chatInputView?.frame = CGRect(x: 0, y: kScreenHeight - kInPutHeight - kBottomSafe, width: kScreenWidth, height: kInPutHeight)
        chatInputView?.delegate = self
        chatInputView?.supVC = self
        
        let imageArray:[String] = ["chat_more_pic"]
        let titleArray:[String] = ["照片"]
        
        for i in 0..<imageArray.count {
            let item = ChatShareMenuItem()
            item.icon = ChatFileHelper.imageNamed(imageArray[i])
            item.title = titleArray[i]
            shareMenuItems.append(item)
        }
        
        chatInputView?.shareMenuItems = shareMenuItems
        chatInputView?.reload()
        
        //添加聊天
        self.view.addSubview(chatTableView)
        let h = self.chatInputView?.y ?? 0
        
        chatTableView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: Int(h))
        let ges = UITapGestureRecognizer(target: self, action: #selector(click))
        chatTableView.addGestureRecognizer(ges)
        
        self.refresh = UIRefreshControl.init()
        self.refresh?.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
        chatTableView.refreshControl = self.refresh
    }
    
    /// 聊天界面
    fileprivate lazy var chatTableView = { () -> UITableView in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.init(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatTextTableViewCell.self, forCellReuseIdentifier: "ChatTextTableViewCell")
        tableView.register(ChatAudioTableViewCell.self, forCellReuseIdentifier: "ChatAudioTableViewCell")
        tableView.register(ChatLocationTableViewCell.self, forCellReuseIdentifier: "ChatLocationTableViewCell")
        tableView.register(ChatImageTableViewCell.self, forCellReuseIdentifier: "ChatImageTableViewCell")
        tableView.register(ChatNoteTableViewCell.self, forCellReuseIdentifier: "ChatNoteTableViewCell")
        tableView.register(ChatCardTableViewCell.self, forCellReuseIdentifier: "ChatCardTableViewCell")
        tableView.register(ChatGifTableViewCell.self, forCellReuseIdentifier: "ChatGifTableViewCell")
        tableView.register(ChatRedPaperTableViewCell.self, forCellReuseIdentifier: "ChatRedPaperTableViewCell")
        tableView.register(ChatVideoTableViewCell.self, forCellReuseIdentifier: "ChatVideoTableViewCell")
        tableView.register(ChatFileTableViewCell.self, forCellReuseIdentifier: "ChatFileTableViewCell")
        tableView.estimatedRowHeight = 0
        tableView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleWidth ]
        return tableView
    }()
    
    @objc func click() {
        //默认输入
        self.chatInputView?.inputType = ChatInputViewType_default
    }
    
}

extension SocketChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageFrame = dataSource[indexPath.row]
        switch messageFrame.message.messageType {
        case ChatMessageBodyType_text: //文本
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTextTableViewCell", for: indexPath) as! ChatTextTableViewCell
            cell.delegate = self
            cell.messageFrame = messageFrame
            return cell
        case ChatMessageBodyType_voice: //语音
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatAudioTableViewCell", for: indexPath) as! ChatAudioTableViewCell
            cell.delegate = self
            cell.messageFrame = messageFrame
            return cell
        case ChatMessageBodyType_location: //位置
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLocationTableViewCell", for: indexPath) as! ChatLocationTableViewCell
            cell.delegate = self
            cell.messageFrame = messageFrame
            return cell
        case ChatMessageBodyType_image: //图片
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatImageTableViewCell", for: indexPath) as! ChatImageTableViewCell
            cell.delegate = self
            cell.messageFrame = messageFrame
            return cell
        case ChatMessageBodyType_note: //通知
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatNoteTableViewCell", for: indexPath) as! ChatNoteTableViewCell
            cell.delegate = self
            cell.messageFrame = messageFrame
            return cell
        case ChatMessageBodyType_card: //名片
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCardTableViewCell", for: indexPath) as! ChatCardTableViewCell
            cell.delegate = self
            cell.messageFrame = messageFrame
            return cell
        case ChatMessageBodyType_gif: //Gif
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatGifTableViewCell", for: indexPath) as! ChatGifTableViewCell
            cell.delegate = self
            cell.messageFrame = messageFrame

            return cell
        case ChatMessageBodyType_redPaper: //红包
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRedPaperTableViewCell", for: indexPath) as! ChatRedPaperTableViewCell
            cell.delegate = self
            cell.messageFrame = messageFrame
            return cell
        case ChatMessageBodyType_video: //视频
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatVideoTableViewCell", for: indexPath) as! ChatVideoTableViewCell
            cell.delegate = self
            cell.messageFrame = messageFrame
            return cell
        case ChatMessageBodyType_file: //文件
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatFileTableViewCell", for: indexPath) as! ChatFileTableViewCell
            cell.delegate = self
            cell.messageFrame = messageFrame
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatFileTableViewCell", for: indexPath) as! ChatFileTableViewCell
            cell.delegate = self
            cell.messageFrame = messageFrame
            return cell
        }
        
    }
    
    /// cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let messageFrame = dataSource[indexPath.row]
        return messageFrame.cell_h
    }
    
    /// 点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension SocketChatViewController {
    // MARK - ScrollVIewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //默认输入
        self.chatInputView?.inputType = ChatInputViewType_default
    }
    
    func tableViewScrollToBottom() {
        if self.dataSource.count > 1 {
            self.tableViewScrollToIndex(self.dataSource.count - 1)
        }
    }
    
    func tableViewScrollToIndex(_ index: Int) {
        if self.dataSource.count > index {
            self.chatTableView.scrollToRow(at: IndexPath.init(row: index, section: 0), at: .bottom, animated: false)
        }
    }
    
    
}

// MARK - 重写
extension SocketChatViewController: MessageProcessingProtocol {
    func toolbarHeightChange() {
        //改变聊天界面高度
        self.chatTableView.height = self.chatInputView?.y ?? 0
        self.view.layoutIfNeeded()
        //滚动到底部
        self.tableViewScrollToBottom()
    }
    
    // MARK -- ChatMessageInputViewDelegate
    //发送文本
    func chatMessage(withSendText text: String!) {
//        let message: ChatMessage = ChatMessageHelper.addPublicParameters()
//        message.messageType = ChatMessageBodyType_text
//        message.text = text
//        message.bubbleMessageType = ChatBubbleMessageType_Send
//        message.messageState = ChatSendMessageType_Successed
//        self.addChatMessageWithMessage(message, true)
                
        let info = text.replacingOccurrences(of: "\n", with: "<br>")
        let model: SendMessageModel = SendMessageModel(toId: toId, msg: info, filetype: "0", tousertype: 0)
        IMManager.shared.sendMessage(model: model)
    }
    
    //发送图片
    func chatMessage(withSend image: UIImage!, imageName name: String!, size: CGSize) {
        
        var data = image?.jpegData(compressionQuality: 1)
        while data!.count / 1024 / 1024 > 3{
            data = image?.jpegData(compressionQuality: 0.5)// 压缩比例在0~1之间
        }
        
        var newImage = image
        // 设定需要修改的图片的大小，这里设定为新图片宽是120，高是90.
        let sizeChange = CGSize(width: 100,height: 100)
        // 打开图片编辑模式
        UIGraphicsBeginImageContextWithOptions(sizeChange, false, 0.0)
        // 修改图片长和宽
        newImage?.draw(in: CGRect(origin: .zero, size: sizeChange))
        // 生成新图片
        newImage = UIGraphicsGetImageFromCurrentImageContext()
    //                UIGraphicsGetImageFromCurrentImageContext()
        // 关闭图片编辑模式
        UIGraphicsEndImageContext()
        newImage!.jpegData(compressionQuality: 0.1)

        NetWorkManager.uploadOnePic(urlString: APIManager.fileUpload, params: nil, imageName: "file", images: [newImage!]) { isSuccess, message, data in

            print(isSuccess)
            
            if isSuccess {
                let url = data["url"] as! String
                let imageUrl:String = "https://hcim.zaoha.net" + url
                let model: SendMessageModel = SendMessageModel(toId: self.toId, msg: imageUrl, filetype: "2", tousertype: 0)

                IMManager.shared.sendMessage(model: model)
                print(imageUrl)
            }

        } failture: { error in
            print(error)
        }
        
    }
    
    //发送视频
    func chatMessage(withSendVideo videoName: String!, fileSize: String!, duration: String!, size: CGSize) {
        let message: ChatMessage = ChatMessageHelper.addPublicParameters()
        message.messageType = ChatMessageBodyType_video
        message.fileName = videoName
        message.imageWidth = size.width
        message.imageHeight = size.height
        message.videoDuration = duration
        
        //添加到聊天页面
        self.addChatMessageWithMessage(message, true)
    }
    
    //发送音频
    func chatMessage(withSendAudio audioName: String!, duration: Int) {
        let url = URL.init(fileURLWithPath: audioName)

        NetWorkManager.uploadFile(urlString: APIManager.fileUpload, params: nil, files: [url]) { isSuccess, message, data in
            
            let Url:String = data["url"] as! String
            let voiceUrl : String = "https://hcim.zaoha.net" + Url + "&time="+"\(duration*1000)"
            let model : SendMessageModel = SendMessageModel(toId: self.toId, msg: voiceUrl, filetype: "3", tousertype: 0)
            IMManager.shared.sendMessage(model: model)
            
        } failture: { error in
            
        }
    }
    
    //发送位置
    func chatMessage(withSendLocation locationName: String!, lon: CGFloat, lat: CGFloat) {
        let message:ChatMessage = ChatMessageHelper.addPublicParameters()
        message.messageType = ChatMessageBodyType_location
        message.locationName = locationName
        message.lat = lat
        message.lon = lon
        
        //添加到聊天页面
        self.addChatMessageWithMessage(message, true)
    }
    
    //发送名片
    func chatMessage(withSendCard card: String!) {
        let message:ChatMessage = ChatMessageHelper.addPublicParameters()
        message.messageType = ChatMessageBodyType_card
        message.card = card
        
        //添加到聊天页面
        self.addChatMessageWithMessage(message, true)
    }
    
    //发送通知
    func chatMessage(withSendNote note: String!) {
        let message:ChatMessage = ChatMessageHelper.addPublicParameters()
        message.messageType = ChatMessageBodyType_note
        message.note = note
        
        //添加到聊天页面
        self.addChatMessageWithMessage(message, true)
    }
    
    //发送红包
    func chatMessage(withSendRedPackage redPackage: String!) {
        let message:ChatMessage = ChatMessageHelper.addPublicParameters()
        message.messageType = ChatMessageBodyType_redPaper
        message.redPackage = redPackage
        
        //添加到聊天页面
        self.addChatMessageWithMessage(message, true)
    }
    
    //发送动图
    func chatMessage(withSendGif gifName: String!, size: CGSize) {
        let message:ChatMessage = ChatMessageHelper.addPublicParameters()
        message.messageType = ChatMessageBodyType_gif
        message.gifName = gifName
        message.gifWidth = size.width
        message.gifHeight = size.height
        
        //添加到聊天页面
        self.addChatMessageWithMessage(message, true)
    }
    
    //发送文件
    func chatMessage(withSendFile fileName: String!, displayName: String!, fileSize: String!) {
        let message:ChatMessage = ChatMessageHelper.addPublicParameters()
        message.messageType = ChatMessageBodyType_file
        message.fileName = fileName
        message.displayName = displayName
        message.fileSize = fileSize
        
        //添加到聊天页面
        self.addChatMessageWithMessage(message, true)
    }
    
    func newMessage(model: MessageModel) {
        let mUserId = Defaults[\.mUserId] ?? ""
        switch model.fileType {
        case "0":
            let message: ChatMessage = ChatMessageHelper.addPublicParameters()
            message.messageType = ChatMessageBodyType_text
            message.text = model.msg
            if model.from == mUserId {
                message.bubbleMessageType = ChatBubbleMessageType_Send
            }else{
                message.bubbleMessageType = ChatBubbleMessageType_Receiving
            }
            message.messageState = ChatSendMessageType_Successed
                        
            self.addChatMessageWithMessage(message, true)
            break
        case "1":
            break
        case "2":
            let message: ChatMessage = ChatMessageHelper.addPublicParameters()
            message.messageType = ChatMessageBodyType_image
            message.fileUrl = model.msg
//            message.imageWidth = size.width
//            message.imageHeight = size.height
            if model.from == mUserId {
                message.bubbleMessageType = ChatBubbleMessageType_Send
            }else{
                message.bubbleMessageType = ChatBubbleMessageType_Receiving
            }
            message.messageState = ChatSendMessageType_Successed
            imageArray.append(model.msg ?? "")
            self.addChatMessageWithMessage(message, true)
            break
        case "3":
            let message:ChatMessage = ChatMessageHelper.addPublicParameters()
            message.messageType = ChatMessageBodyType_voice
            let array = model.msg?.components(separatedBy: "&time=")
            message.fileName = array?.first
            let dur = Int(array?.last ?? "") ?? 0
            message.audioDuration = "\(dur / 1000)"
            if model.from == mUserId {
                message.bubbleMessageType = ChatBubbleMessageType_Send
            }else{
                message.bubbleMessageType = ChatBubbleMessageType_Receiving
            }
            message.messageState = ChatSendMessageType_Successed
            self.addChatMessageWithMessage(message, true)
            break
        default:
            break
        }

    }
    
    func setHistoryMessage(list: [MessageModel]) {
        print(list)
        
        for model in list {
            let mUserId = Defaults[\.mUserId] ?? ""
            switch model.fileType {
            case "0":
                let message: ChatMessage = ChatMessageHelper.addPublicParameters()
                message.messageType = ChatMessageBodyType_text
                message.text = model.msg
                if model.from == mUserId {
                    message.bubbleMessageType = ChatBubbleMessageType_Send
                }else{
                    message.bubbleMessageType = ChatBubbleMessageType_Receiving
                }
                message.messageState = ChatSendMessageType_Successed
                self.addChatMessageWithMessage(message, true)
                break
            case "1":
                break
            case "2":
                let message: ChatMessage = ChatMessageHelper.addPublicParameters()
                message.messageType = ChatMessageBodyType_image
                message.fileUrl = model.msg
    //            message.imageWidth = size.width
    //            message.imageHeight = size.height
                if model.from == mUserId {
                    message.bubbleMessageType = ChatBubbleMessageType_Send
                }else{
                    message.bubbleMessageType = ChatBubbleMessageType_Receiving
                }
                imageArray.append(model.msg ?? "")
                message.messageState = ChatSendMessageType_Successed
                self.addChatMessageWithMessage(message, true)
                break
            case "3":
                let message:ChatMessage = ChatMessageHelper.addPublicParameters()
                message.messageType = ChatMessageBodyType_voice
                let array = model.msg?.components(separatedBy: "&time=")
                message.fileName = array?.first
                let dur = Int(array?.last ?? "") ?? 0
                message.audioDuration = "\(dur / 1000)"
                if model.from == mUserId {
                    message.bubbleMessageType = ChatBubbleMessageType_Send
                }else{
                    message.bubbleMessageType = ChatBubbleMessageType_Receiving
                }
                message.messageState = ChatSendMessageType_Successed
                self.addChatMessageWithMessage(message, true)
                break
            default:
                break
            }
        }
    }
    
    func didSelecteMenuItem(_ menuItem: ChatShareMenuItem!, index: Int) {
        switch menuItem.title {
        case "照片":
            self.chatInputView?.openPhoto()
            break
        case "拍摄":
            self.chatInputView?.openCarema()
            break
        case "位置":
            self.chatInputView?.openLocation()
            break
        case "名片":
            self.chatInputView?.openCard()
            break
        case "红包":
            self.chatInputView?.openRedPaper()
            break
        case "文件":
            self.chatInputView?.openFile()
            break
        default:
            break
        }
    }
    
    //MARK - ChatMessageCellDelegate
    func didSelect(with cell: ChatMessageTableViewCell!, type: ChatMessageClickType, message: ChatMessage!) {
        self.selectCell = cell
        
        //默认输入
        self.chatInputView?.inputType = ChatInputViewType_default
        
        switch type {
        case ChatMessageClickType_click_message:
            print("点击ChatMessageClickType_click_message")
            self.didSelectMessageWithMessage(message)
            break
        case ChatMessageClickType_long_message:
            print("点击ChatMessageClickType_long_message")
            self.becomeFirstResponder() // 这句很重要
            let item1 = UIMenuItem(title: "删除", action: #selector(deleteItem))
            let item2 = UIMenuItem(title: "复制", action: #selector(copyItem))
            let menuArr:[UIMenuItem] = [item1, item2]
            let point:CGPoint = CGPoint(x: cell.btnContent.centerX, y: cell.btnContent.y)
            ChatMenuController.show(with: cell, menuArr: menuArr, showPiont: point)
            break
        case ChatMessageClickType_click_head:
            print("点击ChatMessageClickType_click_head")
            break
        case ChatMessageClickType_long_head:
            print("点击ChatMessageClickType_long_head")
            break
        case ChatMessageClickType_click_retry:
            print("点击ChatMessageClickType_click_retry")
            self.resendChatMessageWithMessageId(message.messageId)
            break
        default:
            break
        }
    }
    
    @objc func deleteItem() {
        self.deleteChatMessageWithMessageId(self.selectCell?.messageFrame.message.messageId ?? "")
    }
    
    @objc func copyItem() {
        UIPasteboard.general.string = self.selectCell?.messageFrame.message.text
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    /// MARK - 删除聊天消息
    func deleteChatMessageWithMessageId(_ messageId: String) {
        //删除此条消息
        for (idx, obj) in dataSource.enumerated() {
            if obj.message.messageId == messageId {
                //删除数据源
                dataSource.remove(at: idx)
                self.dealTimeMassageDataWithCurrent(obj, idx)
            }
        }
    }
    
    func dealTimeMassageDataWithCurrent(_ messageFrame: ChatMessageFrame, _ idx: Int) {
        //操作的此条是显示时间的
        if messageFrame.showTime {
            if self.dataSource.count > idx {
                let frame:ChatMessageFrame = self.dataSource[idx]
                if frame.showTime {
                    self.timeArr.remove(at: idx)
                }else{
                    frame.showTime = true
                    frame.message.sendTime = messageFrame.message.sendTime
                    self.dataSource[idx].message = frame.message
                    self.timeArr.remove(at: idx)
                    self.timeArr[idx] = messageFrame.message.sendTime
                }
            }else{
                self.timeArr.remove(at: idx)
            }
        }else{
            self.timeArr.remove(at: idx)
        }
        print("self.timeArr = \(self.timeArr)")
        self.chatTableView.reloadData()
    }
}

extension SocketChatViewController {
    //点击消息处理
    func didSelectMessageWithMessage(_ message: ChatMessage) {
        var isRefresh:Bool = false
        //判断消息类型
        switch message.messageType {
        case ChatMessageBodyType_image: //图片
            print("点击了 --- 图片消息")
            
            let browser:SDPhotoBrowser = SDPhotoBrowser()
            browser.currentImageIndex = 2 //当前需要展示图片的index
            browser.imageCount = self.imageArray.count //原图的数量
            browser.delegate = self //代理
            browser.show() //展示图片浏览器
            
            break
        case ChatMessageBodyType_voice://语音
            print("点击了 --- 语音消息")
            
            
//            let audio:ChatAudioPlayerHelper = ChatAudioPlayerHelper.shareInstance() as! ChatAudioPlayerHelper
//            audio.delegate = self
            let cell:ChatAudioTableViewCell = self.selectCell as! ChatAudioTableViewCell
            let UrlStr = message.fileName
            
            //创建媒体资源管理对象
            self.palyerItem = AVPlayerItem(url: NSURL(string:UrlStr!)! as URL)
            //创建ACplayer：负责视频播放
            self.player = AVPlayer.init(playerItem: self.palyerItem)
            
//            NotificationCenter.default.addObserver(self, selector: #selector(self.Finished) , name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.palyerItem)
            
            
            
            //如果此条正在播放则停止
            if cell.isPlaying {
                //正在播放
                cell.isPlaying = false
                self.player.pause()
//                audio.stopAudio()//停止
            }else{
                //未播放
                cell.isPlaying = true
                self.player.play()
//                audio.managerAudio(withFileArr: [message], isClear: true)
            }
//
            if message.messageRead {
                isRefresh = true
            }
            break
        case ChatMessageBodyType_location://位置
            let location = ChatMessageLocationViewController()
            location.message = message
            location.locType = ChatMessageLocationType_Look
            self.navigationController?.pushViewController(location, animated: true)
            break
        case ChatMessageBodyType_video://视频
            print("点击了 --- 视频消息")
            /// 本地路径
            let videoPath = ChatFileHelper.getFilePath(withName: message.fileName, type: ChatMessageFileType_video)!
            var player: AVPlayer?
            if FileManager.default.fileExists(atPath: videoPath) {
                player = AVPlayer.init(url: URL(fileURLWithPath: videoPath))
            }else{
                guard let url = message.fileUrl else { return  }
                player = AVPlayer.init(url: URL(string: url)!)
            }
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.navigationController?.pushViewController(playerViewController, animated: true)
            playerViewController.player?.play()
            break
        case ChatMessageBodyType_card://名片
            print("点击了 --- 名片消息")
            break
        case ChatMessageBodyType_redPaper://红包
            print("点击了 --- 红包消息")
            if !message.isReceive {
                message.isReceive = true
                isRefresh = true
            }
            break
        case ChatMessageBodyType_gif://gif
            print("点击了 --- gif消息")
            break
        default:
            break
        }
        
        //修改消息状态
        message.messageRead = true
        
        //刷新
        if isRefresh {
            self.chatTableView.reloadData()
        }
    }
    
    /// 重发聊天消息
    func resendChatMessageWithMessageId(_ messageId: String) {
        for (idx, obj) in dataSource.enumerated() {
            if obj.message.messageId == messageId {
                // 删除之前的数据
                self.dataSource.remove(at: idx)
                
                //添加公共配置
                let model:ChatMessage = ChatMessageHelper.addPublicParameters(with: obj.message)
                
                //模拟数据
                model.messageState = ChatSendMessageType_Successed
                model.bubbleMessageType = ChatBubbleMessageType_Send
                
                //添加消息到聊天界面
                self.addChatMessageWithMessage(model, true)
            }
        }
    }
}

/// MARK - 数据管理
extension SocketChatViewController {
    func addChatMessageWithMessage(_ message: ChatMessage, _ isBottom: Bool) {
        let messageFrame = ChatMessageFrame()
        //////////
        if self.timeArr.count > 0 {
            message.sendTime = ChatMessageHelper.getTimeWithZone()
            messageFrame.showTime = ChatMessageHelper.isShowTime(withTime: message.sendTime, setTime: self.timeArr.last)
            self.timeArr.append(message.sendTime)
        }else{
            message.sendTime = ChatMessageHelper.getTimeWithZone()
            messageFrame.showTime = ChatMessageHelper.isShowTime(withTime: message.sendTime, setTime: "2021-05-26-06-53-19-599")
            self.timeArr.append(message.sendTime)
        }
        
        message.userName = "哈哈哈"
        messageFrame.showName = true
        
        messageFrame.message = message
                
        self.dataSource.append(messageFrame)
        self.chatTableView.reloadData()
        
        if isBottom {
            //滚动到底部
            self.tableViewScrollToBottom()
        }
    }
    
    @objc func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            /// 获取刷新数据
            let temp:[ChatMessageFrame] = self.loadMeaaageDataWithNum(10)
            if temp.count > 0 {
                for i in 0..<temp.count {
                    /// 插入数据
                    self.dataSource.insert(temp[i], at: 0)
                }
                self.chatTableView.reloadData()
                self.tableViewScrollToIndex(temp.count)
            }
            self.refresh?.endRefreshing()
        }
    }
    
    func loadMeaaageDataWithNum(_ num: Int) -> [ChatMessageFrame] {
        var temp:[ChatMessageFrame] = []
        for i in 0..<num {
            var message = ChatMessage()
            let messageFrame = ChatMessageFrame()
            switch i % 8 {
            case 0:
                message = self.getTextMessage()
                break
            case 1:
                message = self.getImageMessage()
                break
            case 2:
                message = self.getVideoMessage()
                break
            case 3:
                message = self.getVoiceMessage()
                break
            case 4:
                message = self.getLocationMessage()
                break
            case 5:
                message = self.getCardMessage()
                break
            case 6:
                message = self.getNoteMessage()
                break
            case 7:
                message = self.getRedPackageMessagee()
                break
            case 8:
                message = self.getGifMessage()
                break
            default:
                message = self.getTextMessage()
                break
            }
            message.messageState = ChatSendMessageType_Successed
            messageFrame.message = message
            temp.append(messageFrame)
        }
        return temp
    }
    
    /// 获取文本
    func getTextMessage() -> ChatMessage {
        let message:ChatMessage = ChatMessageHelper.addPublicParameters()
        message.messageType = ChatMessageBodyType_text
        message.text = "https://github.com/CGXL"
        return message
    }
    
    /// 获取图片
    func getImageMessage() -> ChatMessage {
        let message:ChatMessage = ChatMessageHelper.addPublicParameters()
        message.messageType = ChatMessageBodyType_image
        message.fileName = "headImage"
        message.imageWidth = 150
        message.imageHeight = 200
        return message
    }
    
    /// 获取视频
    func getVideoMessage() -> ChatMessage {
        let message:ChatMessage = ChatMessageHelper.addPublicParameters()
        message.messageType = ChatMessageBodyType_video
        message.fileName = "guideMovie1"
        return message
    }
    
    /// 获取语音
    func getVoiceMessage() -> ChatMessage {
        let message:ChatMessage = ChatMessageHelper.addPublicParameters()
        message.messageType = ChatMessageBodyType_voice
        message.fileName = String(format: "%u", arc4random()%1000000)
        message.audioDuration = "2"
        return message
    }
    
    /// 获取位置
    func getLocationMessage() -> ChatMessage {
        let message:ChatMessage = ChatMessageHelper.addPublicParameters()
        message.messageType = ChatMessageBodyType_location
        message.locationName = "中国"
        message.lon = 120.21937542
        message.lat = 30.25924446
        return message
    }
    
    /// 获取名片
    func getCardMessage() -> ChatMessage {
        let message:ChatMessage = ChatMessageHelper.addPublicParameters()
        message.messageType = ChatMessageBodyType_card
        message.card = "哦哦"
        return message
    }
    
    /// 获取通知
    func getNoteMessage() -> ChatMessage {
        let message:ChatMessage = ChatMessageHelper.addPublicParameters()
        message.messageType = ChatMessageBodyType_note
        message.note = "我的Github地址 https://github.com/CGXL 欢迎关注"
        message.messageState = ChatSendMessageType_Successed
        return message
    }
    
    /// 获取红包
    func getRedPackageMessagee() -> ChatMessage {
        let message:ChatMessage = ChatMessageHelper.addPublicParameters()
        message.messageType = ChatMessageBodyType_redPaper
        message.redPackage = "恭喜发财"
        return message
    }
    
    /// 获取动图
    func getGifMessage() -> ChatMessage {
        let message:ChatMessage = ChatMessageHelper.addPublicParameters()
        message.messageType = ChatMessageBodyType_gif
        message.gifName = "诱惑.gif"
        message.gifWidth = 100
        message.gifHeight = 100
        return message
    }
}

extension SocketChatViewController: SDPhotoBrowserDelegate {
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return UIImage()
    }
    
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        let url = URL(string: imageArray[index])
        return url
        
    }
}

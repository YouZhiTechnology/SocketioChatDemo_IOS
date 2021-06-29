//
//  SwiftChatViewController.swift
//  ChatUIDemo
//
//  Created by youzhi-air5 on 2021/5/21.
//

import UIKit
import SwiftyUserDefaults

class SwiftChatViewController: UIViewController , ChatMessageInputViewDelegate, SHChatMessageCellDelegate, ChatAudioPlayerHelperDelegate {
    func totalCount(count: String) {
        
    }

    var dataArray:[MessageModel] = []
    
    var chatInputView:ChatMessageInputView?
    
    var shareMenuItems:[ChatShareMenuItem] = []
        
    var dataSource:[ChatMessageFrame] = []
    
    var sessionId:String = ""
    
    var toId:String = ""
    
    var player : AVPlayer!
    
    var palyerItem : AVPlayerItem!

    
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
                    message.bubbleMessageType = SHBubbleMessageType_Send
                }else{
                    message.bubbleMessageType = SHBubbleMessageType_Receiving
                }
                message.messageState = SHSendMessageType_Successed
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
                    message.bubbleMessageType = SHBubbleMessageType_Send
                }else{
                    message.bubbleMessageType = SHBubbleMessageType_Receiving
                }
                imageArray.append(model.msg ?? "")
                message.messageState = SHSendMessageType_Successed
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
                    message.bubbleMessageType = SHBubbleMessageType_Send
                }else{
                    message.bubbleMessageType = SHBubbleMessageType_Receiving
                }
                message.messageState = SHSendMessageType_Successed
                self.addChatMessageWithMessage(message, true)
                break
            default:
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IMManager.shared.delegate = self
//        IMManager.shared.connect()
        
        
    }

    /// MARK - 配置参数
    func config() {
        // MARKV --
        /// 下方输入框
        chatInputView = ChatMessageInputView()
        self.view.addSubview(chatInputView!)
        chatInputView?.frame = CGRect(x: 0, y: kScreenHeight - kSHInPutHeight - kSHBottomSafe, width: kScreenWidth, height: kSHInPutHeight)
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
        
    }
    
    @objc func click() {
        //默认输入
        self.chatInputView?.inputType = SHInputViewType_default
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
        tableView.register(ChatImageTableViewCell.self, forCellReuseIdentifier: "ChatImageTableViewCell")
        tableView.register(ChatFileTableViewCell.self, forCellReuseIdentifier: "ChatFileTableViewCell")
        tableView.estimatedRowHeight = 0
        tableView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleWidth ]
        return tableView
    }()
    
}

extension SwiftChatViewController: UITableViewDelegate, UITableViewDataSource {
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
        case ChatMessageBodyType_image: //图片
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatImageTableViewCell", for: indexPath) as! ChatImageTableViewCell
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

extension SwiftChatViewController {
    // MARK - ScrollVIewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //默认输入
        self.chatInputView?.inputType = SHInputViewType_default
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

// MARK - 发送
extension SwiftChatViewController: MessageProcessingProtocol {
    // MARK -- ChatMessageInputViewDelegate
    //发送文本
    func chatMessage(withSendText text: String!) {
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
    
    func newMessage(model: MessageModel) {
        let mUserId = Defaults[\.mUserId] ?? ""
        switch model.fileType {
        case "0":
            let message: ChatMessage = ChatMessageHelper.addPublicParameters()
            message.messageType = ChatMessageBodyType_text
            message.text = model.msg
            if model.from == mUserId {
                message.bubbleMessageType = SHBubbleMessageType_Send
            }else{
                message.bubbleMessageType = SHBubbleMessageType_Receiving
            }
            message.messageState = SHSendMessageType_Successed
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
                message.bubbleMessageType = SHBubbleMessageType_Send
            }else{
                message.bubbleMessageType = SHBubbleMessageType_Receiving
            }
            message.messageState = SHSendMessageType_Successed
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
                message.bubbleMessageType = SHBubbleMessageType_Send
            }else{
                message.bubbleMessageType = SHBubbleMessageType_Receiving
            }
            message.messageState = SHSendMessageType_Successed
            self.addChatMessageWithMessage(message, true)
            break
        default:
            break
        }
        
    }
}

// MARK - 重写
extension SwiftChatViewController {
    func toolbarHeightChange() {
        //改变聊天界面高度
        self.chatTableView.height = self.chatInputView?.y ?? 0
        self.view.layoutIfNeeded()
        //滚动到底部
        self.tableViewScrollToBottom()
    }
    
    func didSelecteMenuItem(_ menuItem: ChatShareMenuItem!, index: Int) {
        switch menuItem.title {
        case "照片":
            self.chatInputView?.openPhoto()
            break
        default:
            break
        }
    }
    
    //MARK - SHChatMessageCellDelegate
    func didSelect(with cell: ChatMessageTableViewCell!, type: ChatMessageClickType, message: ChatMessage!) {
        self.selectCell = cell
        
        //默认输入
        self.chatInputView?.inputType = SHInputViewType_default
        
        switch type {
        case ChatMessageClickType_click_message:
            print("点击ChatMessageClickType_click_message")
            self.didSelectMessageWithMessage(message)
            break
        default:
            break
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
//    func dealTimeMassageDataWithCurrent(_ messageFrame: ChatMessageFrame, _ idx: Int) {
//        //操作的此条是显示时间的
//        if messageFrame.showTime {
//            if self.dataSource.count > idx {
//                let frame:ChatMessageFrame = self.dataSource[idx]
//                if frame.showTime {
//                    self.timeArr.remove(at: idx)
//                }else{
//                    frame.showTime = true
//                    frame.message.sendTime = messageFrame.message.sendTime
//                    self.dataSource[idx].message = frame.message
//                    self.timeArr.remove(at: idx)
//                    self.timeArr[idx] = messageFrame.message.sendTime
//                }
//            }else{
//                self.timeArr.remove(at: idx)
//            }
//        }else{
//            self.timeArr.remove(at: idx)
//        }
//        print("self.timeArr = \(self.timeArr)")
//        self.chatTableView.reloadData()
//    }
}

extension SwiftChatViewController {
    
    //点击消息处理
    func didSelectMessageWithMessage(_ message: ChatMessage) {
        var isRefresh:Bool = false
        //判断消息类型
        switch message.messageType {
        case ChatMessageBodyType_image: //图片
            print("点击了 --- 图片消息")
            
            let browser:SDPhotoBrowser = SDPhotoBrowser()
            browser.currentImageIndex = 0 //当前需要展示图片的index
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
    
   
}

/// MARK - 数据管理
extension SwiftChatViewController {
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
        messageFrame.showTime = false
        messageFrame.message = message
        
        
        
        self.dataSource.append(messageFrame)
        self.chatTableView.reloadData()
        
        if isBottom {
            //滚动到底部
            self.tableViewScrollToBottom()
        }
    }
    
}

extension SwiftChatViewController: SDPhotoBrowserDelegate {
    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
        return UIImage()
    }
    
    func photoBrowser(_ browser: SDPhotoBrowser!, highQualityImageURLFor index: Int) -> URL! {
        let url = URL(string: imageArray[index])
        return url
        
    }
}

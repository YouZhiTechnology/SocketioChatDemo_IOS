//
//  ChatMessageViewController.m
//  ChatUIDemo
//
//  Created by GXL on 2018/6/5.
//  Copyright © 2018年 GXL. All rights reserved.
//

#import "ChatMessageViewController.h"
#import "ChatMessageInputView.h"
#import "ChatAudioTableViewCell.h"

#import "ChatMessageLocationViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ChatMessageViewController ()<
ChatMessageInputViewDelegate,//输入框代理
ChatMessageCellDelegate,//Cell代理
ChatAudioPlayerHelperDelegate,//语音播放代理
UITableViewDelegate,
UITableViewDataSource
>
{
    //复制按钮
    UIMenuItem * _copyMenuItem;
    //删除按钮
    UIMenuItem * _deleteMenuItem;
}

//聊天界面
@property (nonatomic, strong) UITableView *chatTableView;
//下方工具栏
@property (nonatomic, strong) ChatMessageInputView *chatInputView;
//背景图
@property (nonatomic, strong) UIImageView *bgImageView;
//未读
@property (nonatomic, strong) UIButton *unreadBtn;
//加载控件
@property (nonatomic, strong) UIRefreshControl *refresh;

//当前点击的Cell
@property (nonatomic, weak) ChatMessageTableViewCell *selectCell;

//数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

//显示的时间集合
@property (nonatomic, strong) NSMutableArray *timeArr;

@end

@implementation ChatMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化各个参数
    self.view.backgroundColor = kInPutViewColor;
    self.dataSource = [[NSMutableArray alloc]init];

    //配置参数
    [self config];
}

#pragma mark - 配置参数
- (void)config{
    
    //添加下方输入框
    [self.view addSubview:self.chatInputView];
    //添加聊天
    [self.view addSubview:self.chatTableView];
    //添加背景图
    [self.view addSubview:self.bgImageView];
    [self.view sendSubviewToBack:self.bgImageView];
    //添加加载
    self.chatTableView.refreshControl = self.refresh;
    //配置未读控件
    self.unreadBtn.tag = 20;
    [self configUnread:20];
    
    //滑到最下方
    [self tableViewScrollToBottom];
}

- (void)loadData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.dataSource.count) {
            
            //获取数据
            NSArray *temp = [self loadMeaaageDataWithNum:10 isLoad:YES];
            
            if (temp.count) {
                //插入数据
                 NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, temp.count)];
                [self.dataSource insertObjects:temp atIndexes:indexes];

                [self.chatTableView reloadData];
                //滚动到刷新位置
                [self tableViewScrollToIndex:temp.count];
            }
            
            //配置未读控件
            [self configUnread:(self.unreadBtn.tag - temp.count)];
            
        }else{
            
            //获取数据
            NSArray *temp = [self loadMeaaageDataWithNum:10 isLoad:NO];
            
            if (temp.count) {
                //添加数据
                [self.dataSource addObjectsFromArray:temp];
                
                [self.chatTableView reloadData];
                //滚动到最下方
                [self tableViewScrollToBottom];
            }
            
            //配置未读控件
            [self configUnread:(self.unreadBtn.tag - temp.count)];
        }
        
        [self.refresh endRefreshing];
    });
}

#pragma mark - 加载数据
- (NSArray <ChatMessageFrame *>*)loadMeaaageDataWithNum:(NSInteger)num isLoad:(BOOL)isLoad{
    
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    NSMutableArray *loadTimeArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < num; i++) {
        
        ChatMessage *message;
        
        switch (arc4random()%8) {
            case 0:
                message = [self getTextMessage];
                break;
            case 1:
                message = [self getVoiceMessage];
                break;
            case 2:
                message = [self getImageMessage];
                break;
            case 3:
                message = [self getVideoMessage];
                break;
            case 4:
                message = [self getLocationMessage];
                break;
            case 5:
                message = [self getNoteMessage];
                break;
            case 6:
                message = [self getRedPackageMessagee];
                break;
            case 7:
                message = [self getGifMessage];
                break;
            case 8:
                message = [self getCardMessage];
                break;
            default:
                message = [self getTextMessage];
                break;
        }
        
        message.messageState = ChatSendMessageType_Successed;
        
        ChatMessageFrame *messageFrame = [self dealDataWithMessage:message dateSoure:temp setTime:isLoad?loadTimeArr.lastObject:self.timeArr.lastObject];
        
        if (messageFrame) {//做添加
            
            if (messageFrame.showTime) {
                
                if (isLoad) {
                    [loadTimeArr addObject:message.sendTime];
                }else{
                    [self.timeArr addObject:message.sendTime];
                }
            }
            
            [temp addObject:messageFrame];
        }
    }
    
    if (loadTimeArr.count) {
        NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndex:0];
        [indexes addIndex:0];
        
        [self.timeArr insertObjects:loadTimeArr atIndexes:indexes];
    }
    
    return temp;
}

#pragma mark 获取文本
- (ChatMessage *)getTextMessage{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_text;
    message.text = @"https://github.com/CGXL";
    
    return message;
}

#pragma mark 获取图片
- (ChatMessage *)getImageMessage{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_image;
    message.fileName = @"headImage";
    message.imageWidth = 150;
    message.imageHeight = 200;
    
    return message;
}

#pragma mark 获取视频
- (ChatMessage *)getVideoMessage{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_video;
    message.fileName = @"123";
    
    return message;
}

#pragma mark 获取语音
- (ChatMessage *)getVoiceMessage{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_voice;
    message.fileName = [NSString stringWithFormat:@"%u",arc4random()%1000000];
    message.audioDuration = @"2";
    
    return message;
}

#pragma mark 获取位置
- (ChatMessage *)getLocationMessage{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_location;
    message.locationName = @"中国";
    message.lon = 120.21937542;
    message.lat = 30.25924446;
    
    return message;
}

#pragma mark 获取名片
- (ChatMessage *)getCardMessage{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_card;
    message.card = @"哦哦";
    
    return message;
}

#pragma mark 获取通知
- (ChatMessage *)getNoteMessage{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_note;
    message.note = @"我的Github地址 https://github.com/CGXL 欢迎关注";
    
    message.messageState = ChatSendMessageType_Successed;
    
    return message;
}

#pragma mark 获取红包
- (ChatMessage *)getRedPackageMessagee{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_redPaper;
    message.redPackage = @"恭喜发财";
    
    return message;
}

#pragma mark 获取动图
- (ChatMessage *)getGifMessage{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_gif;
    message.gifName = @"诱惑.gif";
    message.gifWidth = 100;
    message.gifHeight = 100;
    
    return message;
}

#pragma mark 未读按钮点击
- (void)unreadClick:(UIButton *)btn{
    
    NSLog(@"增加%ld条",(long)btn.tag);
    
    //默认输入
    self.chatInputView.inputType = ChatInputViewType_default;
    
    //获取数据
    NSArray *temp = [self loadMeaaageDataWithNum:btn.tag isLoad:YES];
    
    if (temp.count) {
        //插入数据
        NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, temp.count)];
        [self.dataSource insertObjects:temp atIndexes:indexes];
        
        [self.chatTableView reloadData];
        //滚动到刷新位置
        [self tableViewScrollToIndex:temp.count];
    }
    
    [self configUnread:0];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatMessageFrame *messageFrame = self.dataSource[indexPath.row];
    return messageFrame.cell_h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatMessageFrame *messageFrame = self.dataSource[indexPath.row];
    
    NSString *reuseIdentifier = @"ChatMessageTableViewCell";
    
    switch (messageFrame.message.messageType) {
        case ChatMessageBodyType_text://文本
        {
            reuseIdentifier = @"ChatTextTableViewCell";
        }
            break;
        case ChatMessageBodyType_voice://语音
        {
            reuseIdentifier = @"ChatAudioTableViewCell";
        }
            break;
        case ChatMessageBodyType_location://位置
        {
            reuseIdentifier = @"ChatLocationTableViewCell";
        }
            break;
        case ChatMessageBodyType_image://图片
        {
            reuseIdentifier = @"ChatImageTableViewCell";
        }
            break;
        case ChatMessageBodyType_note://通知
        {
            reuseIdentifier = @"ChatNoteTableViewCell";
        }
            break;
        case ChatMessageBodyType_card://名片
        {
            reuseIdentifier = @"ChatCardTableViewCell";
        }
            break;
        case ChatMessageBodyType_gif://Gif
        {
            reuseIdentifier = @"ChatGifTableViewCell";
        }
            break;
        case ChatMessageBodyType_redPaper://红包
        {
            reuseIdentifier = @"ChatRedPaperTableViewCell";
        }
            break;
        case ChatMessageBodyType_video://视频
        {
            reuseIdentifier = @"ChatVideoTableViewCell";
        }
            break;
        case ChatMessageBodyType_file://文件
        {
            reuseIdentifier = @"ChatFileTableViewCell";
        }
            break;
        default:
            break;
    }
    
    ChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[NSClassFromString(reuseIdentifier) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.delegate = self;
    }
    
    cell.messageFrame = messageFrame;
    
    return cell;
}

#pragma mark - ScrollVIewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //默认输入
    self.chatInputView.inputType = ChatInputViewType_default;
}

#pragma mark - ChatMessageInputViewDelegate
#pragma mark 发送文本
- (void)chatMessageWithSendText:(NSString *)text{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_text;
    message.text = text;
    
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

#pragma mark 发送图片
- (void)chatMessageWithSendImage:(NSString *)imageName size:(CGSize)size{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_image;
    message.fileName = imageName;
    message.imageWidth = size.width;
    message.imageHeight = size.height;
    
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

#pragma mark 发送视频
- (void)chatMessageWithSendVideo:(NSString *)videoName fileSize:(NSString *)fileSize duration:(NSString *)duration size:(CGSize)size{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_video;
    message.fileName = videoName;
    message.fileSize = fileSize;
    message.videoWidth = size.width;
    message.videoHeight = size.height;
    message.videoDuration = duration;
    
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

#pragma mark 发送音频
- (void)chatMessageWithSendAudio:(NSString *)audioName duration:(NSInteger)duration{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_voice;
    message.fileName = audioName;
    message.audioDuration = [NSString stringWithFormat:@"%ld",(long)duration];
    
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

#pragma mark 发送位置
- (void)chatMessageWithSendLocation:(NSString *)locationName lon:(CGFloat)lon lat:(CGFloat)lat{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_location;
    message.locationName = locationName;
    message.lon = lon;
    message.lat = lat;
    
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

#pragma mark 发送名片
- (void)chatMessageWithSendCard:(NSString *)card{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_card;
    message.card = card;
    
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

#pragma mark 发送通知
- (void)chatMessageWithSendNote:(NSString *)note{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_note;
    message.note = note;
    
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

#pragma mark 发送红包
- (void)chatMessageWithSendRedPackage:(NSString *)redPackage{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_redPaper;
    message.redPackage = redPackage;
    
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

#pragma mark 发送动图
- (void)chatMessageWithSendGif:(NSString *)gifName size:(CGSize)size{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_gif;
    message.gifName = gifName;
    message.gifWidth = size.width;
    message.gifHeight = size.height;
    
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

#pragma mark 发送文件
- (void)chatMessageWithSendFile:(NSString *)fileName displayName:(NSString *)displayName fileSize:(NSString *)fileSize{
    
    ChatMessage *message = [ChatMessageHelper addPublicParameters];
    
    message.messageType = ChatMessageBodyType_file;
    message.fileName = fileName;
    message.displayName = displayName;
    message.fileSize = fileSize;
    //添加到聊天界面
    [self addChatMessageWithMessage:message isBottom:YES];
}

#pragma mark 工具栏高度改变
- (void)toolbarHeightChange{
    
    //改变聊天界面高度
    self.chatTableView.height = self.chatInputView.y;
    [self.view layoutIfNeeded];
    //滚动到底部
    [self tableViewScrollToBottom];
}


#pragma mark 下方菜单点击
- (void)didSelecteMenuItem:(ChatShareMenuItem *)menuItem index:(NSInteger)index{
    
    if ([menuItem.title isEqualToString:@"照片"]){
        
        [self.chatInputView openPhoto];
    }else if ([menuItem.title isEqualToString:@"拍摄"]){
        
        [self.chatInputView openCarema];
    }else if ([menuItem.title isEqualToString:@"位置"]){
        
        [self.chatInputView openLocation];
    }else if ([menuItem.title isEqualToString:@"名片"]){
        
        [self.chatInputView openCard];
    }else if ([menuItem.title isEqualToString:@"红包"]) {
        
        [self.chatInputView openRedPaper];
    }else if ([menuItem.title isEqualToString:@"文件"]) {
        
        [self.chatInputView openFile];
    }
}

#pragma mark - ChatMessageCellDelegate
- (void)didSelectWithCell:(ChatMessageTableViewCell *)cell type:(ChatMessageClickType)type message:(ChatMessage *)message{
    
    self.selectCell = cell;
    //默认输入
    self.chatInputView.inputType = ChatInputViewType_default;
    
    switch (type) {
        case ChatMessageClickType_click_message://点击消息
        {
            NSLog(@"点击消息");
            //点击消息
            [self didSelectMessageWithMessage:message];
        }
            break;
        case ChatMessageClickType_long_message://长按消息
        {
            NSLog(@"长按消息");
            //设置菜单内容
            NSArray *menuArr = [self getMenuControllerWithMessage:message];
            //显示菜单
            [ChatMenuController showMenuControllerWithView:cell menuArr:menuArr showPiont:cell.tapPoint];
            
            cell.tapPoint = CGPointZero;
        }
            break;
        case ChatMessageClickType_click_head://点击头像
        {
            NSLog(@"点击头像");
        }
            break;
        case ChatMessageClickType_long_head://长按头像
        {
            NSLog(@"长按头像");
        }
            break;
        case ChatMessageClickType_click_retry://点击重发
        {
            NSLog(@"点击重发");
            [self resendChatMessageWithMessageId:message.messageId];
        }
            break;
        default:
            break;
    }
}

#pragma mark 点击消息处理
- (void)didSelectMessageWithMessage:(ChatMessage *)message{
    
    BOOL isRefresh = NO;
    //判断消息类型
    switch (message.messageType) {
        case ChatMessageBodyType_image://图片
        {
            NSLog(@"点击了 --- 图片消息");
        }
            break;
        case ChatMessageBodyType_voice://语音
        {
            NSLog(@"点击了 --- 语音消息");
            ChatAudioPlayerHelper *audio = [ChatAudioPlayerHelper shareInstance];
            audio.delegate = self;
            ChatAudioTableViewCell *cell = (ChatAudioTableViewCell *)self.selectCell;
            
            //如果此条正在播放则停止
            if (cell.isPlaying) {
                //正在播放
                cell.isPlaying = NO;
                [audio stopAudio];//停止
            }else{
                //未播放
                cell.isPlaying = YES;
                [audio managerAudioWithFileArr:@[message] isClear:YES];
            }
            if (message.messageRead) {
                isRefresh = YES;
            }
        }
            break;
        case ChatMessageBodyType_location://位置
        {
            NSLog(@"点击了 --- 位置消息");
            //跳转地图界面
            ChatMessageLocationViewController *location = [[ChatMessageLocationViewController alloc]init];
            location.message = message;
            location.locType = ChatMessageLocationType_Look;
            [self.navigationController pushViewController:location animated:YES];
        }
            break;
        case ChatMessageBodyType_video://视频
        {
            NSLog(@"点击了 --- 视频消息");
            //本地路径
            NSString *videoPath = [ChatFileHelper getFilePathWithName:message.fileName type:ChatMessageFileType_video];
            
            AVPlayer *player;
            if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {//如果本地路径存在
                player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:videoPath]];
            }else{//使用URL
                player = [AVPlayer playerWithURL:[NSURL URLWithString:message.fileUrl]];
            }
            
            AVPlayerViewController *playerViewController = [AVPlayerViewController new];
            playerViewController.player = player;
            [self.navigationController pushViewController:playerViewController animated:YES];
            [playerViewController.player play];
        }
            break;
        case ChatMessageBodyType_card://名片
        {
            NSLog(@"点击了 --- 名片消息");
        }
            break;
        case ChatMessageBodyType_redPaper://红包
        {
            NSLog(@"点击了 --- 红包消息");
    
            if (!message.isReceive) {
                message.isReceive = YES;
                isRefresh = YES;
            }
        }
            break;
        case ChatMessageBodyType_gif://Gif
        {
            NSLog(@"点击了 --- gif消息");
        }
            break;
        default:
            break;
    }
    
    //修改消息状态
    message.messageRead = YES;
    
    //刷新
    if (isRefresh) {
        [self.chatTableView reloadData];
    }
}

#pragma mark 获取长按菜单内容
- (NSArray *)getMenuControllerWithMessage:(ChatMessage *)message{
    
    //初始化列表
    if (!_copyMenuItem) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyItem)];
    }
    if (!_deleteMenuItem) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteItem)];
    }
    
    NSMutableArray *menuArr = [[NSMutableArray alloc]init];
    //复制
    if (message.messageType == ChatMessageBodyType_text) {//文本有复制
        //添加复制
        [menuArr addObject:_copyMenuItem];
    }
    //添加删除
    [menuArr addObject:_deleteMenuItem];
    
    return menuArr;
}

#pragma mark 添加第一响应
- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - 长按菜单内容点击
#pragma mark 复制
- (void)copyItem{
    [UIPasteboard generalPasteboard].string = self.selectCell.messageFrame.message.text;
}

#pragma mark 删除
- (void)deleteItem{
    NSLog(@"删除");
    
    //删除消息
    [self deleteChatMessageWithMessageId:self.selectCell.messageFrame.message.messageId];
}

#pragma mark - ChatAudioPlayerHelperDelegate
#pragma mark 开始播放
- (void)audioPlayerStartPlay:(NSString *)playMark{
    
    for (ChatAudioTableViewCell *cell in self.chatTableView.visibleCells) {
        if ([cell isKindOfClass:[ChatAudioTableViewCell class]]) {
            if ([cell.messageFrame.message.messageId isEqualToString:playMark]) {
                [cell playVoiceAnimation];
            }else{
                [cell stopVoiceAnimation];
            }
            break;
        }
    }
}

#pragma mark 结束播放
- (void)audioPlayerEndPlay:(NSString *)playMark error:(NSError *)error{
    if (error) {
        NSLog(@"音频播放错误：%@",error.description);
    }
    for (ChatAudioTableViewCell *cell in self.chatTableView.visibleCells) {
        if ([cell isKindOfClass:[ChatAudioTableViewCell class]]) {
            if ([cell.messageFrame.message.messageId isEqualToString:playMark]) {
                [cell stopVoiceAnimation];
            }
            break;
        }
    }
}

#pragma mark - 数据处理
#pragma mark 添加到下方聊天界面
- (void)addChatMessageWithMessage:(ChatMessage *)message isBottom:(BOOL)isBottom{
    
    //模拟发送状态
    if (message.messageState == ChatSendMessageType_Sending) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            message.messageState = ChatSendMessageType_Failed;
            [self addChatMessageWithMessage:message isBottom:NO];
        });
    }
    
    //判断是否重复
    ChatMessageFrame *messageFrame = [self dealDataWithMessage:message dateSoure:self.dataSource setTime:self.timeArr.lastObject];
    
    if (messageFrame) {//做添加
        
        if (messageFrame.showTime) {
            [self.timeArr addObject:message.sendTime];
        }
        
        [self.dataSource addObject:messageFrame];
    }
    
    [self.chatTableView reloadData];
    
    if (isBottom) {
        //滚动到底部
        [self tableViewScrollToBottom];
    }
    
    //发送到消息服务器(资源文件在这里上传) 上传完毕更新数据源 主要是本地数据库的数据 界面资源用本地就可以
    //文件路径
    if (message.fileName.length) {
        NSString *path = [ChatFileHelper getFilePathWithName:message.fileName type:ChatMessageFileType_file];
        //上传
        message.fileUrl = path;
    }
    
}

#pragma mark 处理数据属性
- (ChatMessageFrame *)dealDataWithMessage:(ChatMessage *)message dateSoure:(NSMutableArray *)dataSoure setTime:(NSString *)setTime{
    
    ChatMessageFrame *messageFrame = [[ChatMessageFrame alloc]init];
    
    //是否需要添加
    __block BOOL isAdd = YES;
    
    //为了判断是否有重复的数据
    [dataSoure enumerateObjectsUsingBlock:^(ChatMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([message.messageId isEqualToString:obj.message.messageId]) {//同一条消息
             *stop = YES;
            
            if ([message.sendTime isEqualToString:obj.message.sendTime]) {//时间相同做刷新
                
                isAdd = NO;
                
                messageFrame.showTime = obj.showTime;
                messageFrame.showName = obj.showName;
                
                [messageFrame setMessage:message];
                [dataSoure replaceObjectAtIndex:idx withObject:messageFrame];
                
            }else{//时间不同做添加
                
                [dataSoure removeObject:obj];
            }
        }
    }];
    
    //已经更新则不用进行处理
    if (isAdd) {
        
        //是否显示时间
        messageFrame.showTime = [ChatMessageHelper isShowTimeWithTime:message.sendTime setTime:setTime];
        
        [messageFrame setMessage:message];
        return messageFrame;
    }
    
    return nil;
}

#pragma mark 删除聊天消息消息
- (void)deleteChatMessageWithMessageId:(NSString *)messageId{
    
    //删除此条消息
    [self.dataSource enumerateObjectsUsingBlock:^(ChatMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop){
        
        if ([obj.message.messageId isEqual:messageId]) {
            *stop = YES;
        
            //删除数据源
            [self.dataSource removeObject:obj];
            
            //处理时间操作
            [self dealTimeMassageDataWithCurrent:obj idx:idx];
        }
    }];
    
    [self.chatTableView reloadData];
}

#pragma mark 重发聊天消息消息
- (void)resendChatMessageWithMessageId:(NSString *)messageId{
    
    [self.dataSource enumerateObjectsUsingBlock:^(ChatMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.message.messageId isEqualToString:messageId]) {
            *stop = YES;
            
            //删除之前数据
            [self.dataSource removeObject:obj];
            
            //处理时间操作
            [self dealTimeMassageDataWithCurrent:obj idx:idx];
            
            //添加公共配置
            ChatMessage *model = [ChatMessageHelper addPublicParametersWithMessage:obj.message];
            
            //模拟数据
            model.messageState = ChatSendMessageType_Successed;
            model.bubbleMessageType = ChatBubbleMessageType_Send;
            //添加消息到聊天界面
            [self addChatMessageWithMessage:model isBottom:YES];
        }
    }];
}

#pragma mark 处理时间操作
- (void)dealTimeMassageDataWithCurrent:(ChatMessageFrame *)current idx:(NSInteger)idx{
    
    //操作的此条是显示时间的
    if (current.showTime) {
        if (self.dataSource.count > idx) {//操作的是中间的
            
            ChatMessageFrame *frame = self.dataSource[idx];
            
            [self.timeArr enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:current.message.sendTime]) {
                    *stop = YES;
                    [self.timeArr replaceObjectAtIndex:idx withObject:frame.message.sendTime];
                }
            }];
            
            frame.showTime = YES;
            //重新计算高度
            [frame setMessage:frame.message];
            [self.dataSource replaceObjectAtIndex:idx withObject:frame];
            
        }else{//操作的是最后一条
            [self.timeArr removeObject:current.message.sendTime];
        }
    }
}

#pragma mark - 界面滚动
#pragma mark 处理是否滚动到底部
- (void)dealScrollToBottom{
    
    if (self.dataSource.count > 1) {
        
        //整个tableview的倒数第二个cell
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 2 inSection:0];
        ChatMessageTableViewCell *lastCell = (ChatMessageTableViewCell *)[self.chatTableView cellForRowAtIndexPath:indexPath];
        
        CGRect last_rect = [lastCell convertRect:lastCell.frame toView:self.chatTableView];
        
        if (last_rect.size.width) {
            //滚动到底部
            [self tableViewScrollToBottom];
        }
    }
}
#pragma mark 滚动最上方
- (void)tableViewScrollToTop{
    
    //界面滚动到指定位置
    [self tableViewScrollToIndex:0];
}

#pragma mark 滚动最下方
- (void)tableViewScrollToBottom{
    
    //界面滚动到指定位置
    [self tableViewScrollToIndex:self.dataSource.count - 1];
}

#pragma mark 滚动到指定位置
- (void)tableViewScrollToIndex:(NSInteger)index{

    @synchronized (self.dataSource) {
        
        if (self.dataSource.count > index) {
            
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

#pragma mark - 懒加载
#pragma mark 背景图片
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        //设置背景
        _bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _bgImageView.image = [UIImage imageNamed:@"message_bg.jpeg"];
        _bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _bgImageView;
}

#pragma mark 聊天界面
- (UITableView *)chatTableView{
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, self.chatInputView.y) style:UITableViewStylePlain];
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTableView.backgroundColor = [UIColor clearColor];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        _chatTableView.estimatedRowHeight = 0;
        
        _chatTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _chatTableView;
}

#pragma mark 下方输入框
- (ChatMessageInputView *)chatInputView{
    
    if (!_chatInputView) {
        _chatInputView = [[ChatMessageInputView alloc]init];
        _chatInputView.frame = CGRectMake(0, self.view.height - kInPutHeight - kBottomSafe, kWidth, kInPutHeight);
        _chatInputView.delegate = self;
        _chatInputView.supVC = self;
        
        NSArray *moreItem = @[
            @{@"chat_more_pic" : @"照片"},
            @{@"chat_more_video" : @"拍摄"},
            @{@"chat_more_call" : @"通话"},
            @{@"chat_more_loc" : @"位置"},
            @{@"chat_more_red" : @"红包"},
            @{@"chat_more_card" : @"名片"},
            @{@"chat_more_file" : @"文件"},
        ];
        
        // 添加第三方接入数据
        NSMutableArray *shareMenuItems = [NSMutableArray array];
        
        //配置Item按钮
        [moreItem enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop)  {

            ChatShareMenuItem *item = [ChatShareMenuItem new];
            item.icon = [ChatFileHelper imageNamed:obj.allKeys[0]];
            item.title = obj.allValues[0];
            [shareMenuItems addObject:item];
        }];
        
        _chatInputView.shareMenuItems = shareMenuItems;
        [_chatInputView reloadView];
        
        if (kBottomSafe) {
      
        }
    }
    return _chatInputView;
}

#pragma mark 时间集合
- (NSMutableArray *)timeArr{
    if (!_timeArr) {
        _timeArr = [[NSMutableArray alloc]init];
    }
    return _timeArr;
}

#pragma mark 加载
- (UIRefreshControl *)refresh{
    if (!_refresh) {
        _refresh = [[UIRefreshControl alloc]init];
        [_refresh addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    }
    return _refresh;
}

#pragma mark 未读按钮
- (UIButton *)unreadBtn{
    if (!_unreadBtn) {
        _unreadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _unreadBtn.frame = CGRectMake(kWidth - 135, 20 + 44 + kTopSafe, 135, 35);
        
        _unreadBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_unreadBtn setTitleColor:[UIColor redColor] forState:0];
        [_unreadBtn setBackgroundImage:[ChatFileHelper imageNamed:@"unread_bg.png"] forState:0];
        [_unreadBtn addTarget:self action:@selector(unreadClick:) forControlEvents:UIControlEventTouchUpInside];
        _unreadBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:_unreadBtn];
    }
    
    return _unreadBtn;
}

#pragma mark 配置未读控件
- (void)configUnread:(NSInteger)unreadNum{
    
    if (!self.unreadBtn.tag) {
        return;
    }
    
    if (unreadNum > 0) {//只有大于一屏的时候才显示未读控件
        
        self.unreadBtn.tag = unreadNum;
        if (unreadNum > 99) {
            [self.unreadBtn setTitle:@"99+ 条新消息 " forState:0];
        }else{
            [self.unreadBtn setTitle:[NSString stringWithFormat:@"%ld 条新消息 ",(long)unreadNum] forState:0];
        }
    }else{
        
        self.unreadBtn.tag = 0;
        [self.unreadBtn removeFromSuperview];
    }
}

#pragma mark - VC界面周期函数
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = @"晶晶";
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.selectCell = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 销毁
- (void)dealloc{
    [self.chatInputView clear];
}

@end

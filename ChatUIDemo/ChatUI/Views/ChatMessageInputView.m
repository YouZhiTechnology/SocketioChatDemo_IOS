//
//  ChatMessageInputView.m
//  SHChatUI
//
//  Created by GXL on 2018/6/5.
//  Copyright © 2018年 GXL. All rights reserved.
//

#import "ChatMessageInputView.h"
#import <AVFoundation/AVFoundation.h>
#import "ChatMessageLocationViewController.h"
#import "ChatShortVideoViewController.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"

@interface ChatMessageInputView () <
UITextViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
ChatShareMenuViewDelegate,     //菜单代理
ChatAudioRecordHelperDelegate, //录音代理
UIDocumentPickerDelegate,
TZImagePickerControllerDelegate>

//改变输入状态按钮（语音、文字）
@property (nonatomic, strong) UIButton *changeBtn;
//表情按钮
@property (nonatomic, strong) UIButton *emojiBtn;
//菜单按钮
@property (nonatomic, strong) UIButton *menuBtn;
//输入背景
@property (nonatomic, strong) UIView *inputBg;
//语音输入按钮
@property (nonatomic, strong) UIButton *voiceBtn;
//文本输入框
@property (nonatomic, strong) ChatTextView *textView;

//其他输入控件
//表情控件
@property (nonatomic, strong) ChatEmotionKeyboard *emojiView;
//菜单控件
@property (nonatomic, strong) ChatShareMenuView *menuView;

//其他
@property (nonatomic, strong) ChatAudioRecordHelper *audioHelper;
@property (nonatomic, assign) CGFloat playTime;
@property (nonatomic, strong) NSTimer *playTimer;

@property (nonatomic, assign) CGFloat viewY;

@end

@implementation ChatMessageInputView

static CGFloat start_maxY;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, kWidth, 1000);
        view.backgroundColor = kInPutViewColor;
        [self addSubview:view];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //分割线
        self.layer.cornerRadius = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
        self.layer.borderWidth = 0.4;
        
        [self addKeyboardNote];
    }
    return self;
}

#pragma mark - 懒加载
#pragma mark 改变输入状态按钮（语音、文字）
- (UIButton *)changeBtn
{
    if (!_changeBtn)
    {
        ////改变输入状态按钮（语音、文字）
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBtn.size = kInPutIcon_size;
        _changeBtn.x = kInPutSpace;
        
        [_changeBtn setBackgroundImage:[ChatFileHelper imageNamed:@"chat_voice"] forState:UIControlStateNormal];
        [_changeBtn setBackgroundImage:[ChatFileHelper imageNamed:@"chat_keyboard"] forState:UIControlStateSelected];
        
        [_changeBtn addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _changeBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_changeBtn];
    }
    return _changeBtn;
}

#pragma mark 输入框背景
- (UIView *)inputBg
{
    if (!_inputBg)
    {
        _inputBg = [[UIView alloc] init];
        _inputBg.origin = CGPointMake(self.changeBtn.maxX + kInPutSpace, 5);
        _inputBg.backgroundColor = [UIColor whiteColor];
        _inputBg.layer.cornerRadius = 4;
        _inputBg.layer.masksToBounds = YES;
        _inputBg.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        _inputBg.layer.borderWidth = 1;
        _inputBg.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:_inputBg];
    }
    return _inputBg;
}

#pragma mark 文本输入框
- (ChatTextView *)textView
{
    if (!_textView)
    {
        _textView = [[ChatTextView alloc] init];
        _textView.delegate = self;
        _textView.textContainerInset = UIEdgeInsetsMake(6, 0, 0, 0);
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //UITextView内部判断send按钮是否可以用
        _textView.enablesReturnKeyAutomatically = YES;
        //frame
        _textView.height = ceil(_textView.font.lineHeight) + 3;
        _textView.y = (int)(self.inputBg.height - _textView.height)/2;
        _textView.x =  _textView.y;
        _textView.width = self.inputBg.width - 2*_textView.x;
        [self.inputBg addSubview:_textView];
    }
    return _textView;
}

#pragma mark 语音输入按钮
- (UIButton *)voiceBtn
{
    if (!_voiceBtn)
    {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceBtn.hidden = YES;
        
        _voiceBtn.size = self.inputBg.size;
        _voiceBtn.backgroundColor = [UIColor whiteColor];
        //文字颜色
        [_voiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //文字内容
        [_voiceBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        [_voiceBtn setTitle:@"松开发送" forState:UIControlStateHighlighted];
        //点击方式
        [_voiceBtn addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [_voiceBtn addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceBtn addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [_voiceBtn addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [_voiceBtn addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        
        _voiceBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.inputBg addSubview:_voiceBtn];
    }
    return _voiceBtn;
}

#pragma mark 菜单按钮
- (UIButton *)menuBtn
{
    if (!_menuBtn)
    {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuBtn.size = kInPutIcon_size;
        [_menuBtn setBackgroundImage:[ChatFileHelper imageNamed:@"chat_menu"] forState:UIControlStateNormal];
        [_menuBtn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        _menuBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:_menuBtn];
    }
    return _menuBtn;
}

#pragma mark 表情按钮
- (UIButton *)emojiBtn
{
    if (!_emojiBtn)
    {
        _emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _emojiBtn.size = kInPutIcon_size;
        [_emojiBtn setBackgroundImage:[ChatFileHelper imageNamed:@"chat_face"] forState:UIControlStateNormal];
        [_emojiBtn setBackgroundImage:[ChatFileHelper imageNamed:@"chat_keyboard"] forState:UIControlStateSelected];
        [_menuBtn setBackgroundImage:[UIImage new] forState:UIControlStateHighlighted];
        [_emojiBtn addTarget:self action:@selector(emojiClick:) forControlEvents:UIControlEventTouchUpInside];
        _emojiBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        _emojiBtn.hidden = YES;
        [self addSubview:_emojiBtn];
    }
    return _emojiBtn;
}

#pragma mark - 自定义输入视图加载
#pragma mark 自定义表情菜单
- (ChatEmotionKeyboard *)emojiView
{
    if (!_emojiView)
    {
        _emojiView = [[ChatEmotionKeyboard alloc] init];
        _emojiView.toolBarArr = @[ @(SHEmoticonType_custom),
                                    @(SHEmoticonType_system),
//                                    @(SHEmoticonType_gif),
                                    @(SHEmoticonType_recent) ];
        
        __weak typeof(self) weakSelf = self;
        //点击了发送
        _emojiView.sendEmotionBlock = ^{
            //发送文字
            [weakSelf sendMessageWithText:[ChatEmotionTool getRealStrWithAtt:weakSelf.textView.attributedText]];
        };
        
        //点击了删除
        _emojiView.deleteEmotionBlock = ^{
            [weakSelf.textView deleteBackward];
        };
        
        //表请点击
        _emojiView.clickEmotionBlock = ^(ChatEmotionModel *model) {
            switch (model.type)
            {
                case SHEmoticonType_gif: //Gif(默认路径为静态的)
                {
                    [weakSelf sendMessageWithGif:model.gif size:CGSizeMake(100, 100)];
                }
                    break;
                default:
                {
                    //添加到输入框
                    NSInteger selectIndex = weakSelf.textView.selectedRange.location;
                    
                    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:weakSelf.textView.attributedText];
                    
                    NSAttributedString *att = [ChatEmotionTool getAttWithEmotion:model font:weakSelf.textView.font];
                    //插入表情到光标位置
                    [attr insertAttributedString:att atIndex:selectIndex];
                    //设置字体
                    [attr addAttribute:NSFontAttributeName value:weakSelf.textView.font range:NSMakeRange(0, attr.length)];
                    //放到文本框
                    weakSelf.textView.attributedText = attr;
                    //移动光标位置
                    weakSelf.textView.selectedRange = NSMakeRange(selectIndex + att.length, 0);
                    
                    [weakSelf textViewDidChange:weakSelf.textView];
                }
                    break;
            }
        };
        
        [_emojiView reloadView];
    }
    
    return _emojiView;
}

#pragma mark 自定义多媒体菜单
- (ChatShareMenuView *)menuView
{
    if (!_menuView)
    {
        CGFloat shareMenuView_H;
        //计算多媒体菜单高度
        if (self.shareMenuItems.count <= kShareMenuPerRowItemCount)
        {
            shareMenuView_H = 2 * KShareMenuItemTop + KShareMenuItemHeight;
        }
        else if (self.shareMenuItems.count <= kShareMenuPerRowItemCount * kShareMenuPerColum)
        {
            shareMenuView_H = (KShareMenuItemTop + KShareMenuItemHeight) * kShareMenuPerColum + KShareMenuItemTop;
        }
        else
        {
            shareMenuView_H = (KShareMenuItemTop + KShareMenuItemHeight) * kShareMenuPerColum + kShareMenuPageControlHeight;
        }
        
        _menuView = [[ChatShareMenuView alloc] initWithFrame:CGRectMake(0, 0, kWidth, shareMenuView_H)];
        
        _menuView.backgroundColor = kInPutViewColor;
        _menuView.hidden = YES;
        _menuView.delegate = self;
        _menuView.shareMenuItems = self.shareMenuItems;
        [_menuView reloadData];
        
        [self.superview addSubview:_menuView];
    }
    
    return _menuView;
}

#pragma mark - 发送消息
#pragma mark 发送文字
- (void)sendMessageWithText:(NSString *)text
{
    if (!text.length) {
        //没有内容
        return;
    }
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendText:)])
    {
        [_delegate chatMessageWithSendText:text];
    }
    
    self.textView.text = @"";
    [self textViewDidChange:self.textView];
}

#pragma mark 发送音频
- (void)sendMessageWithAudio:(NSString *)path duration:(NSInteger)duration
{
    //保存文件 生成 消息服务器用的amr
//    [ChatFileHelper saveFileWithContent:path type:ChatMessageFileType_wav];
//    NSString *name = [ChatFileHelper getFileNameWithPath:path];
    NSString *mp3_file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"/record.mp3"];
    [AudioWrapper audioPCMtoMP3:path :mp3_file];
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendAudio:duration:)])
    {
        [_delegate chatMessageWithSendAudio:mp3_file duration:duration];
    }
}

#pragma mark 发送图片
- (void)sendMessageWithImage:(UIImage *)image
{
    //获取文件路径
    NSString *path = [ChatFileHelper saveFileWithContent:image type:ChatMessageFileType_image];
    NSString *name = [ChatFileHelper getFileNameWithPath:path];
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendImage:imageName:size:)])
    {
//        [_delegate chatMessageWithSendImage:name size:image.size];
        
        [_delegate chatMessageWithSendImage:image imageName:name size:image.size];
    }
}

#pragma mark 发送视频
- (void)sendMessageWithVideo:(NSString *)path
{
    path = [ChatFileHelper saveFileWithContent:path type:ChatMessageFileType_video];
    NSString *name = [ChatFileHelper getFileNameWithPath:path];
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    NSArray *array = asset.tracks;
    CGSize size = CGSizeZero;
    
    for (AVAssetTrack *track in array)
    {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo])
        {
            //视频方向不对
            size = CGSizeMake(track.naturalSize.height, track.naturalSize.width);
            break;
        }
    }
    
    NSString *fileSize = [ChatFileHelper getFileSize:path];
    
    CMTime time = [asset duration];
    NSInteger duration = ceil(time.value / time.timescale);
    
    //保存第一帧
    [ChatFileHelper saveFileWithContent:path type:ChatMessageFileType_video_image];
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendVideo:fileSize:duration:size:)])
    {
        [_delegate chatMessageWithSendVideo:name fileSize:fileSize duration:[self dealTime:duration] size:size];
    }
}

#pragma mark 发送位置
- (void)sendMessageWithLocation:(NSString *)locationName lon:(CGFloat)lon lat:(CGFloat)lat
{
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendLocation:lon:lat:)])
    {
        [_delegate chatMessageWithSendLocation:locationName lon:lon lat:lat];
    }
}

#pragma mark 发送名片
- (void)sendMessageWithCard:(NSString *)card
{
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendCard:)])
    {
        [_delegate chatMessageWithSendCard:card];
    }
}

#pragma mark 发送红包
- (void)sendMessageWithRedPackage:(NSString *)message
{
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendRedPackage:)])
    {
        [_delegate chatMessageWithSendRedPackage:message];
    }
}

#pragma mark 发送Gif
- (void)sendMessageWithGif:(NSString *)gifName size:(CGSize)size
{
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendGif:size:)])
    {
        [_delegate chatMessageWithSendGif:gifName size:size];
    }
}

#pragma mark 发送文件
- (void)sendMessageWithFile:(NSString *)path
{
    NSString *displayName = path.lastPathComponent;
    path = [ChatFileHelper saveFileWithContent:path type:ChatMessageFileType_file];
    NSString *fileSize = [ChatFileHelper getFileSize:path];
    //文件有很多，带着格式
    NSString *name = path.lastPathComponent;
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendFile:displayName:fileSize:)])
    {
        [_delegate chatMessageWithSendFile:name displayName:displayName fileSize:fileSize];
    }
}

#pragma mark - 菜单内容
#pragma mark 打开照片
- (void)openPhoto
{
    
    TZImagePickerController * imagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:1  delegate:self];
    
    imagePickerVc.showSelectBtn = false;
    imagePickerVc.allowTakeVideo = false;
    imagePickerVc.allowPickingImage = true;

    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.supVC.navigationController presentViewController:imagePickerVc animated:true completion:nil];
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didSelectAsset:(PHAsset *)asset photo:(UIImage *)photo isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    //发送图片与照片
    [self sendMessageWithImage:photo];
}


#pragma mark 打开相机
- (void)openCarema
{
    ChatShortVideoViewController *vc = [[ChatShortVideoViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    @kWeak(self);
    vc.finishBlock = ^(id content) {
        @kSHStrong(self);
        if ([content isKindOfClass:[NSString class]])
        {
            NSLog(@"视频路径：%@", content);
            //发送视频
            [self sendMessageWithVideo:content];
        }
        else if ([content isKindOfClass:[UIImage class]])
        {
            NSLog(@"图片内容：%@", content);
            //发送图片与照片
            [self sendMessageWithImage:content];
        }
    };
    [self.supVC presentViewController:vc animated:YES completion:nil];
}

#pragma mark 打开定位
- (void)openLocation
{
    ChatMessageLocationViewController *view = [[ChatMessageLocationViewController alloc] init];
    view.locType = ChatMessageLocationType_Location;
    @kWeak(self);
    view.block = ^(ChatMessage *message) {
        @kSHStrong(self);
        [self sendMessageWithLocation:message.locationName lon:message.lon lat:message.lat];
    };
    
    [self.supVC.navigationController pushViewController:view animated:YES];
}

#pragma mark 打开名片
- (void)openCard
{
    [self sendMessageWithCard:@"个人名片"];
}

#pragma mark 打开红包
- (void)openRedPaper
{
    [self sendMessageWithRedPackage:@"恭喜发财，大吉大利"];
}

#pragma mark 打开文件
- (void)openFile
{
    NSArray *documentTypes = @[ @"public.content",
                                @"public.text",
                                @"public.source-code",
                                @"public.image",
                                @"public.audiovisual-content",
                                @"com.apple.keynote.key",
                                @"com.adobe.pdf",
                                @"com.microsoft.word.doc",
                                @"com.microsoft.excel.xls",
                                @"com.microsoft.powerpoint.ppt" ];
    
    UIDocumentPickerViewController *vc = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
    
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self.supVC presentViewController:vc animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset success:^(NSString *outputPath) {
        
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        //发送视频
        [self sendMessageWithVideo:outputPath];
        
    } failure:^(NSString *errorMessage, NSError *error) {
        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    }];
}

#pragma mark - UITextViewDelegate
#pragma mark 键盘上功能点击
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    { //点击了发送
        //发送文字
        [self sendMessageWithText:[ChatEmotionTool getRealStrWithAtt:textView.attributedText]];
        return NO;
    }
    return YES;
}

#pragma mark 开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.inputType == SHInputViewType_menu)
    {
        [textView resignFirstResponder];
        [self menuClick:self.menuBtn];
        return;
    }
    if (self.inputType != SHInputViewType_emotion)
    {
        //输入文本
        self.inputType = SHInputViewType_text;
    }
    
    [self textViewDidChange:self.textView];
}

#pragma mark 文字改变(监听改变输入框高度)
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxH = ceil(textView.font.lineHeight * kInPutNum);
    
    CGSize size = [ChatTool getSizeWithAtt:textView.attributedText maxSize:CGSizeMake(self.textView.width, CGFLOAT_MAX)];
    
    size.height = MIN(maxH, size.height) + 2 * self.textView.y + 2 * self.inputBg.y;
    CGFloat textH = ceil(MAX(size.height, kInPutHeight));
    
    if (self.height != textH)
    {
        self.y += self.height - textH;
        self.height = textH;
        
    }
}

#pragma mark - ChatShareMenuViewDelegate
- (void)didSelecteShareMenuItem:(ChatShareMenuItem *)menuItem index:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(didSelecteMenuItem:index:)])
    {
        [_delegate didSelecteMenuItem:menuItem index:index];
    }
}

#pragma mark - ChatAudioRecordHelperDelegate 录音结束处理
- (void)audioFinishWithPath:(NSString *)path duration:(NSInteger)duration
{
    if (duration)
    {
        //发送音频
        [self sendMessageWithAudio:path duration:duration];
    }
    else
    {
        //时间太短
        //提示框
        [ChatMessageVoiceHUD shareInstance].hudType = SHVoiceHudType_warning;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ChatMessageVoiceHUD shareInstance].hudType = SHVoiceHudType_remove;
        });
    }
}

#pragma mark - UIDocumentPickerDelegate 选择文件回调
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    BOOL fileUrlAuthozied = [url startAccessingSecurityScopedResource];
    if (fileUrlAuthozied)
    {
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        
        [fileCoordinator coordinateReadingItemAtURL:url
                                            options:0
                                              error:&error
                                         byAccessor:^(NSURL *newURL) {
            [self sendMessageWithFile:newURL.path];
        }];
        [url stopAccessingSecurityScopedResource];
    }
    else
    {
        //Error handling
        NSLog(@"选择文件错误！！");
    }
}

#pragma mark - 录音事件
#pragma mark 开始录音
- (void)beginRecordVoice:(UIButton *)button
{
    
    NSLog(@"sdfsfg");
    //录音的时候停止播放
    [[ChatAudioPlayerHelper shareInstance] stopAudio];
    
    //检查权限
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted)
        { //获取权限
            [ChatMessageVoiceHUD shareInstance].hudType = SHVoiceHudType_remove;
            
            [ChatMessageVoiceHUD shareInstance].hudType = SHVoiceHudType_recording;
            
            //开始录音
            [self.audioHelper startRecord];
            
            if (self.playTimer)
            {
                [self.playTimer invalidate];
                self.playTimer = nil;
            }
            
            self.playTime = 0;
            self.playTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(countVoiceTest) userInfo:nil repeats:YES];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开启权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [ale show];
            });
        }
    }];
}

#pragma mark 停止录音
- (void)endRecordVoice:(UIButton *)button
{
    //隐藏提示框
    [ChatMessageVoiceHUD shareInstance].hudType = SHVoiceHudType_remove;
    
    if (self.playTimer)
    {
        [self.audioHelper stopRecord];
        
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}

#pragma mark 取消录音
- (void)cancelRecordVoice:(UIButton *)button
{
    //隐藏提示框
    [ChatMessageVoiceHUD shareInstance].hudType = SHVoiceHudType_remove;
    
    if (self.playTimer)
    {
        [self.audioHelper cancelRecord];
        
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}

#pragma mark 离开提示
- (void)RemindDragExit:(UIButton *)button
{
    [ChatMessageVoiceHUD shareInstance].hudType = SHVoiceHudType_cancel;
}

#pragma mark 按住提示
- (void)RemindDragEnter:(UIButton *)button
{
    [ChatMessageVoiceHUD shareInstance].hudType = SHVoiceHudType_recording;
}

#pragma mark 声音检测
- (void)countVoiceTest
{
    self.playTime += 0.25;
    
    int meters = [self.audioHelper peekRecorderVoiceMetersWithMax:7];
    //声波显示
    [[ChatMessageVoiceHUD shareInstance] showVoiceMeters:meters];
    
    CGFloat time = self.playTime;
    if (time == kMaxRecordTime - 10)
    {
        NSLog(@"1");
        //最后10秒
        [ChatMessageVoiceHUD shareInstance].hudType = SHVoiceHudType_countdown;
    }
    
    if (self.playTime >= kMaxRecordTime)
    { //超过最大时间停止
        //停止录音
        [self endRecordVoice:self.voiceBtn];
    }
}

#pragma mark - 监听实现
#pragma mark 监听输入框的位置
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"])
    {
        //回调
        if ([self.delegate respondsToSelector:@selector(toolbarHeightChange)])
        {
            [self.delegate toolbarHeightChange];
        }
    }
}

#pragma mark 监听输入框类型
- (void)setInputType:(SHInputViewType)inputType
{
    if (_inputType == inputType)
    {
        return;
    }
    
    if (_inputType == SHInputViewType_voice && inputType == SHInputViewType_default)
    {
        _inputType = inputType;
        return;
    }
    
    //初始化
    self.menuBtn.selected = NO;
    self.emojiBtn.selected = NO;
    self.changeBtn.selected = NO;
    
    self.textView.hidden = YES;
    self.voiceBtn.hidden = YES;
    self.emojiView.hidden = YES;
    self.menuView.hidden = YES;
    
    _inputType = inputType;
    
    self.textView.inputView = nil;
    if (inputType != SHInputViewType_text && inputType != SHInputViewType_emotion)
    {
        [self.textView resignFirstResponder];
    }
    
    switch (inputType)
    {
        case SHInputViewType_default: //默认
        {
            self.textView.hidden = NO;
            
            [self updateViewY:start_maxY - self.height];
        }
            break;
        case SHInputViewType_text: //文本
        {
            self.textView.hidden = NO;
            
            [self.textView reloadInputViews];
            
            //弹出键盘
            [self.textView becomeFirstResponder];
        }
            break;
        case SHInputViewType_voice: //语音
        {
            self.changeBtn.selected = YES;
            
            self.voiceBtn.hidden = NO;
            self.height = kInPutHeight;
            [self updateViewY:start_maxY - self.height];
        }
            break;
        case SHInputViewType_emotion: //表情
        {
            self.emojiBtn.selected = YES;
            
            self.textView.hidden = NO;
            self.emojiView.hidden = NO;
            
            self.textView.inputView = self.emojiView;
            [self.textView reloadInputViews];
            
            //弹出键盘
            [self.textView becomeFirstResponder];
        }
            break;
        case SHInputViewType_menu: //菜单
        {
            self.menuBtn.selected = YES;
            
            self.textView.hidden = NO;
            self.menuView.hidden = NO;
            
            //把高度计算出来
            [self textViewDidChange:self.textView];
            self.menuView.y = self.superview.height;
            //多媒体菜单
            [self updateViewY:start_maxY - self.height - self.menuView.height];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 键盘通知
#pragma mark 添加键盘通知
- (void)addKeyboardNote
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // 1.显示键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    
    // 2.隐藏键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    
    //添加监听
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

#pragma mark 键盘通知执行
- (void)keyboardChange:(NSNotification *)notification
{
    if (self.inputType == SHInputViewType_menu)
    {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    CGFloat viewY = keyboardEndFrame.origin.y - self.height;
    if ([notification.name isEqualToString:UIKeyboardWillHideNotification])
    {
        viewY -= kBottomSafe;
    }
    
    [self updateViewY:viewY];
}

#pragma mark - 私有方法
#pragma mark 更新Y
- (void)updateViewY:(CGFloat)viewY
{
    if (self.y != viewY)
    {
        [UIView animateWithDuration:0.25
                         animations:^{
            self.y = viewY;
            self.menuView.y = self.maxY;
        }];
    }
}

#pragma mark 清除
- (void)clear
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"frame"];
}

#pragma mark 处理时间
- (NSString *)dealTime:(NSInteger)time
{
    if (isnan(time))
    {
        return @"00:00";
    }
    
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    formatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    
    if (time / 3600 >= 1)
    {
        formatter.allowedUnits = kCFCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    }
    else
    {
        formatter.allowedUnits = NSCalendarUnitMinute | NSCalendarUnitSecond;
    }
    NSString *dealTime = [formatter stringFromTimeInterval:time];
    
    if (dealTime.length == 7 || dealTime.length == 4)
    {
        dealTime = [NSString stringWithFormat:@"0%@", dealTime];
    }
    
    return dealTime;
}

#pragma mark - 按钮点击
#pragma mark 状态点击
- (void)changeClick:(UIButton *)btn
{
    NSLog(@"改变输入与录音状态");
    
    if (self.changeBtn.selected)
    {
        [self textViewDidChange:self.textView];
        //文本输入
        self.inputType = SHInputViewType_text;
    }
    else
    {
        //语音输入
        self.inputType = SHInputViewType_voice;
    }
}

#pragma mark 菜单点击
- (void)menuClick:(UIButton *)btn
{
    NSLog(@"点击菜单");
    
    if (self.menuBtn.selected)
    {
        //文本输入
        self.inputType = SHInputViewType_text;
    }
    else
    {
        //菜单输入
        self.inputType = SHInputViewType_menu;
    }
}

#pragma mark 表情点击
- (void)emojiClick:(UIButton *)btn
{
    NSLog(@"点击表情");
    
    if (self.emojiBtn.selected)
    {
        //文本输入
        self.inputType = SHInputViewType_text;
    }
    else
    {
        //表情输入
        self.inputType = SHInputViewType_emotion;
    }
}

#pragma mark - 公共方法
#pragma mark 刷新界面
- (void)reloadView
{
    start_maxY = self.maxY;
    
    self.viewY = (self.height - kInPutIcon_size.height) / 2;
    
    self.changeBtn.y = self.viewY;
    self.menuBtn.origin = CGPointMake(self.width - kInPutSpace - self.menuBtn.width, self.viewY);
    self.emojiBtn.origin = CGPointMake(self.menuBtn.x - kInPutSpace - self.emojiBtn.width, self.viewY);
    
    self.inputBg.width = self.emojiBtn.x - self.changeBtn.maxX - 2 * kInPutSpace + self.emojiBtn.width;
    self.inputBg.height = self.height - 2 * self.inputBg.y;
    
    [self textView];
    
    //设置输入框类型
    self.inputType = SHInputViewType_default;
    
    //设置录音代理
    self.audioHelper = [ChatAudioRecordHelper new];
    self.audioHelper.delegate = self;
}

@end

//
//  ChatFileHelper.m
//  SHChatUI
//
//  Created by GXL on 2018/6/5.
//  Copyright © 2018年 GXL. All rights reserved.
//

#import "ChatFileHelper.h"
#import "ChatMessageHeader.h"

@implementation ChatFileHelper

#pragma mark 获取文件夹（没有的话创建）
+ (NSString *)getCreateFilePath:(NSString *)path
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

#pragma mark 获取录音设置
+ (NSDictionary *)getAudioRecorderSettingDict
{
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat:16000], AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,                     //采样位数 默认 16
                                   [NSNumber numberWithInt:2], AVNumberOfChannelsKey,                       //通道的数目
//                                   [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,                 //大端还是小端 是内存的组织方式
//                                   [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,                     //采样信号是整数还是浮点数
                                   [NSNumber numberWithInt:AVAudioQualityMin], AVEncoderAudioQualityKey, //音频编码质量
                                   nil];
    return recordSetting;
}

#pragma mark 获取资源路径并且保存资源
+ (NSString *)saveFileWithContent:(id)content type:(ChatMessageFileType)type
{
    if (!content)
    {
        return @"";
    }
    
    NSString *filePath;
    NSData *data;
    
    filePath = [self getFilePathWithName:[ChatMessageHelper getTimeWithZone] type:type];
    
    switch (type)
    {
        case ChatMessageFileType_image:
        {
            data = [ChatMessageHelper getDataWithImage:content num:1];
        }
            break;
        case ChatMessageFileType_wav:
        {
            NSString *name = [ChatFileHelper getFileNameWithPath:content];
            NSString *amr = [self getFilePathWithName:name type:ChatMessageFileType_amr];
            //转格式 WAV-->AMR
            [VoiceConverter wavToAmr:content amrSavePath:amr];
        }
        case ChatMessageFileType_video_image:
        {
            //视频第一帧图片
            UIImage *image = [ChatMessageHelper getVideoImage:content];
            data = [ChatMessageHelper getDataWithImage:image num:1];
            filePath = [self getFilePathWithName:[ChatFileHelper getFileNameWithPath:content] type:type];
        }
            break;
        case ChatMessageFileType_file://文件
        {
            filePath = [NSString stringWithFormat:@"%@.%@",filePath,[content pathExtension]];
        }
            break;
        default:
            break;
    }
    
    if (!data)
    {
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager copyItemAtPath:content toPath:filePath error:nil];
    }else{
        [data writeToFile:filePath atomically:NO];
    }
    
    return filePath;
}

#pragma mark 获取资源路径
+ (NSString *)getFilePathWithName:(NSString *)name type:(ChatMessageFileType)type
{
    if (!name)
    {
        name = [ChatMessageHelper getTimeWithZone];
    }
    
    switch (type)
    {
        case ChatMessageFileType_image: //image
        {
            name = [self addFileType:@"jpg" name:name];
            return [NSString stringWithFormat:@"%@/%@", kPath_image, name];
        }
            break;
        case ChatMessageFileType_wav: //语音wav
        {
            name = [self addFileType:@"wav" name:name];
            return [NSString stringWithFormat:@"%@/%@", kPath_audio_wav, name];
        }
            break;
        case ChatMessageFileType_amr: //语音amr
        {
            name = [self addFileType:@"amr" name:name];
            return [NSString stringWithFormat:@"%@/%@", kPath_audio_amr, name];
        }
            break;
        case ChatMessageFileType_gif: //gif
        {
            name = [self addFileType:@"gif" name:name];
            return [NSString stringWithFormat:@"%@/%@", kPath_gif, name];
        }
            break;
        case ChatMessageFileType_video: //video
        {
            name = [self addFileType:@"mp4" name:name];
            return [NSString stringWithFormat:@"%@/%@", kPath_video, name];
        }
            break;
        case ChatMessageFileType_video_image: //视频图片
        {
            name = [self addFileType:@"jpg" name:name];
            return [NSString stringWithFormat:@"%@/%@", kPath_video_image, name];
        }
            break;
        case ChatMessageFileType_file: //文件
        {
            return [NSString stringWithFormat:@"%@/%@", kPath_file, name];
        }
            break;
        default:
            break;
    }
    return name;
}

#pragma mark 添加文件类型
+ (NSString *)addFileType:(NSString *)type name:(NSString *)name{
    if (![name containsString:@"."]) {
        name = [NSString stringWithFormat:@"%@.%@",name,type];
    }
    return name;
}

#pragma mark 获取文件名
+ (NSString *)getFileNameWithPath:(NSString *)path{
    if (!path.length)
    {
        return nil;
    }
    
    NSArray *arr = [path.lastPathComponent componentsSeparatedByString:@"."];
    
    if (arr.count)
    {
        return arr.firstObject;
       
    }
    return path;
}

#pragma mark 获取图片
+ (UIImage *)imageNamed:(NSString *)name
{
    if (![name containsString:@"png"])
    {
        name = [NSString stringWithFormat:@"%@.png", name];
    }
    return [UIImage imageNamed:[NSString stringWithFormat:@"SHChatUI.bundle/%@", name]];
}

#pragma mark 获取文件大小
+ (NSString *)getFileSize:(NSString *)path{
    CGFloat fileSize = 0;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]){
        fileSize = [[manager attributesOfItemAtPath:path error:nil] fileSize];
    }
    
    NSString *size = @"";
    if (fileSize < 1024) {
        size = [NSString stringWithFormat:@"%fB", fileSize];
    }
    else if(fileSize < 1024 * 1024){
        size = [NSString stringWithFormat:@"%.2fkB", fileSize / 1024];
    }
    else
    {
        size = [NSString stringWithFormat:@"%.2fMB", fileSize / (1024 * 1024)];
    }
    
    return size;
}

@end

//
//  AudioWrapper.h
//  WClassRoom
//
//  Created by 单剑秋 on 2019/2/11.
//  Copyright © 2019 单剑秋. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioWrapper : NSObject
+ (void)audioPCMtoMP3 :(NSString *)audioFileSavePath :(NSString *)mp3FilePath;
@end

NS_ASSUME_NONNULL_END

//
//  SwpRequest.m
//  swp_song
//
//  Created by songweiping on 15/12/11.
//  Copyright © 2015年 songweiping. All rights reserved.
//
//  @author             --->    swp_song
//
//  @modification Time  --->    2015-12-11 17:28:06
//
//  @since              --->    1.0.7
//
//  @warning            --->    !!! < AFNetworking 二次封装 使用时 需要导入 AFNetworking 网路库  > !!!

#import "SwpRequest.h"
#import <AVFoundation/AVFoundation.h>

/*! ---------------------- Tool       ---------------------- !*/
//#import <Base64nl/Base64.h>             // Base64 加密
#import "Base64/Base64.h"
#import <CommonCrypto/CommonDigest.h>   // MD5    加密
/*! ---------------------- Tool       ---------------------- !*/

@interface SwpRequest ()

#pragma mark - Networking Property
/*! AFHTTPSessionManager 网络请求管理者对象 !*/
@property (nonatomic, strong) AFHTTPSessionManager *swpSessionManager;

@end

@implementation SwpRequest

#pragma mark - SwpRequest Tool Methods
/*!
 *  @author swp_song, 2015-12-11 16:54:28
 *
 *  @brief  swpPOST                     ( 请求网络获取数据 <POST> )
 *
 *  @param  URLString                   请求的 url
 *
 *  @param  parameters                  请求 需要传递的参数
 *
 *  @param  base64                      请求 是否 对参数加密 (YES 加密 / NO 不加密)
 *
 *  @param  success                     请求获取数据成功
 *
 *  @param  failure                     请求获取数据失败
 *
 *  @since  1.0.7
 */
+ (void)swpPOST:(NSString *)URLString parameters:(NSDictionary *)parameters isBase64:(BOOL)base64 success:(void (^)(NSURLSessionDataTask *task , id resultObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMessage))failure {

    // 初始化自定义网络请求类
    SwpRequest *swpRequest               = [SwpRequest shareInstance];
    
    // 字典加密
    NSDictionary         *dictionary     = base64 ? [swpRequest encryptedParamsWithDict:parameters] : parameters;
    // 返回结果集
    __block NSDictionary *resultObject   = [NSDictionary dictionary];
    
    // 显示 状态栏 请求数据的菊花
    [swpRequest settingNetworkPicture:YES];
    
    // 发起请求
//    [swpRequest.swpSessionManager  POST:URLString parameters:dictionary progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        resultObject = [swpRequest requestDispose:responseObject isBase64:base64];
//        if (resultObject != nil) {
//            success(task, resultObject);
//        };
//        [swpRequest settingNetworkPicture:NO];
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSString *errorInfo = error == nil ? nil : [NSString stringWithFormat:@"错误代码%ld \n 错误信息%@", (long)error.code, error.localizedDescription];
//        failure(task, error, errorInfo);
//        [swpRequest settingNetworkPicture:NO];
//    }];
    
}

/*!
 *  @author swp_song, 2015-12-11 16:54:43
 *
 *  @brief  swpPOSTAddFile              ( 请求网络获上传文件 单文件上传 <POST> )
 *
 *  @param  URLString                   请求的 url
 *
 *  @param  parameters                  请求 需要传递的参数
 *
 *  @param  base64                      请求 是否 对参数加密 (YES 加密 / NO 不加密)
 *
 *  @param  fileName                    请求 上传文件的名称 (和后台一致)
 *
 *  @param  fileData                    请求 上传文件的数据流
 *
 *  @param  success                     请求获取数据成功
 *
 *  @param  failure                     请求获取数据失败
 *
 *  @since  1.0.7
 */
+ (void)swpPOSTAddFile:(NSString *)URLString parameters:(NSDictionary *)parameters isBase64:(BOOL)base64 fileName:(NSString *)fileName fileData:(NSData *)fileData  success:(void (^)(NSURLSessionDataTask *task , id resultObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMessage))failure {
    
    // 初始化自定义网络请求类
    SwpRequest *swpRequest               = [SwpRequest shareInstance];
    
    // 字典加密
    NSDictionary         *dictionary     = base64 ? [swpRequest encryptedParamsWithDict:parameters] : parameters;
    // 返回结果集
    __block NSDictionary *resultObject   = [NSDictionary dictionary];
    
    // 显示 状态栏 请求数据的菊花
    [swpRequest settingNetworkPicture:YES];
    
    // 发起请求
    [swpRequest.swpSessionManager POST:URLString parameters:dictionary headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileData name:fileName fileName:@"picture.png" mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        resultObject = [swpRequest requestDispose:responseObject isBase64:base64];
        success(task, resultObject);
        [swpRequest settingNetworkPicture:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *errorInfo = error == nil ? nil : [NSString stringWithFormat:@"错误代码%ld \n 错误信息%@", (long)error.code, error.localizedDescription];
        failure(task, error, errorInfo);
        [swpRequest settingNetworkPicture:NO];
        
    }];
    
    
}



+ (void)swpPOSTAddFilevideo:(NSString *)URLString parameters:(NSDictionary *)parameters isBase64:(BOOL)base64 fileName:(NSString *)fileName fileData:(NSData *)fileData  success:(void (^)(NSURLSessionDataTask *task , id resultObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMessage))failure {
    
    // 初始化自定义网络请求类
    SwpRequest *swpRequest               = [SwpRequest shareInstance];
    
    // 字典加密
    NSDictionary         *dictionary     = base64 ? [swpRequest encryptedParamsWithDict:parameters] : parameters;
    // 返回结果集
    __block NSDictionary *resultObject   = [NSDictionary dictionary];
    
    // 显示 状态栏 请求数据的菊花
    [swpRequest settingNetworkPicture:YES];
    
    // 发起请求
//    [swpRequest.swpSessionManager POST:URLString parameters:dictionary constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:fileData name:fileName fileName:@"video.mp4" mimeType:@"image/png"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        resultObject = [swpRequest requestDispose:responseObject isBase64:base64];
//        success(task, resultObject);
//        [swpRequest settingNetworkPicture:NO];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSString *errorInfo = error == nil ? nil : [NSString stringWithFormat:@"错误代码%ld \n 错误信息%@", (long)error.code, error.localizedDescription];
//        failure(task, error, errorInfo);
//        [swpRequest settingNetworkPicture:NO];
//    }];
}
/*!
 *  @author swp_song, 2015-12-11 17:06:23
 *
 *  @brief  swpPOSTAddFiles             ( 请求网络获上传文件 多文件上传, 文件名称相同使用该方法 <POST> )
 *
 *  @param  URLString                   请求的 url
 *
 *  @param  parameters                  请求 需要传递的参数
 *
 *  @param  base64                      请求 是否 对参数加密 (YES 加密 / NO 不加密)
 *
 *  @param  fileName                    请求 上传文件的名称 (和后台一致)
 *
 *  @param  fileDatas                   请求 上传文件的流数组
 *
 *  @param  success                     请求获取数据成功
 *
 *  @param  failure                     请求获取数据失败
 *
 *  @since  1.0.7
 */
+ (void)swpPOSTAddFiles:(NSString *)URLString parameters:(NSDictionary *)parameters isBase64:(BOOL)base64 fileName:(NSString *)fileName fileDatas:(NSArray *)fileDatas success:(void (^)(NSURLSessionDataTask *task , id resultObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMessage))failure {
    
    // 初始化自定义网络请求类
    SwpRequest *swpRequest               = [SwpRequest shareInstance];
    
    // 字典加密
    NSDictionary         *dictionary     = base64 ? [swpRequest encryptedParamsWithDict:parameters] : parameters;
    // 返回结果集
    __block NSDictionary *resultObject   = [NSDictionary dictionary];
    
    // 显示 状态栏 请求数据的菊花
    [swpRequest settingNetworkPicture:YES];
    
    // 发起请求
    
    [swpRequest.swpSessionManager POST:URLString parameters:dictionary headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i=0; i<fileDatas.count; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%@[%i]", fileName, i];
            [formData appendPartWithFileData:fileDatas[i] name:imageName fileName:imageName mimeType:@"image/png"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        resultObject = [swpRequest requestDispose:responseObject isBase64:base64];
        success(task, resultObject);
        [swpRequest settingNetworkPicture:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *errorInfo = error == nil ? nil : [NSString stringWithFormat:@"错误代码%ld \n 错误信息%@", (long)error.code, error.localizedDescription];
        failure(task, error, errorInfo);
        [swpRequest settingNetworkPicture:NO];
        
    }];
    
    
//    [swpRequest.swpSessionManager POST:URLString parameters:dictionary constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    
}


/*!
 *  @author swp_song, 2015-12-11 17:17:14
 *
 *  @brief  swpPOSTAddWithFiles         ( 请求网络获上传文件 多文件上传, 文件名称不相同相同使用该方法  <POST> )
 *
 *  @param  URLString                   请求的 url
 *
 *  @param  parameters                  请求 需要传递的参数
 *
 *  @param  base64                      请求 是否 对参数加密 (YES 加密 / NO 不加密)
 *
 *  @param  fileNames                   请求 上传文件的名称数组 (和后台一致)
 *
 *  @param  fileDatas                   请求 上传文件的流数组
 *
 *  @param  success                     请求获取数据成功
 *
 *  @param  failure                     请求获取数据失败
 *
 *  @since  1.0.7
 */
+ (void)swpPOSTAddWithFiles:(NSString *)URLString parameters:(NSDictionary *)parameters isBase64:(BOOL)base64 fileNames:(NSArray *)fileNames fileDatas:(NSArray *)fileDatas success:(void (^)(NSURLSessionDataTask *task , id resultObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMessage))failure {
    
    // 初始化自定义网络请求类
    SwpRequest *swpRequest               = [SwpRequest shareInstance];
    
    // 字典加密
    NSDictionary         *dictionary     = base64 ? [swpRequest encryptedParamsWithDict:parameters] : parameters;
    // 返回结果集
    __block NSDictionary *resultObject   = [NSDictionary dictionary];
    
    // 显示 状态栏 请求数据的菊花
    [swpRequest settingNetworkPicture:YES];
    
    // 发起请求
//    [swpRequest.swpSessionManager POST:URLString parameters:dictionary constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        for (int i=0; i<fileDatas.count; i++) {
//            [formData appendPartWithFileData:fileDatas[i] name:fileNames[i] fileName:fileNames[i] mimeType:@"image/png"];
//        }
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        resultObject = [swpRequest requestDispose:responseObject isBase64:base64];
//        success(task, resultObject);
//        [swpRequest settingNetworkPicture:NO];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSString *errorInfo = error == nil ? nil : [NSString stringWithFormat:@"错误代码%ld \n 错误信息%@", (long)error.code, error.localizedDescription];
//        failure(task, error, errorInfo);
//        [swpRequest settingNetworkPicture:NO];
//    }];
    
}

/*!
 *  @author swp_song, 2015-12-11 17:24:00
 *
 *  @brief  swpRequestAFNetworkingTest  ( AFNetworking 测试方法 )
 *
 *  @param  URLString                   请求的 url
 *
 *  @param  parameters                  请求 需要传递的参数
 *
 *  @param  base64                      请求 是否 对参数加密 (YES 加密 / NO 不加密)
 *
 *  @since  1.0.7
 */
+ (void) swpRequestAFNetworkingTest:(NSString *)URLString parameters:(NSDictionary *)parameters isBase64:(BOOL)base64 {
    NSLog(@"This is AFNetworking Test Method");
}

#pragma mark - Init SwpRequest Method
/*!
 *  @author swp_song, 2015-12-11 16:55:07
 *
 *  @brief  shareInstance       ( 单利 快速初始化一个 用户数据模型 )
 *
 *  @return SwpRequest
 *
 *  @since  1.0.7
 */
+ (instancetype) shareInstance {
    static SwpRequest *swpRequest = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        swpRequest = [[self alloc] init];
    });
    return swpRequest;
}

#pragma mark - POST Parameters Encrypt Methods
/*!
 *  @author swp_song, 2015-12-11 16:56:43
 *
 *  @brief  encryptedParamsWithDict     ( 对字典 进行加密 返回 加密之后的字典 )
 *
 *  @param  dict
 *
 *  @return NSDictionary
 *
 *  @since  1.0.7
 */
- (NSDictionary *)encryptedParamsWithDict:(NSDictionary *)dict {
    
    //创建返回字典
    NSMutableDictionary* returnDict = [[NSMutableDictionary alloc]init];
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* obj, BOOL *stop) {
        
        //传入字典自检 查询字典中的key和Obj是否有空值
        if (key == nil || obj == nil) {
            NSAssert(nil, @"something nil in dictionary");
            *stop = YES;
        }
        
        //app_key 需要先进行MD5加密
        if (![key isEqualToString:@"app_key"]) {
            //对所有key和obj 进行加密
            NSString *baseObj   = [obj base64EncodedString];
            [returnDict setObject:baseObj forKey:key];
        } else {
            //地址先MD5在Base64加密
            NSString *md5String = [self encryptedWithMD5:obj];
            NSString *baseObj   = [md5String base64EncodedString];
            [returnDict setObject:baseObj forKey:key];
        }
    }];
    return returnDict;
}

/*!
 *  @author swp_song, 2015-12-11 16:57:20
 *
 *  @brief  encryptedWithMD5        ( MD5 加密 第一次加密  < 原理，app_key 整体加密，加密完毕之后，截取钱10位，在进行加密 >)
 *
 *  @param  inputStr
 *
 *  @return NSString
 *
 *  @since  1.0.7
 */
- (NSString *)encryptedWithMD5:(NSString *)inputStr {
    NSLog(@"inputText:%@",inputStr);
    const    char *cStr = [inputStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *str=[NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [str appendFormat:@"%02X",result[i]];
    }
    return [self againcStr:[str lowercaseString]];
}

/*!
 *  @author swp_song, 2015-12-11 16:58:03
 *
 *  @brief  againcStr   ( 第二次取前十位进行加密 )
 *
 *  @param  inputStr
 *
 *  @return NSString
 *
 *  @since  1.0.7
 */
- (NSString *)againcStr:(NSString *)inputStr {
    NSString *sstr      = [inputStr substringToIndex:10];
    const    char *cStr = [sstr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString * mstr=[NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [mstr appendFormat:@"%02x",result[i]];
    }
    return [mstr lowercaseString];
}

/*!
 *  @author swp_song, 2015-12-11 16:59:57
 *
 *  @brief  settingNetworkPicture   ( 显示 或隐藏 网络获取数据时 UINavigationBar 上的图标(转圈的菊花) )
 *
 *  @param  isShow                  networkActivityIndicatorVisible YES 显示，NO 隐藏
 *
 *  @since  1.0.7
 */
- (void) settingNetworkPicture:(BOOL)isShow {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = isShow;
}


#pragma mark - Request Dispose Method
/*!
 *  @author swp_song, 15-12-11 16:12:31
 *
 *  @brief  requestDispose      ( 返回 网络 结果集 处理 )
 *
 *  @param  responseObject
 *
 *  @param  base64              是否base64加密
 *
 *  @return NSDictionary
 *
 *  @since  1.0.7
 */
- (NSDictionary *)requestDispose:(id)responseObject isBase64:(BOOL)base64 {
    
    // 转换成 字符串
    NSString *decodeJson = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    decodeJson           = base64 ? [decodeJson base64DecodedString] : decodeJson;
    NSLog(@"%@", decodeJson);
    if (!decodeJson) return nil;
    
    // 字符串转成流
    NSData       *data = [decodeJson dataUsingEncoding:NSUTF8StringEncoding];
    // 转换字典
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    // 返回结果集
    NSLog(@"code    : ---> %@",  [dict objectForKey:@"code"]);
    NSLog(@"message : ---> %@",  [dict objectForKey:@"message"]);
    NSLog(@"dict    : ---> %@",  dict);
    return dict;
}

#pragma Init AFHTTPSessionManager Method
- (AFHTTPSessionManager *)swpSessionManager {
    
    if (!_swpSessionManager) {
        
        _swpSessionManager = [AFHTTPSessionManager manager];
        _swpSessionManager.responseSerializer  = [AFHTTPResponseSerializer serializer];
        [_swpSessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/css", @"text/javascript", nil]];
    }
    return _swpSessionManager;
}

+ (NSTimeInterval)audioDurationFromURL:(NSString *)url {
    AVURLAsset *audioAsset = nil;
    NSDictionary *dic = @{AVURLAssetPreferPreciseDurationAndTimingKey:@(YES)};
    //    if ([url hasPrefix:@"http://"]) {
    audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:dic];
    //    }else {
    //        audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:url] options:dic];
    //    }
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}

@end

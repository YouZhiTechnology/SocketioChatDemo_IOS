//
//  SwpRequest.h
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


#import <Foundation/Foundation.h>

/*! ---------------------- Tool       ---------------------- !*/
#import <AFNetworking/AFNetworking.h>     // AFNetworking 网络库
/*! ---------------------- Tool       ---------------------- !*/

NS_ASSUME_NONNULL_BEGIN

@interface SwpRequest : NSObject

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
+ (void)swpPOST:(NSString *)URLString parameters:(NSDictionary *)parameters isBase64:(BOOL)base64 success:(void (^)(NSURLSessionDataTask *task , id resultObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMessage))failure;

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
+ (void)swpPOSTAddFile:(NSString *)URLString parameters:(NSDictionary *)parameters isBase64:(BOOL)base64 fileName:(NSString *)fileName fileData:(NSData *)fileData  success:(void (^)(NSURLSessionDataTask *task , id resultObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMessage))failure;

+ (void)swpPOSTAddFilevideo:(NSString *)URLString parameters:(NSDictionary *)parameters isBase64:(BOOL)base64 fileName:(NSString *)fileName fileData:(NSData *)fileData  success:(void (^)(NSURLSessionDataTask *task , id resultObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMessage))failure;
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
+ (void)swpPOSTAddFiles:(NSString *)URLString parameters:(NSDictionary *)parameters isBase64:(BOOL)base64 fileName:(NSString *)fileName fileDatas:(NSArray *)fileDatas success:(void (^)(NSURLSessionDataTask *task , id resultObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMessage))failure;

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
+ (void)swpPOSTAddWithFiles:(NSString *)URLString parameters:(NSDictionary *)parameters isBase64:(BOOL)base64 fileNames:(NSArray *)fileNames fileDatas:(NSArray *)fileDatas success:(void (^)(NSURLSessionDataTask *task , id resultObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMessage))failure;

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
+ (void) swpRequestAFNetworkingTest:(NSString *)URLString parameters:(NSDictionary *)parameters isBase64:(BOOL)base64;


+ (NSTimeInterval)audioDurationFromURL:(NSString *)url;

@end

NS_ASSUME_NONNULL_END


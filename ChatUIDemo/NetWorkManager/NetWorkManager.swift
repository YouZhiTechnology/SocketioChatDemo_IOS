//
//  NetWorkManager.swift
//  kuaikaoti
//
//  Created by youzhi-air5 on 2021/3/4.
//  Copyright © 2021 GuoXiaolei. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyUserDefaults
import SwiftyJSON
import Toast_Swift

/// 响应句柄  是否成功, 状态信息, 数据字典
public typealias ResponseHandler = ((Bool, String, [String: Any]) -> Void)

class NetWorkManager: NSObject {
    // post 网络请求
    static func postRequest(_ url: String,
                            method: HTTPMethod = .post,
                            parameters: Parameters? = nil,
                            headers: HTTPHeaders? = nil,
                            completionHandler: @escaping ResponseHandler) {
        
        Session.default.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default , headers: NetWorkHeaders.normalHeaders).responseJSON { (response) in
            switch response.result {
            case.success(let json):
                print("\(JSON(json as Any))")
                //打印JSON数据
                guard let dict = response.value as? [String: Any] else {
                    completionHandler(false, response.error.debugDescription, [String : Any]())
                    return
                }
                
                guard let status = dict["code"], status as! String == "200" else {
                    let info = (dict["message"] as? String) ?? "失败"
//                    if info == "签名不正确" || info == "token未生效" || info == "token过期" || info == "token错误" || info == "踢出登录" {
//                        Defaults[\.userLogin] = false
//                        Defaults[\.token] = nil
//                        Defaults[\.user_id] = nil
//                        Defaults[\.stu_in_id] = nil
//                        let loginVC = SigninViewController()
//                        let navigation = LoginNavigationController(rootViewController: loginVC)
//                        let rootVC = UIApplication.shared.delegate as! AppDelegate
//                        rootVC.window?.rootViewController = navigation
//                        rootVC.window?.makeKey()
//                        loginVC.view.makeToast("登录过期,请重新登录")
//                        print("退出登录--------info")
//                    }
                    
                    let error = (dict["error"] as? String) ?? info
                    completionHandler(false, error, dict)
                    return
                }
                
                let info = (dict["message"] as? String) ?? "成功"
                completionHandler(true, info, dict)
            case.failure(let error):
                //                let rootVC = UIApplication.shared.delegate as! AppDelegate
                //                rootVC.window?.makeToast("网络错误", duration: 1.0, position: .center)
                print("\(error)")
            }
        }
    }
    
    /// 图片上传
    ///
    /// - Parameters:
    ///   - urlString: 服务器地址
    ///   - params: 参数 ["token": "89757", "userid": "nb74110"]
    ///   - images: image数组
    ///   - success: 成功闭包
    ///   - failture: 失败闭包
    static func upload(urlString : String, params:[String:String]?, imageName: String = "file",images: [UIImage], success: @escaping ResponseHandler, failture : @escaping (_ error : Error)->()) {
        
        let request = AF.upload(multipartFormData: { (multipartFormData) in
            if params != nil {
                for (key, value) in params! {
                    //参数的上传
                    multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
                }
            }
            for (index, value) in images.enumerated() {
                let imageData = value.jpegData(compressionQuality: 0.5)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMddHHmmss"
                let str = formatter.string(from: Date())
                let fileName = str+"\(index)FlamingoCustomerServer"+".jpg"

                // 以文件流格式上传
                // 批量上传与单张上传，后台语言为java或.net等
                multipartFormData.append(imageData!, withName: imageName, fileName: fileName, mimeType: "image/jpeg")
                //                // 单张上传，后台语言为PHP
                //                multipartFormData.append(imageData!, withName: "fileupload", fileName: fileName, mimeType: "image/jpeg")
                //                // 批量上传，后台语言为PHP。 注意：此处服务器需要知道，前台传入的是一个图片数组
                //                multipartFormData.append(imageData!, withName: "fileupload[\(index)]", fileName: fileName, mimeType: "image/jpeg")
            }
        }, to: urlString, usingThreshold: UInt64.init(), method: .post, headers: NetWorkHeaders.normalHeaders, interceptor: nil, fileManager: FileManager(), requestModifier: nil)
        
        request.responseJSON { (response) in
            switch response.result {
                case .success(_):
                    guard let dict = response.value as? [String:Any] else {
//                        success(false, response.error.debugDescription, [String:Any]())
                        success(false, "网络连接错误，请检查网络", [String : Any]())
                        return
                    }
                    print(dict)
                    
                    guard let status = dict["status"] as? Int, status == 1 else {
                        let info = (dict["msg"] as? String) ?? "失败"
                        let error = (dict["error"] as? String) ?? info
                        success(false, error, [String : Any]())
                        return
                    }
                    let info = (dict["msg"] as? String) ?? "成功"
                    success(true, info, dict)
                    
                    break
                case .failure(let encodingError):
                    failture(encodingError)
                    break
            }
        }
    }
    
    
    static func uploadOnePic(urlString : String, params:[String:String]?, imageName: String = "file",images: [UIImage], success: @escaping ResponseHandler, failture : @escaping (_ error : Error)->()) {
        let request = AF.upload(multipartFormData: { (multipartFormData) in
            if params != nil {
                for (key, value) in params! {
                    //参数的上传
                    multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
                }
            }
            for (index, value) in images.enumerated() {
                let imageData = value.jpegData(compressionQuality: 0.5)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMddHHmmss"
                let str = formatter.string(from: Date())
                let fileName = str+"\(index)FlamingoCustomerServer"+".jpg"

                // 以文件流格式上传
                // 批量上传与单张上传，后台语言为java或.net等
//                multipartFormData.append(imageData!, withName: imageName, fileName: fileName, mimeType: "image/jpeg")
                //                // 单张上传，后台语言为PHP
                multipartFormData.append(imageData!, withName: "file", fileName: fileName, mimeType: "image/jpeg")
                //                // 批量上传，后台语言为PHP。 注意：此处服务器需要知道，前台传入的是一个图片数组
                //                multipartFormData.append(imageData!, withName: "fileupload[\(index)]", fileName: fileName, mimeType: "image/jpeg")
            }
        }, to: urlString, usingThreshold: UInt64.init(), method: .post, headers: NetWorkHeaders.normalHeaders, interceptor: nil, fileManager: FileManager(), requestModifier: nil)
        
        request.responseJSON { (response) in
            switch response.result {
                case .success(_):
                    print("\(response)")                           //打印JSON数据
                    guard let dict = response.value as? [String: Any] else {
                        //                                        success(false, response.error.debugDescription, [String : Any]())
                        success(false, "网络连接错误，请检查网络", [String : Any]())
                        return
                    }
                    print(dict)
                    guard let status = dict["code"], status as! String == "200" else {
                        let info = (dict["message"] as? String) ?? "失败"
                        let error = (dict["error"] as? String) ?? info
                        success(false, error, [String : Any]())
                        return
                    }
                    let info = (dict["message"] as? String) ?? "成功"
                    success(true, info, dict)
                    break
                case .failure(let encodingError):
                    failture(encodingError)
            }
        }
    }
    
    
    /// 文件上传
    ///
    /// - Parameters:
    ///   - urlString: 服务器地址
    ///   - params: 参数 ["token": "89757", "userid": "nb74110"]
    ///   - images: 文件名称
    ///   - success: 成功闭包
    ///   - failture: 失败闭包
    static func uploadFile(urlString : String, params:[String:String]?, imageName: String = "file",files: [URL], success: @escaping ResponseHandler, failture : @escaping (_ error : Error)->()) {
        
        let request = AF.upload(multipartFormData: { (multipartFormData) in
            if params != nil {
                for (key, value) in params! {
                    //参数的上传
                    multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
                }
            }
            for (_, value) in files.enumerated() {
                do {
                    let data = try Data(contentsOf: value)
                    let mimeType = BaseTools.mimeType(pathExtension: value.pathExtension)
                    // 以文件流格式上传
                    // 批量上传与单张上传，后台语言为java或.net等
                    print(value.lastPathComponent.removingPercentEncoding ?? "")
                    multipartFormData.append(data, withName: imageName, fileName: value.lastPathComponent.removingPercentEncoding ?? "", mimeType: mimeType)
                    //                // 单张上传，后台语言为PHP
                    //                multipartFormData.append(imageData!, withName: "fileupload", fileName: fileName, mimeType: "image/jpeg")
                    //                // 批量上传，后台语言为PHP。 注意：此处服务器需要知道，前台传入的是一个图片数组
                    //                multipartFormData.append(imageData!, withName: "fileupload[\(index)]", fileName: fileName, mimeType: "image/jpeg")
                } catch {
                    print(error)
                }


            }
        }, to: urlString, usingThreshold: UInt64.init(), method: .post, headers: NetWorkHeaders.normalHeaders, interceptor: nil, fileManager: FileManager(), requestModifier: nil)
        
        request.responseJSON { (response) in
            switch response.result {
                case .success(_):
                    print("\(response)")                           //打印JSON数据
                    guard let dict = response.value as? [String: Any] else {
                        //                                        success(false, response.error.debugDescription, [String : Any]())
                        success(false, "网络连接错误，请检查网络", [String : Any]())
                        return
                    }
                    print(dict)
                    guard let status = dict["code"], status as! String == "200" else {
                        let info = (dict["msg"] as? String) ?? "失败"
                        let error = (dict["error"] as? String) ?? info
                        success(false, error, [String : Any]())
                        return
                    }
                    let info = (dict["msg"] as? String) ?? "成功"
                    success(true, info, dict)
                    break
                case .failure(let encodingError):
                    failture(encodingError)
            }
        }
    }
    
    //上传语音
    static func uploadVoiceFile(urlString : String, params:[String:String]?, Name: String = "file",files: [Data], success: @escaping ResponseHandler, failture : @escaping (_ error : Error)->()) {
        
        let request = AF.upload(multipartFormData: { multipartFormData in
            
            if params != nil {
                for (key, value) in params! {
                    //参数的上传
                    multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
                }
            }
            for (_, value) in files.enumerated() {
                do {
                    let data = value
//                    let mimeType = Tools.mimeType(pathExtension: value.pathExtension)
                    // 以文件流格式上传
                    // 批量上传与单张上传，后台语言为java或.net等
//                    print(value.lastPathComponent.removingPercentEncoding ?? "")
                    multipartFormData.append(data, withName: Name, fileName: "file", mimeType: "audio/mpeg")
                    //                // 单张上传，后台语言为PHP
                    //                multipartFormData.append(imageData!, withName: "fileupload", fileName: fileName, mimeType: "image/jpeg")
                    //                // 批量上传，后台语言为PHP。 注意：此处服务器需要知道，前台传入的是一个图片数组
                    //                multipartFormData.append(imageData!, withName: "fileupload[\(index)]", fileName: fileName, mimeType: "image/jpeg")
                }
                
            }
        }, to: urlString, usingThreshold: UInt64.init(), method: .post, headers: NetWorkHeaders.normalHeaders, interceptor: nil, fileManager: FileManager(), requestModifier: nil)
        
        request.responseJSON { (response) in
            switch response.result {
                case .success(_):
                    guard let dict = response.value as? [String:Any] else {
//                        success(false, response.error.debugDescription, [String:Any]())
                        success(false, "网络连接错误，请检查网络", [String : Any]())
                        return
                    }
                    print(dict)
                    
                    guard let status = dict["status"] as? Int, status == 1 else {
                        let info = (dict["msg"] as? String) ?? "失败"
                        let error = (dict["error"] as? String) ?? info
                        success(false, error, [String : Any]())
                        return
                    }
                    let info = (dict["msg"] as? String) ?? "成功"
                    success(true, info, dict)
                    
                    break
                case .failure(let encodingError):
                    failture(encodingError)
                    break
            }
        }
    }
        
        
//        Alamofire.upload(multipartFormData: { multipartFormData in
//            if params != nil {
//                for (key, value) in params! {
//                    //参数的上传
//                    multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
//                }
//            }
//            for (_, value) in files.enumerated() {
//                do {
//                    let data = value
////                    let mimeType = Tools.mimeType(pathExtension: value.pathExtension)
//                    // 以文件流格式上传
//                    // 批量上传与单张上传，后台语言为java或.net等
////                    print(value.lastPathComponent.removingPercentEncoding ?? "")
//                    multipartFormData.append(data, withName: Name, fileName: "file", mimeType: "audio/mpeg")
//                    //                // 单张上传，后台语言为PHP
//                    //                multipartFormData.append(imageData!, withName: "fileupload", fileName: fileName, mimeType: "image/jpeg")
//                    //                // 批量上传，后台语言为PHP。 注意：此处服务器需要知道，前台传入的是一个图片数组
//                    //                multipartFormData.append(imageData!, withName: "fileupload[\(index)]", fileName: fileName, mimeType: "image/jpeg")
//                }
//
//            }
//        },
//                         to: urlString,
//                         headers: NetWorkHeaders.normalHeaders,
//                         encodingCompletion: { encodingResult in
//                            switch encodingResult {
//                            case .success(let upload, _, _):
//                                upload.responseJSON { response in
//                                    print("\(response)")                           //打印JSON数据
//                                    guard let dict = response.value as? [String: Any] else {
//                                        //                                        success(false, response.error.debugDescription, [String : Any]())
//                                        success(false, "网络连接错误，请检查网络", [String : Any]())
//                                        return
//                                    }
//                                    print(dict)
//                                    guard let status = dict["status"] as? Int, status == 1 else {
//                                        let info = (dict["msg"] as? String) ?? "失败"
//                                        let error = (dict["error"] as? String) ?? info
//                                        success(false, error, [String : Any]())
//                                        return
//                                    }
//                                    let info = (dict["msg"] as? String) ?? "成功"
//                                    success(true, info, dict)
//                                }
//                            case .failure(let encodingError):
//                                failture(encodingError)
//                            }
//        }
//        )
//    }
}

class NetWorkHeaders: NSObject {
    ///
    static var normalHeaders: HTTPHeaders? {
        return [
            "Content-type":"application/json;charset=UTF-8",
            "Accept":"application/json",
            "channel":"00"
        ]
    }
}

extension DefaultsKeys{
    /// 登录状态
    var userLogin: DefaultsKey<Bool?> { .init("userLogin") }
    /// 用户id
    var mUserId: DefaultsKey<String?> { .init("mUserId") }
    /// 保存companyId
    var companyId: DefaultsKey<String?> { .init("companyId") }
}

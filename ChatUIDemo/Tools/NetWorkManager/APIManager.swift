//
//  NetWorkConfigurationFile.swift
//  kuaikaoti
//
//  Created by youzhi-air5 on 2021/3/4.
//  Copyright © 2021 GuoXiaolei. All rights reserved.
//

import UIKit

struct APIManager {
    //https
    static let release_host = "https://opim.zaoha.net/opapi"
    //socket
    static let release_im_host = "https://opim.zaoha.net"
    
    // 即时通讯
    static var IMUrl: String {
        return release_im_host
    }
    
    // 登录
    static var loginCheck: String {
        return release_host + "/openSource/loginCheck"
    }
    
    static var getUserInfo: String {
        return release_host + "/openSource/getUserInfo"
    }
    
    static var uploadPic: String {
        return "https://hecheng.yy2080.xyz/action/ac_house/uploadpic"
    }
    
    static var chatVoice: String {
        return "https://hecheng.yy2080.xyz/action/ac_user/chatVoice"
    }
    
    //上传文件/图片
    static var fileUpload: String {
        return APIManager.release_host + "/openSource/fileUpload"
    }
    
}

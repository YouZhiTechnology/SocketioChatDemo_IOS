//
//  IMCmdInfo.swift
//  ChatUIDemo
//
//  Created by youzhi-air8 on 2021/6/24.
//

import UIKit

class IMCmdInfo: BaseModel {
    var body: [String: Any]!
    // cmd类型
    var cmd: String?
    
    var exclude: String?
    
    var mid: String?
    
    var scope: String?
    
    var time: Date?
    
    var to: String?
}

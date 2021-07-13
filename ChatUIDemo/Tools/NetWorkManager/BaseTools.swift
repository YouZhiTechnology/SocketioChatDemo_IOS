//
//  BaseTools.swift
//  kuaikaoti
//
//  Created by youzhi-air5 on 2021/3/4.
//

import UIKit
import MobileCoreServices

typealias ActionBlock = () -> ()

class BaseTools: NSObject {
    // MARK: - 统一类型标识符(UTI) 文件格式或内存中的数据类型
    /// 根据后缀获取对应的Mime-Type
    /// - Parameter pathExtension: 后缀
    static func mimeType(pathExtension: String) -> String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
                .takeRetainedValue() {
                return mimetype as String
            }
        }
        //文件资源类型如果不知道，传万能类型application/octet-stream，服务器会自动解析文件类
        return "application/octet-stream"
    }
    
    /// 打印工具
    static func printLog(_ items: Any...,
                    separator: String = " ",
                    terminator: String = "\n",
                    file: String = #file,
                    line: Int = #line,
                    method: String = #function)
    {
        #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method)", terminator: separator)
        var i = 0
        let j = items.count
        for a in items {
            i += 1
            print(" ",a, terminator:i == j ? terminator: separator)
        }
        #endif
    }

    
}

class GCDTimer: NSObject {
    static let share = GCDTimer()
    
    lazy var timerContainer = [String: DispatchSourceTimer]()
    
    /// 创建一个名字为name的定时
    ///
    /// - Parameters:
    ///   - name: 定时器的名字
    ///   - timeInterval: 时间间隔
    ///   - queue: 线程
    ///   - repeats: 是否重复
    ///   - action: 执行的操作
    func scheduledDispatchTimer(withName name:String?, timeInterval:Double, queue:DispatchQueue, repeats:Bool, action:@escaping ActionBlock ) {
        if name == nil {
            return
        }
        var timer = timerContainer[name!]
        if timer==nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
            timer?.resume()
            timerContainer[name!] = timer
        }
        timer?.schedule(deadline: .now(), repeating: timeInterval, leeway: .milliseconds(100))
        timer?.setEventHandler(handler: { [weak self] in
            action()
            if repeats==false {
                self?.destoryTimer(withName: name!)
            }
        })
            
    }
        
    /// 销毁名字为name的计时器
    ///
    /// - Parameter name: 计时器的名字
    func destoryTimer(withName name:String?) {
        let timer = timerContainer[name!]
        if timer == nil {
            return
        }
        timerContainer.removeValue(forKey: name!)
        timer?.cancel()
    }
        
    /// 检测是否已经存在名字为name的计时器
    ///
    /// - Parameter name: 计时器的名字
    /// - Returns: 返回bool值
    func isExistTimer(withName name:String?) -> Bool {
        if timerContainer[name!] != nil {
            return true
        }
        return false
    }
}

//
//  Config.swift
//  SwiftChatUI
//
//  Created by youzhi-air5 on 2021/5/12.
//

import UIKit

public let kScreenWidth:Int = Int(UIScreen.main.bounds.width)

public let kScreenHeight:Int = Int(UIScreen.main.bounds.height)

//输入框高度
public let kInPutHeight = 49

//输入框控件间隔
public let kChatInPutSpace = 7

//输入框最多几行
public let kChatInPutNum = 5

//菜单一行几个
public let kChatShareMenuPerRowItemCount = 4

public let kChatTopSafe = UIApplication.shared.statusBarFrame.size.height

public let kBottomSafe = kChatTopSafe > 20 ? 39 : 0

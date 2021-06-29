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
public let kSHInPutHeight = 49

//输入框控件间隔
public let kSHInPutSpace = 7

//输入框最多几行
public let kSHInPutNum = 5

//菜单一行几个
public let kSHShareMenuPerRowItemCount = 4

public let kSHTopSafe = UIApplication.shared.statusBarFrame.size.height

public let kSHBottomSafe = kSHTopSafe > 20 ? 39 : 0

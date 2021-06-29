//
//  AppDelegate.swift
//  ChatUIDemo
//
//  Created by youzhi-air5 on 2021/5/21.
//

import UIKit
import SwiftyUserDefaults

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print(Defaults[\.mUserId] ?? "")
        
        if Defaults[\.userLogin] == true {
            let rootViewController = ViewController()
            let rootNavigationController = UINavigationController(rootViewController: rootViewController)
            self.window!.rootViewController = rootNavigationController
        } else {
            let rootViewController = SignInViewController()
            let rootNavigationController = UINavigationController(rootViewController: rootViewController)
            self.window!.rootViewController = rootNavigationController
        }
                
        return true
    }
}


//
//  SignInViewController.swift
//  ChatUIDemo
//
//  Created by youzhi-air8 on 2021/6/22.
//

import UIKit
import SwiftyUserDefaults

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(zhTextField)
        view.addSubview(mmTextField)
        view.addSubview(signInBtn)
        
        zhTextField.frame = CGRect(x: 20, y: 95, width: kScreenWidth - 40, height: 45)
        
        mmTextField.frame = CGRect(x: 20, y: 170, width: kScreenWidth - 40, height: 45)
        
        signInBtn.frame = CGRect(x: 30, y: 255, width: kScreenWidth - 60, height: 48)
        
        signInBtn.addTarget(self, action: #selector(signinClick), for: .touchUpInside)
    }

    // 账号
    let zhTextField:UITextField = {
        let text = UITextField()
        text.placeholder = "请输入账号"
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.magenta.cgColor
        text.layer.cornerRadius = 4
        text.layer.masksToBounds = true
        text.font = UIFont.systemFont(ofSize: 15)
//        text.keyboardType = .numberPad
        return text
    }()
    
    // 密码
    let mmTextField:UITextField = {
        let text = UITextField()
        text.placeholder = "请输入密码"
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.magenta.cgColor
        text.layer.cornerRadius = 4
        text.layer.masksToBounds = true
        text.font = UIFont.systemFont(ofSize: 15)
        text.keyboardType = .numberPad
        return text
    }()
    
    let signInBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("登 录", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = .orange
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    @objc func signinClick() {
        let pama:[String:Any] = ["companyId":self.zhTextField.text ?? "", "siteId":self.mmTextField.text ?? ""]
        let url = APIManager.release_host + "/openSource/loginCheck"
        
        NetWorkManager.postRequest(url, method: .post, parameters: pama, headers: nil) { success, message, data in
            if success {
                let rootVC = UIApplication.shared.delegate as! AppDelegate
                let rootViewController = ViewController()
                let rootNavigationController = UINavigationController(rootViewController: rootViewController)
                rootVC.window!.rootViewController = rootNavigationController
                
                Defaults[\.userLogin] = true
                Defaults[\.mUserId] = "\(data["mUserId"]!)"
                Defaults[\.companyId] = self.zhTextField.text!
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

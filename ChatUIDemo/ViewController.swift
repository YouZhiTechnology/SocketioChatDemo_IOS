//
//  ViewController.swift
//  ChatUIDemo
//
//  Created by youzhi-air5 on 2021/5/21.
//

import UIKit
import SocketIO
import SwiftyUserDefaults

class ViewController: UIViewController, MessageProcessingProtocol {
    
    var manager:SocketManager!

    var socketIOClient: SocketIOClient!

    var socket: SocketIOClient?
    
    var dataArray:[ChatListModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        IMManager.shared.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            IMManager.shared.chatList()
        }
        
        
    }
    
    func newMessage(model: MessageModel) {
        IMManager.shared.chatList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(tableView)
        self.navigationItem.title = "通讯录"
        
        tableView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)

        let addItem = UIBarButtonItem(title: "添加", style: .plain, target: self, action: #selector(addClick))
        self.navigationItem.rightBarButtonItem = addItem

        
        IMManager.shared.chatList()
        
    }

    func chatList(list: [ChatListModel]) {
        dataArray = list
        self.tableView.reloadData()
    }
    
    @objc func addClick() {
        
        let alert = AlertWithInput()
        alert.showAlert { content in
            
            
            let parameters:[String:Any] = ["mUserId":Defaults[\.mUserId] ?? "", "companyId":Defaults[\.companyId] ?? "", "siteId":content]
            
            NetWorkManager.postRequest(APIManager.getUserInfo, method: .post, parameters: parameters, headers: nil) { isSuccess, message, data in
                
                if isSuccess {
                      
//                    let json = JSON()
                    
                    let user:[String:Any] = data["user"] as! [String : Any]
                    
                    
                    let vc = SocketChatViewController()
                                
                    vc.sessionId = data["sessionId"] as! String
                    vc.toId = user["id"] as! String
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            
            

        }
    }
    
    fileprivate lazy var tableView = { () -> UITableView in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserListTableViewCell.self, forCellReuseIdentifier: "reuse")
        IMManager.shared.chatList()
        return tableView
    }()
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse", for: indexPath) as! UserListTableViewCell
        cell.selectionStyle = .none
//        cell.textLabel?.text = model.nick
        cell.titleLabel.text = model.nick
        cell.messageLabel.text = model.lastMsg
        cell.headImage.image = UIImage(named: "head")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArray[indexPath.row]
        let vc = SocketChatViewController()
        vc.sessionId = model.sessionId ?? ""
        vc.toId = model.toUserId ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

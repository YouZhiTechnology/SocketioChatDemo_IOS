//
//  UserListTableViewCell.swift
//  ChatUIDemo
//
//  Created by youzhi-air8 on 2021/6/28.
//

import UIKit

class UserListTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(headImage)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(messageLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headImage.frame = CGRect(x: 15, y: 10, width: 40, height: 40)
        titleLabel.frame = CGRect(x: 65, y: 10, width: kScreenWidth - 80, height: 20)
        messageLabel.frame = CGRect(x: 65, y: 30, width: kScreenWidth - 80, height: 20)
    }
    
    let headImage:UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 20
        return image
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let messageLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    
}

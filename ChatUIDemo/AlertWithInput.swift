//
//  AlertWithInput.swift
//  SwiftText
//
//  Created by youzhi-air5 on 2021/2/2.
//

import UIKit

typealias InputBlock = (_ contentString: String) -> Void

class AlertWithInput: UIView, UITextViewDelegate {
    
    var titleString: String?
    
    var selectBlock: InputBlock?
    
    func showAlert(completionHandler: @escaping InputBlock) {
        self.selectBlock = {(content: String) in
            completionHandler(content)
        }
        self.show()
    }
    
    let bgView: UIView = {
        let bg = UIView()
        bg.backgroundColor = .white
        bg.layer.cornerRadius = 10
        bg.layer.masksToBounds = true
        return bg
    }()
    
    
    
    let determineBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .orange
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.layer.cornerRadius = 4
        btn.layer.masksToBounds = true
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("确 认", for: .normal)
        return btn
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField.init()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.orange.cgColor
        textField.layer.cornerRadius = 3
        textField.layer.masksToBounds = true
        return textField
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        UIApplication.shared.keyWindow?.addSubview(self)
        self.addSubview(bgView)
        bgView.addSubview(determineBtn)

        bgView.addSubview(textField)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        
        self.bgView.frame = CGRect(x: 30, y: 180, width: kScreenWidth - 60, height: 160)
        
        textField.frame = CGRect(x: 15, y: 25, width: kScreenWidth - 90, height: 45)
        
        determineBtn.frame = CGRect(x: 35, y: 95, width: kScreenWidth - 130, height: 40)
        
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(dismiss))
        self.addGestureRecognizer(tapGes)
        
        determineBtn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        

        
    }
    
    @objc func btnClick(sender:UIButton) {
        if selectBlock != nil {
            self.selectBlock!(textField.text!)
        }
        dismiss()
    }
    
    @objc func closeBtn(sender:UIButton) {
        dismiss()
    }
    
    func show() {
        bgView.alpha = 0
        bgView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.3) { [self] in
            self.bgView.alpha = 1.0
            self.bgView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    @objc func dismiss() {
        self.removeFromSuperview()
    }
}

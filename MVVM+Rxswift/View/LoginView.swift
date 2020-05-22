//
//  LoginView.swift
//  MVVM+Rxswift
//
//  Created by rau4o on 5/21/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit
import SnapKit

class LoginView: UIView {
    
    let usernameTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Enter Username"
        text.backgroundColor = .lightGray
        return text
    }()
    
    let passwordTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Enter Password"
        text.isSecureTextEntry = true
        text.backgroundColor = .lightGray
        return text
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layoutUI()
    }
    
    private func layoutUI() {
        [usernameTextField, passwordTextField, loginButton].forEach {
            addSubview($0)
        }
        usernameTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(usernameTextField.snp.bottom).offset(30)
            make.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  MainController.swift
//  MVVM+Rxswift
//
//  Created by rau4o on 5/22/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    
    var user: User?
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        layoutUI()
        
        nameLabel.text = "Welcome \(user?.name ?? "")"
    }
    
    private func layoutUI() {
        view.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview().offset(50)
            make.height.equalTo(100)
        }
    }

}

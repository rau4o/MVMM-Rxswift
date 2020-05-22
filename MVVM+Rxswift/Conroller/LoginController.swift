//
//  LoginController.swift
//  MVVM+Rxswift
//
//  Created by rau4o on 5/21/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginController: UIViewController {
    
    var loginView = LoginView()
    var viewModel = LoginViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        bindUI()
        bindViewModel()
        updateControlStatus()
    }
    
    private func layoutUI() {
        view.addSubview(loginView)
        
        loginView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension LoginController {
    
    private func bindUI() {
        viewModel.didLogin.asObserver()
            .observeOn(MainScheduler.instance)
            .bind {[weak self] user in self?.showVC(user: user) }
            .disposed(by: disposeBag)
        
        viewModel.error
            .bind { [weak self] error in print(error.localizedDescription) }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        loginView.usernameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        loginView.passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        loginView.loginButton.rx.tap
            .bind(to: viewModel.needLogin)
            .disposed(by: disposeBag)
    }
    
    private func updateControlStatus() {
        viewModel.isEmailPasswordValid
            .drive(onNext: { [unowned self] isEnabled in
                self.loginView.loginButton.isEnabled = isEnabled
                self.loginView.loginButton.alpha = isEnabled ? 1 : 0.5
            })
            .disposed(by: disposeBag)
        
        loginView.usernameTextField.rx
            .controlEvent(UIControl.Event.editingDidEnd)
            .asDriver()
            .withLatestFrom(viewModel.isEmailValid)
            .drive(onNext: { [unowned self] isValid in
                self.loginView.usernameTextField.textColor = isValid ? UIColor.green : UIColor.red
            })
            .disposed(by: disposeBag)
        
        Driver.combineLatest(
            loginView.usernameTextField.rx.controlEvent(UIControl.Event.editingChanged).asDriver(),
            loginView.passwordTextField.rx.controlEvent(UIControl.Event.editingChanged).asDriver(),
            resultSelector: {_, _ in return ()})
            .withLatestFrom(viewModel.isEmailValid)
            .drive(onNext: { [unowned self] isValid in
                self.loginView.usernameTextField.textColor = isValid ? UIColor.green : UIColor.red
            })
            .disposed(by: disposeBag)
                             
    }
    
    private func showVC(user: User) {
        let vc = MainController()
        vc.user = user
        self.present(vc, animated: true, completion: nil)
    }
}

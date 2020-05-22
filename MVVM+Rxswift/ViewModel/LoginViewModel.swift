//
//  LoginViewModel.swift
//  MVVM+Rxswift
//
//  Created by rau4o on 5/21/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginViewModel {
    
    let userEmail = "user@gmail.com"
    let userPassword = "passsword"
    
    let email = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")
    let needLogin = PublishSubject<Void>()
    
    let isEmailValid: Driver<Bool>
    let isPasswordValid: Driver<Bool>
    let isEmailPasswordValid: Driver<Bool>
    
    
    let error = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    var didLogin = PublishSubject<User>()
    
    init() {
        isEmailValid = email
            .asDriver()
            .map { $0.isValidEmail() }
        
        isPasswordValid = password
            .asDriver()
            .map { $0.count >= 6 }
        
        isEmailPasswordValid = Driver.combineLatest(email.asDriver(), isEmailValid, isPasswordValid) {
            email, isValidEmail, isValidPassword in
            return !email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty && isValidEmail && isValidPassword
            
        }
        
        let loginParams = Driver.combineLatest(email.asDriver(), password.asDriver()) { (email: $0, password: $1)}
        
        needLogin.withLatestFrom(loginParams).flatMap { [unowned self] (email, password) in
            self.logIn(email: email, password: password).catchError { [unowned self] (error) in
                self.error.onNext(error)
                return Observable.empty()
            }
        }.bind(to: didLogin).disposed(by: disposeBag)
    }
    
    func logIn(email: String, password: String) -> Observable<User> {
        return Observable.create { (observer) in
            if email == self.userEmail && password == self.userPassword {
                let responseUser = User(name: "User", surname: "number 1")
                observer.onNext(responseUser)
                observer.onCompleted()
            } else {
                let error = NSError(domain: "org.toprating.authentication", code: 1000,
                                    userInfo: [NSLocalizedDescriptionKey: "The email or password is incorrect"])
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}

extension String {

    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}

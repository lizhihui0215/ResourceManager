//
//  RMLoginViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 28/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Result
import Moya

protocol RMLoginViewModelAction: RMViewModelAction {
}

class RMLoginViewModel: RMViewModel {
    var disposeBag = DisposeBag()
    var username: Driver<Result<String,MoyaError>>
    var password: Driver<Result<String,MoyaError>>
    var signedIn: Driver<Bool>
    
    init(input: (username: Driver<String>, password: Driver<String>, loginTaps: Driver<Void>),
         dependency: (domain: RMLoginDomain, vilidate: RMLoginValidate),
         loginAction: RMLoginViewModelAction) {
        let validate = dependency.vilidate
        let domain = dependency.domain
        self.username = input.username.flatMapLatest({ username in
            return validate.validateUsername(username)
                .asDriver(onErrorJustReturn: Result(error: error(code: 0, message: nil)))
        })
        
        self.password = input.password.flatMapLatest({ password in
            return validate.validateUsername(password)
                .asDriver(onErrorJustReturn: Result(error: error(code: 0, message: nil)))
        })
        
        let usernameAndPassword = Driver.combineLatest(username, password) { ($0, $1) }
        
        
        signedIn = input.loginTaps.withLatestFrom(self.username)
            .flatMapLatest({ username in
                return loginAction.alert(result: username)
            }).withLatestFrom(self.password)
            .flatMapLatest { password in
                return loginAction.alert(result: password)
            }.flatMapLatest({ validate  in
                return loginAction.animation(start: true)
            }).withLatestFrom(usernameAndPassword)
            .flatMapLatest({ username, password in
                return domain.sigin(username: username.value!, password: password.value!)
                    .asDriver(onErrorRecover: { Driver.just(Result(error: $0 as! MoyaError))})
            }).do( onNext: { _ in
                let _ =  loginAction.animation(start: false)
            }).flatMapLatest { result  in
                return loginAction.alert(result: result).asDriver(onErrorJustReturn: false)
            }
        
    }
}

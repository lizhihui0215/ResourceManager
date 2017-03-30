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

class RMLoginViewModel {
    var disposeBag = DisposeBag()
    var username: Driver<ValidationResult>
    var password: Driver<ValidationResult>
    var signedIn: Driver<Bool>
    
    init(input: (username: Driver<String>, password: Driver<String>, loginTaps: Driver<Void>),
         dependency: (domain: RMLoginDomain, vilidate: RMLoginValidate),
         loginAction: RMLoginViewModelAction) {
        let validate = dependency.vilidate
        let domain = dependency.domain
        self.username = input.username.flatMapLatest({ username in
            return validate.validateUsername(username)
                .asDriver(onErrorJustReturn: .failed(message: "Error contacting server", value: username))
        })
        
        self.password = input.password.flatMapLatest({ password in
            return validate.validateUsername(password).asDriver(onErrorJustReturn: .failed(message: "Error contacting server", value: password))
        })
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) { ($0, $1) }
        
        signedIn = input.loginTaps.withLatestFrom(usernameAndPassword).flatMapLatest({ username, password in
            
            let sigin = domain.sigin(username: username, password: password).asDriver(onErrorRecover: { error in
                let x  = error as! Moya.Error;
                return Driver.just(Result(error: x))
            }).asObservable()
            
            let alert = sigin.flatMapLatest({ result in
                return loginAction.alert(result: result)
            })
            
            return alert.asDriver(onErrorJustReturn: false)
        })
    }
    
    func test(title: String) -> Observable<Array<String>> {
        return Observable.just(["1","2",title])
    }
}

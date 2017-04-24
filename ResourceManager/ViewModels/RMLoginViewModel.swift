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
    var username = Variable("")
    var password = Variable("")
    var loginAction: RMLoginViewModelAction
    
    init(loginAction: RMLoginViewModelAction) {
        self.loginAction = loginAction
    }
    
    func user() -> Driver<Bool> {
        return RMLoginDomain.shared.user().flatMapLatest({[weak self] result in
            switch result {
            case .success(let user):
                if let user = user, let strongSelf = self {
                    strongSelf.username.value = user.loginName!
                    strongSelf.password.value = user.password!
                }
                return Driver.just(true)
            case .failure( _):
                break
            }
            return Driver.just(false)
        })
    }
    
    func sigin() -> Driver<Bool> {
        self.loginAction.animation.value = true
        return RMLoginValidate.shared.validateNil(self.username.value, message: "用户名不能为空！")
            .flatMapLatest{ result in
                return self.loginAction.alert(result: result)
            }.flatMapLatest{ result in
                return RMLoginValidate.shared.validateNil(self.password.value, message: "密码不能为空！")
            }.flatMapLatest{ result in
                return self.loginAction.alert(result: result)
            }.flatMapLatest{ _ in
                return RMLoginDomain.shared.sigin(username: self.username.value, password: self.password.value)
            }.flatMapLatest{ result in
                self.loginAction.animation.value = false
                return self.loginAction.alert(result: result)
        }
    }
}

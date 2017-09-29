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
import PCCWFoundationSwift

protocol RMLoginViewModelAction: PFSViewAction {
}

class RMLoginViewModel: PFSViewModel<RMLoginViewController, RMLoginDomain> {
    var username = Variable("")
    var password = Variable("")
    
    func user() -> Driver<Bool> {
        return self.domain.user().flatMapLatest{ result in
            guard let user = try? result.dematerialize() else { return Driver.just(false) }
            self.username.value = user.loginName!
            return Driver.just(false)
        }
    }
    
    func sigin() -> Driver<Bool> {
        let validateAccount = username.value.notNull(message: "用户名不能为空！")
        let validatePassword = password.value.notNull(message: "密码不能为空！")
        let validateResult = PFSValidate.of(validateAccount, validatePassword)
        self.action?.animation.value = true
        return validateResult.flatMapLatest{ result in
                return self.action!.alert(result: result)
            }.flatMapLatest{ _ in
                return self.domain.sigin(username: self.username.value, password: self.password.value)
            }.flatMapLatest{ result in
                self.action?.animation.value = false
                return self.action!.alert(result: result)
        }
    }
}

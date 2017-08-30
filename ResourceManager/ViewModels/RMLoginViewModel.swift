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
        return self.domain.user().flatMapLatest({[weak self] result in
            switch result {
            case .success(let user):
                if let user = user, let strongSelf = self {
                    strongSelf.username.value = user.loginName!
//                    strongSelf.password.value = user.password!
                }
                return Driver.just(true)
            case .failure( _):
                break
            }
            return Driver.just(false)
        })
    }
    
    func sigin() -> Driver<Bool> {
        let validateAccount = username.value.notNull(message: "用户名不能为空！")
        
        let validatePassword = password.value.notNull(message: "密码不能为空！")
        
        let validateResult = PFSValidate.of(validateAccount, validatePassword)

        return validateResult.flatMapLatest{ result in
                return self.action!.alert(result: result)
            }.flatMapLatest{ _ in
                return self.domain.sigin(username: self.username.value, password: self.password.value)
            }.flatMapLatest{ result in
                return self.action!.alert(result: result)
        }
    }
}

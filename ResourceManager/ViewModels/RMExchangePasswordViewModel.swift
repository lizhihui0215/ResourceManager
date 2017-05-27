//
//  RMExchangePasswordViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 17/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift

protocol RMExchangePasswordViewAction: RMViewModelAction {
    
}

class RMExchangePasswordViewModel: RMViewModel {

    var user: RMUser
    
    var action: RMExchangePasswordViewAction
    
    init(action: RMExchangePasswordViewAction, user: RMUser) {
        self.user = user
        self.action = action
    }
    
    func exchangePassword(originPassword: String, newPassword: String, confirmPassword: String) -> Driver<Bool> {
        self.action.animation.value = true
       return RMPersonalCenterValidate.shared.validate(originPassword, newPassword: newPassword, confirmPassword: confirmPassword)
            .flatMapLatest { result   in
                return self.action.alert(result: result)
            }.flatMapLatest { _  in
                return RMPersonalCenterDomain.shared.exchangePassword(password: originPassword, newPassword: newPassword)
        }.flatMapLatest { result  -> Driver<Bool> in
            self.action.animation.value = false
            return self.action.alert(result: result)
        }.flatMapLatest({ _  in
            return self.action.alert(message: "修改成功！", success: true)
        })
    }
}

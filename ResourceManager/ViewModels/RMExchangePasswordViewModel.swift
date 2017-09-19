//
//  RMExchangePasswordViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 17/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import PCCWFoundationSwift

protocol RMExchangePasswordViewAction: PFSViewAction {
    
}

class RMExchangePasswordViewModel: PFSViewModel<RMExchangePasswordViewController, RMPersonalCenterDomain> {

    var user: RMUser
    
    
    init(action: RMExchangePasswordViewController, user: RMUser) {
        self.user = user
        super.init(action: action, domain: RMPersonalCenterDomain())
    }
    
    func exchangePassword(originPassword: String, newPassword: String, confirmPassword: String) -> Driver<Bool> {
       return RMPersonalCenterValidate.shared.validate(originPassword, newPassword: newPassword, confirmPassword: confirmPassword)
            .flatMapLatest { result   in
                return self.action!.alert(result: result)
            }.flatMapLatest { _  in
                return self.domain.exchangePassword(password: originPassword, newPassword: newPassword)
        }.flatMapLatest { result  -> Driver<Bool> in
            return self.action!.alert(result: result)
        }.flatMapLatest({ _  in
            return self.action!.alert(message: "修改成功！", success: true)
        })
    }
}

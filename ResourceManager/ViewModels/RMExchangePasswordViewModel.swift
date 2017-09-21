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

        let validateOriginPassword = originPassword.notNull(message: "原密码不能为空")
        
        let validateNewPassword = newPassword.notNull(message: "新密码不能为空")
        
        let validateConfirmPassword = newPassword.notNull(message: "确认密码不能为空")
        
        let validateSame = newPassword.same(message: "新密码和确认密码不同", confirmPassword)
        
        let validateResult = PFSValidate.of(validateOriginPassword,
                                            validateNewPassword,
                                            validateConfirmPassword,
                                            validateSame)
        
        return validateResult
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

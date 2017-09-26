//
//  RMSuggestViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 18/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import PCCWFoundationSwift

protocol RMSuggestViewAction: PFSViewAction {
    
}

class RMSuggestViewModel: PFSViewModel<RMSuggestViewController, RMPersonalCenterDomain> {
    
    
    init(action: RMSuggestViewController) {
        super.init(action: action, domain: RMPersonalCenterDomain())
    }
    
    func suggest(name: String, phone: String, detail: String) -> Driver<Bool> {        
        let validateName = name.notNull(message: "姓名不能为空")
        
        let validatePhone = phone.notNull(message: "电话码不能为空")
        
        let validateDetail = detail.notNull(message: "内容不能为空")
        
        let validateResult = PFSValidate.of(validateName,
                                            validatePhone,
                                            validateDetail)
        return validateResult
            .flatMapLatest { result   in
                return self.action!.alert(result: result)
            }.flatMapLatest { _  in
                return self.domain.suggest(name: name, phone: phone, detail: detail)
            }.flatMapLatest({ result  in
                return self.action!.alert(result: result)
            })
            .flatMapLatest({ _  in
                return self.action!.alert(message: "提交成功！")
            })
        }
}

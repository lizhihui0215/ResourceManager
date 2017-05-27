//
//  RMSuggestViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 18/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift

protocol RMSuggestViewAction: RMViewModelAction {
    
}

class RMSuggestViewModel: RMViewModel {

    var action: RMSuggestViewAction
    
    
    init(action: RMSuggestViewAction) {
        self.action = action
    }
    
    func suggest(name: String, phone: String, detail: String) -> Driver<Bool> {
        self.action.animation.value = true
        return RMPersonalCenterValidate.shared.validate(name, phone: phone, detail: detail)
            .flatMapLatest { result   in
                return self.action.alert(result: result)
            }.flatMapLatest { _  in
                return RMPersonalCenterDomain.shared.suggest(name: name, phone: phone, detail: detail)
            }.do(onNext: { [weak self] result in
                if let strongSelf = self {
                    
                    strongSelf.action.animation.value = false
                }
            }).flatMapLatest({ result  in
                return self.action.alert(result: result)
            })
            .flatMapLatest({ _  in
                return self.action.alert(message: "提交成功！", success: true)
            })
        }
}

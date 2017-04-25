//
//  RMRootViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/24.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import RxSwift
import RealmSwift
import RxCocoa

protocol RMRootViewAction: RMViewModelAction {
    
}

class RMRootViewModel: RMViewModel {
    
    weak var action: RMRootViewAction?
    

    init(action : RMRootViewAction) {
        self.action = action
    }
    
    func navigationTo() -> Driver<Bool> {
       return RMLoginDomain.shared.user().flatMapLatest { result  in
        
        
        
            switch result{
            case .success(let user):
                if let user = user {
                    return RMLoginDomain.shared.sigin(username: user.loginName!, password: user.password!).flatMapLatest({[weak self] result  in
                        if let action = self?.action {
                            return action.alert(result: result)
                        }else {
                            return Driver.just(false)
                        }
                    })                    
                }
                return Driver.just(false)
            default:
                return Driver.just(false)
            }
        }
    
    }
}

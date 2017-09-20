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
import PCCWFoundationSwift

protocol RMRootViewAction: PFSViewAction {
    
}

class RMRootViewModel: PFSViewModel<RMRootViewController, RMLoginDomain> {
    
    func navigationTo() -> Driver<Bool> {
        self.action?.animation.value = true
//       return RMLoginDomain.shared.user().flatMapLatest { result  in
//            switch result{
//            case .success(let user):
//                if let user = user {
//                    return RMLoginDomain.shared.sigin(username: user.loginName!, password: user.password!).flatMapLatest({[weak self] result  in
//                        switch result {
//                        case .success:
//                            return Driver.just(true)
//                        case .failure(let error):
//                            return (self?.action?.alert(message: error.errorDescription!, success: false))!
//                        }
//                    })                    
//                }
//                return Driver.just(false)
//            default:
//                return Driver.just(false)
//            }
//        }
        return self.domain.sigin(username: "admin", password: "1234").flatMapLatest{ result  in
            self.action?.animation.value = false
            return Driver.just(true)
        }

    }
}

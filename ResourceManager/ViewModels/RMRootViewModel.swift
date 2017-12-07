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
        return self.domain.user().flatMapLatest { result  in
            guard let user = try? result.dematerialize() else { return Driver.just(false) }
            return self.domain.sigin(username: user.loginName!, password: user.password!).map{ $0.value != nil }
        }
//        return self.domain.sigin(username: "admin", password: "1234").flatMapLatest{ result  in
//            self.action?.animation.value = false
//            return Driver.just(true)
//        }
        
    }
}

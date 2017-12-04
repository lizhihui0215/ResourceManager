//
//  RMLoginDomain.swift
//  ResourceManager
//
//  Created by 李智慧 on 28/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import Moya
import Result
import RealmSwift
import PCCWFoundationSwift

class RMLoginDomain: PFSDomain {
    func user() -> Driver<Result<RMUser, MoyaError>> {
        guard let lastUsername = PFSDomain.lastUserName() else {
            return Driver.just(Result(error: error(message: "没有登录用户！")))
        }
        let user: RMUser? = PFSRealm.shared.object("loginName = %@", "admin")
        
        let c: RMUser? = PFSRealm.shared.object()
        
        guard let loginUser = user else {
            return Driver.just(Result(error: error(message: "没有登录用户！")))
        }
        
        return Driver.just(Result(value: loginUser))
    }
    
    func sigin(username: String, password: String) -> Driver<Result<RMUser, MoyaError>> {
        return RMDataRepository.shared.sigin(username: username, password: password)
            .do(onNext: { result in
                guard let user = try? result.dematerialize() else { return }
                user.password = password
                PFSRealm.shared.save(obj: user)
                PFSDomain.login(user: user)
                PFSDomain.last(username: user.loginName)
            })
    }
}

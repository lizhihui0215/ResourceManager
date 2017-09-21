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

class RMLoginValidate: RMValidate {
    static let shared = RMLoginValidate()
}

class RMLoginDomain: PFSDomain {
    func user() -> Driver<Result<RMUser?, MoyaError>> {
        
        let realm = try? Realm()
        
        let user = realm?.objects(RMUser.self).first
        
        return Driver.just(Result(value: user))
    }
    
    func sigin(username: String, password: String) -> Driver<Result<RMUser, MoyaError>> {
        return RMDataRepository.shared.sigin(username: username, password: password).map({ result in
            switch result {
            case .success(let user) :
                do{
                    user.password = password
                    let realm = try Realm()
                    try? realm.write {
                        realm.delete(realm.objects(RMUser.self))
                    }
                    try user.save()
                    RMDomain.user = user
                }catch{
                    print(error)
                }
                return Result(value: user)
            case .failure(let error):
                return Result(error: error)
            }
        }).asDriver(onErrorRecover: { error in
            let x  = error as! MoyaError;
            return Driver.just(Result(error: x))
        })
    }
}

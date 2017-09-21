//
//  RMPersonalCenterDomain.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/16.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import Moya
import Result
import RealmSwift
import PCCWFoundationSwift

class RMPersonalCenterDomain: PFSDomain {

    func logout() ->  Driver<Result<Bool, MoyaError>>{
        return Driver.just(Result(value: true))
    }
    
    func exchangePassword(password: String, newPassword: String) -> Driver<Result<String, MoyaError>> {
        return RMDataRepository.shared.exchangePassword(password: password, newPassword: newPassword).asDriver(onErrorRecover: { error in
            let x  = error as! MoyaError;
            return Driver.just(Result(error: x))
        })
    }
    
    func suggest(name: String, phone: String, detail: String) -> Driver<Result<String, MoyaError>> {
        return RMDataRepository.shared.suggest(name: name, phone: phone, detail: detail).asDriver(onErrorRecover: { error in
            let x  = error as! MoyaError;
            return Driver.just(Result(error: x))
        })
        
    }
    

}

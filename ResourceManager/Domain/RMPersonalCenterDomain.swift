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
        return RMDataRepository.shared.exchangePassword(password: password, newPassword: newPassword)
    }
    
    func suggest(name: String, phone: String, detail: String) -> Driver<Result<String, MoyaError>> {
        return RMDataRepository.shared.suggest(name: name, phone: phone, detail: detail)
        
    }


    func updateOfflineData() -> Driver<Result<Bool, MoyaError>> {
        let result = RMDataRepository.shared.offlineData()

        return result.flatMapLatest { result  in
            guard let cabinet = try? result.dematerialize() else {
                return Driver.just(Result(error: error(message: "更新失败！")) )
            }
            try? PFSRealm.shared.deleteAll(typeOf: RMInspect.self)
            try? PFSRealm.shared.deleteAll(typeOf: RMLink.self)
            try? PFSRealm.shared.deleteAll(typeOf: RMDevice.self)
            try? PFSRealm.shared.deleteAll(typeOf: RMPort.self)
            return self.save(cabinets: cabinet)
         }
    }
    
    func save(cabinets: [RMCabinet]) -> Driver<Result<Bool, MoyaError>>  {
        let result :Result<[RMCabinet], MoyaError> = PFSRealm.shared.save(objs: cabinets)
        
        if let realmError = result.error {
            let result = Result<Bool, MoyaError>(error: error(message: realmError.localizedDescription))
            return Driver.just(result)
        }
        
        return Driver.just(Result(value: true))
    }
}

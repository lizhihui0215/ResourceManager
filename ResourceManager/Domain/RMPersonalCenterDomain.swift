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

class RMPersonalCenterDomain: RMDomain {
    static let shared = RMPersonalCenterDomain()
    
    func user() -> Driver<Result<RMUser, MoyaError>> {
        return RMPersonalCenterDomain.repository.user().asDriver(onErrorRecover: { error in
            let x  = error as! Moya.Error;
            return Driver.just(Result(error: x))
        })
    }
    

}

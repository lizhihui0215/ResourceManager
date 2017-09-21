//
//  RMLinkDetailDomain.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/15.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import Result
import Moya
import PCCWFoundationSwift

class RMLinkDetailValidate: RMValidate {
    static let shared = RMLinkDetailValidate()

}

class RMLinkDetailDomain: PFSDomain {

    func linkModify(link: RMLink) -> Driver<Result<String, MoyaError>> {
        return RMDataRepository.shared.linkModify(link: link).asDriver(onErrorRecover: { error in
            print(error)
            let x  = error as! MoyaError;
            return Driver.just(Result(error: x))
        })
    }

    func link(deviceCode: String) -> Driver<Result<[RMLink], MoyaError>> {
        return RMDataRepository.shared.link(deviceCode: deviceCode).asDriver(onErrorRecover: { error in
            print(error)
            let x  = error as! MoyaError;
            return Driver.just(Result(error: x))
        })
    }
    
    func ports(deviceCode: String) -> Driver<Result<[String], MoyaError>> {
        return RMDataRepository.shared.ports(deviceCode: deviceCode).asDriver(onErrorRecover: { error in
            print(error)
            let x  = error as! MoyaError;
            return Driver.just(Result(error: x))
        })
    }
}

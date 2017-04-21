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

class RMLinkDetailDomain: RMDomain {
    static let shared = RMLinkDetailDomain()

    func linkModify(link: RMLink) -> Driver<Result<String, Moya.Error>> {
        return RMLinkDetailDomain.repository.linkModify(link: link).asDriver(onErrorRecover: { error in
            print(error)
            let x  = error as! Moya.Error;
            return Driver.just(Result(error: x))
        })
    }

    func link(deviceCode: String) -> Driver<Result<[RMLink], Moya.Error>> {
        return RMLinkDetailDomain.repository.link(deviceCode: deviceCode).asDriver(onErrorRecover: { error in
            print(error)
            let x  = error as! Moya.Error;
            return Driver.just(Result(error: x))
        })
    }
}

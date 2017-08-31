//
//  RMCabinetSearchDomain.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift
import Result
import Moya
import PCCWFoundationSwift

class RMCabinetSearchDomain: PFSDomain {
    
    var page = 0
    
    var size = 20
    
    func cabinetList(account: String, customerName: String, linkCode: String, refresh: Bool) -> Driver<Result<[RMCabinet], Moya.Error>> {
        if refresh { page = 0 } else { page += 1 }
        return RMDataRepository.shared.cabinetList(account: account, customerName: customerName, linkCode: linkCode , page: page, size: size).asDriver(onErrorRecover: {[weak self] error in
            print(error)
            self?.page -= 1
            let x  = error as! Moya.Error;
            return Driver.just(Result(error: x))
        })
    }
    
}

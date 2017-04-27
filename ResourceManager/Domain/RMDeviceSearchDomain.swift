//
//  RMDeviceSearchDomain.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/27.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift
import Result
import Moya

class RMDeviceSearchDomain: RMDomain {
    static let shared = RMDeviceSearchDomain()
    
    var page = 0
    
    var size = 20
    
    func deviceList(deviceCode: String, deviceName: String, refresh: Bool) -> Driver<Result<[RMDevice], Moya.Error>> {
        if refresh { page = 0 } else { page += 1 }
        return RMDeviceSearchDomain.repository.deviceList(deviceCode: deviceCode, deviceName: deviceName, page: page, size: size).asDriver(onErrorRecover: {[weak self] error in
            print(error)
            self?.page -= 1
            let x  = error as! Moya.Error;
            return Driver.just(Result(error: x))
        })
    }
}

//
//  RMDeviceModifyDomain.swift
//  ResourceManager
//
//  Created by 李智慧 on 12/05/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import Result
import RxSwift
import Moya

class RMDeviceModifyDomain: RMDomain {
    static let shared = RMDeviceModifyDomain()
    
    func modifyDevice(device: RMDevice) -> Driver<Result<String,Moya.Error>> {
        return RMDeviceModifyDomain.repository.modifyDevice(device: device).asDriver(onErrorRecover: { error in
            print(error)
            let x  = error as! Moya.Error;
            return Driver.just(Result(error: x))
        })
    }
}

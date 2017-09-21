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
import PCCWFoundationSwift

class RMDeviceModifyDomain: PFSDomain {
    
    func modifyDevice(device: RMDevice) -> Driver<Result<String,MoyaError>> {
        return RMDataRepository.shared.modifyDevice(device: device).asDriver(onErrorRecover: { error in
            print(error)
            let x  = error as! MoyaError;
            return Driver.just(Result(error: x))
        })
    }
}

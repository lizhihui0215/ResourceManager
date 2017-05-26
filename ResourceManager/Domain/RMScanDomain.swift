//
//  RMScanDomain.swift
//  ResourceManager
//
//  Created by 李智慧 on 06/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import Result

class RMScanDomain: RMDomain {
    static let shared = RMScanDomain()
    
    func link(linkCode: String) -> Driver<Result<RMLink, Moya.Error>> {
        return RMScanDomain.repository.link(linkCode: linkCode).asDriver(onErrorRecover:  { error in
            let x  = error as! Moya.Error;
            return Driver.just(Result(error: x))
        })
    }
    
    func cabinet(cabinetId: String) -> Driver<Result<RMCabinet, Moya.Error>> {
        return RMScanDomain.repository.cabinet(cabinetId: cabinetId).asDriver(onErrorRecover:  { error in
            let x  = error as! Moya.Error;
            return Driver.just(Result(error: x))
        })
    }
    
    func deviceDetail(deviceCode: String) -> Driver<Result<RMDevice, Moya.Error>> {
        return RMScanDomain.repository.device(deviceCode: deviceCode).asDriver(onErrorRecover:  { error in
            let x  = error as! Moya.Error;
            return Driver.just(Result(error: x))
        })
    }
}

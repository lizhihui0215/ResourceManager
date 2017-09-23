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
import PCCWFoundationSwift

class RMScanDomain: PFSDomain {
    
    var linkDomain = RMLinkSearchDomain()
    
    func linkList(account: String, customerName: String, linkCode: String, refresh: Bool) -> Driver<Result<[RMLink], MoyaError>> {
        return linkDomain.linkList(account: account,
                                   customerName: customerName,
                                   linkCode: linkCode,
                                   refresh: refresh)
    }
    
    func link(linkCode: String) -> Driver<Result<RMLink, MoyaError>> {
        return RMDataRepository.shared.link(linkCode: linkCode)
    }
    
    func cabinet(cabinetId: String) -> Driver<Result<RMCabinet, MoyaError>> {
        return RMDataRepository.shared.cabinet(cabinetId: cabinetId)
    }
    
    func deviceDetail(deviceCode: String) -> Driver<Result<RMDevice, MoyaError>> {
        return RMDataRepository.shared.device(deviceCode: deviceCode)
    }
    
    
}

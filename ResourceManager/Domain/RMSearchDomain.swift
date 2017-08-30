//
//  RMSearchDomain.swift
//  ResourceManager
//
//  Created by 李智慧 on 31/08/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import PCCWFoundationSwift
import RxCocoa
import Moya
import RxSwift
import Result

class RMSearchDomain: PFSDomain {
    
    var linkDomain = RMLinkSearchDomain()
    
    var cabinetDomain = RMCabinetSearchDomain()
    
    var deviceDomain = RMDeviceSearchDomain()
    
    func linkList(account: String, customerName: String, linkCode: String, refresh: Bool) -> Driver<Result<[RMLink], Moya.Error>> {
        return linkDomain.linkList(account: account,
                                   customerName: customerName,
                                   linkCode: linkCode,
                                   refresh: refresh)
    }
    
    func cabinetList(account: String, customerName: String, linkCode: String, refresh: Bool) -> Driver<Result<[RMCabinet], Moya.Error>> {
        return cabinetDomain.cabinetList(account: account,
                                         customerName: customerName,
                                         linkCode: linkCode,
                                         refresh: refresh)
    }
    
    func deviceList(deviceCode: String, deviceName: String, refresh: Bool) -> Driver<Result<[RMDevice], Moya.Error>> {
        return deviceDomain.deviceList(deviceCode: deviceCode,
                                       deviceName: deviceName,
                                       refresh: refresh)
    }

}

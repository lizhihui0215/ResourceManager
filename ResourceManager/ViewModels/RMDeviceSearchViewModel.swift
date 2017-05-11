//
//  RMDeviceSearchViewModel.swift
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

protocol RMDeviceSearchAction: RMSearchListAction {
    
}

class RMDeviceSearchViewModel: RMSearchViewModel {
    var devices = [RMDevice]()
    
    var isAccess: Bool
    
    
    init(actions: RMSearchListAction, isAccess: Bool) {
        self.isAccess = isAccess
        super.init(actions: actions, title: "设备查询")
    }
        
    override func search() -> Driver<Bool> {
        return deviceList(refresh: true)
    }
    
    override func identifier(`for`: RMSearchIdentifier) -> String{
        switch `for` {
        case .toScan:
            return "toDeviceScan"
        case .toSearchList:
            return "toDeviceList"
        }
    }
    
    
    func deviceList(refresh: Bool) -> Driver<Bool> {
        self.actions.animation.value = true
        return RMDeviceSearchDomain.shared.deviceList(deviceCode: self.firstField.value, deviceName: self.secondField.value, refresh: refresh)
                .do(onNext: { [weak self] result in
                
                if let strongSelf = self {
                    switch result {
                    case.success(let devices):
                        strongSelf.devices = devices
                    case.failure(_): break
                    }
                    strongSelf.actions.animation.value = false
                }
            }).flatMapLatest({ result  in
                return self.actions.alert(result: result)
            })
    }
}
//
//  RMDeviceListViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 27/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift

protocol RMDeviceListViewAction: RMViewModelAction {
    
}

class RMDeviceListViewModel: RMViewModel, RMListDataSource {
    
    var deviceCode = Variable("")
    
    var deviceName = Variable("")
    
    var isAccess: Bool
    
    var datasource: Array<RMSection<RMDevice, Void>> = []
    
    var action: RMDeviceListViewAction
    
    init(action: RMDeviceListViewAction, isAccess: Bool) {
        self.datasource.append(RMSection())
        self.isAccess = isAccess
        self.action = action
    }
    
    func deviceList(refresh: Bool) -> Driver<Bool> {
        self.action.animation.value = true
        return RMDeviceSearchDomain.shared.deviceList(deviceCode: deviceCode.value,
                                                      deviceName: deviceName.value,
                                                      refresh: refresh)
            .do(onNext: { [weak self] result in
                
                if let strongSelf = self {
                    switch result {
                    case.success(let devices):
                        if refresh {
                            strongSelf.section(at: 0).removeAll()
                        }
                        strongSelf.section(at: 0).append(contentsOf: devices)
                    case.failure(_): break
                    }
                    strongSelf.action.animation.value = false
                }
            })
            .flatMapLatest({ result  in
                return self.action.toast(message: result)
            })
    }
}

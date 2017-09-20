//
//  RMDeviceListViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 27/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import PCCWFoundationSwift
protocol RMDeviceListViewAction: PFSViewAction {
    
}

class RMDeviceListViewModel: PFSViewModel<RMDeviceListViewController, RMDeviceSearchDomain>, RMListDataSource {
    
    var deviceCode = Variable("")
    
    var deviceName = Variable("")
    
    var isAccess: Bool
    
    var datasource: Array<RMSection<RMDevice, Void>> = []
    
    
    var isModify: Bool
    
    
    init(action: RMDeviceListViewController, isAccess: Bool, isModify: Bool = false) {
        self.datasource.append(RMSection())
        self.isAccess = isAccess
        self.isModify = isModify
        super.init(action: action, domain: RMDeviceSearchDomain())
    }
    
    func deviceList(refresh: Bool) -> Driver<Bool> {
        self.action?.animation.value = true

        return self.domain.deviceList(deviceCode: deviceCode.value,
                                                      deviceName: deviceName.value,
                                                      refresh: refresh)
            .do(onNext: { [weak self] result in
                self?.action?.animation.value = false
                if let strongSelf = self {
                    switch result {
                    case.success(let devices):
                        if refresh {
                            strongSelf.section(at: 0).removeAll()
                        }
                        strongSelf.section(at: 0).append(contentsOf: devices)
                    case.failure(_): break
                    }
                }
            })
            .flatMapLatest({ result  in
                return self.action!.toast(message: result)
            })
    }
}

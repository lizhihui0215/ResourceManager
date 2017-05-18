//
//  RMDeviceModifyViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 12/05/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa
import Result

protocol RMDeviceModifyAction: RMViewModelAction {
    
}

class RMDeviceModifyViewModel: RMViewModel {
    
    var action: RMDeviceModifyAction
    
    var device: RMDevice
    
    var deviceCode = Variable("")
    var deviceName = Variable("")
    var deviceLocation = Variable("")
    var totalTerminals = Variable("0")
    var terminalOccupied = Variable("0")
    var terminalFree = Variable("0")
    var deviceDesc = Variable("")
    
    init(action: RMDeviceModifyAction, device: RMDevice) {
        self.action = action
        self.device = device
        self.deviceCode.value = self.device.deviceCode ?? ""
        self.deviceName.value = self.device.deviceName ?? ""
        self.deviceLocation.value = self.device.deviceLocation ?? ""
        self.totalTerminals.value = String(self.device.totalTerminals)
        self.terminalOccupied.value = String(self.device.terminalOccupied)
        self.terminalFree.value = String(self.device.terminalFree)
        self.deviceDesc.value = self.device.deviceDesc ?? ""
        super.init()
        deviceCode.asObservable().bind { device.deviceCode = $0  }.addDisposableTo(disposeBag)
        deviceName.asObservable().bind { device.deviceName = $0  }.addDisposableTo(disposeBag)
        deviceLocation.asObservable().bind { device.deviceLocation = $0  }.addDisposableTo(disposeBag)
        totalTerminals.asObservable().bind { device.totalTerminals = Int($0) ?? 0  }.addDisposableTo(disposeBag)
        terminalOccupied.asObservable().bind { device.terminalOccupied = Int($0) ?? 0  }.addDisposableTo(disposeBag)
        terminalFree.asObservable().bind { device.terminalFree = Int($0) ?? 0  }.addDisposableTo(disposeBag)
        deviceDesc.asObservable().bind { device.deviceDesc = $0  }.addDisposableTo(disposeBag)
    }
    
    func commit() -> Driver<Bool> {        
        guard let totalTerminals = Int(totalTerminals.value) else {
            return self.action.alert(message: "请输入正确的数字！")
        }
        
        if totalTerminals > 128 {
            return self.action.alert(message: "端口总数不能大于128！")
        }
        
        return RMDeviceModifyDomain.shared.modifyDevice(device: device).do(onNext: { [weak self] result in
            if let strongSelf = self {
                strongSelf.action.animation.value = false
            }
        }).flatMapLatest({ result  in
            return self.action.alert(result: result)
        }).flatMapLatest({ _  in
            return self.action.alert(message: "修改成功！")
        })
    }

}

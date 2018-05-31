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
import PCCWFoundationSwift

protocol RMDeviceModifyAction: PFSViewAction {
    
}

class RMDeviceModifyViewModel: PFSViewModel<RMDeviceDetailViewController, RMDeviceModifyDomain> {
        
    var device: RMDevice
    
    var deviceCode = Variable("")
//    var deviceName = Variable("")
    var deviceLocation = Variable("")
    var totalTerminals = Variable("0")
    var terminalOccupied = Variable("0")
    var terminalFree = Variable("0")
    var deviceDesc = Variable("")
 
    var deviceType = Variable("")
    var deviceProducer = Variable("")
    var deviceModel = Variable("")
    
    
    init(action: RMDeviceDetailViewController, device: RMDevice) {
        self.device = device
        self.deviceCode.value = self.device.deviceCode ?? ""
//        self.deviceName.value = self.device.deviceName ?? ""
        self.deviceLocation.value = self.device.deviceLocation ?? ""
        self.totalTerminals.value = String(self.device.totalTerminals)
        self.terminalOccupied.value = String(self.device.terminalOccupied)
        self.terminalFree.value = String(self.device.terminalFree)
        self.deviceDesc.value = self.device.deviceDesc ?? ""
        self.deviceType.value = self.device.deviceType ?? ""
        self.deviceProducer.value = self.device.deviceProducer ?? ""
        self.deviceModel.value = self.device.deviceModel ?? ""
        
        super.init(action: action, domain: RMDeviceModifyDomain())
        deviceCode.asObservable().bind { deviceCode in
                device.deviceCode = deviceCode
        }.addDisposableTo(disposeBag)
//        deviceName.asObservable().bind { device.deviceName = $0  }.addDisposableTo(disposeBag)
        deviceLocation.asObservable().bind { deviceLocation in
                device.deviceLocation = deviceLocation
       }.addDisposableTo(disposeBag)
        totalTerminals.asObservable().bind { totalTerminals in
                device.totalTerminals = Int(totalTerminals) ?? 0
        }.addDisposableTo(disposeBag)
        terminalOccupied.asObservable().bind { terminalOccupied in
                device.terminalOccupied = Int(terminalOccupied) ?? 0
        }.addDisposableTo(disposeBag)
        terminalFree.asObservable().bind { terminalFree in
                device.terminalFree = Int(terminalFree) ?? 0
        }.addDisposableTo(disposeBag)
        deviceDesc.asObservable().bind { deviceDesc in
                device.deviceDesc = deviceDesc
        }.addDisposableTo(disposeBag)
        deviceType.asObservable().bind { deviceType in
                device.deviceType = deviceType
        }.addDisposableTo(disposeBag)
        deviceProducer.asObservable().bind { deviceProducer in
                device.deviceProducer = deviceProducer
        }.addDisposableTo(disposeBag)
        deviceModel.asObservable().bind { deviceModel in
                device.deviceModel = deviceModel
        }.addDisposableTo(disposeBag)

    }
    
    func commit() -> Driver<Bool> {
        guard let totalTerminals = Int(totalTerminals.value) else {
            return self.action!.alert(message: "请输入正确的数字！", success: false)
        }
        
        if totalTerminals > 128 {
            return self.action!.alert(message: "端口总数不能大于128！", success: false)
        }
        
        if deviceType.value.characters.count <= 0 {
            return self.action!.alert(message: "请输入设备类型", success: false)
        }
        
        if deviceProducer.value.characters.count <= 0 {
            return self.action!.alert(message: "请输入设备厂家", success: false)
        }
        
        if deviceModel.value.characters.count <= 0 {
            return self.action!.alert(message: "请输入设备型号", success: false)
        }
//        PFSRealm.shared.update(obj: device)

        return self.domain.modifyDevice(device: device).flatMapLatest({ result  in
            return self.action!.alert(result: result)
        }).flatMapLatest({ _  in
            return self.action!.alert(message: "修改成功！", success: true)
        })
    }

}

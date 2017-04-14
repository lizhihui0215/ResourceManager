//
//  RMDeviceDetailViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 14/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa

enum RMDevicePort {
    case free
    case occupied
    case other
    
    func image() -> UIImage {
        switch self {
        case .free:
            return UIImage(named: "cabinet-detail.icon.white")!
        case .occupied:
            return UIImage(named: "cabinet-detail.icon.green")!
        case .other:
            return UIImage(named: "cabinet-detail.icon.rad")!
        }
    }
    
    func titleColor() -> UIColor {
        switch self {
        case .free:
            return UIColor.black
        case .occupied:
            return UIColor.white
        case .other:
            return UIColor.yellow
        }
    }
}

class RMDeviceDetailViewModel: RMViewModel, RMListDataSource {
    var datasource: Array<RMSection<RMDevicePort, Void>> = []
    
    var device: RMDevice
    
    var deviceCode = Variable("")
    var deviceName = Variable("")
    var deviceLocation = Variable("")
    var totalTerminals = Variable("")
    var terminalOccupied = Variable("")
    var terminalFree = Variable("")
    var deviceDesc = Variable("")

    init(device: RMDevice) {
        self.device = device
        self.deviceCode.value = self.device.deviceCode ?? ""
        self.deviceName.value = self.device.deviceName ?? ""
        self.deviceLocation.value = self.device.deviceLocation ?? ""
        self.totalTerminals.value = String(self.device.totalTerminals)
        self.terminalOccupied.value = String(self.device.terminalOccupied)
        self.terminalFree.value = String(self.device.terminalFree)
        self.deviceDesc.value = self.device.deviceDesc ?? ""
        
        super.init()
        self.datasource.append(RMSection())
        let section = self.section(at: 0)
        for _ in 1...device.terminalOccupied {
            section.append(item: .occupied)
        }
        
        for _ in 1...device.terminalFree {
            section.append(item: .free)
        }
    }
}

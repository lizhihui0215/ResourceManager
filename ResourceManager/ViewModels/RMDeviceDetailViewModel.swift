//
//  RMDeviceDetailViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 14/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa
import Result

enum RMDevicePort {
    case free(Int)
    case occupied(Bool, RMLink)
    case other(RMLink)
    
    init(free port: Int) {
        self = .free(port)
    }
    
    init(occupied link: RMLink, isFarend: Bool) {
        self = .occupied(isFarend, link)
    }
    
    init(other link: RMLink) {
        self = .other(link)
    }
    
    func port() -> String {
        switch self {
        case let .free(port):
            return String(port)
        case let .occupied(isFarend, link):
            if isFarend {
                return String( link.farendDevicePort)
            }else {
                return String( link.accessDevicePort)
            }
        case .other:
            return "unknow"
        }
    }
    
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

protocol RMDeviceDetailViewAction: RMViewModelAction {
    
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
    
    var links = [RMLink]()
    
    
    var action: RMDeviceDetailViewAction
    
    init(device: RMDevice, action: RMDeviceDetailViewAction) {
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
        self.datasource.append(RMSection())
    }
    
    func link() -> Driver<Bool> {
        self.action.animation.value = true
        return RMLinkDetailDomain.shared.link(deviceCode: self.deviceCode.value)
            .flatMapLatest({ result  in
                self.action.animation.value = false
                switch result {
                case .success(let links):
                    let occupiedPorts: [RMDevicePort] = links.filter{
                        $0.farendDeviceName == self.deviceName.value || $0.accessDeviceName == self.deviceName.value
                        }
                        .map{
                            if $0.farendDeviceName == self.deviceName.value {
                                return RMDevicePort(occupied: $0, isFarend: true)
                            }
                            
                            if $0.accessDeviceName == self.deviceName.value {
                                return RMDevicePort(occupied: $0, isFarend: false)
                            }
                            
                            return RMDevicePort(free: -1)
                        }.sorted(by: { $0.port() < $1.port()})
                    
                    if occupiedPorts.count != occupiedPorts.count {
                        return self.action.alert(message: "程序异常，请联系管理员");
                    }
                    
                    self.section(at: 0).append(contentsOf: occupiedPorts)
                    
                    for i in 1...self.device.terminalFree {
                        guard let occupiedPort = occupiedPorts.last?.port() else {
                            break
                        }
                        
                        let port = i + Int(occupiedPort)!
                        self.section(at: 0).append(item: RMDevicePort(free: port))
                    }
                    
                default:
                    break
                }
                return self.action.alert(result: result)
            })
    }
}

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
import PCCWFoundationSwift

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
                return link.farendDevicePort ?? ""
            }else {
                return link.accessDevicePort ?? ""
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

protocol RMDeviceDetailViewAction: PFSViewAction {
    
}

class RMDeviceDetailViewModel: PFSViewModel<RMDeviceViewController, RMLinkDetailDomain>, RMListDataSource {
    var datasource: Array<RMSection<RMDevicePort, Void>> = []
    
    var device: RMDevice
    
    var deviceCode = Variable("")
    var deviceLocation = Variable("")
    var totalTerminals = Variable("")
    var terminalOccupied = Variable("")
    var terminalFree = Variable("")
    var deviceDesc = Variable("")
    var deviceRoom = Variable("")
    
    var links = [RMLink]()
    
    init(device: RMDevice, deviceRoom: String, action: RMDeviceViewController) {
        self.device = device
        self.deviceCode.value = self.device.deviceCode ?? ""
        self.deviceLocation.value = self.device.deviceLocation ?? ""
        self.totalTerminals.value = String(self.device.totalTerminals)
        self.terminalOccupied.value = String(self.device.terminalOccupied)
        self.terminalFree.value = String(self.device.terminalFree)
        self.deviceDesc.value = self.device.deviceDesc ?? ""
        self.deviceRoom.value = deviceRoom
        super.init(action: action, domain: RMLinkDetailDomain() )
        self.datasource.append(RMSection())
    }
    
    func link() -> Driver<Bool> {
        return self.domain.link(deviceCode: self.deviceCode.value)
            .flatMapLatest({ result  in
                switch result {
                case .success(let links):
                    let occupiedPorts: [RMDevicePort] = links.filter{
                        $0.farendDeviceId == self.deviceCode.value || $0.accessDeviceId == self.deviceCode.value
                        }
                        .map{
                            if $0.farendDeviceId == self.deviceCode.value {
                                return RMDevicePort(occupied: $0, isFarend: true)
                            }
                            
                            if $0.accessDeviceId == self.deviceCode.value {
                                return RMDevicePort(occupied: $0, isFarend: false)
                            }
                            
                            return RMDevicePort(free: -1)
                        }.sorted(by: { $0.port() < $1.port()})
                    
                    if occupiedPorts.count != occupiedPorts.count {
                        return self.action!.alert(message: "程序异常，请联系管理员", success: false);
                    }
                    
                    for occupiedPort in occupiedPorts {
                        self.section(at: 0).append(item: occupiedPort)
                    }
                    
                    for i in occupiedPorts.count..<self.device.totalTerminals {
                        self.section(at: 0).append(item: RMDevicePort(free: i))
                    }
                    
                default:
                    break
                }
                return self.action!.alert(result: result)
            })
    }
}

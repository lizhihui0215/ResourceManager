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
    /// 1.端口名称，2电路总数， 3所属设备， 4，是否是对端 5，电路列表
    case occupied(String, String, String, Bool, [RMLink])
    case other(RMLink)
    
    init(free port: Int) {
        self = .free(port)
    }
    
    init(occupied portName: String,
         linkCount: String,
         inDevice: String,
         isFarend: Bool,
         links: [RMLink]) {
        self = .occupied(portName, linkCount,inDevice, isFarend, links)
    }
    
    init(other link: RMLink) {
        self = .other(link)
    }
    
    func portName() -> String {
        switch self {
        case let .free(port):
            return String(port)
        case let .occupied(portName,_, _, _, _):
            return portName
        case .other:
            return "unknow"
        }
    }
    
    func isFarend() -> Bool {
        switch self {
        case let .free(port):
            return false
        case let .occupied(_,_, _, isFarend, _):
            return isFarend
        case .other:
            return false
        }
    }
    
    func deviceName() -> String {
        switch self {
        case let .free(port):
            return String(port)
        case let .occupied(_,_, deviceName, _, _):
            return deviceName
        case .other:
            return "unknow"
        }
    }
    
    func portCount() -> String {
        switch self {
        case let .free(port):
            return String(port)
        case let .occupied(_, linkCount, _, _, _):
            return linkCount
        case .other:
            return "unknow"
        }
    }
    
    func links() -> [RMLink] {
        switch self {
        case .free:
            return []
        case let .occupied(_, _, _, _, links):
            return links
        case .other:
            return []
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

protocol RMCabinetDeviceDetailViewAction: PFSViewAction {
    
}

extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}

class RMCabinetDeviceDetailViewModel: PFSViewModel<RMCabinetDeviceDetailViewController, RMLinkDetailDomain>, RMListDataSource {
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
    
    init(device: RMDevice, deviceRoom: String, action: RMCabinetDeviceDetailViewController) {
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
    
    func groupPorts(with links: [RMLink])  {
        
        let sameAccessDeviceIds = links.filter { $0.accessDeviceId == self.deviceCode.value }
        
        let sameFarendDeviceIds = links.filter{ $0.farendDeviceId == self.deviceCode.value }
        
        
        let sameAccessDevicePorts: [RMLink] = sameAccessDeviceIds.unique { link  in
            return link.accessDevicePort!
        }
        
        let sameFarendDevicePorts: [RMLink] = sameFarendDeviceIds.unique { link  in
            return link.farendDevicePort!
        }
        
        for link in sameAccessDevicePorts {
            let access = sameAccessDeviceIds.filter{ $0.accessDevicePort == link.accessDevicePort}

            let occupiedPort = RMDevicePort(occupied: link.accessDevicePort!,
                                            linkCount: String(access.count),
                                            inDevice: self.deviceCode.value,
                                            isFarend: false,
                                            links: access)
            self.section(at: 0).append(item: occupiedPort)
        }
        for link in sameFarendDevicePorts {
            let farends = sameFarendDeviceIds.filter{ $0.farendDevicePort == link.farendDevicePort}
            let occupiedPort = RMDevicePort(occupied: link.farendDevicePort!,
                                            linkCount: String(farends.count),
                                            inDevice: self.deviceCode.value,
                                            isFarend: true,
                                            links: farends)
            self.section(at: 0).append(item: occupiedPort)
        }
        
        let occupiedPorts = self.section(at: 0).items.count
        
        for i in occupiedPorts..<self.device.totalTerminals {
            self.section(at: 0).append(item: RMDevicePort(free: i))
        }
    }
    
    func link() -> Driver<Bool> {
        self.action?.animation.value = true
        return self.domain.link(deviceCode: self.deviceCode.value)
            .flatMapLatest({ result  in
                self.action?.animation.value = false
                switch result {
                case .success(let links):
                    self.groupPorts(with: links)
                default:
                    break
                }
                return self.action!.alert(result: result)
            })
    }
}

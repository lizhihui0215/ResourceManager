//
//  RMDevicePortDetailViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 06/10/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import PCCWFoundationSwift
import RxCocoa
import RxSwift

protocol RMDevicePortDetailAction: PFSViewAction  {
    
}

class RMDevicePortDetailViewModel: PFSViewModel<RMDevicePortDetailViewController, RMDevicePortDetailDomain>, RMListDataSource {
    
    var datasource: Array<RMSection<RMLink, Void>> = []
    
    var portName = Variable("")
    
    var linkCount = Variable("")
    
    var deviceName = Variable("")
    
    var isFarend = false
    
    init(action: RMDevicePortDetailViewController, port: RMDevicePort) {
        super.init(action: action, domain: RMDevicePortDetailDomain())
        self.portName.value = port.portName()
        self.linkCount.value = port.portCount()
        self.deviceName.value = port.deviceName()
        self.datasource.append(RMSection())
        self.isFarend = port.isFarend()
        self.section(at: 0).append(contentsOf: port.links())
    }
    
    func linkCodeAt(indexPath: IndexPath) -> String {
        let link  = self.elementAt(indexPath: indexPath)
        return link.linkCode ?? ""
    }
    
    func linkNameAt(indexPath: IndexPath) -> String {
        let link  = self.elementAt(indexPath: indexPath)
        return link.linkName ?? ""
    }
    
    func deviceIdAt(indexPath: IndexPath) -> String {
        let link  = self.elementAt(indexPath: indexPath)
        return (self.isFarend ? link.farendDeviceId : link.accessDeviceId) ?? ""
    }
    
    func customerNameAt(indexPath: IndexPath) -> String {
        let link  = self.elementAt(indexPath: indexPath)
        return link.customerName ?? ""
    }
    
    func devicePortAt(indexPath: IndexPath) -> String {
        let link  = self.elementAt(indexPath: indexPath)
        return (self.isFarend ? link.farendDevicePort : link.accessDevicePort) ?? ""
    }
}

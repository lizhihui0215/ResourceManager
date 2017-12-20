//
//  RMCabinetDetailViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PCCWFoundationSwift

protocol RMCabinetDetailAction: PFSViewAction {
    
}

class RMCabinetDetailViewModel: PFSViewModel<RMCabinetDetailViewController, RMCabinetDetailDomain>, RMListDataSource {
    
    var datasource: Array<RMSection<RMDevice, Void>> = []
    var cabinetCode = Variable<String>("")
    var cabinetLocation = Variable<String>("")
    var capacity = Variable<String>("")
    var cabinetRoom = Variable<String>("")
    var cabinet: RMCabinet
    var isModify: Bool

    init(action: RMCabinetDetailViewController, cabinet: RMCabinet, isModify: Bool) {
        self.cabinet = cabinet
        self.isModify = isModify
        super.init(action: action, domain: RMCabinetDetailDomain())
        self.cabinetCode.value = self.cabinet.cabinetCode ?? ""
        self.cabinetLocation.value = self.cabinet.cabinetLocation ?? ""
        self.capacity.value = self.cabinet.capacity ?? ""
        self.cabinetRoom.value = self.cabinet.cabinetRoom ?? ""
        
        
        cabinetRoom.asObservable().bind { cabinetRoom in
            try? PFSRealm.realm.write {
                cabinet.cabinetRoom = cabinetRoom
            }
        }.addDisposableTo(disposeBag)
        
        cabinetCode.asObservable().bind { cabinetCode in
            try? PFSRealm.realm.write {
                cabinet.cabinetCode = cabinetCode
            }
        }.addDisposableTo(disposeBag)
        cabinetLocation.asObservable().bind { cabinetLocation in
            try? PFSRealm.realm.write {
                cabinet.cabinetLocation = cabinetLocation
            }
        }.addDisposableTo(disposeBag)
        capacity.asObservable().bind { capacity in
            try? PFSRealm.realm.write {
                cabinet.capacity = capacity
            }
        }.addDisposableTo(disposeBag)
        let section = RMSection<RMDevice, Void>()
        section.append(contentsOf: cabinet.devices.toArray())
        datasource.append(section)
    }

    func commit() -> Driver<Bool> {
        return self.domain.modifyCabinet(cabinet:cabinet).flatMapLatest{
            return self.action!.alert(result: $0)
        }.flatMapLatest{ _  in
            return self.action!.alert(message: "修改成功！", success: true)
        }
    }
}

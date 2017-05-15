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

protocol RMCabinetDetailAction: RMViewModelAction {
    
}

class RMCabinetDetailViewModel: RMViewModel, RMListDataSource {
    
    var datasource: Array<RMSection<RMDevice, Void>> = []
    var cabinetName = Variable<String>("")
    var cabinetCode = Variable<String>("")
    var cabinetLocation = Variable<String>("")
    var capacity = Variable<String>("")
    var cabinetRoom = Variable<String>("")
    var cabinet: RMCabinet
    var isModify: Bool
    var action: RMCabinetDetailAction
    

    init(action: RMCabinetDetailAction, cabinet: RMCabinet, isModify: Bool) {
        self.action = action
        self.cabinet = cabinet
        self.isModify = isModify
        super.init()
        self.cabinetName.value = self.cabinet.cabinetName ?? ""
        self.cabinetCode.value = self.cabinet.cabinetCode ?? ""
        self.cabinetLocation.value = self.cabinet.cabinetLocation ?? ""
        self.capacity.value = self.cabinet.capacity ?? ""
        self.cabinetRoom.value = self.cabinet.cabinetRoom ?? ""
        
        cabinetRoom.asObservable().bind { cabinet.cabinetRoom = $0 }.addDisposableTo(disposeBag)
        cabinetName.asObservable().bind { cabinet.cabinetName = $0 }.addDisposableTo(disposeBag)
        cabinetCode.asObservable().bind { cabinet.cabinetCode = $0  }.addDisposableTo(disposeBag)
        cabinetLocation.asObservable().bind { cabinet.cabinetLocation = $0  }.addDisposableTo(disposeBag)
        capacity.asObservable().bind { cabinet.capacity = $0  }.addDisposableTo(disposeBag)
        let section = RMSection<RMDevice, Void>()
        section.append(contentsOf: cabinet.devices?.toArray() ?? [])
        datasource.append(section)
    }

    func commit() -> Driver<Bool> {
        self.action.animation.value = true
        return RMCabinetDetailDomain.shared.modifyCabinet(cabinet:cabinet).do(onNext: { [weak self] result in
            
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

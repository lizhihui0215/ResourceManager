//
//  RMCabinetViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift


protocol RMCabinetListAction: RMViewModelAction  {
    
}

class RMCabinetListViewModel:RMViewModel, RMListDataSource {
    
    var datasource: Array<RMSection<RMCabinet, Void>> = []
    
    var action: RMCabinetListAction
    
    var account = Variable("")
    
    var linkCode = Variable("")
    
    var customerName = Variable("")
    
    
    init(action: RMCabinetListAction) {
        self.datasource.append(RMSection())
        self.action = action
    }
    
    func cabinetList(refresh: Bool) -> Driver<Bool> {
        self.action.animation.value = true
        return RMCabinetSearchDomain.shared.cabinetList(account: self.account.value, customerName: self.customerName.value, linkCode: self.linkCode.value, refresh: refresh)
            .do(onNext: { [weak self] result in
                if let strongSelf = self {
                    switch result {
                    case.success(let links):
                        if refresh {
                            strongSelf.section(at: 0).removeAll()
                        }
                        strongSelf.section(at: 0).append(contentsOf: links)
                    case.failure(_): break
                    }
                    strongSelf.action.animation.value = false
                }
            })
            .flatMapLatest({ result  in
                return self.action.alert(result: result)
            })
    }
    
}

//
//  RMCabinetViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import PCCWFoundationSwift

protocol RMCabinetListAction: PFSViewAction  {
    
}

class RMCabinetListViewModel: PFSViewModel<RMCabinetListViewController, RMCabinetSearchDomain>, RMListDataSource {
    
    var datasource: Array<RMSection<RMCabinet, Void>> = []
    
    var account = Variable("")
    
    var linkCode = Variable("")
    
    var customerName = Variable("")

    var isModify = false
    
    init(action: RMCabinetListViewController, isModify: Bool) {
        self.datasource.append(RMSection())
        self.isModify = isModify
        super.init(action: action, domain: RMCabinetSearchDomain())
    }
    
    func cabinetList(refresh: Bool) -> Driver<Bool> {
        return self.domain.cabinetList(account: self.account.value, customerName: self.customerName.value, linkCode: self.linkCode.value, refresh: refresh)
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
                }
            })
            .flatMapLatest({ result  in
                return self.action!.toast(message: result)
            })
    }
    
}

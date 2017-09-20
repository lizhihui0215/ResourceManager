//
//  RMLinkListViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 07/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import PCCWFoundationSwift


protocol RMLinkListAction: PFSViewAction  {
    
}

class RMLinkListViewModel: PFSViewModel<RMLinkListViewController, RMLinkSearchDomain>, RMListDataSource {
    
    var datasource: Array<RMSection<RMLink, Void>> = []
    
    var account = Variable("")
    
    var linkCode = Variable("")
    
    var customerName = Variable("")
    
    var isModify: Bool
    
    init(action: RMLinkListViewController, isModify: Bool = false, linkCode: String = "") {
        self.datasource.append(RMSection())
        self.isModify = isModify
        self.linkCode.value = linkCode
        super.init(action: action, domain: RMLinkSearchDomain())
    }
    
    func linkList(refresh: Bool) -> Driver<Bool> {
        self.action?.animation.value = true

        return self.domain.linkList(account: self.account.value, customerName: self.customerName.value, linkCode: self.linkCode.value, refresh: refresh)
            .do(onNext: { [weak self] result in
                self?.action?.animation.value = false

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

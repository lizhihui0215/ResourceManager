//
//  RMLinkListViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 07/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


protocol RMLinkListAction: RMViewModelAction  {
    
}

class RMLinkListViewModel: RMListDataSource {
    var datasource: Array<RMSection<RMLink, Void>> = []
    
    var action: RMLinkListAction
    
    var account = Variable("")
    
    var linkCode = Variable("")
    
    var customerName = Variable("")
    
    
    init(action: RMLinkListAction) {
        self.datasource.append(RMSection())
        self.action = action
    }
    
    func linkList(refresh: Bool) -> Driver<Bool> {
        self.action.animation.value = true
        return RMLinkSearchDomain.shared.linkList(account: self.account.value, customerName: self.customerName.value, linkCode: self.linkCode.value, refresh: refresh)
            .do(onNext: { [weak self] result in
                
                if let strongSelf = self {
                    switch result {
                    case.success(let links):
                        if refresh {
                          strongSelf.section(at: 0).removeAll()
                        }
                        let _ =  strongSelf.section(at: 0).append(contentsOf: links)
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

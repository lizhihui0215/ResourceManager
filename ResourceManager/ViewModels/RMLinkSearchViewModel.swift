//
//  RMLinkSearchViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 06/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import Result
import Moya

protocol RMSearchListAction: RMViewModelAction {
    
}

class RMLinkSearchViewModel: RMViewModel {
    var links = [RMLink]()
    
    var actions: RMSearchListAction
    
    var account = Variable("")
    
    var linkCode = Variable("")
    
    var customerName = Variable("")
    
    init(actions: RMSearchListAction) {
        self.actions = actions
        super.init()
    }
    
    func linkList(refresh: Bool) -> Driver<Bool> {
        self.actions.animation.value = true
        return RMLinkSearchDomain.shared.linkList(account: self.account.value, customerName: self.customerName.value, linkCode: self.linkCode.value, refresh: refresh)
            .do(onNext: { [weak self] result in
                
                if let strongSelf = self {
                    switch result {
                    case.success(let links):
                        strongSelf.links = links
                    case.failure(_): break
                    }
                    self?.actions.animation.value = false
                }
            })
            .flatMapLatest({ result  in
                return self.actions.alert(result: result)
            })
    }
}

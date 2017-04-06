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

class RMLinkSearchViewModel: RMListDataSource {
    private var _datasource = [RMSection<RMLink, String>]()
    
    var total = 0
    
    var actions: RMSearchListAction
    
    var account = Variable("")
    
    var linkCode = Variable("")
    
    var customerName = Variable("")
    
    
    var datasource: Array<RMSection<RMLink, String>> {
        set {
            _datasource = newValue
        }
        
        get{
            return _datasource
        }
    }
    
    init(actions: RMSearchListAction) {
        self.actions = actions
        self.datasource.append(RMSection(item: nil, items: [RMSectionItem<RMLink>]()))
    }
    
    func linkList(refresh: Bool) -> Driver<Bool> {
        return Driver.just(self.actions.animation(start: true))
            .flatMapLatest{_ in
                return RMLinkSearchDomain.shared.linkList(account: self.account.value, customerName: self.customerName.value, linkCode: self.linkCode.value, refresh: refresh)
            }.do(onNext: { [weak self] result in
                switch result {
                case.success(let links):
                    if refresh { self?.section(at: 0).removeAll() }
                    let _ = self?.section(at: 0).append(contentsOf: links.links ?? [])
                    self?.total = links.total ?? 0
                case.failure(_): break
                }
            })
            .flatMapLatest({ result  in
                return self.actions.alert(result: result)
            })
    }
}

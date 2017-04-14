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

protocol RMSearchListAction: RMSearchAction {
    
}

class RMLinkSearchViewModel: RMSearchViewModel {
    var links = [RMLink]()
    
    var isModify: Bool
    
    
    init(actions: RMSearchListAction, isModify: Bool = false) {
        self.isModify = isModify
        super.init(actions: actions, title: isModify ? "链路修改" : "链路查询")
    }
    
    override func identifier(`for`: RMSearchIdentifier) -> String{
        switch `for` {
        case .toScan:
            return "toLinkScan"
        case .toSearchList:
            return "toLinkList"
        }
    }
    
    override func search() -> Driver<Bool> {
        return linkList(refresh: true)
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
                    strongSelf.actions.animation.value = false
                }
            })
            .flatMapLatest({ result  in
                return self.actions.alert(result: result)
            })
    }
}

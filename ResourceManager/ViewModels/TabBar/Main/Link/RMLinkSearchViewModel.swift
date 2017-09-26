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
import PCCWFoundationSwift

protocol RMSearchListAction: RMSearchAction {
    
}

class RMLinkSearchViewModel: RMSearchViewModel {
    var links = [RMLink]()
    
    var isModify: Bool
    
    
    init(action: RMSearchViewController, isModify: Bool = false) {
        self.isModify = isModify
        super.init(action: action, title: isModify ? "电路修改" : "电路查询")
    }
    
    override func identifier(for: RMSearchIdentifier) -> String {
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
        self.action?.animation.value = true
        return self.domain.linkList(account: self.secondField.value, customerName: self.thirdField.value, linkCode: self.firstField.value, refresh: refresh)
            .do(onNext: { [weak self] result in
                self?.action?.animation.value = false
                if let strongSelf = self {
                    switch result {
                    case.success(let links):
                        strongSelf.links = links
                    case.failure(_): break
                    }
                }
            })
            .flatMapLatest({ result  in
                return self.action!.alert(result: result)
            })
    }
}

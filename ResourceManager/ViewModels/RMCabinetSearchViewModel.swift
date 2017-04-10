//
//  RMCabinetSearchViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import Result
import Moya

protocol RMCabinetSearchAction: RMSearchAction {
    
}

class RMCabinetSearchViewModel: RMSearchViewModel {
    var links = [RMCabinet]()
    
    init(actions: RMSearchListAction) {
        super.init(actions: actions)
    }
    
    override func identifier(`for`: RMSearchIdentifier) -> String{
        switch `for` {
        case .toScan:
            return "toCabinetScan"
        case .toSearchList:
            return "toCabinetList"
        }
    }
    
    override func search() -> Driver<Bool> {
        return cabinetList(refresh: true)
    }
    
    func cabinetList(refresh: Bool) -> Driver<Bool> {
        self.actions.animation.value = true
        return RMCabinetSearchDomain.shared.cabinetList(account: self.account.value, customerName: self.customerName.value, linkCode: self.linkCode.value, refresh: refresh)
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

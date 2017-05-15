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

    var isModify = false
    
    init(actions: RMSearchListAction, isModify: Bool = false) {
        super.init(actions: actions, title: isModify ? "机柜修改" : "机柜查询")
        self.isModify = isModify
    }
    
    override func search() -> Driver<Bool> {
        return cabinetList(refresh: true)
    }
    
    override func identifier(`for`: RMSearchIdentifier) -> String{
        switch `for` {
        case .toScan:
            return "toCabinetScan"
        case .toSearchList:
            return "toCabinetList"
        }
    }
    
    func cabinetList(refresh: Bool) -> Driver<Bool> {
        self.actions.animation.value = true
        return RMCabinetSearchDomain.shared.cabinetList(account: self.secondField.value, customerName: self.thirdField.value, linkCode: self.firstField.value, refresh: refresh)
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

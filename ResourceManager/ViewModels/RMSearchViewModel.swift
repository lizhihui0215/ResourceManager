//
//  RMSearchViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import Result
import Moya

protocol RMSearchAction: RMViewModelAction {
    
}

enum RMSearchIdentifier {
    case toScan
    case toSearchList
    case toDeviceList
}

class RMSearchViewModel: RMViewModel {
    var actions: RMSearchAction

    var firstField = Variable("")
    
    var secondField = Variable("")
    
    var thirdField = Variable("")
    
    var title: String
    
    
    init(actions: RMSearchAction, title: String) {
        self.title = title
        self.actions = actions
    }
    
    func search() -> Driver<Bool> {
        return Driver.just(true)
    }
    
    func identifier(`for`: RMSearchIdentifier) -> String{
        switch `for` {
        case .toScan:
            return "toCabinetScan"
        case .toSearchList:
            return "toCabinetList"
        case .toDeviceList:
            return "toDeviceList"
        }
    }
}

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
}

class RMSearchViewModel: RMViewModel {
    var actions: RMSearchAction

    var account = Variable("")
    
    var linkCode = Variable("")
    
    var customerName = Variable("")
    
    init(actions: RMSearchAction) {
        self.actions = actions
    }
    
    func search() -> Driver<Bool> {
        return Driver.just(true)
    }
    
    func identifier(`for`: RMSearchIdentifier ) -> String{
        return ""
    }
    
    
    
}
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
import PCCWFoundationSwift
protocol RMSearchAction: PFSViewAction {
    
}

enum RMSearchIdentifier {
    case toScan
    case toSearchList
}

class RMSearchViewModel: PFSViewModel<RMSearchViewController, RMSearchDomain> {

    var firstField = Variable("")
    
    var secondField = Variable("")
    
    var thirdField = Variable("")
    
    var title: String
    
    init(action: RMSearchViewController, title: String) {
        self.title = title
        super.init(action: action, domain: RMSearchDomain())
    }
    
    func search() -> Driver<Bool> {
        return Driver.just(true)
    }
    
    func identifier(`for`: RMSearchIdentifier) -> String{
        return ""
    }
}

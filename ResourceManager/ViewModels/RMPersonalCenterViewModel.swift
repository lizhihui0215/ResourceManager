//
//  RMPersonalCenterViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/16.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import RxSwift
import Result
import Moya
import RxCocoa

enum RMPersonalItem {
    case changePassword
    case help
    case suggest
    
    
    func idenfitier() -> String {
        switch self {
        case .changePassword:
            return "toExchangePassword"
        case .help:
            return "toHelo"
        case .suggest:
            return "toSuggest"
        }
    }
    
    func title() -> String {
        switch self {
        case .changePassword:
            return "修改密码"
        case .help:
            return "帮助中心"
        case .suggest:
            return "意见反馈"
        }
    }
    
    func image() -> UIImage {
        switch self {
        case .changePassword:
            return UIImage(named: "personal-center.exchange-password.normal")!
        case .help:
            return UIImage(named: "personal-center.help.normal")!
        case .suggest:
            return UIImage(named: "personal-center.suggest.normal")!
        }
    }
    
    func selectedImage() -> UIImage {
        switch self {
        case .changePassword:
            return UIImage(named: "personal-center.exchange-password.selected")!
        case .help:
            return UIImage(named: "personal-center.help.selected")!
        case .suggest:
            return UIImage(named: "personal-center.suggest.selected")!
        }
    }
}

protocol RMPersonalCenterViewAction: RMViewModelAction {
    
}

class RMPersonalCenterViewModel: RMViewModel, RMListDataSource {
    var datasource: Array<RMSection<RMPersonalItem, Void>> = []
    
    var user: RMUser?
    
    var action: RMViewModelAction
    
    
    init(action: RMViewModelAction) {
        self.action = action
        let section: RMSection<RMPersonalItem, Void> = RMSection()
        section.append(item: .changePassword)
        section.append(item: .help)
        section.append(item: .suggest)
        
        
        self.datasource.append(section)
    }
    
    func loginUser() -> Driver<Bool> {
        return RMPersonalCenterDomain.shared.user().do(onNext: { result in
            switch result {
            case .success(let user):
                self.user = user
            case .failure:
                break
            }
        }).flatMapLatest({ result in
            return self.action.alert(result: result)
        })
    }
    
}

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
import RealmSwift
import PCCWFoundationSwift

enum RMPersonalItem {
    case changePassword
    case help
    case suggest
    case updateOfflineData
    
    
    func idenfitier() -> String {
        switch self {
        case .changePassword:
            return "toExchangePassword"
        case .help:
            return "toHelp"
        case .suggest:
            return "toSuggest"
        case .updateOfflineData:
            return "updateOfflineData"
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
        case .updateOfflineData:
            return "更新数据"
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
        case .updateOfflineData:
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
        case .updateOfflineData:
            return UIImage(named: "personal-center.suggest.selected")!
        }
    }
}

protocol RMPersonalCenterViewAction: PFSViewAction {
    
}

class RMPersonalCenterViewModel: PFSViewModel<RMPersonalCenterViewController, RMPersonalCenterDomain>, RMListDataSource {
    var datasource: Array<RMSection<RMPersonalItem, Void>> = []
    
    var user: RMUser?
    
    init(action: RMPersonalCenterViewController) {
        let section: RMSection<RMPersonalItem, Void> = RMSection()
        section.append(item: .changePassword)
        section.append(item: .help)
        section.append(item: .suggest)
        section.append(item: .updateOfflineData)
        
        self.datasource.append(section)
        super.init(action: action, domain: RMPersonalCenterDomain())
    }

    func updateOfflineData() -> Driver<Bool> {
        self.action?.animation.value = true
        return self.domain.updateOfflineData().do(onNext: { result in
                    self.action?.animation.value = false
                }).flatMapLatest { result in
                    return self.action!.alert(result: result)
                }.flatMapLatest { _ in
                    return self.action!.alert(message: "更新成功！", success: true)
                }
    }
    
    func logout() {
        try? PFSRealm.shared.clean()
    }
    
    func loginUser() -> Driver<Bool> {
        let flag = PFSDomain.login() != nil
        return Driver.just(flag)
    }
}

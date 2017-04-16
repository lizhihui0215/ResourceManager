//
//  RMPersonalCenterViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/16.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import UIKit


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

class RMPersonalCenterViewModel: RMViewModel, RMListDataSource {
    var datasource: Array<RMSection<RMPersonalItem, Void>> = []
    
    var user: RMUser?
    
    override init() {
        let section: RMSection<RMPersonalItem, Void> = RMSection()
        section.append(item: .changePassword)
        section.append(item: .help)
        section.append(item: .suggest)
        
        
        self.datasource.append(section)
    }
    
    func user() -> Driver {
        <#function body#>
    }
    
    
    
    
    
    
    
    
    
}

//
//  RMResourceManagerViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 07/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit

enum RMResourceItem {
    case linkSearch
    case cabinet
    case linkModify
    case inspect
    
    
    func idenfitier() -> String {
        switch self {
        case .linkSearch:
            return "toLinkSearch"
        case .cabinet:
            return ""
        case .linkModify:
            return ""
        case .inspect:
            return ""
        }
    }
    
    func title() -> String {
        switch self {
        case .linkSearch:
            return "链路查询"
        case .cabinet:
            return "机柜查询"
        case .linkModify:
            return "链路修改"
        case .inspect:
            return "巡检记录"
        }
    }
    
    func image() -> UIImage {
        switch self {
        case .linkSearch:
            return UIImage(named: "xxx")!
        case .cabinet:
            return UIImage(named: "xxx")!
        case .linkModify:
            return UIImage(named: "xxx")!
        case .inspect:
            return UIImage(named: "xxx")!
        }
    }
}

class RMResourceManagerViewModel: RMViewModel, RMListDataSource {
    var datasource: Array<RMSection<RMResourceItem, Void>> = []
    
    
    override init() {
        let section: RMSection<RMResourceItem, Void> = RMSection()
        let _ = section.append(item: .linkSearch)
        let _ = section.append(item: .cabinet)
        let _ = section.append(item: .linkModify)
        let _ = section.append(item: .inspect)
        self.datasource.append(section)
    }
    
    

}

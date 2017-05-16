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
    case cabinetSearch
    case linkModify
    case inspect
    case cabinetModify
    case deviceModify
    
    func idenfitier() -> String {
        switch self {
        case .linkSearch:
            return "toLinkSearch"
        case .cabinetSearch:
            return "toCabinetSearch"
        case .linkModify:
            return "toLinkModify"
        case .inspect:
            return "toInspect"
        case .cabinetModify:
            return "toCabinetModify"
        case .deviceModify:
            return "toDeviceModify"
        }
    }
    
    func title() -> String {
        switch self {
        case .linkSearch:
            return "电路查询"
        case .cabinetSearch:
            return "机柜查询"
        case .linkModify:
            return "电路修改"
        case .inspect:
            return "巡检记录"
        case .cabinetModify:
            return "机柜修改"
        case .deviceModify:
            return "设备修改"
        }
    }
    
    func image() -> UIImage {
        switch self {
        case .linkSearch:
            return UIImage(named: "resource-mamager.link-search.menu.normal")!
        case .cabinetSearch:
            return UIImage(named: "resource-manager.cabinet-search.menu.normal")!
        case .linkModify:
            return UIImage(named: "resource-manager.link-modify.menu.normal")!
        case .inspect:
            return UIImage(named: "resource-manager.inspect.menu.normal")!
        case .cabinetModify:
            return UIImage(named: "resource-manager.link-modify.menu.normal")!
        case .deviceModify:
            return UIImage(named: "resource-manager.link-modify.menu.normal")!
        }
    }
    
    func selectedImage() -> UIImage {
        switch self {
        case .linkSearch:
            return UIImage(named: "resource-mamager.link-search.menu.selected")!
        case .cabinetSearch:
            return UIImage(named: "resource-manager.cabinet-search.menu.selected")!
        case .linkModify:
            return UIImage(named: "resource-manager.link-modify.menu.selected")!
        case .inspect:
            return UIImage(named: "resource-manager.inspect.menu.selected")!
        case .cabinetModify:
            return UIImage(named: "resource-manager.link-modify.menu.selected")!
        case .deviceModify:
            return UIImage(named: "resource-manager.link-modify.menu.selected")!
        }
    }
}

class RMResourceManagerViewModel: RMViewModel, RMListDataSource {
    var datasource: Array<RMSection<RMResourceItem, Void>> = []
    
    
    override init() {
        let section: RMSection<RMResourceItem, Void> = RMSection()
        section.append(item: .linkSearch)
        section.append(item: .cabinetSearch)
        section.append(item: .linkModify)
        section.append(item: .cabinetModify)
        section.append(item: .deviceModify)
        section.append(item: .inspect)
        self.datasource.append(section)
    }
}

//
//  RMLocationViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/12.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import MapKit

protocol RMLocationAction: RMViewModelAction {
    func reload()
}

class RMLocationViewModel: RMViewModel, RMListDataSource {
    var datasource: Array<RMSection<AMapPOI, Void>> = []
    var locationManager = AMLocationManager()
    weak var action: RMLocationAction?
    var query = Variable("")
    
    var page: Int = 0
    
    
    init(action:  RMLocationAction) {
        self.datasource.append(RMSection())
        self.action = action
    }
    
    
    func start (query: String = "路", isRefresh: Bool = true, completionHandler: (() -> Void)?)  {
        
        if isRefresh { self.page = 0; self.section(at: 0).removeAll() }
        else { self.page += 1 }
        
        locationManager.search(query: query, page: self.page, count: 20) {[weak self] result in
            if let strongSelf = self {
                let section = strongSelf.section(at: 0)
                if isRefresh {
                    section.removeAll()
                }
                
                if result.count > 0 {
                    section.append(contentsOf: result)
                }
            }
            
            if let completionHandler = completionHandler {
                completionHandler()
            }
        }

    }
    
    deinit {
//        locationManager.stopUpdatingLocation()
    }
}

//
//  RMLocationViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/12.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftLocation


class RMLocationViewModel: RMViewModel, RMListDataSource {
    var datasource: Array<RMSection<RMLink, Void>> = []
    
    override init() {
        self.datasource.append(RMSection())
    }
    
    
    func xxxx()  {
        Location.getLocation(accuracy: .city, frequency: .continuous, success: { (request, location) -> (Void) in
            
        }) { (request, location, error) -> (Void) in
            
        }
    }

}

//
//  RMCabinetDetailViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit

protocol RMCabinetDetailAction: RMViewModelAction {
    
}

class RMCabinetDetailViewModel: RMViewModel, RMListDataSource {
    
    var datasource: Array<RMSection<RMDevice, Void>> = []
    
    var cabinet: RMCabinet
    
    
    init(cabinet: RMCabinet) {
        self.cabinet = cabinet
        
        let section = RMSection<RMDevice, Void>()
        
        let _ = section.append(contentsOf: cabinet.devices?.toArray() ?? [])

        datasource.append(section)
    }
    
    

}

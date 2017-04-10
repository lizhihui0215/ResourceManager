//
//  RMScanViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 06/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa

protocol RMScanAction: RMViewModelAction {
    func restartScan()
}

class RMScanViewModel: RMViewModel {
    
    var result: Any?
    
    var scanedCode = Variable("")
    
    var action: RMScanAction
    
    
    init(action: RMScanAction) {
        self.action = action
    }
    
    func scaned(of code: String ) -> Driver<Bool> {
        return Driver.just(true)
    }
    
}

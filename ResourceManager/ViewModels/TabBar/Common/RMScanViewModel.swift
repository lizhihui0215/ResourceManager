//
//  RMScanViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 06/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa
import PCCWFoundationSwift

protocol RMScanAction: PFSViewAction {
    func rescan()
    func navigationTo()
}

class RMScanViewModel: PFSViewModel<RMScanViewController, RMScanDomain> {
    
    var result: Any?
    
    var scanedCode = Variable("")
    
    
    init(action: RMScanViewController) {
        super.init(action: action, domain: RMScanDomain())
    }
    
    func scaned(of code: String ) -> Driver<Bool> {
        return Driver.just(true)
    }
    
}

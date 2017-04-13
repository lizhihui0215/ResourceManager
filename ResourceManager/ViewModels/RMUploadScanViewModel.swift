//
//  RMUploadScanViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 13/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift

protocol RMUploadScanAction: RMScanAction {
    func navigationTo()
}

class RMUploadScanViewModel: RMScanViewModel {
    
    init(action: RMUploadScanAction) {
        super.init(action: action)
    }
    
    override func scaned(of code: String ) -> Driver<Bool> {
        if let action = self.action as? RMUploadScanAction{
            action.navigationTo()
        }
        return Driver.just(true)
    }

}

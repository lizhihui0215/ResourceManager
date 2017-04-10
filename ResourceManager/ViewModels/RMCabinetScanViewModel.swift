//
//  RMCabinetScanViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa

protocol RMCabinetScanAction: RMScanAction {
    
}

class RMCabinetScanViewModel: RMScanViewModel {
    
    init(action: RMCabinetScanAction) {
        super.init(action: action)
    }
    
    override func scaned(of code: String ) -> Driver<Bool> {
        return cabinetDetail(of: code)
    }
    
    func cabinetDetail(of code: String ) -> Driver<Bool> {
        self.action.animation.value = true
        return  RMScanDomain.shared.cabinet(linkCode: code).do(onNext: { result in
            switch result {
            case .success(let link):
                self.result = link
            case .failure(_): break;
            }
            self.action.animation.value = false
        }).flatMapLatest { result  in
            switch result {
            case.failure(_):
                self.action.restartScan()
            default:
                break
            }
            
            return self.action.alert(result: result)
        }
    }
}

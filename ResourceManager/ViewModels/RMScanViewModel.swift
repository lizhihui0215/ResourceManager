//
//  RMScanViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 06/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol RMScanAction: RMViewModelAction {
    func restartScan()
}

class RMScanViewModel: RMViewModel {
    
    var link: RMLink?
    
    var scanedCode = Variable("")
    
    var action: RMScanAction
    
    
    init(action: RMScanAction) {
        self.action = action
    }
    
    func scaned(of code: String ) -> Driver<Bool> {
        self.action.animation.value = true
        return  RMScanDomain.shared.link(linkCode: code).do(onNext: { result in
            switch result {
            case .success(let link):
                self.link = link
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

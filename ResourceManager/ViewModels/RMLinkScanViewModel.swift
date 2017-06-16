//
//  RMLinkScanViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa

protocol RMLinkScanAction: RMScanAction {

}

class RMLinkScanViewModel: RMScanViewModel {
    var isModify: Bool
    
    var links = [RMLink]()

    init(action: RMLinkScanAction, isModify: Bool = false) {
        self.isModify = isModify
        super.init(action: action)
    }
    
    override func scaned(of code: String ) -> Driver<Bool> {
        return linkDetail(of: code)
//        return linkList(refresh: true, code: code)
    }
    
    func linkList(refresh: Bool, code: String) -> Driver<Bool> {
        self.action.animation.value = true
        return RMLinkSearchDomain.shared.linkList(account: "", customerName: "", linkCode: code, refresh: refresh)
            .do(onNext: { [weak self] result in
                
                if let strongSelf = self {
                    switch result {
                    case.success(let links):
                        strongSelf.links = links
                    case.failure(_): break
                    }
                    strongSelf.action.animation.value = false
                }
            })
            .flatMapLatest({ result  in
                return self.action.alert(result: result)
            })
    }
    
    func linkDetail(of code: String ) -> Driver<Bool> {
        self.action.animation.value = true
        self.scanedCode.value = code
        return  RMScanDomain.shared.link(linkCode: code).do(onNext: { result in
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

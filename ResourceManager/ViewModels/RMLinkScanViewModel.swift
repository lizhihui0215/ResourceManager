//
//  RMLinkScanViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa


class RMLinkScanViewModel: RMScanViewModel {
    var isModify: Bool
    
    var links = [RMLink]()

    init(action: RMScanViewController, isModify: Bool = false) {
        self.isModify = isModify
        super.init(action: action)
    }
    
    override func scaned(of code: String ) -> Driver<Bool> {
        return linkDetail(of: code)
//        return linkList(refresh: true, code: code)
    }
    
    func linkList(refresh: Bool, code: String) -> Driver<Bool> {
        return self.domain.linkList(account: "", customerName: "", linkCode: code, refresh: refresh)
            .do(onNext: { [weak self] result in
                
                if let strongSelf = self {
                    switch result {
                    case.success(let links):
                        strongSelf.links = links
                    case.failure(_): break
                    }
                }
            })
            .flatMapLatest({ result  in
                return self.action!.alert(result: result)
            })
    }
    
    func linkDetail(of code: String ) -> Driver<Bool> {
        self.scanedCode.value = code
        return  self.domain.link(linkCode: code).do(onNext: { result in
            switch result {
            case .success(let link):
                self.result = link
            case .failure(_): break;
            }
        }).flatMapLatest { result  in
            switch result {
            case.failure(_):
                self.action?.rescan()
            default:
                break
            }
            
            return self.action!.alert(result: result)
        }
    }
    
    
}

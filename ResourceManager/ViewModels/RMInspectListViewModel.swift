//
//  RMInspectListViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 11/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import PCCWFoundationSwift

protocol RMInpsectListAction: PFSViewAction {
    
}

class RMInspectListViewModel: PFSViewModel<RMInspectListViewController ,RMInspectListDomain>, RMListDataSource {
    var datasource: Array<RMSection<RMInspect, Void>> = []
    
    init(action: RMInspectListViewController) {
        super.init(action: action, domain: RMInspectListDomain())
        self.datasource.append(RMSection())
        self.action = action
    }
    
    func inspectList(refresh: Bool) -> Driver<Bool> {
        self.action?.animation.value = true
        return self.domain.inspectList(refresh: refresh)
            .do(onNext: { [weak self] result in
                
                if let strongSelf = self {
                    switch result {
                    case.success(let links):
                        if refresh {
                            strongSelf.section(at: 0).removeAll()
                        }
                        strongSelf.section(at: 0).append(contentsOf: links)
                    case.failure(_): break
                    }
                    strongSelf.action?.animation.value = false
                }
            })
            .flatMapLatest({[weak self] result  in
                if let action = self?.action {
                    return action.toast(result: result)
                }
                return Driver.just(false)
            })
    }
    
    deinit {
        
    }
}

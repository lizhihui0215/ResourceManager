//
//  RMInspectListViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 11/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift

protocol RMInpsectListAction: RMViewModelAction {
    
}

class RMInspectListViewModel: RMViewModel, RMListDataSource {
    var datasource: Array<RMSection<RMInspect, Void>> = []
    
    weak var action: RMInpsectListAction?
    
    init(action: RMInpsectListAction) {
        self.datasource.append(RMSection())
        self.action = action
    }
    
    func inspectList(refresh: Bool) -> Driver<Bool> {
        self.action?.animation.value = true
        return RMInspectListDomain.shared.inspectList(refresh: refresh)
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
                    return action.toast(message: result)
                }
                return Driver.just(false)
            })
    }
    
    deinit {
        
    }
}

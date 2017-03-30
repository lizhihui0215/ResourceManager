//
//  RMViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 30/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import Result
import Moya

protocol RMViewModelAction {
    func showErrorAlert(_ message: String, cancelAction: String?) -> Observable<Bool>
}


extension RMViewModelAction {
    
    func alert<T: RMModel>(result: Result<T, MoyaError>) -> Observable<Bool> {
        switch result {
        case .failure(let error):
            return showErrorAlert(error.errorDescription!, cancelAction: nil)
        case.success:
            return Observable.just(true)
        }
    }
    
}

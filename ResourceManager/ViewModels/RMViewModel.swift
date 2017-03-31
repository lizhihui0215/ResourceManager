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
import RxCocoa

protocol RMViewModelAction {
    func showErrorAlert(_ message: String, cancelAction: String?) -> Driver<Bool>
}


extension RMViewModelAction {
    
    func alert<T>(result: Result<T, MoyaError>) -> Driver<Bool> {
        switch result {
        case .failure(let error):
            return showErrorAlert(error.errorDescription!, cancelAction: nil)
        case.success:
            return Driver.just(true)
        }
    }
    
}

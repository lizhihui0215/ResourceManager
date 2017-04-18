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

class RMViewModel {
    var disposeBag = DisposeBag()    
}

protocol RMViewModelAction {
    func showErrorAlert(_ message: String, cancelAction: String?) -> Driver<Bool>
    
    func showMessage(message: String) -> Driver<Bool>
    
    var animation: Variable<Bool> { get }
    
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
    
    func message(message: String = "提交成功") -> Driver<Bool> {
        return showMessage(message: message)
    }
    
}

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

protocol RMViewModelAction: class {
    func showErrorAlert(_ message: String, cancelAction: String?) -> Driver<Bool>
    
    func showMessage(message: String) -> Driver<Bool>
    
    var animation: Variable<Bool> { get }
    
    func toast(message: String) -> Driver<Bool>
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
    
    func alert(message: String = "提交成功") -> Driver<Bool> {
        return showMessage(message: message)
    }
    
    
    func toast<T>(message: Result<T, MoyaError>) -> Driver<Bool> {
        switch message {
        case .failure(let error):
            return toast(message: error.errorDescription!)
        case.success:
            return Driver.just(true)
        }
    }
    
}

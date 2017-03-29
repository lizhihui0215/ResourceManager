//
//  RMLoginDomain.swift
//  ResourceManager
//
//  Created by 李智慧 on 28/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import Moya
import Result

class RMLoginValidate: RMDomain {
    static let shared = RMLoginValidate()
    
    func validateUsername(_ username: String) -> Observable<ValidationResult> {
        if username.characters.count == 0 {
            return .just(.empty)
        }
        
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "Username can only contain numbers or digits",value: username))
        }
        
        let loadingValue = ValidationResult.validating
        
        // do some network
        
        return Observable.just(.ok(message: "Username available", value: username)).startWith(loadingValue)
    }
}

class RMLoginDomain: RMDomain {
    static let shared = RMLoginDomain()
    func sigin(username: String, password: String) -> Driver<Result<RMUser, Moya.Error>> {
        return RMLoginDomain.repository.sigin(username: username, password: password).map({ result in
            switch result {
            case .success(let user) :
                return Result(value: user)
            case .failure(let error):
                return Result(error: error)
            }
        }).asDriver(onErrorRecover: { error in
            let x  = error as! Moya.Error;
            return Driver.just(Result(error: x))
        })
    }
}

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

class RMLoginValidate: RMValidate {
    static let shared = RMLoginValidate()

    func validateUsername(_ username: String) -> Driver<Result<String,Moya.Error>> {
        if username.characters.count == 0 {
            return .just(Result(error: error(code: 0, message: "code must > 0")))
        }
        
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(Result(error: error(code: 0, message: "Username can only contain numbers or digits")))
        }
        
        // do some network
        
        return Driver.just(Result(value: username))
    }
}

class RMLoginDomain: RMDomain {
    static let shared = RMLoginDomain()
    func sigin(username: String, password: String) -> Driver<Result<RMUser, Moya.Error>> {
        return RMLoginDomain.repository.sigin(username: username, password: password).map({ result in
            switch result {
            case .success(let user) :
                do{
                    try user.save()
                    RMDomain.user = user
                }catch{
                    print(error)
                }
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

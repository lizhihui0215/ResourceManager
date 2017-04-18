//
//  RMPersonalCenterDomain.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/16.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import Moya
import Result

class RMPersonalCenterValidate: RMValidate {
    static let shared = RMPersonalCenterValidate()
    
    func validate(_ originPassword: String, newPassword: String, confirmPassword: String) -> Driver<Result<(String, String),Moya.Error>> {
        
        if originPassword.isEmpty {
            return .just(Result(error: error(code: 0, message: "原密码不能为空")))
        }
        
        if newPassword.isEmpty {
            return .just(Result(error: error(code: 0, message: "新密码不能为空")))
        }
        
        if confirmPassword.isEmpty {
            return .just(Result(error: error(code: 0, message: "确认密码不能为空")))
        }
        
        if newPassword != confirmPassword {
            return .just(Result(error: error(code: 0, message: "新密码和确认密码不同")))
        }
        
        return Driver.just(Result(value: (originPassword,confirmPassword )))
    }
    
    func validate(_ name: String, phone: String, detail: String) -> Driver<Result<(String, String, String),Moya.Error>> {
        
        return Driver.just(Result(value: (name,phone, detail)))
    }
    
    
    
}

class RMPersonalCenterDomain: RMDomain {
    static let shared = RMPersonalCenterDomain()
    
    func user() -> Driver<Result<RMUser, MoyaError>> {
        return RMPersonalCenterDomain.repository.user().asDriver(onErrorRecover: { error in
            let x  = error as! Moya.Error;
            return Driver.just(Result(error: x))
        })
    }
    
    func exchangePassword(password: String, newPassword: String) -> Driver<Result<String, MoyaError>> {
        return RMPersonalCenterDomain.repository.exchangePassword(password: password, newPassword: newPassword).asDriver(onErrorRecover: { error in
            let x  = error as! Moya.Error;
            return Driver.just(Result(error: x))
        })
    }
    
    func suggest(name: String, phone: String, detail: String) -> Driver<Result<String, MoyaError>> {
        return RMPersonalCenterDomain.repository.suggest(name: name, phone: phone, detail: detail).asDriver(onErrorRecover: { error in
            let x  = error as! Moya.Error;
            return Driver.just(Result(error: x))
        })
        
    }
    

}

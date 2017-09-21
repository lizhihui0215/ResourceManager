//
//  RMDomain.swift
//  ResourceManager
//
//  Created by 李智慧 on 28/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import Moya
import Result

class RMValidate {
    
    func validateNil(_ value: String, message: String = "") -> Driver<Result<String,MoyaError>> {
        
        if value.characters.count == 0 {
            return .just(Result(error: error(code: 0, message: message)))
        }
        
        // do some network
        
        return Driver.just(Result(value: value))
    }
}

//
//  RMLoginDomain.swift
//  ResourceManager
//
//  Created by 李智慧 on 28/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift

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
    func sigin(username: String, password: String) -> Observable<RMResult<RMUser>> {
        return RMLoginDomain.repository.sigin(username: username, password: password).map({ response in
            if response.code == 0 {
                return .success((response.results?.first)!)
            }
            return .failure(response.code!, response.message!)
        })
    }

}

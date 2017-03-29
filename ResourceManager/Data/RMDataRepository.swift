//
//  RMDataRepositoryswift.swift
//  ResourceManager
//
//  Created by 李智慧 on 28/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa
import Result
import Moya
import RealmSwift

class RMDataRepository {
    
    func sigin(username: String, password: String) -> Observable<Result<RMUser, Moya.Error>> {
        let result: Observable<RMResponseObject<RMUser>> = RMNetworkServices.shared.request(.login(username, password))
        
        return self.handlerError(response: result).map { result in
            switch result {
            case .success(let user):
                return Result(value: user.first!)
            case.failure(let error) :
                return Result(error: error)
            }
        }
    }
    
    func handlerError<T>(response: Observable<RMResponseObject<T>>) -> Observable<Result<List<T>, Moya.Error>> {
        return response.map { response  in
            if response.code == 0 {
                return Result(value: response.results!)
            }else {
                return Result(error: MoyaError.requestMapping("xx"))
            }
        }
    }
}




//public enum Error: MoyaError {
//    case serverError(Int, String)
//    
//    
//}

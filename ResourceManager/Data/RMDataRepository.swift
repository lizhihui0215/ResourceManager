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
                return Result(value: user)
            case.failure(let error) :
                return Result(error: error)
            }
        }
    }
    
    func linkList(account: String, customerName: String, linkCode: String, page: Int, size: Int) -> Observable<Result<RMLinkResponse, Moya.Error>> {
        let resukt: Observable<RMResponseObject<RMLinkResponse>> = RMNetworkServices.shared.request(.linkList((RMDomain.user?.accessToken)!, account, customerName, linkCode, page, size))
        
        return self.handlerError(response: resukt).map({ result in
            switch result {
            case .success(let links):
                return Result(value: links)
            case .failure(let error):
                return Result(error: error)
            }
        })
    }
    
    func handlerError<T>(response: Observable<RMResponseObject<T>>) -> Observable<Result<T, Moya.Error>> {
        return response.map { response  in
            if response.code == 0 {
                return Result(value: response.results!)
            }else {
                return Result(error: error(code: response.code, message: response.message) )
            }
        }
    }
}


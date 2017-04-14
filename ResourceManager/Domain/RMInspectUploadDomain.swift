//
//  RMInspectUploadDomain.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/15.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import Moya
import Result

class RMInspectUploadDomain: RMDomain {
    static let shared = RMInspectUploadDomain()
    
    func upload() -> Driver<Result<RMLink, MoyaError>> {
        return RMInspectUploadDomain.repository.inspectUpload(parameter:[ "":"" ] ).asDriver(onErrorRecover: { error in
            let x  = error as! Moya.Error;
            return Driver.just(Result(error: x))
        })
    }

}

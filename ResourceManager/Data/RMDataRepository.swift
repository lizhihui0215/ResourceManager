//
//  RMDataRepositoryswift.swift
//  ResourceManager
//
//  Created by 李智慧 on 28/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa

class RMDataRepository {
    
    func sigin(username: String, password: String) -> Observable<RMResponseObject<RMUser>> {
        return RMNetworkServices.shared.request(.login(username, password))
    }
    
}

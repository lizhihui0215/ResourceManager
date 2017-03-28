//
//  RMDomain.swift
//  ResourceManager
//
//  Created by 李智慧 on 28/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import Foundation

enum RMResult<T> {
    case success(T)
    case failure(Int,String)
}

class RMDomain {
    static let repository = RMDataRepository()
    
}

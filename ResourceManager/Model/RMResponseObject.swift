//
//  RMResponseObject.swift
//  ResourceManager
//
//  Created by 李智慧 on 23/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class RMResponseNil: Mappable {
    var message: String?
    
    var code: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message <- map[RMNetworkServices.kMessage]
        
        code <- map[RMNetworkServices.kCode]
    }
}

class RMResponseArray<T: Mappable>: Mappable {
    var message: String?
    
    var code: Int?
    
    var results: [T]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message <- map[RMNetworkServices.kMessage]
        
        code <- map[RMNetworkServices.kCode]
        
        results <- map[RMNetworkServices.kResults]
    }
}

class RMResponseObject<T: Mappable>: Mappable {
    
    var message: String?
    
    var code: Int?
    
    var result: T?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message <- map[RMNetworkServices.kMessage]
        
        code <- map[RMNetworkServices.kCode]
        
        result <- map[RMNetworkServices.kResults]
    }
}



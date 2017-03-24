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


class RMResponseObject<T: RMModel>: Mappable {
    
    var message: String?
    
    var code: Int?
    
    var results: List<T>?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message <- map[RMNetworkServices.kMessage!]
        
        code <- map[RMNetworkServices.kCode!]
        
        let results = map[RMNetworkServices.kResults!].currentValue
        
        if results is Array<Any> {
            self.results <- (map[RMNetworkServices.kResults!], ListTransform<T>())
        }else{
            let map = Map(mappingType: map.mappingType, JSON: [RMNetworkServices.kResults! : [results]])
            self.results <- (map[RMNetworkServices.kResults!], ListTransform<T>())
        }
    }
}



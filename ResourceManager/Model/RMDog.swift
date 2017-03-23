//
//  RMDog.swift
//  ResourceManager
//
//  Created by 李智慧 on 22/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import ObjectMapper

class RMDog: RMAnimal {
    
    dynamic var age: String?
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        age <- map["age"]
    }
}

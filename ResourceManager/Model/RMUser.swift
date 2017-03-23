//
//  RMUser.swift
//  ResourceManager
//
//  Created by 李智慧 on 22/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class RMUser: RMModel {
    dynamic var username: String?
    dynamic var password: String?

    var dogs = List<RMDog>()

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        username <- map["username"]
        password <- map["password"]
        dogs <- (map["dogs"], ListTransform<RMDog>())
    }

}

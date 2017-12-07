//
//  RMPort.swift
//  ResourceManager
//
//  Created by 李智慧 on 05/12/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
import PCCWFoundationSwift

class RMPort: PFSModel {
    @objc dynamic var portType: String? = nil
    //    dynamic var deviceName: String?
    @objc dynamic var deviceCode: String? = nil
    @objc dynamic var portName: String? = nil
    var links: List<RMLink> = List<RMLink>()
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        deviceCode <- map["deviceCode"]
        portType <- map["portType"]
        portName <- map["portName"]
        links <- (map["links"], ListTransform<RMLink>())
    }
}

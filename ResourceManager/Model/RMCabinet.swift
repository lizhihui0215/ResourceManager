//
//  RMCabinet.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
import PCCWFoundationSwift

class RMCabinet: PFSModel {
    @objc dynamic var cabinetCode: String?
//    dynamic var cabinetName: String?
    @objc dynamic var cabinetLocation: String?
    @objc dynamic var capacity: String?
    @objc dynamic var cabinetRoom: String?
    @objc dynamic var cabinetId: String?
    
    var devices: List<RMDevice>?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        cabinetCode <- map["cabinetCode"]
//        cabinetName <- map["cabinetName"]
        cabinetLocation <- map["cabinetLocation"]
        capacity <- map["capacity"]
        cabinetRoom <- map["cabinetRoom"]
        cabinetId <- map["cabinetId"]
        devices <- (map["devices"], ListTransform<RMDevice>())
    }
    
}

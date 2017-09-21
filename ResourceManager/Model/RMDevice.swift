//
//  RMDevice.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
import PCCWFoundationSwift

@objc class RMDevice: PFSModel {
    @objc dynamic var deviceCode: String?
//    dynamic var deviceName: String?
    @objc dynamic var deviceLocation: String?
    @objc dynamic var totalTerminals: Int = 0
    @objc dynamic var terminalOccupied: Int = 0
    @objc dynamic var terminalFree: Int = 0
    @objc dynamic var deviceDesc: String?
    @objc dynamic var deviceType: String?
    @objc dynamic var deviceProducer: String?
    @objc dynamic var deviceModel: String?

    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        deviceCode <- map["deviceCode"]
//        deviceName <- map["deviceName"]
        deviceLocation <- map["deviceLocation"]
        totalTerminals <- map["totalTerminals"]
        terminalOccupied <- map["terminalOccupied"]
        terminalFree <- map["terminalFree"]
        deviceDesc <- map["deviceDesc"]
        deviceType <- map["deviceType"]
        deviceProducer <- map["deviceProducer"]
        deviceModel <- map["deviceModel"]

    }
}

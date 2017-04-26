//
//  RMLink.swift
//  ResourceManager
//
//  Created by 李智慧 on 01/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class RMLink: RMModel {
    dynamic var linkCode: String?
    dynamic var account: String?
    dynamic var customerName: String?
    dynamic var barcode: String?
    dynamic var linkRate: String?
    dynamic var customerLevel: String?
    dynamic var pictures: String?
    dynamic var accessDeviceName: String?
    dynamic var accessDevicePort: Int = 0
    dynamic var accessDeviceUpTime: String?
    dynamic var localODFName: String?
    dynamic var localODFID: String?
    dynamic var localODFPort: String?
    dynamic var farendDeviceName: String?
    dynamic var farendDevicePort: Int = 0
    dynamic var farendODFName: String?
    dynamic var farendODFID: String?
    dynamic var farendODFPort: String?
    dynamic var farendDeviceId: String?
    dynamic var accessDeviceId: String?

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        linkCode <- map["linkCode"]
        account <- map["account"]
        customerName <- map["customerName"]
        barcode <- map["barcode"]
        linkRate <- map["linkRate"]
        customerLevel <- map["customerLevel"]
        accessDeviceName <- map["accessDeviceName"]
        accessDevicePort <- map["accessDevicePort"]
        accessDeviceUpTime <- map["accessDeviceUpTime"]
        localODFName <- map["localODFName"]
        localODFID <- map["localODFID"]
        localODFPort <- map["localODFPort"]
        farendDeviceName <- map["farendDeviceName"]
        farendODFName <- map["farendODFName"]
        farendODFID <- map["farendODFID"]
        farendODFPort <- map["farendODFPort"]
        farendDeviceId <- map["farendDeviceId"]
        accessDeviceId <- map["accessDeviceId"]
        farendDevicePort <- map["farendDevicePort"]
    }


}

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
import PCCWFoundationSwift

class RMLink: PFSModel {
    @objc dynamic var linkCode: String?
    @objc dynamic var linkName: String?
    @objc dynamic var customerName: String?
    @objc dynamic var barcode: String?
    @objc dynamic var linkRate: String?
    @objc dynamic var customerLevel: String?
    @objc dynamic var serviceLevel: String?
    @objc dynamic var pictures: String?
    @objc dynamic var accessDeviceName: String?
    @objc dynamic var accessDevicePort: String?
    @objc dynamic var accessDeviceUpTime: String?
    @objc dynamic var localODFName: String?
    @objc dynamic var localODFID: String?
    @objc dynamic var localODFPort: String?
    @objc dynamic var farendDeviceName: String?
    @objc dynamic var farendDevicePort: String?
    @objc dynamic var farendODFName: String?
    @objc dynamic var farendODFID: String?
    @objc dynamic var farendODFPort: String?
    @objc dynamic var farendDeviceId: String?
    @objc dynamic var accessDeviceId: String?
    @objc dynamic var farendDevicePortType: String?
    @objc dynamic var accessDevicePortType: String?
    @objc dynamic var businessType: String?
    @objc dynamic var linkId: String?
    @objc dynamic var orderNo: String?
    @objc dynamic var billingNo: String?

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        linkCode <- map["linkCode"]
        linkName <- map["linkName"]
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
        serviceLevel <- map["serviceLevel"]
        orderNo <- map["orderNo"]
        billingNo <- map["billingNo"]
        farendDevicePortType <- map["farendDevicePortType"]
        accessDevicePortType <- map["accessDevicePortType"]
        businessType <- map["businessType"]
        linkId <- map["linkId"]
    }
}

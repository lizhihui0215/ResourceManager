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
    @objc dynamic var linkCode: String? = nil
    @objc dynamic var linkName: String? = nil
    @objc dynamic var customerName: String? = nil
    @objc dynamic var barcode: String? = nil
    @objc dynamic var linkRate: String? = nil
    @objc dynamic var customerLevel: String? = nil
    @objc dynamic var serviceLevel: String? = nil
    @objc dynamic var pictures: String? = nil
    @objc dynamic var accessDeviceName: String? = nil
    @objc dynamic var accessDevicePort: String? = nil
    @objc dynamic var accessDeviceUpTime: String? = nil
    @objc dynamic var localODFName: String? = nil
    @objc dynamic var localODFID: String? = nil
    @objc dynamic var localODFPort: String? = nil
    @objc dynamic var farendDeviceName: String? = nil
    @objc dynamic var farendDevicePort: String? = nil
    @objc dynamic var farendODFName: String? = nil
    @objc dynamic var farendODFID: String? = nil
    @objc dynamic var farendODFPort: String? = nil
    @objc dynamic var farendDeviceId: String? = nil
    @objc dynamic var accessDeviceId: String? = nil
    @objc dynamic var farendDevicePortType: String? = nil
    @objc dynamic var accessDevicePortType: String? = nil
    @objc dynamic var businessType: String? = nil
    @objc dynamic var linkId: String? = nil
    @objc dynamic var orderNo: String? = nil
    @objc dynamic var billingNo: String? = nil

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

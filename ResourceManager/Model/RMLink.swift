//
//  RMLink.swift
//  ResourceManager
//
//  Created by 李智慧 on 01/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class RMLinkResponse: Mappable {
    var total: Int?
    
    var links: [RMLink]?
    
    required init?(map: Map) {
    
    }

    func mapping(map: Map) {
        total <- map["total"]
        links <- map["links"]
    }
}


class RMLink: RMModel {
    dynamic var linkCode: String?
    dynamic var account: String?
    dynamic var customerName: String?
    dynamic var barcode: String?
    dynamic var linkRate: String?
    dynamic var customerLevel: String?
    dynamic var pictures: String?
    dynamic var accessDeviceName: String?
    dynamic var accessDevicePort: String?
    dynamic var accessDeviceUpTime: String?
    dynamic var localODFName: String?
    dynamic var localODFID: String?
    dynamic var localODFPort: String?
    dynamic var farendDeviceName: String?
    dynamic var farendDevicePort: String?
    dynamic var farendODFName: String?
    dynamic var farendODFID: String?
    dynamic var farendODFPort: String?

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        linkCode <- map["link.linkCode"]
        account <- map["link.account"]
        customerName <- map["link.customerName"]
        barcode <- map["link.barcode"]
        linkRate <- map["link.linkRate"]
        customerLevel <- map["link.customerLevel"]
        accessDeviceName <- map["link.accessDeviceName"]
        accessDevicePort <- map["link.accessDevicePort"]
        accessDeviceUpTime <- map["link.accessDeviceUpTime"]
        localODFName <- map["link.localODFName"]
        localODFID <- map["link.localODFID"]
        localODFPort <- map["link.localODFPort"]
        farendDeviceName <- map["link.farendDeviceName"]
        farendODFName <- map["link.farendODFName"]
        farendODFID <- map["link.farendODFID"]
        farendODFPort <- map["link.farendODFPort"]
    }


}

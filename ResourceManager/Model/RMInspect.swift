//
//  RMInspect.swift
//  ResourceManager
//
//  Created by 李智慧 on 11/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
import PCCWFoundationSwift

class RMPicture: PFSModel {
   @objc dynamic var thumbnail: String?
   @objc dynamic var picUrl: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        thumbnail <- map["thumbnail"]
        picUrl <- map["picUrl"]
    }
}

class RMInspect: PFSModel {
    @objc dynamic var reportID: String?
    @objc dynamic var latitude: Float = 0.0
    @objc dynamic var longitude: Float = 0.0
    @objc dynamic var locationName: String?
    @objc dynamic var reportContent: String?
    @objc dynamic var resourceType: Int = 0
    @objc dynamic var createdtime: Int = 0
    @objc dynamic var resourceName: String?
    @objc dynamic var resourceId: String?
    var pictures: List<RMPicture>?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        reportID <- map["reportID"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        locationName <- map["locationName"]
        reportContent <- map["reportContent"]
        resourceType <- map["resourceType"]
        resourceName <- map["resourceName"]
        resourceId <- map["resourceId"]
        createdtime <- map["createdtime"]
        pictures <- (map["pictures"], ListTransform<RMPicture>())
    }

}

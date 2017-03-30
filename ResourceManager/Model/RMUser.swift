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
    dynamic var nickname: String?
    dynamic var loginName: String?
    dynamic var avatar: String?
    dynamic var name: String?
    dynamic var mobile: String?
    dynamic var sex: String?
    dynamic var accessToken: String?

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        nickname <- map["userinfo.nickname"]
        loginName <- map["userinfo.loginName"]
        avatar <- map["userinfo.avatar"]
        name <- map["userinfo.name"]
        mobile <- map["userinfo.mobile"]
        loginName <- map["userinfo.loginName"]
        sex <- map["userinfo.sex"]
        accessToken <- map["accessToken"]
    }

}

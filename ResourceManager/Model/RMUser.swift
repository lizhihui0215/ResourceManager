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
import PCCWFoundationSwift

class RMUser: PFSModel {
    @objc dynamic var nickname: String?
    @objc dynamic var password: String?
    @objc dynamic var loginName: String?
    @objc dynamic var avatar: String?
    @objc dynamic var name: String?
    @objc dynamic var mobile: String?
    @objc dynamic var sex: String?
    @objc dynamic var accessToken: String?

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
        password <- map["password"]
    }

}

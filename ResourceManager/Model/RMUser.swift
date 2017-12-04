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

public class RMUser: PFSModel {
    @objc dynamic var nickname: String? = nil
    @objc dynamic var password: String? = nil
    @objc dynamic var loginName: String? = nil
    @objc dynamic var avatar: String? = nil
    @objc dynamic var name: String? = nil
    @objc dynamic var mobile: String? = nil
    @objc dynamic var sex: String? = nil
    @objc dynamic var accessToken: String? = nil

    public required convenience init?(map: Map) {
        self.init()
    }
    
    override public func mapping(map: Map) {
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

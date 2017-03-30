//
//  RMModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 22/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RealmSwift
import ObjectMapper
import RealmSwift

class RMModel: Object, Mappable {
    
    static func config(_ config: Realm.Configuration) {
        Realm.Configuration.defaultConfiguration = config
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
    }
    
    func save() throws {
        let realm = try Realm()
        try realm.write {
            realm.add(self)
        }
    }
    
}

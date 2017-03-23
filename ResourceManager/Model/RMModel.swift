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
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        
    }
    
    func save() throws {
        try? self.realm?.write {
            self.realm?.add(self)
        }
    }
    
    static func all<T: Object>() -> Any {
        let realm = try? Realm(fileURL: URL(string: "/Users/lizhihui/Desktop/RM.realm")!);
        return try? realm?.objects(T.self)
    }
    
}

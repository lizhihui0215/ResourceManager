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
import PCCWFoundationSwift

public class RMModel: PFSModel {
    
    public required convenience init?(map: Map) {
        self.init()
    }
}

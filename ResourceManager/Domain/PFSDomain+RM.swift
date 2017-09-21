//
//  PFSDomain+RM.swift
//  ResourceManager
//
//  Created by 李智慧 on 21/09/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import PCCWFoundationSwift

extension PFSDomain {
    public static func login(user: IBLUser?) {
        IBLDataRepository.shared.put(key: "user", value: user)
    }
    
    public static func login() -> IBLUser? {
        return IBLDataRepository.shared.get(key: "user")
    }
}

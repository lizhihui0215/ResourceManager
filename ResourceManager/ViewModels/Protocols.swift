//
//  Protocols.swift
//  ResourceManager
//
//  Created by 李智慧 on 28/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa

enum ValidationResult {
    case ok(message: String, value: Any)
    case empty
    case validating
    case failed(message: String, value: Any)
}

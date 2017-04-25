//
//  NSDate+RM.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/24.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import Foundation

extension Date {
    func date(template: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = template
        return dateFormatter.string(from: self)
    }
}

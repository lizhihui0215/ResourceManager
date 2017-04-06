//
//  RMScanDomain.swift
//  ResourceManager
//
//  Created by 李智慧 on 06/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import Result

class RMScanDomain: RMDomain {
    static let shared = RMScanDomain()
    
    func linkList(linkCode: String) -> Driver<Result<RMLink, Moya.Error>> {
    
    
    }


}

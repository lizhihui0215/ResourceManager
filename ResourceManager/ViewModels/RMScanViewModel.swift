//
//  RMScanViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 06/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RMScanViewModel: RMViewModel {
    
    var link: RMLink?
    
    
    var scanedCode = Variable("")
    
    func scaned(of code: String ) -> Driver<Bool> {
        
        
    }
    

}

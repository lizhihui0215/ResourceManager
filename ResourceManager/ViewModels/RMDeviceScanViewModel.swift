//
//  RMDeviceScanViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/27.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa

class RMDeviceScanViewModel: RMScanViewModel {
    
    var isAccess: Bool
    
    
    init(action: RMScanViewController, isAccess: Bool) {
        self.isAccess = isAccess
        super.init(action: action)
    }
    
    override func scaned(of code: String ) -> Driver<Bool> {
        return deviceDetail(of: code)
    }
    
    func deviceDetail(of code: String ) -> Driver<Bool> {
//        self.action.animation.value = true
        return  self.domain.deviceDetail(deviceCode: code).do(onNext: { result in
            switch result {
            case .success(let device):
                self.result = device
            case .failure(_): break;
            }
        }).flatMapLatest { result  in
            switch result {
            case.failure(_):
                self.action?.restartScan()
            default:
                break
            }
            
            return self.action!.alert(result: result)
        }
    }
}

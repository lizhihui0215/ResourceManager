//
//  RMUploadScanViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 13/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift


class RMUploadScanViewModel: RMScanViewModel {
    
    override func scaned(of code: String ) -> Driver<Bool> {
        return cabinetDetail(of: code)
    }
    
    func cabinetDetail(of code: String ) -> Driver<Bool> {
        return  self.domain.cabinet(cabinetId: code).do(onNext: { result in
            switch result {
            case .success(let link):
                self.result = link
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

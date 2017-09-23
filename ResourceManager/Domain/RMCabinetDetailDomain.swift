//
// Created by 李智慧 on 11/05/2017.
// Copyright (c) 2017 北京海睿兴业. All rights reserved.
//

import Result
import RxCocoa
import RxSwift
import Moya
import PCCWFoundationSwift

class RMCabinetDetailDomain: PFSDomain {

    func modifyCabinet(cabinet: RMCabinet) -> Driver<Result<String,MoyaError>> {
        return RMDataRepository.shared.modifyCabinet(cabinet: cabinet)
    }
    
}

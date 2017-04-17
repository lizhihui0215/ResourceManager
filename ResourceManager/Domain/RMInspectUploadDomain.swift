//
//  RMInspectUploadDomain.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/15.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import RxCocoa
import RxSwift
import Moya
import Result

class RMInspectUploadDomain: RMDomain {
    static let shared = RMInspectUploadDomain()
    
    
    
    func upload(parameters: [String: Any], images: [UIImage]) -> Driver<Result<String, MoyaError>> {
        
        var fromDatas = [MultipartFormData]()
        
        for image in images {
            let imageData = UIImagePNGRepresentation(image)
            
            let formData = MultipartFormData(provider: .data(imageData!), name: UUID().uuidString, fileName: "\(UUID().uuidString).png", mimeType: "image/png")
            
            fromDatas.append(formData)
        }
            
        return RMInspectUploadDomain.repository.inspectUpload(parameter:parameters, images: fromDatas ).asDriver(onErrorRecover: { error in
            let x  = error as! Moya.Error;
            return Driver.just(Result(error: x))
        })
    }

}

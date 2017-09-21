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
import MapKit
import PCCWFoundationSwift

//class RMInspectUploadValidate {
//    static let shared = RMInspectUploadValidate()
//    
//    func validate(_ parameters: [String : Any]) -> Driver<Result<[String : Any],MoyaError>> {
//     
//        
////        _ = parameters["latitude"] as! CLLocationDegrees
////        _ = parameters["serial"] as! String
////        _ = parameters["longitude"] as! CLLocationDegrees
////        _ = parameters["locationName"] as! String
////        _ = parameters["reportContent"] as! String
////        _ = parameters["resourceType"] as! Int
////        _ = parameters["resourceId"] as! String
//        
//        let images = parameters["images"] as! [UIImage]
//        
//        if images.isEmpty  {
//            
//            return .just(Result(error: error(code: 0, message: "请选择图片")))
//        }
//        // do some network
//        
//        return Driver.just(Result(value: parameters))
//    }
//}

class RMInspectUploadDomain: PFSDomain {
    
    func upload(parameters: [String: Any], images: [UIImage]) -> Driver<Result<String, MoyaError>> {
        
        var fromDatas = [MultipartFormData]()
        
        for image in images {
            let imageData = UIImagePNGRepresentation(image)
            
            let formData = MultipartFormData(provider: .data(imageData!), name: UUID().uuidString, fileName: "\(UUID().uuidString).png", mimeType: "image/png")
            
            fromDatas.append(formData)
        }
        
        
        return RMDataRepository.shared.inspectUpload(parameter:parameters, images: fromDatas ).asDriver(onErrorRecover: { error in
            let x  = error as! MoyaError;
            return Driver.just(Result(error: x))
        })
    }

}

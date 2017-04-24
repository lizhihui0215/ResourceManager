//
//  RMInspectUploadViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 12/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa
import MapKit



class RMResourceType: RMPickerViewItem {
    enum Resource: Int {
        case unknow
        case device = 1
        case cabinet
        case link
    }
    
    var type: Resource
    
    var title: String = ""
    
    
    init(title: String, resource: Resource) {
        self.title = title
        self.type = resource
    }
}

class RMImageItem {
    var isPlus = false
    var image: UIImage?
    
    
    init(_ isPlus: Bool = false, image: UIImage?) {
        self.isPlus = isPlus
        self.image = image
        
    }
    
}

protocol RMInspectUploadAction: RMViewModelAction {
    
}


class RMInspectUploadViewModel: RMViewModel, RMListDataSource {
    var datasource: Array<RMSection<RMImageItem, Void>> = []
    
    var action: RMInspectUploadAction
    
    var latitude = Variable(kCLLocationCoordinate2DInvalid.latitude)
    
    var longitude = Variable(kCLLocationCoordinate2DInvalid.longitude)
    
    var locationName = Variable("")
    
    var resportContent = Variable("")
    
    var resourceType = Variable(3)
    
    var resourceId = Variable("")
    
    
    init(action: RMInspectUploadAction) {
        self.action = action
        super.init()
        self.datasource.append(RMSection())
        self.section(at: 0).append(item: RMImageItem(true, image: UIImage(named: "inspect-upload.plus")))
    }
    
    func resourceTypes() -> [RMResourceType] {
        return [ RMResourceType(title: "链路", resource: .link),
                 RMResourceType(title: "机柜", resource: .device),
                 RMResourceType(title: "设备", resource: . cabinet)]
    }
    
    func upload() -> Driver<Bool> {
        self.action.animation.value = true
        
        var images = [UIImage]()
        
        for imageItem in self.section(at: 0).sectionItems() {
            if let image = imageItem.image, !imageItem.isPlus {
                images.append(image)
            }
        }
        
        let parameters: [String : Any] = ["latitude": latitude.value,
                                          "serial" : UUID().uuidString,
                                          "longitude": longitude.value,
                                          "locationName": locationName.value,
                                          "resportContent": resportContent.value,
                                          "resourceType": resourceType.value,
                                          "resourceId": resourceId.value
        ]
        
        var validateParameters = parameters
        
        validateParameters["images"] = images
        
        return RMInspectUploadValidate.shared.validate(validateParameters).flatMapLatest { result  in
            self.action.alert(result: result)
            }.flatMapLatest { _ in
                return RMInspectUploadDomain.shared.upload(parameters: parameters, images: images)
            } .do(onNext: { [weak self] result in
                if let strongSelf = self {
                    
                    strongSelf.action.animation.value = false
                }
            })
            .flatMapLatest({ result  in
                return self.action.alert(result: result)
            })
            .flatMapLatest({ _  in
                return self.action.alert(message: "提交成功！")
            })
    }
    
    
    
}

//
//  RMInspectUploadViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 12/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import RxSwift
import RxCocoa
class RMImageItem {
    var isPlus = false
    var image: UIImage?
    
    
    init(_ isPlus: Bool = false, image: UIImage?) {
        self.isPlus = isPlus
        self.image = image
    }
    
}

class RMInspectUploadViewModel: RMViewModel, RMListDataSource {
    var datasource: Array<RMSection<RMImageItem, Void>> = []
    
    override init() {
        super.init()
        self.datasource.append(RMSection())
        self.section(at: 0).append(item: RMImageItem(true, image: nil))
    }
    

}

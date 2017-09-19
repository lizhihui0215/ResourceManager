//
//  RMInspectPhotoViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/11.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import UIKit
import PCCWFoundationSwift

protocol RMInspectPhotoViewAction: PFSViewAction {
    
}

class RMInspectPhotoViewModel: PFSViewModel<RMInspectPhotoViewController, RMInspectPhotoDomain>, RMListDataSource {
    var datasource: Array<RMSection<RMPicture, Void>> = []
    
    var caption = ""
    
    init(action: RMInspectPhotoViewController, pictures: [RMPicture], caption: String?) {
        super.init(action: action, domain: RMInspectPhotoDomain())
        self.caption = caption ?? ""
        self.datasource.append(RMSection())
        for picture in pictures {
            self.section(at: 0).append(item: picture)
        }
    }

}

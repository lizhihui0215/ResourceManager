//
//  RMInspectPhotoViewModel.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/11.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import UIKit
import MWPhotoBrowser

class RMInspectPhotoViewModel: RMViewModel, RMListDataSource {
    var datasource: Array<RMSection<MWPhoto, Void>> = []
    
    init(pictures: [RMPicture], caption: String?) {
        super.init()
        self.datasource.append(RMSection())
        for picture in pictures {
            let photo = MWPhoto(url: URL(string: picture.picUrl!))
            photo?.caption = caption
            self.section(at: 0).append(item: photo!)
        }
    }

}

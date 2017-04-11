//
//  RMInspectPhotoViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 11/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import MWPhotoBrowser

class RMInspectPhotoViewController: MWPhotoBrowser, MWPhotoBrowserDelegate {
    
    var viewModel: RMInspectPhotoViewModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.reloadData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        if let viewModel = self.viewModel {
            return UInt(viewModel.numberOfRowsInSection(section: 0))
        }
        
        return 0
    }

    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        
        if let viewModel = self.viewModel {
            let indexPath = IndexPath(row: Int(index), section: 0)
            
            return viewModel.elementAt(indexPath: indexPath)
        }
        
        return nil
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

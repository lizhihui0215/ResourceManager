//
//  RMContentViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 12/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import Kingfisher

class RMContentViewController: RMViewController {
    var picture: RMPicture?
    var content: String?
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let picture = self.picture {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: picture.picUrl!))
        }
        self.contentLabel.text = content
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

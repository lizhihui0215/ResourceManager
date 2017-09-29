//
//  RMTabBarViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 29/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit

extension RMTabBarViewController: RMInspectUploadViewControllerDelegate {
    
    func inspectUpload(viewController: RMInspectUploadViewController, didEndCommit success: Bool) {
        let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "RMInspectUploadNavigationController") as! UINavigationController
        
        let inspectUploadViewController = navigationController.topViewController as! RMInspectUploadViewController
        
        inspectUploadViewController.delegate = self
        
        self.viewControllers?[1] = navigationController
    }
}

class RMTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let inspectNavigationController = self.viewControllers?[1] as! UINavigationController
        
        let inspectUploadViewController = inspectNavigationController.topViewController as! RMInspectUploadViewController
        
        inspectUploadViewController.delegate = self
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

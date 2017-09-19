//
//  RMInspectPhotoViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 11/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import PCCWFoundationSwift

extension RMInspectPhotoViewController: RMInspectPhotoViewAction {
    
}

class RMInspectPhotoViewController: UIPageViewController, UIPageViewControllerDataSource {

    
    var contentViewControllers = [RMContentViewController]()
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let index = contentViewControllers.index(of: viewController as! RMContentViewController)
        self.navigationItem.title = "\(index! + 1 )/ \(contentViewControllers.count)"

        if var i = index, ++i < contentViewControllers.count {
            let contentViewController = contentViewControllers[i]
            
            
            
            return contentViewController
        }else{
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = contentViewControllers.index(of: viewController as! RMContentViewController)
        self.navigationItem.title = "\(index! + 1 )/ \(contentViewControllers.count)"

        if var i = index, --i >= 0 {
            let contentViewController = contentViewControllers[i]
            
            return contentViewController
        }else{
            return nil
        }
    }
    
    var viewModel: RMInspectPhotoViewModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let viewModel = self.viewModel {
            for sectionItem in viewModel.section(at: 0).items {
                let contentViewController =  self.storyboard?.instantiateViewController(withIdentifier: "contentViewController") as! RMContentViewController
                contentViewController.picture = sectionItem.item
                contentViewController.content = viewModel.caption
                contentViewControllers.append(contentViewController)
            }
        }
        
        self.setViewControllers([contentViewControllers[0]], direction: .reverse, animated: true, completion: nil)
        
        self.navigationItem.title = "1/ \(contentViewControllers.count)"
        self.dataSource = self
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

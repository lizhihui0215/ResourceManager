//
//  RMRootViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/3/29.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import UIKit
import RealmSwift
import PCCWFoundationSwift

class RMRootViewController: PFSViewController, RMRootViewAction {
    
    var viewModel: RMRootViewModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.viewModel = RMRootViewModel(action: self, domain: RMLoginDomain())
        
        self.viewModel?.navigationTo().drive(onNext: {[weak self] success in
            if success {
                self?.performSegue(withIdentifier: "toMain", sender: nil)
            }else {
                self?.perform(segue: StoryboardSegue.Main.toLogin, sender: nil)
            }
        }).disposed(by: disposeBag)
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
    
    deinit {
        
    }

}

//
//  RMHelpViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/30.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import PCCWFoundationSwift

class RMHelpViewController: PFSViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let  urlString = RMNetworkServices.kBaseURL.appending("/helpDocsIOS/")

        webView.loadRequest(URLRequest(url: URL(string: urlString)!))
        
        webView.rx.didStartLoad.subscribe(onNext: { [weak self] in
            if let strongSelf = self {
                strongSelf.animation.value = true
            }
            
        }).disposed(by: disposeBag)
        webView.rx.didFinishLoad.subscribe(onNext: { [weak self] in
            if let strongSelf = self {
                strongSelf.animation.value = false
            }
            
        }).disposed(by: disposeBag)
        
        webView.rx.didFailLoad.subscribe(onNext: { [weak self] _ in
            if let strongSelf = self {
                strongSelf.animation.value = false
            }
            
        }).disposed(by: disposeBag)

        self.navigationItem.backBarButtonItem?.action = #selector(RMHelpViewController.backButtonPressed(_:))
        
    }
    
    func backButtonPressed(_ sender: UIBarButtonItem)  {
        
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

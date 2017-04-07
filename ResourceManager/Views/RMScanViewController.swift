//
//  RMScanViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 01/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RMScanViewController: LBXScanViewController, RMScanAction {
    

    var disposeBag = DisposeBag()

    var viewModel: RMScanViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner;
        style.photoframeLineW = 2;
        style.photoframeAngleW = 18;
        style.photoframeAngleH = 18;
        style.isNeedShowRetangle = false;
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove;
        style.colorAngle = UIColor(red: 0.0/255, green: 200.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_Scan_weixin_Line")
        self.scanStyle = style;
        self.viewModel = RMScanViewModel(action: self)
    }
    
    override func handleCodeResult(arrayResult: [LBXScanResult]){
        self.viewModel?.scaned(of: (arrayResult.first?.strScanned)!).drive(onNext: {
            success in
            if success {
                self.performSegue(withIdentifier: "toDetail", sender: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    func restartScan() {
        self.startScan()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let linkDetailViewController = segue.destination as! RMLinkDetailViewController
        
        linkDetailViewController.viewModel = RMLinkDetailViewModel(link: (self.viewModel?.link)!)
    }
    

}

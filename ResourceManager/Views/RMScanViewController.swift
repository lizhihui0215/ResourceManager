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
import PCCWFoundationSwift

protocol RMScanViewControllerDelegate: NSObjectProtocol {
      func scaned(result: Any, of scanViewController: RMScanViewController) -> Void
}

extension RMScanViewController: LBXScanViewControllerDelegate {
    func scanResult(with array: [LBXScanResult]!) {
        self.viewModel?.scaned(of: (array.first?.strScanned)!).drive(onNext: {
            success in
            if let _ = self.viewModel as? RMLinkScanViewModel,success {
                if (array.first?.strScanned.hasPrefix("a`"))! {
                    self.performSegue(withIdentifier: "toLinkList", sender: nil)
                }else {
                    self.performSegue(withIdentifier: "toLinkDetail", sender: nil)
                }
            }else if let _ = self.viewModel as? RMCabinetScanViewModel, success {
                self.performSegue(withIdentifier: "toCabinetDetail", sender: nil)
            }else if let _ = self.viewModel as? RMDeviceScanViewModel, success {
                self.performSegue(withIdentifier: "endScan", sender: nil)
            }else if let viewModel = self.viewModel as? RMUploadScanViewModel, success {
                
                let result = viewModel.result
                
                self.scanControllerDelegate?.scaned(result: result ?? RMCabinet(), of: self)
                self.navigationController?.popViewController(animated: true)
                
            }
        }).disposed(by: disposeBag)
        self.qRScanView.stopScanAnimation()
    }
    
    func rescan() {
    }
}

class RMScanViewController: LBXScanViewController, RMScanAction {
    
    
    
//    var disposeBag = DisposeBag()
    
    var scanControllerDelegate: RMScanViewControllerDelegate?

    var viewModel: RMScanViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
        let style = LBXScanViewStyle()
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner;
        style.photoframeLineW = 2;
        style.photoframeAngleW = 18;
        style.photoframeAngleH = 18;
        style.isNeedShowRetangle = false;
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove;
        style.colorAngle = UIColor(red: 0.0/255, green: 200.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_Scan_weixin_Line")
        self.style = style;
        
    }
    
    
//    override func scanResultWithArray(arrayResult: [LBXScanResult]){
//        self.viewModel?.scaned(of: (arrayResult.first?.strScanned)!).drive(onNext: {
//            success in
//            if let _ = self.viewModel as? RMLinkScanViewModel,success {
//                self.performSegue(withIdentifier: "toLinkDetail", sender: nil)
////                self.performSegue(withIdentifier: "toLinkList", sender: nil)
//
//            }else if let _ = self.viewModel as? RMCabinetScanViewModel, success {
//                self.performSegue(withIdentifier: "toCabinetDetail", sender: nil)
//            }else if let _ = self.viewModel as? RMDeviceScanViewModel, success {
//                self.performSegue(withIdentifier: "endScan", sender: nil)
//            }else if let viewModel = self.viewModel as? RMUploadScanViewModel, success {
//
//                let result = viewModel.result
//
//                self.scanControllerDelegate?.scaned(result: result ?? RMCabinet(), of: self)
//                self.navigationController?.popViewController(animated: true)
//
//            }
//        }).disposed(by: disposeBag)
//
////        if let delegate = self.delegate , let _ = self.viewModel as? RMUploadScanViewModel {
//////            delegate.scaned(of: self , of:(arrayResult.first?.strScanned)!)
////            delegate.scaned(code: (arrayResult.first?.strScanned)!, of: self)
////            self.navigationController?.popViewController(animated: true)
////        }
//    }
    
    func navigationTo()  {
        
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
        if segue.identifier == "toLinkDetail" {
            let linkDetailViewController = segue.destination as! RMLinkDetailViewController
            
            let viewModel = self.viewModel as! RMLinkScanViewModel
            
            linkDetailViewController.viewModel = RMLinkDetailViewModel(link: (self.viewModel?.result) as! RMLink, action: linkDetailViewController, isModify: viewModel.isModify)

        }else if segue.identifier == "toCabinetDetail" {
            if let viewModel = self.viewModel as? RMCabinetScanViewModel {
                let cabinetDetailViewController = segue.destination as! RMCabinetDetailViewController
                
                cabinetDetailViewController.viewModel = RMCabinetDetailViewModel(action: cabinetDetailViewController,
                                                                                 cabinet: (self.viewModel?.result) as! RMCabinet, isModify: viewModel.isModify)
            }
        }else if segue.identifier == "endScan" {
            if let viewModel = self.viewModel as? RMDeviceScanViewModel {
                let delegate = segue.destination as! RMDeviceSearchViewControllerDelegate
                let device = viewModel.result as! RMDevice
                delegate.didEndSearch(device: device, isAccess: viewModel.isAccess)
            }
        }else if segue.identifier == "toLinkList" {
            if let viewModel = self.viewModel as? RMLinkScanViewModel {
                let linkListViewController = segue.destination as! RMLinkListViewController
                linkListViewController.viewModel = RMLinkListViewModel(action: linkListViewController, isModify: viewModel.isModify, linkCode: viewModel.scanedCode.value)
                linkListViewController.viewModel?.section(at: 0).append(contentsOf: (viewModel.links))

                
            }
        }
    }
    

}

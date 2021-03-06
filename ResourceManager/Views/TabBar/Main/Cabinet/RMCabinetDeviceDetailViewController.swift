//
//  RMCabinetDeviceDetailViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/9.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PCCWFoundationSwift
import RSKGrowingTextView

extension RMCabinetDeviceDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 8.0
        return CGSize(width: width, height: width)
    }
}

extension RMCabinetDeviceDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let devicePort = self.viewModel?.elementAt(indexPath: indexPath) {
            performSegue(withIdentifier: "toLinkList", sender: devicePort)

            
            
//            switch devicePort {
//            case let .occupied(_, link):
////                performSegue(withIdentifier: "toLinkDetail", sender: link)
//
//            default:
//                break
//            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RMDevicePortCell", for: indexPath) as! RMDevicePortCell
        let devicePort = self.viewModel?.elementAt(indexPath: indexPath)
        cell.imageView.image = devicePort?.image()
//        cell.titleLabel.text = devicePort?.port()
        cell.titleLabel.textColor = devicePort?.titleColor()
        return cell
    }
}

extension RMCabinetDeviceDetailViewController: RMCabinetDeviceDetailViewAction {
    
}

class RMDevicePortCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
}

class RMCabinetDeviceDetailViewController: PFSViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: RMCabinetDeviceDetailViewModel?
    @IBOutlet weak var deviceNameTextField: UITextField!
    @IBOutlet weak var totalTerminalsTextField: UITextField!
    @IBOutlet weak var terminalOccupiedTextField: UITextField!
    @IBOutlet weak var terminalFreeTextField: UITextField!
    @IBOutlet weak var deviceDescTextField: RSKGrowingTextView!
    @IBOutlet weak var deviceRoomTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deviceDescTextField.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        if let viewModel = self.viewModel {
            deviceNameTextField.rx.textInput <-> viewModel.deviceCode
            totalTerminalsTextField.rx.textInput <-> viewModel.totalTerminals
            terminalOccupiedTextField.rx.textInput <-> viewModel.terminalOccupied
            terminalFreeTextField.rx.textInput <-> viewModel.terminalFree
            deviceDescTextField.rx.textInput <-> viewModel.deviceDesc
            deviceRoomTextField.rx.textInput <-> viewModel.deviceRoom
            viewModel.link().drive(onNext: { _ in
                self.collectionView.reloadData()
            }).disposed(by: disposeBag)
        }
        
        deviceNameTextField.backgroundColor = UIColor.white
        totalTerminalsTextField.backgroundColor = UIColor.white
        terminalOccupiedTextField.backgroundColor = UIColor.white
        terminalFreeTextField.backgroundColor = UIColor.white
        deviceRoomTextField.backgroundColor = UIColor.white
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
            let theLink = sender as! RMLink
            let copyLink = theLink.copy() as! RMLink
            linkDetailViewController.viewModel = RMLinkDetailViewModel(link: copyLink, action: linkDetailViewController)
        }else if segue.identifier == "toLinkList" {
            let linkDetailViewController = segue.destination as! RMDevicePortDetailViewController
            linkDetailViewController.viewModel = RMDevicePortDetailViewModel(action: linkDetailViewController, port: sender as! RMDevicePort)

        }
    }
}

//
//  RMSearchViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 29/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit



class RMSearchViewController: RMViewController, RMSearchListAction {
    
    var viewModel: RMSearchViewModel?
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = self.viewModel?.title
        
        if let _ = self.viewModel as? RMCabinetSearchViewModel {
            self.firstTextField.placeholder = "机柜代码"
            self.secondTextField.placeholder = "机柜名称"
            self.stackView.removeArrangedSubview(self.stackView.subviews.last!)
        }else if let _ = self.viewModel as? RMLinkSearchViewModel {
            
        }else if let _ = self.viewModel as? RMDeviceSearchViewModel {
            self.firstTextField.placeholder = "设备代码"
            self.secondTextField.placeholder = "设备名称"
            self.stackView.removeArrangedSubview(self.stackView.subviews.last!)
            self.navigationItem.rightBarButtonItem = nil
        }
        
        self.secondTextField.rx.textInput <-> (self.viewModel?.secondField)!
        
        self.thirdTextField.rx.textInput <-> (self.viewModel?.thirdField)!
        
        self.firstTextField.rx.textInput <-> (self.viewModel?.firstField)!
        
    }
    
    @IBAction func scanButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: (self.viewModel?.identifier(for: .toScan))!, sender: nil)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if let viewModel = self.viewModel {
            viewModel.search().drive(onNext: {[weak viewModel] success in
                if let strongViewModel = viewModel {
                    if success {
                        self.performSegue(withIdentifier: strongViewModel.identifier(for: .toSearchList), sender: nil)
                    }
                }
            }).disposed(by: disposeBag)
        }
        
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
        if segue.identifier == "toLinkList" {
            let linkListViewController = segue.destination as! RMLinkListViewController
            if let linkSearchViewModel = self.viewModel as? RMLinkSearchViewModel {
                let linkListViewModel = RMLinkListViewModel(action: linkListViewController,
                                                            isModify:linkSearchViewModel.isModify)
                linkListViewModel.section(at: 0).append(contentsOf: (linkSearchViewModel.links))
                linkListViewModel.account.value = (linkSearchViewModel.firstField.value)
                linkListViewModel.customerName.value = (linkSearchViewModel.thirdField.value)
                linkListViewModel.linkCode.value = (linkSearchViewModel.secondField.value)
                linkListViewController.viewModel = linkListViewModel
            }
        }else if segue.identifier == "toCabinetList" {
            let cabinetListViewController = segue.destination as! RMCabinetListViewController
            if let cabinetSearchViewModel = self.viewModel as? RMCabinetSearchViewModel {
                let cabinetListViewModel = RMCabinetListViewModel(action: cabinetListViewController)
                cabinetListViewModel.section(at: 0).append(contentsOf: (cabinetSearchViewModel.links))
                cabinetListViewModel.account.value = (cabinetSearchViewModel.firstField.value)
                cabinetListViewModel.customerName.value = (cabinetSearchViewModel.thirdField.value)
                cabinetListViewModel.linkCode.value = (cabinetSearchViewModel.secondField.value)
                cabinetListViewController.viewModel = cabinetListViewModel
            }
        }else if segue.identifier == "toLinkScan" {
            let scanViewController = segue.destination as! RMScanViewController
            if let linkSearchViewModel = self.viewModel as? RMLinkSearchViewModel {
                scanViewController.viewModel = RMLinkScanViewModel(action: scanViewController,
                                                                   isModify: linkSearchViewModel.isModify)
            }
        }else if segue.identifier == "toCabinetScan" {
            let scanViewController = segue.destination as! RMScanViewController
            scanViewController.viewModel = RMCabinetScanViewModel(action: scanViewController)
        }else if segue.identifier == "toDeviceList" {
            if let deviceSearchViewModel = self.viewModel as? RMDeviceSearchViewModel {
                let deviceListViewController = segue.destination as! RMDeviceListViewController
                deviceListViewController.viewModel = RMDeviceListViewModel(action: deviceListViewController, isAccess: deviceSearchViewModel.isAccess)
                deviceListViewController.viewModel?.section(at: 0).append(contentsOf: (deviceSearchViewModel.devices))
                deviceListViewController.viewModel?.deviceCode.value = deviceSearchViewModel.firstField.value
                deviceListViewController.viewModel?.deviceName.value = deviceSearchViewModel.secondField.value

            }
        }else if segue.identifier == "toDeviceScan" {
            if let deviceSearchViewModel = self.viewModel as? RMDeviceSearchViewModel {
                let scanViewController = segue.destination as! RMScanViewController
                scanViewController.viewModel = RMDeviceScanViewModel(action: scanViewController, isAccess: deviceSearchViewModel.isAccess)

            }
        }
    }
}

//
//  RMSearchViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 29/03/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit

extension RMSearchViewController: RMScanViewControllerDelegate{
    func scaned(code: String, of scanViewController: RMScanViewController) {
//        self.firstTextField.text = code
        self.viewModel?.firstField.value = code
    }
}

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
            self.stackView.removeArrangedSubview(self.stackView.subviews.first!)
            self.secondTextField.placeholder = "机柜名称"
            self.stackView.removeArrangedSubview(self.stackView.subviews.last!)
        }else if let _ = self.viewModel as? RMLinkSearchViewModel {
            
        }else if let _ = self.viewModel as? RMDeviceSearchViewModel {
            self.firstTextField.placeholder = "设备代码"
            self.secondTextField.placeholder = "设备名称"
            self.navigationItem.rightBarButtonItem = nil
            self.stackView.removeArrangedSubview(self.stackView.subviews.first!)
            self.stackView.removeArrangedSubview(self.stackView.subviews.last!)
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
                linkListViewModel.linkCode.value = (linkSearchViewModel.firstField.value)
                linkListViewModel.account.value = (linkSearchViewModel.secondField.value)
                linkListViewModel.customerName.value = (linkSearchViewModel.thirdField.value)
                linkListViewController.viewModel = linkListViewModel
            }
        }else if segue.identifier == "toCabinetList" {
            let cabinetListViewController = segue.destination as! RMCabinetListViewController
            if let cabinetSearchViewModel = self.viewModel as? RMCabinetSearchViewModel {
                let cabinetListViewModel = RMCabinetListViewModel(action: cabinetListViewController,
                        isModify: cabinetSearchViewModel.isModify)
                cabinetListViewModel.section(at: 0).append(contentsOf: (cabinetSearchViewModel.links))
                cabinetListViewModel.linkCode.value = (cabinetSearchViewModel.firstField.value)
                cabinetListViewModel.account.value = (cabinetSearchViewModel.secondField.value)
                cabinetListViewModel.customerName.value = (cabinetSearchViewModel.thirdField.value)
                cabinetListViewController.viewModel = cabinetListViewModel
            }
        }else if segue.identifier == "toLinkScan" {
            let scanViewController = segue.destination as! RMScanViewController
            if let linkSearchViewModel = self.viewModel as? RMLinkSearchViewModel {
                scanViewController.viewModel = RMLinkScanViewModel(action: scanViewController,
                                                                   isModify: linkSearchViewModel.isModify)
                scanViewController.delegate = self
            }
        }else if segue.identifier == "toCabinetScan" {
            let scanViewController = segue.destination as! RMScanViewController
            if let cabinetSearchViewModel = self.viewModel as? RMCabinetSearchViewModel {
                scanViewController.viewModel = RMCabinetScanViewModel(action: scanViewController, isModify: cabinetSearchViewModel.isModify)
                scanViewController.delegate = self
            }
        }else if segue.identifier == "toDeviceList" {
            if let deviceSearchViewModel = self.viewModel as? RMDeviceSearchViewModel {
                let deviceListViewController = segue.destination as! RMDeviceListViewController
                deviceListViewController.viewModel = RMDeviceListViewModel(action: deviceListViewController, isAccess: deviceSearchViewModel.isAccess, isModify: deviceSearchViewModel.isModify)
                deviceListViewController.viewModel?.section(at: 0).append(contentsOf: (deviceSearchViewModel.devices))
                deviceListViewController.viewModel?.deviceCode.value = deviceSearchViewModel.firstField.value
                deviceListViewController.viewModel?.deviceName.value = deviceSearchViewModel.secondField.value
            }
        }else if segue.identifier == "toDeviceScan" {
            if let deviceSearchViewModel = self.viewModel as? RMDeviceSearchViewModel {
                let scanViewController = segue.destination as! RMScanViewController
                scanViewController.viewModel = RMDeviceScanViewModel(action: scanViewController, isAccess: deviceSearchViewModel.isAccess)
                scanViewController.delegate = self
            }
        }
    }
}

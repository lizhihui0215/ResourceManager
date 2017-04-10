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
    
    @IBOutlet weak var linkCodeTextField: UITextField!
    @IBOutlet weak var customerTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.accountTextField.rx.textInput <-> (self.viewModel?.account)!
        
        self.customerTextField.rx.textInput <-> (self.viewModel?.customerName)!
        
        self.linkCodeTextField.rx.textInput <-> (self.viewModel?.linkCode)!
        
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
                linkListViewModel.account.value = (linkSearchViewModel.account.value)
                linkListViewModel.customerName.value = (linkSearchViewModel.customerName.value)
                linkListViewModel.linkCode.value = (linkSearchViewModel.linkCode.value)
                linkListViewController.viewModel = linkListViewModel
            }
        }else if segue.identifier == "toCabinetList" {
            let cabinetListViewController = segue.destination as! RMCabinetListViewController
            if let cabinetSearchViewModel = self.viewModel as? RMCabinetSearchViewModel {
                let cabinetListViewModel = RMCabinetListViewModel(action: cabinetListViewController)
                cabinetListViewModel.section(at: 0).append(contentsOf: (cabinetSearchViewModel.links))
                cabinetListViewModel.account.value = (cabinetSearchViewModel.account.value)
                cabinetListViewModel.customerName.value = (cabinetSearchViewModel.customerName.value)
                cabinetListViewModel.linkCode.value = (cabinetSearchViewModel.linkCode.value)
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
        }
    }
}

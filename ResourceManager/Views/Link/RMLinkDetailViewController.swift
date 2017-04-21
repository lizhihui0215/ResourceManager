//
//  RMLinkDetailViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 01/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit

extension RMLinkDetailViewController: RMLinkDetailAction {
    
}

class RMLinkDetailViewController: RMViewController {
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var linkRateTextField: UITextField!
    @IBOutlet weak var linkCodeTextField: UITextField!
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var customerLevelTextField: UITextField!
    var viewModel: RMLinkDetailViewModel? = nil
    
    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var farendDevicePortTextField: UITextField!
    @IBOutlet weak var farendDeviceNameTextField: UITextField!
    @IBOutlet weak var accessDevicePortTextField: UITextField!
    @IBOutlet weak var accessDeviceNameTextField: UITextField!
    
    @IBOutlet weak var commitButtonHightConstraint: NSLayoutConstraint!
    @IBAction func commitButtonPressed(_ sender: UIButton) {
        self.viewModel?.linkModify().drive().disposed(by: disposeBag)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let isModify = self.viewModel?.isModify, isModify == false {
            
            self.accountTextField.isEnabled = false
            self.accountTextField.backgroundColor = UIColor.white
            
            self.linkRateTextField.isEnabled = false
            self.linkRateTextField.backgroundColor = UIColor.white

            self.linkCodeTextField.isEnabled = false
            self.linkCodeTextField.backgroundColor = UIColor.white

            self.customerNameTextField.isEnabled = false
            self.customerNameTextField.backgroundColor = UIColor.white

            self.customerLevelTextField.isEnabled = false
            self.customerLevelTextField.backgroundColor = UIColor.white


            self.farendDeviceNameTextField.borderStyle = .none
            self.farendDeviceNameTextField.isEnabled = false
            self.farendDevicePortTextField.isEnabled = false
            self.farendDevicePortTextField.borderStyle = .none
            
            self.accessDeviceNameTextField.borderStyle = .none
            self.accessDeviceNameTextField.isEnabled = false

            self.accessDevicePortTextField.borderStyle = .none
            self.accessDevicePortTextField.isEnabled = false
            
            self.commitButtonHightConstraint.constant = 0

        }else {
            self.linkCodeTextField.isEnabled = false
            self.linkCodeTextField.backgroundColor = UIColor.white
        }
        
        if let viewModel = self.viewModel {
            accountTextField.rx.textInput <-> viewModel.account
            linkRateTextField.rx.textInput <-> viewModel.linkRate
            linkCodeTextField.rx.textInput <-> viewModel.linkCode
            customerNameTextField.rx.textInput <-> viewModel.customerName
            customerLevelTextField.rx.textInput <-> viewModel.customerLevel
            farendDeviceNameTextField.rx.textInput <-> viewModel.farendDeviceName
            farendDevicePortTextField.rx.textInput <-> viewModel.farendDevicePort
            accessDeviceNameTextField.rx.textInput <-> viewModel.accessDeviceName
            accessDevicePortTextField.rx.textInput <-> viewModel.accessDevicePort
        }
    }
    @IBAction func test(_ sender: UIBarButtonItem) {
        print(viewModel?.link ?? "")
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

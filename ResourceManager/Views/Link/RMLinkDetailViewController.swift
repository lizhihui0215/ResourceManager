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
    
    
    @IBOutlet weak var accessDeviceNameLabel: UILabel!
    @IBOutlet weak var accessDevicePortLabel: UILabel!
    
    @IBOutlet weak var farendDeviceNameLabel: UILabel!
    @IBOutlet weak var farendDevicePortLabel: UILabel!
    
    @IBOutlet var accessDevicePortTapGesture: UITapGestureRecognizer!
    @IBOutlet var accessDeviceTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var commitButtonHightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var farendDeviceNameTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var farendDevicePortTapGesture: UITapGestureRecognizer!
    
    
    @IBAction func accessDevicePortTapped(_ sender: UITapGestureRecognizer) {
        
    }
    
    @IBAction func farendDeviceNameTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "toDeviceSearch", sender: sender)
    }
    
    @IBAction func accessDeviceTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "toDeviceSearch", sender: sender)
    }
    
    @IBAction func farendDevicePortTappped(_ sender: UITapGestureRecognizer) {
        
    }
    
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

            self.accessDeviceNameLabel.layer.borderWidth = 0
            self.accessDevicePortLabel.layer.borderWidth = 0
            
            self.farendDeviceNameLabel.layer.borderWidth = 0
            self.farendDevicePortLabel.layer.borderWidth = 0
            
            self.commitButtonHightConstraint.constant = 0
            
            self.accessDeviceTapGesture.isEnabled = false

        }else {
            self.linkCodeTextField.isEnabled = false
            self.linkCodeTextField.backgroundColor = UIColor.white
            self.accessDeviceTapGesture.isEnabled = true
        }
        
        if let viewModel = self.viewModel {
            accountTextField.rx.textInput <-> viewModel.account
            linkRateTextField.rx.textInput <-> viewModel.linkRate
            linkCodeTextField.rx.textInput <-> viewModel.linkCode
            customerNameTextField.rx.textInput <-> viewModel.customerName
            customerLevelTextField.rx.textInput <-> viewModel.customerLevel
            farendDeviceNameLabel <-> viewModel.farendDeviceName
            farendDevicePortLabel <-> viewModel.farendDevicePort
            accessDeviceNameLabel <-> viewModel.accessDeviceName
            accessDevicePortLabel <-> viewModel.accessDevicePort
        }
    }
    @IBAction func test(_ sender: UIBarButtonItem) {
        print(viewModel?.link ?? "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unwindForDeviceSearch(segue:UIStoryboardSegue) {
        let deviceList = segue.destination as! RMDeviceListViewController
        
    }

    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "toDeviceSearch" {
            
            let searchViewController = segue.destination as! RMSearchViewController
            
            let isAccess = sender as! UITapGestureRecognizer == farendDeviceNameTapGesture
            searchViewController.viewModel = RMDeviceSearchViewModel(actions: searchViewController, isAccess: isAccess)
            
        }
        
     }
    
    
}

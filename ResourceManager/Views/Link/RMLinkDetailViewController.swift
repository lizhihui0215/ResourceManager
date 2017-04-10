//
//  RMLinkDetailViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 01/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit

class RMLinkDetailViewController: RMViewController {
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var linkRateTextField: UITextField!
    @IBOutlet weak var customerAddressTextField: UITextField!
    @IBOutlet weak var linkCodeTextField: UITextField!
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var customerLevelTextField: UITextField!
    var viewModel: RMLinkDetailViewModel? = nil

    @IBOutlet weak var farendDevicePortTextField: UITextField!
    @IBOutlet weak var farendDeviceNameTextField: UITextField!
    @IBOutlet weak var accessDevicePortTextField: UITextField!
    @IBOutlet weak var accessDeviceNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let viewModel = self.viewModel {
            let _ = accountTextField.rx.textInput <-> viewModel.account
            let _ = linkRateTextField.rx.textInput <-> viewModel.linkRate
            let _ = customerAddressTextField.rx.textInput <-> viewModel.customerAddress
            let _ = linkCodeTextField.rx.textInput <-> viewModel.linkCode
            let _ = customerNameTextField.rx.textInput <-> viewModel.customerName
            let _ = customerLevelTextField.rx.textInput <-> viewModel.customerLevel
            let _ = farendDeviceNameTextField.rx.textInput <-> viewModel.farendDeviceName
            let _ = farendDevicePortTextField.rx.textInput <-> viewModel.farendDevicePort
            let _ = accessDeviceNameTextField.rx.textInput <-> viewModel.accessDeviceName
            let _ = accessDevicePortTextField.rx.textInput <-> viewModel.accessDevicePort
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

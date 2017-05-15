//
//  RMDeviceDetailViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 12/05/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension RMDeviceDetailViewController: RMDeviceModifyAction{
    
}

class RMDeviceDetailViewController: RMViewController {
    @IBOutlet weak var deviceNameTextField: UITextField!

    @IBOutlet weak var deviceDescriptionTextField: UITextField!
    @IBOutlet weak var termailCountTextField: UITextField!
    @IBOutlet weak var deviceLocationTextField: UITextField!
    @IBOutlet weak var deviceCodeTextField: UITextField!
    
    var viewModel: RMDeviceModifyViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let viewModel = self.viewModel {
            deviceNameTextField.rx.textInput <-> viewModel.deviceName
            termailCountTextField.rx.textInput <-> viewModel.totalTerminals
            deviceLocationTextField.rx.textInput <-> viewModel.deviceLocation
            deviceCodeTextField.rx.textInput <-> viewModel.deviceCode
            deviceDescriptionTextField.rx.textInput <-> viewModel.deviceDesc
            deviceCodeTextField.backgroundColor = UIColor.white
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func commitButtonPressed(_ sender: UIButton) {
        self.viewModel?.commit().drive().disposed(by: disposeBag)
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

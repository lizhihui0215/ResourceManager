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

protocol RMDeviceDetailViewControllerDelegate: class {
    func didEndModify()
}

class RMDeviceDetailViewController: RMViewController {
    @IBOutlet weak var deviceNameTextField: UITextField!

    @IBOutlet weak var deviceDescriptionTextField: UITextField!
    @IBOutlet weak var termailCountTextField: UITextField!
//    @IBOutlet weak var deviceCodeTextField: UITextField!
    weak var delegate: RMDeviceDetailViewControllerDelegate?
    var viewModel: RMDeviceModifyViewModel?
    @IBOutlet weak var deviceProducerTextField: UITextField!
    
    @IBOutlet weak var deviceModelTextField: UITextField!
    @IBOutlet weak var deviceTypeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let viewModel = self.viewModel {
            
            deviceNameTextField.rx.textInput <-> viewModel.deviceCode
            deviceNameTextField.isEnabled = false
            deviceNameTextField.backgroundColor = UIColor.white
            termailCountTextField.rx.textInput <-> viewModel.totalTerminals
//            deviceCodeTextField.rx.textInput <-> viewModel.deviceCode
            deviceDescriptionTextField.rx.textInput <-> viewModel.deviceDesc
            
            deviceTypeTextField.rx.textInput <-> viewModel.deviceType
            deviceProducerTextField.rx.textInput <-> viewModel.deviceProducer
            deviceModelTextField.rx.textInput <-> viewModel.deviceModel
            
            maxLength(of: deviceTypeTextField, maxLength: 12)
            maxLength(of: deviceProducerTextField, maxLength: 124)
            maxLength(of: deviceModelTextField, maxLength: 124)


//            deviceCodeTextField.backgroundColor = UIColor.white
            termailCountTextField.keyboardType = .asciiCapableNumberPad
        }
        // Do any additional setup after loading the view.
    }
    
    func maxLength(of textField: UITextField, maxLength: Int)  {
        textField.rx.controlEvent(UIControlEvents.editingChanged).subscribe(onNext: { [weak textField] xx in
            if let textField = textField {
                if let text = textField.text, text.characters.count > maxLength {
                    let index = text.index(text.startIndex, offsetBy: maxLength)
                    textField.text = text.substring(to: index)
                }
            }
        }).disposed(by: disposeBag);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func commitButtonPressed(_ sender: UIButton) {
        self.viewModel?.commit().drive(onNext: {[weak self] success in
            if success {
                self?.delegate?.didEndModify()
            }
        }).disposed(by: disposeBag)
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

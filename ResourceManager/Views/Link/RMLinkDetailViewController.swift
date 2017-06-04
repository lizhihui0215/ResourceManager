//
//  RMLinkDetailViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 01/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit

protocol RMLinkDetailViewControllerDelegate: class {
    func didEndModify()
}

extension RMLinkDetailViewController: RMLinkDetailAction {
    
}

extension RMLinkDetailViewController: RMDeviceSearchViewControllerDelegate {
    func didEndSearch(device: RMDevice, isAccess: Bool){
        if isAccess {
            self.viewModel?.accessDevice = device
//            self.viewModel?.accessDeviceId.value = device.deviceCode!
            self.accessDeviceNameLabel.text = device.deviceName
            self.accessDevicePortLabel.text = ""
        }else {
            self.viewModel?.farendDevice = device
//            self.viewModel?.farendDeviceId.value = device.deviceCode!
            self.farendDeviceNameLabel.text = device.deviceName
            self.farendDevicePortLabel.text = ""
        }
    }
}

class RMLinkDetailViewController: RMViewController {
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var linkRateTextField: UITextField!
    @IBOutlet weak var linkCodeTextField: UITextField!
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var customerLevelTextField: UITextField!
    var viewModel: RMLinkDetailViewModel? = nil
    weak var delegate: RMLinkDetailViewControllerDelegate?
    
    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var billingNoTextField: UITextField!
    
    @IBOutlet weak var orderNoTextField: UITextField!
    
    @IBOutlet weak var accessDeviceNameLabel: UILabel!
    @IBOutlet weak var accessDevicePortLabel: UILabel!
    @IBOutlet weak var accessDeviceTypeLabel: UITextField!
    
    @IBOutlet weak var farendDeviceTypeLabel: UITextField!
    @IBOutlet weak var farendDeviceNameLabel: UILabel!
    @IBOutlet weak var farendDevicePortLabel: UILabel!
    
    @IBOutlet var accessDevicePortTapGesture: UITapGestureRecognizer!
    @IBOutlet var accessDeviceTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var commitButtonHightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var serviceLevelTextField: UITextField!
    @IBOutlet weak var farendDeviceNameTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var farendDevicePortTapGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var businessTypeTextField: UITextField!
    
    @IBOutlet var customerLevelTapGesture: UITapGestureRecognizer!
    @IBOutlet var serviceLevelTapGesture: UITapGestureRecognizer!
    
    @IBAction func farendDeviceNameTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "toDeviceSearch", sender: sender)
    }
    
    @IBAction func accessDeviceTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "toDeviceSearch", sender: sender)
    }
    
    @IBAction func accessDevicePortTapped(_ sender: UITapGestureRecognizer) {
        if let viewModel = self.viewModel {
            viewModel.freePort(isAccess: true).map({ (ints) -> [RMPortItem] in
                var xx = [RMPortItem]()
                for port in ints {
                    xx.append(RMPortItem(port: port))
                }
                return xx
            }).drive(onNext: {[weak self] ports in
                if let strongSelf = self {
                    strongSelf.presentPicker(items: ports, completeHandler: {[weak self] port in
                        if let strongSelf = self {
                            strongSelf.accessDevicePortLabel.text = port.title
                        }
                    })
                }
            }).disposed(by: disposeBag)
        }
    }

    
    @IBAction func farendDevicePortTappped(_ sender: UITapGestureRecognizer) {
        if let viewModel = self.viewModel {
            viewModel.freePort(isAccess: true).map({ (ints) -> [RMPortItem] in
                var xx = [RMPortItem]()
                for port in ints {
                    xx.append(RMPortItem(port: port))
                }
                return xx
            }).drive(onNext: {[weak self] ports in
                if let strongSelf = self {
                    strongSelf.presentPicker(items: ports, completeHandler: {[weak self] port in
                        if let strongSelf = self {
                            strongSelf.farendDevicePortLabel.text = port.title
                        }
                    })
                }
            }).disposed(by: disposeBag)
        }
    }
    
    @IBAction func commitButtonPressed(_ sender: UIButton) {
        self.viewModel?.linkModify().drive(onNext: {[weak self] success in
            if success {
                self?.delegate?.didEndModify()
            }
        }).disposed(by: disposeBag)
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
            self.businessTypeTextField.isEnabled = false
            self.businessTypeTextField.backgroundColor = UIColor.white


            self.customerLevelTextField.isEnabled = false
            self.customerLevelTextField.backgroundColor = UIColor.white

            self.accessDeviceNameLabel.layer.borderWidth = 0
            self.accessDevicePortLabel.layer.borderWidth = 0
            self.accessDeviceTypeLabel.layer.borderWidth = 0

            
            self.farendDeviceNameLabel.layer.borderWidth = 0
            self.farendDevicePortLabel.layer.borderWidth = 0
            self.farendDeviceTypeLabel.layer.borderWidth = 0

            
            self.commitButtonHightConstraint.constant = 0
            
            self.accessDeviceTapGesture.isEnabled = false
            self.accessDevicePortTapGesture.isEnabled = false
            self.farendDeviceNameTapGesture.isEnabled = false
            self.farendDevicePortTapGesture.isEnabled = false
            self.customerLevelTapGesture.isEnabled = false
            self.serviceLevelTapGesture.isEnabled = false
            
            
            self.orderNoTextField.isEnabled = false
            self.orderNoTextField.backgroundColor = UIColor.white

            self.billingNoTextField.isEnabled = false
            self.billingNoTextField.backgroundColor = UIColor.white


        }else {
            self.linkCodeTextField.isEnabled = false
            self.linkCodeTextField.backgroundColor = UIColor.white
            self.accessDeviceTapGesture.isEnabled = true
            self.accessDevicePortTapGesture.isEnabled = true
            self.farendDeviceNameTapGesture.isEnabled = true
            self.farendDevicePortTapGesture.isEnabled = true
            self.billingNoTextField.isEnabled = true
            self.orderNoTextField.isEnabled = true
            self.accessDeviceTypeLabel.isEnabled = true
            self.farendDeviceTypeLabel.isEnabled = true
            self.businessTypeTextField.isEnabled = true
        }
        
        self.customerLevelTextField.isEnabled = false
        self.customerLevelTextField.backgroundColor = UIColor.white

        
        self.serviceLevelTextField.isEnabled = false
        self.serviceLevelTextField.backgroundColor = UIColor.white

        
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
            serviceLevelTextField.rx.textInput <-> viewModel.serviceLevel
            farendDeviceTypeLabel.rx.textInput <-> viewModel.farendDevicePortType
            accessDeviceTypeLabel.rx.textInput <-> viewModel.accessDevicePortType

            orderNoTextField.rx.textInput <-> viewModel.orderNo
            billingNoTextField.rx.text <-> viewModel.billingNo
            billingNoTextField.keyboardType = .asciiCapableNumberPad
            businessTypeTextField.rx.textInput <-> viewModel.businessType
            
            billingNoTextField.rx.controlEvent(UIControlEvents.editingChanged).subscribe(onNext: { [weak billingNoTextField] xx in
                if let textField = billingNoTextField {
                    if let text = textField.text, text.characters.count > 10 {
                        let index = text.index(text.startIndex, offsetBy: 10)
                        textField.text = text.substring(to: index)
                    }
                }
            }).disposed(by: disposeBag);

        }
    }
    
    @IBAction func customerLevelTapped(_ sender: UITapGestureRecognizer) {
        let level1 = RMLevel(title: "金")
        let level2 = RMLevel(title: "银")
        let level3 = RMLevel(title: "铜")
        let level4 = RMLevel(title: "标准")


        self.presentPicker(items: [level1,level2,level3,level4]) {[weak self] (level: RMLevel) in
            self?.viewModel?.customerLevel.value = level.title
         }
    }
    @IBAction func serviceLevelTapped(_ sender: UITapGestureRecognizer) {
        let level1 = RMLevel(title: "AAA")
        let level2 = RMLevel(title: "AA")
        let level3 = RMLevel(title: "A")
        let level4 = RMLevel(title: "普通")
        
        
        self.presentPicker(items: [level1,level2,level3,level4]) {[weak self] (level: RMLevel) in
            self?.viewModel?.serviceLevel.value = level.title
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
//        let deviceList = segue.destination as! RMDeviceListViewController
        
    }

    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "toDeviceSearch" {
            
            let searchViewController = segue.destination as! RMSearchViewController
            
            let isAccess = sender as! UITapGestureRecognizer == accessDeviceTapGesture
            searchViewController.viewModel = RMDeviceSearchViewModel(actions: searchViewController, isAccess: isAccess)
            
        }
        
     }
    
    
}

class RMLevel: RMPickerViewItem {
    var title: String = ""

    init(title: String){
        self.title = title
    }
}

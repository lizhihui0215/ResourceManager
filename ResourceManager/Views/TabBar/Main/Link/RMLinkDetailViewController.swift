//
//  RMLinkDetailViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 01/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import PCCWFoundationSwift

protocol RMLinkDetailViewControllerDelegate: class {
    func didEndModify()
}

extension RMLinkDetailViewController: RMLinkDetailAction {
    
}

extension RMLinkDetailViewController: RMDeviceSearchViewControllerDelegate {
    func didEndSearch(device: RMDevice, isAccess: Bool){
        if isAccess {
            self.viewModel?.accessDevice = device
            self.viewModel?.accessDeviceName.value = device.deviceCode!
            self.viewModel?.accessDevicePort.value = ""
        }else {
            self.viewModel?.farendDevice = device
            self.viewModel?.farendDeviceName.value = device.deviceCode!
            self.viewModel?.farendDevicePort.value = ""
        }
    }
}

class RMLinkDetailViewController: PFSViewController {
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var linkRateTextField: UITextField!
    @IBOutlet weak var linkCodeTextField: UITextField!
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var customerLevelTextField: UITextField!
    var viewModel: RMLinkDetailViewModel!
    weak var delegate: RMLinkDetailViewControllerDelegate?
    
    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var billingNoTextField: UITextField!
    
    @IBOutlet weak var orderNoTextField: UITextField!
    
    @IBOutlet weak var accessDeviceNameTextField: UITextField!
    @IBOutlet weak var accessDevicePortTextField: UITextField!
    @IBOutlet weak var accessDeviceTypeTextField: UITextField!
    
    @IBOutlet weak var farendDeviceTypeTextField: UITextField!
    @IBOutlet weak var farendDeviceNameTextField: UITextField!
    @IBOutlet weak var farendDevicePortTextField: UITextField!
    
    @IBOutlet var accessDevicePortTapGesture: UITapGestureRecognizer!
    @IBOutlet var accessDeviceTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var commitButtonHightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var serviceLevelTextField: UITextField!
    @IBOutlet weak var farendDeviceNameTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var farendDevicePortTapGesture: UITapGestureRecognizer!
    
    @IBOutlet var businessTypeTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var businessTypeTextField: UITextField!
    
    @IBOutlet var customerLevelTapGesture: UITapGestureRecognizer!
    @IBOutlet var serviceLevelTapGesture: UITapGestureRecognizer!
    
    @IBAction func farendDeviceNameTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "toDeviceSearch", sender: sender)
    }
    
    @IBAction func accessDeviceTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "toDeviceSearch", sender: sender)
    }
    
    @IBAction func printButtonPressed(_ sender: UIBarButtonItem) {
        let link = self.viewModel?.link
        
        let template = "<?xml version=\"1.0\" encoding=\"utf-8\" ?><Data><Print><CodeType>02F</CodeType><Code>\( link?.linkId ?? "")</Code><Text>专线名称:\(link?.linkName ?? "")</Text><Text>服务热线：10086-8</Text></Print></Data>";
        print(template)
        PrintServices.shared.printInView(view: self.view, template: template)
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
                if let strongSelf = self, ports.isEmpty == false {
                    strongSelf.presentPicker(items: ports, completeHandler: {[weak self] port in
                        if let strongSelf = self {
                            strongSelf.viewModel?.accessDevicePort.value = port.title;
                        }
                    })
                }
            }).disposed(by: disposeBag)
        }
    }
    @IBAction func businessTypeTapped(_ sender: UITapGestureRecognizer) {
        let level1 = RMLevel(title: "互联网")
        let level2 = RMLevel(title: "数据专线")
        let level3 = RMLevel(title: "APN")
        let level4 = RMLevel(title: "VOIP")
        
        
        self.presentPicker(items: [level1,level2,level3,level4]) {[weak self] (level: RMLevel) in
            self?.viewModel?.businessType.value = level.title
        }
    }
    
    
    @IBAction func farendDevicePortTappped(_ sender: UITapGestureRecognizer) {
        self.viewModel?.freePort(isAccess: true).map({ (ints) -> [RMPortItem] in
            var xx = [RMPortItem]()
            for port in ints {
                xx.append(RMPortItem(port: port))
            }
            return xx
        }).drive(onNext: {[weak self] ports in
            if let strongSelf = self, ports.isEmpty == false {
                strongSelf.presentPicker(items: ports, completeHandler: {[weak self] port in
                    if let strongSelf = self {
                        strongSelf.viewModel?.farendDevicePort.value = port.title
                    }
                })
            }
        }).disposed(by: disposeBag)
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
            self.orderNoTextField.isEnabled = false
            self.billingNoTextField.isEnabled = false
            self.billingNoTextField.backgroundColor = UIColor.white
            self.orderNoTextField.backgroundColor = UIColor.white
            self.accessDeviceNameTextField.layer.borderWidth = 0
            self.accessDevicePortTextField.layer.borderWidth = 0
            self.accessDeviceTypeTextField.layer.borderWidth = 0
            self.farendDeviceNameTextField.layer.borderWidth = 0
            self.farendDevicePortTextField.layer.borderWidth = 0
            self.farendDeviceTypeTextField.layer.borderWidth = 0
            self.commitButtonHightConstraint.constant = 0
            self.accessDeviceTapGesture.isEnabled = false
            self.accessDevicePortTapGesture.isEnabled = false
            self.farendDeviceNameTapGesture.isEnabled = false
            self.farendDevicePortTapGesture.isEnabled = false
            self.customerLevelTapGesture.isEnabled = false
            self.serviceLevelTapGesture.isEnabled = false
            self.businessTypeTapGesture.isEnabled = false
        }else {
            self.linkCodeTextField.isEnabled = true
            self.accessDeviceTapGesture.isEnabled = true
            self.accessDevicePortTapGesture.isEnabled = true
            self.farendDeviceNameTapGesture.isEnabled = true
            self.farendDevicePortTapGesture.isEnabled = true
            self.businessTypeTapGesture.isEnabled = true
            self.billingNoTextField.isEnabled = true
            self.orderNoTextField.isEnabled = true
            self.accessDeviceTypeTextField.isEnabled = true
            self.farendDeviceTypeTextField.isEnabled = true
            self.businessTypeTextField.isEnabled = true
        }
        
        self.customerLevelTextField.isEnabled = false
        self.customerLevelTextField.backgroundColor = UIColor.white
        self.serviceLevelTextField.isEnabled = false
        self.serviceLevelTextField.backgroundColor = UIColor.white
        self.businessTypeTextField.isEnabled = false
        self.businessTypeTextField.backgroundColor = UIColor.white
        
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
            serviceLevelTextField.rx.textInput <-> viewModel.serviceLevel
            farendDeviceTypeTextField.rx.textInput <-> viewModel.farendDevicePortType
            accessDeviceTypeTextField.rx.textInput <-> viewModel.accessDevicePortType
            orderNoTextField.rx.textInput <-> viewModel.orderNo
            billingNoTextField.rx.textInput <-> viewModel.billingNo
            billingNoTextField.keyboardType = .asciiCapableNumberPad
            businessTypeTextField.rx.textInput <-> viewModel.businessType
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unwindForDeviceSearch(segue:UIStoryboardSegue) {
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toDeviceSearch" {
            let searchViewController = segue.destination as! RMSearchViewController
            let isAccess = sender as? UITapGestureRecognizer == accessDeviceTapGesture
            searchViewController.viewModel = RMDeviceSearchViewModel(actions: searchViewController, isAccess: isAccess)
            
        }
    }
}

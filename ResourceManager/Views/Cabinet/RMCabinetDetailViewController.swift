//
//  RMCabinetDetailViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RxCocoa

class RMDeviceTableViewCell: RMTableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension RMCabinetDetailViewController: RMCabinetDetailAction {
    
}


class RMCabinetDetailViewController: RMTableViewController, UITableViewDataSource {
    
    var viewModel: RMCabinetDetailViewModel?
    
    @IBOutlet weak var commitButtonHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var deviceHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cabinetCodeTextField: UITextField!
    @IBOutlet weak var cabinetNameTextField: UITextField!
    @IBOutlet weak var deviceListView: UIView!
    
    @IBOutlet weak var cabinetNameLabel: UILabel!
//    @IBOutlet weak var devicesTextField: UITextField!
    @IBOutlet weak var capacityTextField: UITextField!
    @IBOutlet weak var cabinetLocationTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let viewModel = self.viewModel {
            cabinetCodeTextField.rx.textInput <-> viewModel.cabinetCode
            cabinetNameTextField.rx.textInput <-> viewModel.cabinetName
            capacityTextField.rx.textInput <-> viewModel.capacity
            cabinetLocationTextField.rx.textInput <-> viewModel.cabinetLocation
            cabinetNameLabel.text = viewModel.cabinet.cabinetName
            commitButtonHightConstraint.constant = viewModel.isModify ? 30 : 0;
            cabinetCodeTextField.isEnabled = viewModel.isModify
            cabinetNameTextField.isEnabled = viewModel.isModify
            capacityTextField.isEnabled = viewModel.isModify
            cabinetLocationTextField.isEnabled = viewModel.isModify
            
            if viewModel.isModify {
                deviceListView.removeFromSuperview()
            }
        }
        
        self.tableView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: {[weak self] x in
            
            if let strongSelf = self {
                strongSelf.deviceHeightConstraint.constant = (x?.height)!
            }
            
            
        }).disposed(by: disposeBag)
        
        
                
        cabinetCodeTextField.backgroundColor = UIColor.white
        cabinetNameTextField.backgroundColor = UIColor.white
//        devicesTextField.background = nil
        capacityTextField.backgroundColor = UIColor.white
        cabinetLocationTextField.backgroundColor = UIColor.white
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func commitButtonPressed(_ sender: UIButton) {
         self.viewModel?.commit().drive().disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RMDeviceTableViewCell", for: indexPath) as! RMDeviceTableViewCell
        
        if let viewModel = self.viewModel {
            let device = viewModel.elementAt(indexPath: indexPath)
            cell.nameLabel.text = device.deviceName
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        self.deviceHeightConstraint.constant = CGFloat((self.viewModel?.numberOfRowsInSection(section: section) ?? 1)  * 41)
        
        return self.viewModel?.numberOfRowsInSection(section: section) ?? 0
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let deviceViewController = segue.destination as! RMDeviceViewController
        
        let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
        
        let device = self.viewModel?.elementAt(indexPath: indexPath!)
        
        deviceViewController.viewModel = RMDeviceDetailViewModel(device: device!, action: deviceViewController)
        
    }
    
    
}

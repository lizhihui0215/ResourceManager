//
//  RMCabinetDetailViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import RxCocoa
import PCCWFoundationSwift

class RMDeviceTableViewCell: PFSTableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension RMCabinetDetailViewController: RMCabinetDetailAction {
    
}

protocol RMCabinetDetailViewControllerDelegate: class {
    func didEndModify()
}


class RMCabinetDetailViewController: PFSTableViewController, UITableViewDataSource {
    
    var viewModel: RMCabinetDetailViewModel?
    
    @IBOutlet weak var commitButtonHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var deviceHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var cabinetCodeTextField: UITextField!
    @IBOutlet weak var cabinetNameTextField: UITextField!
    @IBOutlet weak var deviceListView: UIView!
    weak var delegate: RMCabinetDetailViewControllerDelegate?
    
    @IBOutlet weak var cabinetRoomTextField: UITextField!
    @IBOutlet weak var cabinetNameLabel: UILabel!
//    @IBOutlet weak var devicesTextField: UITextField!
    @IBOutlet weak var capacityTextField: UITextField!
    @IBOutlet weak var cabinetLocationTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let viewModel = self.viewModel {
//            cabinetCodeTextField.rx.textInput <-> viewModel.cabinetCode
            cabinetNameTextField.rx.textInput <-> viewModel.cabinetCode
            capacityTextField.rx.textInput <-> viewModel.capacity
            cabinetLocationTextField.rx.textInput <-> viewModel.cabinetLocation
            cabinetNameLabel.text = viewModel.cabinet.cabinetCode
            cabinetRoomTextField.rx.textInput <-> viewModel.cabinetRoom
            commitButtonHightConstraint.constant = viewModel.isModify ? 30 : 0;
//            cabinetCodeTextField.isEnabled = viewModel.isModify
            cabinetNameTextField.isEnabled = viewModel.isModify
            capacityTextField.isEnabled = viewModel.isModify
            cabinetLocationTextField.isEnabled = viewModel.isModify
            cabinetRoomTextField.isEnabled = viewModel.isModify
            
            if viewModel.isModify {
                deviceListView.removeFromSuperview()
            }
        }
        
        self.tableView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: {[weak self] x in
            
            if let strongSelf = self {
                strongSelf.deviceHeightConstraint.constant = (x?.height)!
            }
            
            
        }).disposed(by: disposeBag)
        
        
                
//        cabinetCodeTextField.backgroundColor = UIColor.white
        cabinetNameTextField.backgroundColor = UIColor.white
//        devicesTextField.background = nil
        capacityTextField.backgroundColor = UIColor.white
        cabinetLocationTextField.backgroundColor = UIColor.white
        cabinetRoomTextField.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func commitButtonPressed(_ sender: UIButton) {
         self.viewModel?.commit().drive(onNext: {[weak self] success in
            if success {
                self?.delegate?.didEndModify()
            }
         }).disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RMDeviceTableViewCell", for: indexPath) as! RMDeviceTableViewCell
        
        if let viewModel = self.viewModel {
            let device = viewModel.elementAt(indexPath: indexPath)
            cell.nameLabel.text = device.deviceCode
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
        
        let deviceViewController = segue.destination as! RMCabinetDeviceDetailViewController
        
        let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
        
        let device = self.viewModel?.elementAt(indexPath: indexPath!)
        
        let deviceRoom = self.viewModel?.cabinetRoom.value;
        
        deviceViewController.viewModel = RMDeviceDetailViewModel(device: device!, deviceRoom: deviceRoom ?? "", action: deviceViewController)
        
    }
    
    
}

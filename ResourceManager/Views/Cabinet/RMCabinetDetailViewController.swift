//
//  RMCabinetDetailViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 10/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit

class RMDeviceTableViewCell: RMTableViewCell {
   
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10) //if you also want to adjust separatorInset
    }
}

class RMCabinetDetailViewController: RMTableViewController, UITableViewDataSource {

    var viewModel: RMCabinetDetailViewModel?
    
    @IBOutlet weak var cabinetCodeTextField: UITextField!
    @IBOutlet weak var cabinetNameTextField: UITextField!
    
    @IBOutlet weak var cabinetNameLabel: UILabel!
    @IBOutlet weak var devicesTextField: UITextField!
    @IBOutlet weak var capacityTextField: UITextField!
    @IBOutlet weak var cabinetLocationTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.estimatedRowHeight = 40
        
        if let viewModel = self.viewModel {
            cabinetCodeTextField.text = viewModel.cabinet.cabinetCode
            cabinetNameTextField.text = viewModel.cabinet.cabinetName
            capacityTextField.text = viewModel.cabinet.capacity
            cabinetLocationTextField.text = viewModel.cabinet.cabinetLocation
            cabinetNameLabel.text = viewModel.cabinet.cabinetName
        }
        
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        

        // Do any additional setup after loading the view.
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
        return self.viewModel?.numberOfRowsInSection(section: section) ?? 0
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

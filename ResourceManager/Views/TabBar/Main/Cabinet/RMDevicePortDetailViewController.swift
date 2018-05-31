//
//  RMDevicePortDetailViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 06/10/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
import PCCWFoundationSwift
import CryptoSwift

class RMDevicePortDetailCell: PFSTableViewCell {
    
    @IBOutlet weak var linkCodeLabel: UILabel!
    
    @IBOutlet weak var linkNameTitleLabel: UILabel!
    @IBOutlet weak var deviceIdTitleLabel: UILabel!
    @IBOutlet weak var devicePortLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var accessDeviceIdLabel: UILabel!
    @IBOutlet weak var linkNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension RMDevicePortDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RMDevicePortDetailCell", for: indexPath) as! RMDevicePortDetailCell
        
        cell.linkCodeLabel.text = self.viewModel.linkCodeAt(indexPath: indexPath)
        
        cell.linkNameLabel.text = self.viewModel.linkNameAt(indexPath: indexPath)
        cell.accessDeviceIdLabel.text = self.viewModel.deviceIdAt(indexPath: indexPath)
        cell.customerNameLabel.text = self.viewModel.customerNameAt(indexPath: indexPath)
        cell.devicePortLabel.text = self.viewModel.devicePortAt(indexPath: indexPath)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section: section)
    }
}



extension String {
    public func md5Bit16() -> String {
        let md5 = self.md5()
        let startIndex = md5.index(md5.startIndex, offsetBy: 8)
        let endIndex = md5.index(md5.endIndex, offsetBy: -8)
        let md516 = md5[startIndex..<endIndex]
        return String(md516)
    }
}

class RMDevicePortDetailViewController: PFSTableViewController {

    var viewModel: RMDevicePortDetailViewModel!
    
    @IBOutlet weak var portNameTextField: UITextField!
    @IBOutlet weak var linkCountTextField: UITextField!
    @IBOutlet weak var deviceNameTextField: UITextField!

    @IBAction func printButtonTapped(_ sender: UIBarButtonItem) {
        let printContant = "\(self.deviceNameTextField.text!)`\(self.portNameTextField.text!)"
        let md5Str = printContant.md5Bit16()
        let template = "<?xml version=\"1.0\" encoding=\"utf-8\" ?><Data><Print><CodeType>1005</CodeType><Code>a`\(md5Str)</Code><Text>汇聚端口</Text></Print></Data>"
        
//        let te = "<?xml version=\"1.0\" encoding=\"utf-8\" ?><Data><Print><CodeType>60-40</CodeType><Code>3121-00000600</Code><Text>站点名称:辽阳刘二堡中心学校资源点</Text><Text>服务热线:10086-8</Text><Text>机柜名称:1015039967154400</Text></Print></Data>"
        PrintServices.shared.printInView(view: self.view, template: template)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        self.portNameTextField.rx.textInput <-> self.viewModel.portName
        self.linkCountTextField.rx.textInput <-> self.viewModel.linkCount
        self.deviceNameTextField.rx.textInput <-> self.viewModel.deviceName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toLinkDetail" {
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            let link = self.viewModel.elementAt(indexPath: indexPath!);
            let linkDetailViewController = segue.destination as! RMLinkDetailViewController
            let copyLink = link.copy() as! RMLink

            linkDetailViewController.viewModel = RMLinkDetailViewModel(link: copyLink, action: linkDetailViewController)
        }
    }
    

}

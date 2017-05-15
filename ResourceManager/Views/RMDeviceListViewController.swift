//
//  RMDeviceListViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 2017/4/27.
//  Copyright © 2017年 北京海睿兴业. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RMDeviceListCell: RMTableViewCell {
    @IBOutlet weak var deviceCodeLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var totalPortLabel: UILabel!
    @IBOutlet weak var freePortLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

protocol RMDeviceSearchViewControllerDelegate {
    func didEndSearch(device: RMDevice, isAccess: Bool)
}

extension RMDeviceListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if let viewModel = self.viewModel, viewModel.isModify {
            self.performSegue(withIdentifier: "toModifyDevice", sender: indexPath)
        }else {
            self.performSegue(withIdentifier: "endSearch", sender: indexPath)
        }
    }
    
}
extension RMDeviceListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RMDeviceListCell", for: indexPath) as! RMDeviceListCell
        
        if let viewModel = self.viewModel {
            let device = viewModel.elementAt(indexPath: indexPath)
            cell.deviceNameLabel.text = device.deviceName
            cell.deviceCodeLabel.text = device.deviceCode
            cell.totalPortLabel.text = String(device.totalTerminals)
            cell.freePortLabel.text = String(device.terminalFree)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.numberOfRowsInSection(section: section) ?? 0
    }

}

class RMDeviceListViewController: RMTableViewController, RMDeviceListViewAction {
    var viewModel: RMDeviceListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.headerRefresh(enable: true, target: self)
        
        self.tableView.footerRefresh(enable: true, target: self)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.estimatedRowHeight = 40

        // Do any additional setup after loading the view.
    }

    
    override func headerRefreshingFor(tableView: UITableView ) {
        tableView.mj_header.endRefreshing()
        self.viewModel?.deviceList(refresh: true).drive(onNext: { result in
            self.tableView.reloadData()
        }, onCompleted: {
        }).disposed(by: disposeBag)
    }
    
    override func footerRefreshingFor(tableView: UITableView) {
        tableView.mj_footer.endRefreshing()
        self.viewModel?.deviceList(refresh: false).drive(onNext: { result in
            self.tableView.reloadData()
        }, onCompleted: {
        }).disposed(by: disposeBag)
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
        if segue.identifier == "endSearch" {
            let delegate = segue.destination as! RMDeviceSearchViewControllerDelegate
            let device = viewModel?.elementAt(indexPath: sender as! IndexPath)
            delegate.didEndSearch(device: device!, isAccess: (self.viewModel?.isAccess)!)
        }else if segue.identifier == "toModifyDevice" {
            let deviceDetailViewController = segue.destination as! RMDeviceDetailViewController
            let device = viewModel?.elementAt(indexPath: sender as! IndexPath)
            
            deviceDetailViewController.viewModel = RMDeviceModifyViewModel(action: deviceDetailViewController, device: device!)
            
            deviceDetailViewController.delegate = self
        }
    }
}

extension RMDeviceListViewController: RMDeviceDetailViewControllerDelegate {
    func didEndModify() {
        self.tableView.mj_header.beginRefreshing()
    }
}

//
//  RMLinkListViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 07/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
class RMLinkTableViewCell: RMTableViewCell {
    @IBOutlet weak var accessDevicePortLabel: UILabel!
    @IBOutlet weak var accessDeviceNameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10) //if you also want to adjust separatorInset
    }
}

class RMLinkListViewController: RMTableViewController, RMLinkListAction, UITableViewDataSource {

    var viewModel: RMLinkListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let isModify = self.viewModel?.isModify, isModify {
            self.navigationItem.title = isModify ? "链路修改" : "链路查询"
        }
        
        // Do any additional setup after loading the view.
        self.tableView.headerRefresh(enable: true, target: self)
        
        self.tableView.footerRefresh(enable: true, target: self)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.estimatedRowHeight = 40
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func headerRefreshingFor(tableView: UITableView ) {
        self.viewModel?.linkList(refresh: true).drive(onNext: { result in
            self.tableView.reloadData()
        }, onCompleted: {
            tableView.mj_header.endRefreshing()
        }).disposed(by: disposeBag)
    }
    
    override func footerRefreshingFor(tableView: UITableView) {
        self.viewModel?.linkList(refresh: false).drive(onNext: { result in
            self.tableView.reloadData()
        }, onCompleted: {
            tableView.mj_footer.endRefreshing()
        }).disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RMLinkTableViewCell", for: indexPath) as! RMLinkTableViewCell
        
        if let viewModel = self.viewModel {
            let link = viewModel.elementAt(indexPath: indexPath)
            cell.accessDeviceNameLabel.text = link.accessDeviceName
            cell.accessDevicePortLabel.text = link.accessDevicePort
            cell.customerNameLabel.text = link.customerName
            cell.codeLabel.text = link.barcode
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.numberOfRowsInSection(section: section) ?? 0
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let linkDetailViewController = segue.destination as! RMLinkDetailViewController
        
        if let viewModel = self.viewModel {
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            
            let link = viewModel.elementAt(indexPath: indexPath!)
            
            linkDetailViewController.viewModel = RMLinkDetailViewModel(link: link, action: linkDetailViewController, isModify: viewModel.isModify)
        }
        
    }

}

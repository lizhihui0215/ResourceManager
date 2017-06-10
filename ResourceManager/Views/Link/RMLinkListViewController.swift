//
//  RMLinkListViewController.swift
//  ResourceManager
//
//  Created by 李智慧 on 07/04/2017.
//  Copyright © 2017 北京海睿兴业. All rights reserved.
//

import UIKit
class RMLinkTableViewCell: RMTableViewCell {
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var accessDevicePortLabel: UILabel!
    @IBOutlet weak var accessDeviceNameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10) //if you also want to adjust separatorInset
    }
}

extension RMLinkListViewController: RMLinkDetailViewControllerDelegate {
    func didEndModify() {
        self.reloadData(refresh: true)
    }
}

class RMLinkListViewController: RMTableViewController, RMLinkListAction, UITableViewDataSource {

    var viewModel: RMLinkListViewModel?
    
    @IBAction func printButtonPressed(_ sender: UIButton) {
        
        let point = sender.superview?.convert(sender.center, to: self.tableView)
        
        let indexPath = self.tableView.indexPathForRow(at: point!)
        
        let link = self.viewModel?.elementAt(indexPath: indexPath!)

        let template = "<?xml version=\"1.0\" encoding=\"utf-8\" ?><Data><Print><CodeType>02F</CodeType><Code>\( link?.linkCode ?? "")</Code><Text>专线名称:\(link?.linkName ?? "")</Text><Text>服务热线：10086-8</Text></Print></Data>";
        print(template)
        PrintServices.shared.printInView(view: self.view, template: template)
        
    }
    
    func reloadData(refresh: Bool) {
        self.viewModel?.linkList(refresh: refresh).drive(onNext: { result in
            self.tableView.reloadData()
        }, onCompleted: {
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let isModify = self.viewModel?.isModify, isModify {
            self.navigationItem.title = isModify ? "电路修改" : "电路查询"
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
        tableView.mj_header.endRefreshing()
        self.reloadData(refresh: true)
    }
    
    override func footerRefreshingFor(tableView: UITableView) {
        tableView.mj_footer.endRefreshing()
        self.reloadData(refresh: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RMLinkTableViewCell", for: indexPath) as! RMLinkTableViewCell
        
        if let viewModel = self.viewModel {
            let link = viewModel.elementAt(indexPath: indexPath)
            cell.accessDeviceNameLabel.text = link.accessDeviceName
            cell.accessDevicePortLabel.text = link.accessDevicePort
            cell.customerNameLabel.text = link.customerName
            cell.codeLabel.text = link.linkCode
            cell.accountLabel.text = link.linkName
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
            linkDetailViewController.delegate = self
        }
        
    }

}
